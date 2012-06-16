//
//  UserNameViewController.h
//  WishingTreeUser
//
//  Created by Brian Chen on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserNameViewController : UIViewController <UIImagePickerControllerDelegate>
{
    IBOutlet UITextField *lastname;
    IBOutlet UITextField *firstname;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *btnBanner;
}
- (IBAction)checkValue:(id)sender;
- (IBAction)editBegin:(id)sender;
@end
