//
//  UserInfo.h
//  WishingTreeUser
//
//  Created by Brian Chen on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    NSString *firstname;
    NSString *lastname;
    NSString *wishwords;
    NSString *userPhotoDir;
}

-(void)setFirstname:(NSString *)aName;
-(NSString *)getFirstname;
-(void)setLastname:(NSString *)aName;
-(NSString *)getLastname;
-(void)setWishwords:(NSString *)words;
-(NSString *)getWishwords;
-(void)setUserPhotoDir:(NSString *)photoDir;
-(NSString *)getUserPhotoDir;

@end
