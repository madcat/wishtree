//
//  UserPhotoViewController.m
//  WishingTreeUser
//
//  Created by Brian Chen on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserPhotoViewController.h"
#import "Service.h"
#import "UserInfo.h"

@interface UserPhotoViewController ()
@property (nonatomic,strong) Service *service;
@property (nonatomic,strong) UserInfo *userInfo;
@end

@implementation UserPhotoViewController
@synthesize photoImageView,photoPick,nextButton,rephotoButton,imagePicker,session,showTimer,service,userInfo;

- (Service *)service
{
    service = [[Service alloc] init];
    return service;
}

- (UserInfo *)userInfo
{
    userInfo = [[UserInfo alloc] init];
    return userInfo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ipad3bg.png"]];
    self.view.backgroundColor = background;
    
    self.rephotoButton.hidden = YES;
    self.photoPick.hidden = NO;
    showTimer.hidden = YES;
    self.nextButton.hidden = YES;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(session == nil)
    {
        [self setupCaptureSession];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(IBAction)touchPhoto:(id)sende
{
    timerNumber = 3;
    showTimer.text = @"3";
    showTimer.hidden = NO;
    photoTimer = [NSTimer scheduledTimerWithTimeInterval:0.67 target: self selector:@selector(setTime2Photo) userInfo:nil repeats:YES];
}

- (IBAction)retakePhoto:(id)sender {
    [[photoImageView.layer.sublayers lastObject] setHidden:NO];
    [session startRunning];
    self.rephotoButton.hidden = YES;
    self.photoPick.hidden = NO;
    self.nextButton.hidden = YES;
}

-(void)setTime2Photo
{
    timerNumber --;
    showTimer.text = [NSString stringWithFormat:@"%d",timerNumber]; 
    if(timerNumber == 0)
    {
        [photoTimer invalidate];
        photoTimer = nil;
        showTimer.hidden = YES;
        [self frozenPhoto];
    }
}

-(void)frozenPhoto
{
    self.photoPick.hidden = YES;
    self.rephotoButton.hidden = NO;
    [[photoImageView.layer.sublayers lastObject] setHidden:YES];
    photoImageView.image = tempImage;
    self.nextButton.hidden = NO;

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput   
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer   
       fromConnection:(AVCaptureConnection *)connection  
{   
    // Create a UIImage from the sample buffer data  
    tempImage = [self imageFromSampleBuffer:sampleBuffer];
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer   
{  
    // Get a CMSampleBuffer's Core Video image buffer for the media data  
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);   
    // Lock the base address of the pixel buffer  
    CVPixelBufferLockBaseAddress(imageBuffer, 0);   
    
    // Get the number of bytes per row for the pixel buffer  
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);   
    
    // Get the number of bytes per row for the pixel buffer  
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);   
    // Get the pixel buffer width and height  
    size_t width = CVPixelBufferGetWidth(imageBuffer);   
    size_t height = CVPixelBufferGetHeight(imageBuffer);   
    
    // Create a device-dependent RGB color space  
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();   
    
    // Create a bitmap graphics context with the sample buffer data  
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,   
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);   
    // Create a Quartz image from the pixel data in the bitmap graphics context  
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);   
    // Unlock the pixel buffer  
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);  
    
    // Free up the context and color space  
    CGContextRelease(context);   
    CGColorSpaceRelease(colorSpace);  
    
    // Create an image object from the Quartz image  
    UIImage *image;
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];  
    if (self.interfaceOrientation==UIDeviceOrientationPortraitUpsideDown) {
        image=[UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRightMirrored]; 
    }
    else
    {
        image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationLeftMirrored];  
    }
    
    // Release the Quartz image  
    CGImageRelease(quartzImage);  
    
    return (image);  
    
}

-(void)setupCaptureSession
{
    NSError *error = nil;
    
    //Create the session
    if(session == nil)
    {
        session = [[AVCaptureSession alloc] init];
    }
    
    session.sessionPreset = AVCaptureSessionPresetMedium;//set medium quality
    
    //Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [self getFrontCamera];//set front camera;
    
    // Create a device input with the device and add it to the session.  
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device   
                                                                        error:&error];  
    if (!input) {  
        // Handling the error appropriately.  
    }  
    [session addInput:input];  
    
    //Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    //Configure your output
    dispatch_queue_t queue = dispatch_queue_create("photoQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    // Specify the pixel format  
    output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:  
                            [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,  
                            [NSNumber numberWithInt: 429], (id)kCVPixelBufferWidthKey,  
                            [NSNumber numberWithInt:572], (id)kCVPixelBufferHeightKey,  
                            nil];
    
    
    AVCaptureVideoPreviewLayer* preLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];  
    //preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];  
    preLayer.frame = CGRectMake(0, 0, 429, 572);  
    preLayer.orientation=self.interfaceOrientation;
    preLayer.videoGravity = AVLayerVideoGravityResize;  
    [self.photoImageView.layer addSublayer:preLayer];
    
    [session startRunning];
}

-(AVCaptureDevice *)getFrontCamera
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras)
    {
        if (device.position == AVCaptureDevicePositionFront)
            return device;
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"next2UserConfirm"])
    {
        [self.userInfo setUserPhotoDir:[self.service saveUserPhoto:[self.service scaleAndRotateImage:photoImageView.image]]];
        //[self.userInfo setWishwords:@""];
    }
}

@end
