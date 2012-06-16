//
//  UserConfirmViewController.h
//  WishingTreeUser
//
//  Created by Brian Chen on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserConfirmViewController : UIViewController
{
    IBOutlet UIImageView *userPhoto;
    IBOutlet UIImageView *cardBackground;
    IBOutlet UITextView *userWishWords;
    IBOutlet UILabel *username;
    IBOutlet UIButton *confirmButton;
    IBOutlet UIButton *backButton;
}
- (IBAction)confirm2Push:(id)sender;

@end
