//
//  WishDetailViewController.h
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishDetailViewController : UIViewController
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextView *contentView;
}

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *wishContent;
@property (nonatomic,copy) NSNumber *idname;

- (IBAction)showWish:(id)sender;

@end
