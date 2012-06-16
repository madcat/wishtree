//
//  DrawResultViewController.h
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawResultViewController : UIViewController
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextView *contentView;
}

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *content;

@end
