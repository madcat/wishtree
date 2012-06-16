//
//  UserInfo.m
//  WishingTreeUser
//
//  Created by Brian Chen on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(void)setFirstname:(NSString *)aName
{
    firstname = aName;
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    [userPref setValue:firstname forKey:@"firstname"];
    [userPref synchronize];
}

-(NSString *)getFirstname
{
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    firstname = [userPrefs stringForKey:@"firstname"];
    return firstname;
}

-(void)setLastname:(NSString *)aName
{
    lastname = aName;
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    [userPref setValue:lastname forKey:@"lastname"];
    [userPref synchronize];
}

-(NSString *)getLastname
{
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    lastname = [userPref stringForKey:@"lastname"];
    return lastname;
}

-(void)setWishwords:(NSString *)words
{
    wishwords = words;
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    [userPref setValue:wishwords forKey:@"wishwords"];
    [userPref synchronize];
}

-(NSString *)getWishwords
{
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    wishwords = [userPref stringForKey:@"wishwords"];
    return wishwords;
}

-(void)setUserPhotoDir:(NSString *)photoDir
{
    userPhotoDir = photoDir;
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    [userPref setValue:userPhotoDir forKey:@"userPhoto"];
    [userPref synchronize];
}

-(NSString *)getUserPhotoDir
{
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    userPhotoDir = [userPref stringForKey:@"userPhoto"];
    return userPhotoDir;
}

@end
