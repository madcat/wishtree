//
//  LuckyDrawViewController.m
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuckyDrawViewController.h"
#import "WishesService.h"
#import "DrawService.h"
#import "DrawResultViewController.h"

@interface LuckyDrawViewController ()
@property (nonatomic,strong)WishesService *service;
@property (nonatomic,strong)DrawService *drawbrain;
@end

@implementation LuckyDrawViewController
@synthesize service = _service,drawbrain = _drawbrain;

-(WishesService *)service
{
    if(!_service)_service = [[WishesService alloc] init];
    return _service;
}

-(DrawService *)drawbrain
{
    if(!_drawbrain)_drawbrain = [[DrawService alloc] init];
    return _drawbrain;
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
    
    drawList = [[self.service getAllWishesIndex] mutableCopy];
    
    [drawSwitch setTitle:@"Start" forState:UIControlStateNormal];
    [drawSwitch setTitle:@"Start" forState:UIControlStateHighlighted];
    [drawSwitch setTitle:@"Start" forState:UIControlStateDisabled];
    [drawSwitch setTitle:@"Start" forState:UIControlStateSelected];
    drawing = false;
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

- (IBAction)DrawAwish:(id)sender {
    if(!drawing)
    {
        [drawSwitch setTitle:@"Stop" forState:UIControlStateNormal];
        [drawSwitch setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [drawSwitch setTitle:@"Stop" forState:UIControlStateHighlighted];
        [drawSwitch setTitle:@"Stop" forState:UIControlStateDisabled];
        [drawSwitch setTitle:@"Stop" forState:UIControlStateSelected];
        drawing = true;
        [self.drawbrain startDraw];
    }else
    {
        drawing = false;
        [drawSwitch setTitle:@"Start" forState:UIControlStateNormal];
        [drawSwitch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [drawSwitch setTitle:@"Start" forState:UIControlStateHighlighted];
        [drawSwitch setTitle:@"Start" forState:UIControlStateDisabled];
        [drawSwitch setTitle:@"Start" forState:UIControlStateSelected];
        //[self performSegueWithIdentifier:@"showDrawResult" sender:self];
        if([drawList count] != 0){
            NSArray *drawArray = drawList.copy;
            NSNumber *luckynumber = [self.drawbrain pickaWish:drawArray];
            [drawList removeObject:luckynumber];
            if([[self.drawbrain stopDraw:luckynumber] isEqualToString:@"success"])
            {
                NSLog(@"success");
            }else
            {
                NSLog(@"failed");
            }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showDrawResult"])
    {
        Wish *luckyWish = [self.service getWishByIndex:[self.drawbrain pickaWish:[self.service getAllWishesIndex]]];
        [segue.destinationViewController setUsername:luckyWish.username];
        [segue.destinationViewController setContent:luckyWish.content];
    }
}

@end
