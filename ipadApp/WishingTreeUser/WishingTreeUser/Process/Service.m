//
//  Service.m
//  WishingTreeUser
//
//  Created by Brian Chen on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Service.h"
#import "ASIFormDataRequest.h"
#import "UserInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

@interface Service ()
@property (nonatomic,strong)UserInfo *userInfo;
@end

@implementation Service
@synthesize userInfo;

- (UserInfo *)userInfo
{
    userInfo = [[UserInfo alloc] init];
    return userInfo;
}

-(NSString *)saveUserPhoto:(UIImage *)photo
{
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userPhoto.jpg"];
    
    [UIImageJPEGRepresentation(photo, 1.0) writeToFile:jpgPath atomically:YES];
    
    // Create file manager
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    return jpgPath;
}

-(NSString *)pushUserCard2Server
{
    NSLog(@"connect with server.");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/wishes",[self getHostAddress]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:[self.userInfo getFirstname] forKey:@"fn"];
    [request setPostValue:[self.userInfo getLastname] forKey:@"ln"];
    [request setPostValue:[self.userInfo getWishwords] forKey:@"text"];
    [request setShouldStreamPostDataFromDisk:YES];
    
    [request setFile:[self.userInfo getUserPhotoDir] withFileName:@"userPhoto.jpg" andContentType:@"multipart/form-data" forKey:@"pic_data"];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    NSString *strResponse = [request responseString];
    NSError *error = [request error];
    
    if(error || [request responseStatusCode] == 404)
    {
        NSLog(@"connection error.");
        strResponse = @"error";
    }else{
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
        strResponse = [jsonData objectForKey:@"status"];
    }
    return strResponse;
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(NSString *)getHostAddress
{
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    return [userPref stringForKey:@"hostaddress"];
}
@end
