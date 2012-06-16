//
//  WishesService.h
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wish.h"

@interface WishesService : NSObject
{
    NSArray *wishList;
}

-(NSArray *)getWishList;
-(NSArray *)getMoreWishes:(NSArray *)oldWishList;
-(NSArray *)getAllWishesIndex;
-(Wish *)getWishByIndex:(NSNumber *)index;
-(NSString *)showWish:(NSNumber *)wishId;
@end
