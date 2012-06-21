//
//  WishesService.m
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishesService.h"
#import "Wish.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation WishesService

- (NSArray *)getWishList
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/show",[self getHostAddress]]];//set the url of server
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; //make a ASIHTTP request 
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    [request startSynchronous]; //start to send the message
    
    NSMutableArray *newWishList = [[NSMutableArray alloc]init];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    if(json != nil)
    {
        NSMutableArray *jsonData = [json objectForKey:@"body"];
        for(NSDictionary *wishData in jsonData)
        {
            Wish *newWish = [[Wish alloc] init];
            newWish.idname = [wishData objectForKey:@"id"];
            NSString *firstname = [wishData objectForKey:@"first_name"];
            NSString *lastname = [wishData objectForKey:@"last_name"];
            newWish.username = [self adjestName:firstname :lastname];
            newWish.content = [wishData objectForKey:@"wish_text"];
            newWish.imageUrl = [wishData objectForKey:@"pic_path"];
            [newWishList addObject:newWish];
        }
    }
    
    wishList = (NSArray *)newWishList;
    
    return wishList;
}

-(NSArray *)getMoreWishes:(NSArray *)oldWishList
{
    
    return wishList;
}

-(NSArray *)getAllWishesIndex
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ids",[self getHostAddress]]];//set the url of server
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; //make a ASIHTTP request 
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    [request startSynchronous]; //start to send the message
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    if(json != nil){
        wishList = (NSArray *)[json objectForKey:@"body"];
        return wishList;
    }else
    {
        return nil;
    }
}

-(Wish *)getWishByIndex:(NSNumber *)index
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/wishes/%@",[self getHostAddress],[index stringValue]]];//set the url of server
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; //make a ASIHTTP request 
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    [request startSynchronous]; //start to send the message
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    if(json != nil){
        NSDictionary *dataBody = [json objectForKey:@"body"];
        Wish *wishdata = [[Wish alloc]init];
        wishdata.idname = [dataBody objectForKey:@"id"];
        NSString *userFirstname = [dataBody objectForKey:@"first_name"];
        NSString *userLastname = [dataBody objectForKey:@"last_name"];
        wishdata.username = [self adjestName:userFirstname :userLastname];
        wishdata.content = [dataBody objectForKey:@"wish_text"];
        wishdata.imageUrl = [dataBody objectForKey:@"pic_path"];
        return wishdata;

    }else
    {
        return nil;
    }

}

-(NSString *)adjestName:(NSString *)userFirstname:(NSString *)userLastname
{
    NSString *userFullName = [NSString stringWithFormat:@"%@  %@",userFirstname,userLastname];
    for(int i=0; i < userFirstname.length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [userFirstname substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            userFullName = [NSString stringWithFormat:@"%@ %@",userLastname,userFirstname];
        }
    }
    
    for(int i=0; i < userLastname.length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [userLastname substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            userFullName = [NSString stringWithFormat:@"%@ %@",userLastname,userFirstname];
        }
    }
    
    return userFullName;
}

-(NSString *)showWish:(NSNumber *)wishId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/show/%@",[self getHostAddress],[wishId stringValue]]];//set the url of server
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    [request startSynchronous]; //start to send the message
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    if(json!=nil)
    {
        return [json objectForKey:@"status"];
    }else{
        return @"failed";
    }

}

-(NSString *)getHostAddress
{
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    return [userPref stringForKey:@"hostaddress"];
}

@end
