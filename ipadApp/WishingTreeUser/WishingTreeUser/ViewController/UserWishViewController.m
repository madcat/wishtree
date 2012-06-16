//
//  UserWishViewController.m
//  WishingTreeUser
//
//  Created by Brian Chen on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserWishViewController.h"
#import "UserInfo.h"

@interface UserWishViewController ()
@property (nonatomic,strong) UserInfo *userInfo;
@end

@implementation UserWishViewController
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
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ipad4bg.png"]];
    self.view.backgroundColor = background;
    
    wishWords.text = [self.userInfo getWishwords];
    wishWords.delegate = self;

    [wishWords becomeFirstResponder];
    [self adjestBannerUp];
    
    wishWordsWarning.text = [NSString stringWithFormat:@"0/%d 字数(Characters)",maxChar];
    wishWordsWarning.textColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upingButton:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downingButton:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputModeDidChange:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
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
    if(touch.view.tag != 1)
    {
        [wishWords resignFirstResponder];
        if([wishWords.text length] >0){
            wishWordsWarning.text = [NSString stringWithFormat:@"%d/%d 字数(Characters)",wishWords.text.length,maxChar];
            wishWordsWarning.textColor = [UIColor blackColor];
        }
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

- (IBAction)checkValue:(id)sender
{
    if([wishWords.text length] > 0 && [wishWords.text length] <= maxChar )
    {
        [self.userInfo setWishwords:wishWords.text];
        [self performSegueWithIdentifier:@"next2UserConfirm" sender:self];
    }else if([wishWords.text length] == 0)
    {
        [wishWords becomeFirstResponder];
        [self adjestBannerDown];
        wishWordsWarning.text = @"请输入内容。  Blank!";
        wishWordsWarning.textColor = [UIColor redColor];
    }else{
        [self adjestBannerDown];
        wishWordsWarning.text = @"超出字数限制。 Characters Limit.";
        wishWordsWarning.textColor = [UIColor redColor];
    }
}

- (void)inputModeDidChange:(NSNotification*)notification
{
    [self adjestBannerUp];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > maxChar)
    {
        wishWordsWarning.text = @"超出字数限制。 Characters Limit.";
        wishWordsWarning.textColor = [UIColor redColor];
        [self adjestBannerDown];
    }else
    {
        wishWordsWarning.text = [NSString stringWithFormat:@"%d/%d 字数(Characters)",wishWords.text.length,maxChar];
        wishWordsWarning.textColor = [UIColor blackColor];
        [self adjestBannerUp];
    }
}

-(void)adjestBannerUp
{
    if([[UITextInputMode currentInputMode].primaryLanguage isEqualToString:@"zh-Hans"])
    {
        backButton.frame = CGRectMake(73, 630, 140, 55);
        nextButton.frame = CGRectMake(555, 630, 140, 55);
        btnBanner.frame = CGRectMake(0, 630, 768, 59);
        maxChar = 24;
    }else
    {
        backButton.frame = CGRectMake(73, 680, 140, 55);
        nextButton.frame = CGRectMake(555, 680, 140, 55);
        btnBanner.frame = CGRectMake(0, 680, 768, 59);
        maxChar = 60;
    }
}

-(void)adjestBannerDown
{
    backButton.frame = CGRectMake(73, 901, 140, 55);
    nextButton.frame = CGRectMake(555, 901, 140, 55);
    btnBanner.frame = CGRectMake(0, 901, 768, 59);
}

@end
