//
//  Service.h
//  WishingTreeUser
//
//  Created by Brian Chen on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject
{
    UIImage *userPhoto;
    NSString *savedPhotoPath;
}

-(NSString *)saveUserPhoto:(UIImage *)photo;
-(NSString *)pushUserCard2Server;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
@end
