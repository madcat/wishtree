//
//  UserPhotoViewController.h
//  WishingTreeUser
//
//  Created by Brian Chen on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>

@interface UserPhotoViewController : UIViewController<UIImagePickerControllerDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
{
    UIImagePickerController *imagePicker;
    AVCaptureSession *session;
    int timerNumber;
    NSTimer *photoTimer;
    UIImage *tempImage;
}

@property (nonatomic,retain) IBOutlet UIImageView *photoImageView;
@property (nonatomic,retain) UIImagePickerController *imagePicker;
@property (nonatomic,retain) IBOutlet UIButton *nextButton;
@property (nonatomic,retain) IBOutlet UIButton *photoPick;
@property (nonatomic,retain) IBOutlet UIButton *rephotoButton;
@property (nonatomic,retain) IBOutlet UILabel *showTimer;
@property (nonatomic,retain) AVCaptureSession *session;

-(IBAction)touchPhoto:(id)sende;
- (IBAction)retakePhoto:(id)sender;
-(void)setupCaptureSession;
-(AVCaptureDevice *)getFrontCamera;

@end
