//
//  Wish.h
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wish : NSObject
{
    NSNumber *idname;
    NSString *username;
    NSString *content;
    NSString *imageUrl;
}

@property (nonatomic,copy) NSNumber *idname;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *imageUrl;

@end
