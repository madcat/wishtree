//
//  FinishingViewController.m
//  WishingTreeUser
//
//  Created by Brian Chen on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FinishingViewController.h"
#import "UserInfo.h"

@interface FinishingViewController ()
@property (nonatomic,strong) UserInfo *userInfo;
@end

@implementation FinishingViewController
@synthesize userInfo;

- (UserInfo *)userInfo
{
    userInfo = [[UserInfo alloc] init];
    return userInfo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ipad6bg.png"]];
    self.view.backgroundColor = background;
    
    [NSTimer scheduledTimerWithTimeInterval:3 target: self selector:@selector(return2MainView) userInfo:nil repeats:NO];
	// Do any additional setup after loading the view.
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

-(void)return2MainView
{
    [self performSegueWithIdentifier:@"return2Main" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"return2Main"])
    {
        [self.userInfo setFirstname:@""];
        [self.userInfo setLastname:@""];
        [self.userInfo setWishwords:@""];
    }
}

@end
