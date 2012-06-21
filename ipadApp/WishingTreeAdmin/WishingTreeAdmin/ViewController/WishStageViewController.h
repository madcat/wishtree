//
//  WishStageViewController.h
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishStageViewController : UIViewController
{
    NSArray *wishes;
    IBOutlet UIButton *begianButton;
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextView *contentView;
    IBOutlet UILabel *indexLabel;
    IBOutlet UIImageView *cardBackground;
    IBOutlet UIButton *prevButton;
    IBOutlet UIButton *nextButton;
    int wishIndex;
}

- (IBAction)begin2Show:(id)sender;
- (IBAction)prev2Show:(id)sender;
- (IBAction)next2Show:(id)sender;
@property (nonatomic,strong) NSArray *wishes;
@end
