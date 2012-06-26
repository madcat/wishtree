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
#import "WhiteListDraw.h"

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
    drawCount = 0;
    drawTimesLabel.text = @"Draw Times: 0/21";
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ipadnormalbg.png"]];
    self.view.backgroundColor = background;
    
    [self.drawbrain getDrawList];
    
    drawList = self.drawbrain.normalList;
    whiteList = self.drawbrain.whiteList;
    
    [startButton setEnabled:YES];
    [stopButton setEnabled:NO];
    //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"start-normal.png"] forState:UIControlStateNormal];
    //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"start-click.png"] forState:UIControlStateHighlighted];
    //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"start-normal.png"] forState:UIControlStateDisabled];
    //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"start-normal.png"] forState:UIControlStateSelected];
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
    if(drawCount <= 21){
        if(!drawing)
        {
            //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"stop-normal.png"] forState:UIControlStateNormal];
            //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"stop-click.png"] forState:UIControlStateHighlighted];
            //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"stop-normal.png"] forState:UIControlStateDisabled];
            //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"stop-normal.png"] forState:UIControlStateSelected];
            drawing = true;
            [self.drawbrain startDraw];
        }else
        {
            drawing = false;
            drawCount ++;
            drawTimesLabel.text = [NSString stringWithFormat:@"Draw Times: %d/21",drawCount];
            //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"start-normal.png"] forState:UIControlStateNormal];
            //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"start-click.png"] forState:UIControlStateHighlighted];
            //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"start-normal.png"] forState:UIControlStateDisabled];
            //[drawSwitch setBackgroundImage:[UIImage imageNamed:@"start-normal.png"] forState:UIControlStateSelected];
            //[self performSegueWithIdentifier:@"showDrawResult" sender:self];
            BOOL isWhite = false;
            for(WhiteListDraw *whiteObj in whiteList)
            {
                if(drawCount == [whiteObj.whitePosition intValue])
                {
                    isWhite = true;
                    [self.drawbrain stopDraw:whiteObj.idnumber];
                    break;
                }
            }
            if([drawList count] != 0 && !isWhite){
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
}

- (IBAction)startDraw:(id)sender {
    [self.drawbrain startDraw];
    [startButton setEnabled:NO];
    [stopButton setEnabled:YES];
}

- (IBAction)stopDraw:(id)sender {
    if(drawCount <= 20)
    {
        drawCount ++;
        drawTimesLabel.text = [NSString stringWithFormat:@"Draw Times: %d/21",drawCount];
        
        [startButton setEnabled:YES];
        [stopButton setEnabled:NO];
        
        BOOL isWhite = false;
        for(WhiteListDraw *whiteObj in whiteList)
        {
            if(drawCount == [whiteObj.whitePosition intValue])
            {
                isWhite = true;
                [self.drawbrain stopDraw:whiteObj.idnumber];
                break;
            }
        }
        if([drawList count] != 0 && !isWhite){
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
    }else
    {
        [startButton setEnabled:NO];
        [stopButton setEnabled:NO];
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
