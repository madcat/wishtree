//
//  WhiteListDraw.h
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhiteListDraw : NSObject
{
    NSNumber *idnumber;
    NSNumber *whitePosition;
}

@property (nonatomic,copy) NSNumber *idnumber;
@property (nonatomic) NSNumber *whitePosition;

@end
