//
//  WishingTreeUserViewController.m
//  WishingTreeUser
//
//  Created by Brian Chen on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishingTreeUserViewController.h"
#import "UserInfo.h"

@interface WishingTreeUserViewController ()
@property (nonatomic,strong) UserInfo *userInfo;
@end

@implementation WishingTreeUserViewController
@synthesize userInfo;

- (UserInfo *)userInfo
{
    userInfo = [[UserInfo alloc] init];
    return userInfo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ipad1bg.png"]];
    self.view.backgroundColor = background;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Next2Username"])
    {
        [self.userInfo setFirstname:@""];
        [self.userInfo setLastname:@""];
        [self.userInfo setWishwords:@""];
    }
}

@end
