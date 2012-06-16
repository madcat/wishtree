//
//  LuckyDrawViewController.h
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LuckyDrawViewController : UIViewController
{
    IBOutlet UIButton *drawSwitch;
    BOOL drawing;
    NSMutableArray *drawList;
}

- (IBAction)DrawAwish:(id)sender;

@end
