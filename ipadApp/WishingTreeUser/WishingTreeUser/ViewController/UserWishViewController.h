//
//  UserWishViewController.h
//  WishingTreeUser
//
//  Created by Brian Chen on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserWishViewController : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextView *wishWords;
    IBOutlet UILabel *wishWordsWarning;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *btnBanner;
    int maxChar;
}

- (IBAction)checkValue:(id)sender;

@end
