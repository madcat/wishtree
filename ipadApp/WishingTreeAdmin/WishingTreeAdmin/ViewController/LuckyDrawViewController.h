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
    //IBOutlet UIButton *drawSwitch;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *stopButton;
    IBOutlet UILabel *drawTimesLabel;
    BOOL drawing;
    NSMutableArray *drawList;
    NSMutableArray *whiteList;
    int drawCount;
}

//- (IBAction)DrawAwish:(id)sender;
- (IBAction)startDraw:(id)sender;
- (IBAction)stopDraw:(id)sender;

@end
