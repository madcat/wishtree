//
//  DrawService.h
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawService : NSObject
{
    NSArray *drawRange;
}

-(NSNumber *)pickaWish:(NSArray *)aRange;
-(NSString *)startDraw;
-(NSString *)stopDraw:(NSNumber *)idnumber;
@end
