//
//  UserNameViewController.m
//  WishingTreeUser
//
//  Created by Brian Chen on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserNameViewController.h"
#import "UserInfo.h"

@interface UserNameViewController ()
@property (nonatomic,strong) UserInfo *userInfo;
@end

@implementation UserNameViewController
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ipad2bg.png"]];
    self.view.backgroundColor = background;
    
    firstname.placeholder = @"";
    firstname.text = [self.userInfo getFirstname];
    lastname.placeholder = @"";
    lastname.text = [self.userInfo getLastname];
    
    [lastname becomeFirstResponder];
    [self adjestBannerUp];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upingButton:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downingButton:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputModeDidChange:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.view.tag == 1)
    {
        [self adjestBannerUp];
    }
    
}

-(void)upingButton: (NSNotification *)notification 
{
    [self adjestBannerUp];
}

-(void)downingButton: (NSNotification *)notification 
{
    [self adjestBannerDown];
}

- (IBAction)checkValue:(id)sender {
    
    
    if([lastname.text length] <= 0)
    {
        lastname.placeholder = @"Blank!";
        [lastname becomeFirstResponder];
        [self adjestBannerDown];
        if([firstname.text length] <= 0)
        {
            firstname.placeholder = @"Blank!";
        }
    }
    
    /*
    else if([firstname.text length] <= 0)
    {
        firstname.placeholder = @"Blank!";
        [firstname becomeFirstResponder];
        [self adjestBannerDown];
    }
     */

    //if([firstname.text length] > 0 && [lastname.text length] > 0)

    if([lastname.text length] > 0)
    {
        [self adjestBannerUp];
        lastname.placeholder = @"";
        [self.userInfo setLastname:lastname.text];
        firstname.placeholder = @"";
        [self.userInfo setFirstname:firstname.text];
        [self performSegueWithIdentifier:@"next2UserPhoto" sender:self];
    }
}

- (IBAction)editBegin:(id)sender
{
    [self adjestBannerUp];
}

- (void)inputModeDidChange:(NSNotification*)notification
{
    [self adjestBannerUp];
}

-(void)adjestBannerUp
{
    if([[UITextInputMode currentInputMode].primaryLanguage isEqualToString:@"zh-Hans"])
    {
        backButton.frame = CGRectMake(73, 630, 140, 55);
        nextButton.frame = CGRectMake(555, 630, 140, 55);
        btnBanner.frame = CGRectMake(0, 630, 768, 59);
    }else
    {
        backButton.frame = CGRectMake(73, 680, 140, 55);
        nextButton.frame = CGRectMake(555, 680, 140, 55);
        btnBanner.frame = CGRectMake(0, 680, 768, 59);
    }
}

-(void)adjestBannerDown
{
    backButton.frame = CGRectMake(73, 901, 140, 55);
    nextButton.frame = CGRectMake(555, 901, 140, 55);
    btnBanner.frame = CGRectMake(0, 901, 768, 59);
}

@end
