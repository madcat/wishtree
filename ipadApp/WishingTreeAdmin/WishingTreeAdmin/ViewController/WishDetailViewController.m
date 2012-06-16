//
//  WishDetailViewController.m
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishDetailViewController.h"
#import "WishListViewController.h"
#import "WishesService.h"

@interface WishDetailViewController ()
@property (nonatomic,strong) WishesService *service;
@end

@implementation WishDetailViewController
@synthesize username,wishContent,idname;
@synthesize service = _service;

-(WishesService *)service
{
    if(!_service)_service = [[WishesService alloc] init];
    return _service;
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ipadnormalbg.png"]];
    self.view.backgroundColor = background;
    nameLabel.text = username;
    contentView.text = wishContent;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"back2WishList"])
    {
        [segue.destinationViewController setWishes:[self.service getWishList]];
    }
}

- (IBAction)showWish:(id)sender {
    [self.service showWish:idname];
}
@end
