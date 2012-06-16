//
//  WishingTreeAdminViewController.m
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishingTreeAdminViewController.h"
#import "WishListViewController.h"
#import "WishesService.h"

@interface WishingTreeAdminViewController ()
@property (nonatomic,strong) WishesService *service;
@end

@implementation WishingTreeAdminViewController
@synthesize service = _service;

-(WishesService *)service
{
    if(!_service)_service = [[WishesService alloc] init];
    return _service;
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
    if([segue.identifier isEqualToString:@"go2WishList"])
    {
        [segue.destinationViewController setWishes:[self.service getWishList]];
    }
}

@end
