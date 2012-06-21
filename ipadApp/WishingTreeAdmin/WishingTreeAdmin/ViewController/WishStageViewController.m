//
//  WishStageViewController.m
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishStageViewController.h"
#import "Wish.h"
#import "WishesService.h"

@interface WishStageViewController ()
@property (nonatomic,strong) WishesService *service;
@end

@implementation WishStageViewController
@synthesize wishes;
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
    begianButton.hidden = NO;
    indexLabel.hidden = YES;
    cardBackground.image = [UIImage imageNamed:@"white.png"];
    cardBackground.hidden = YES;
    nameLabel.hidden = YES;
    contentView.hidden = YES;
    prevButton.hidden = YES;
    nextButton.hidden = YES;
    wishIndex = 0;
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ipadnormalbg.png"]];
    self.view.backgroundColor = background;
    
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

- (IBAction)begin2Show:(id)sender {
    [self pushWish:0];
    begianButton.hidden = YES;
    indexLabel.hidden = NO;
    nameLabel.hidden = NO;
    contentView.hidden = NO;
    cardBackground.hidden = NO;
    prevButton.hidden = NO;
    nextButton.hidden = NO;
    
}

- (IBAction)prev2Show:(id)sender {
    if(wishIndex - 1 >= 0)
    {
        wishIndex = wishIndex - 1;
        [self pushWish:wishIndex];
    }
}

- (IBAction)next2Show:(id)sender {
    if(wishIndex + 1 <= [wishes count] - 1)
    {
        wishIndex = wishIndex + 1;
        [self pushWish:wishIndex];
    }
}

-(void)pushWish:(int)index
{
    indexLabel.text = [NSString stringWithFormat:@"%d/%d",index + 1,[wishes count]];
    Wish *newWish = [wishes objectAtIndex:index];
    nameLabel.text = newWish.username;
    contentView.text = newWish.content;
    [self.service showWish:newWish.idname];
}
@end
