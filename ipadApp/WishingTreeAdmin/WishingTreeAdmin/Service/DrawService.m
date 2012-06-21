//
//  DrawService.m
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawService.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "WhiteListDraw.h"

@implementation DrawService
@synthesize normalList,whiteList;

-(NSNumber *)pickaWish:(NSArray *)aRange
{
    drawRange = aRange;
    int randomNumber = arc4random() %[drawRange count];
    NSLog(@"%d",randomNumber);
    return [drawRange objectAtIndex:randomNumber];
}

-(NSString *)startDraw
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/luck/start",[self getHostAddress]]];//set the url of server
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; //make a ASIHTTP request 
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
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

-(NSString *)stopDraw:(NSNumber *)idnumber
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/luck/stop",[self getHostAddress]]];//set the url of server
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];    
    [request setPostValue:idnumber forKey:@"id"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
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

-(void)getDrawList
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ids",[self getHostAddress]]];//set the url of server
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; //make a ASIHTTP request 
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    [request startSynchronous]; //start to send the message
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSDictionary *body = [json objectForKey:@"body"];
    normalList = [[body objectForKey:@"normal"] mutableCopy];
    NSMutableArray *newWhiteList = [[NSMutableArray alloc]init];
    for(NSDictionary *whiteObg in [body objectForKey:@"white"])
    {
        WhiteListDraw *newWhite = [[WhiteListDraw alloc]init];
        newWhite.idnumber = [whiteObg objectForKey:@"id"];
        newWhite.whitePosition = [whiteObg objectForKey:@"is_white"];
        [newWhiteList addObject:newWhite];
    }
    whiteList = newWhiteList;

}

@end
