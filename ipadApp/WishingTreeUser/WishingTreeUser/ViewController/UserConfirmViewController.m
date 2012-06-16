//
//  UserConfirmViewController.m
//  WishingTreeUser
//
//  Created by Brian Chen on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserConfirmViewController.h"
#import "UserInfo.h"
#import "Service.h"

@interface UserConfirmViewController ()
@property (nonatomic,strong) UserInfo *userInfo;
@property (nonatomic,strong) Service *service;
@end

@implementation UserConfirmViewController
@synthesize userInfo,service;

- (UserInfo *)userInfo
{
    userInfo = [[UserInfo alloc] init];
    return userInfo;
}

-(Service *)service
{
    service = [[Service alloc] init];
    return service;
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
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ipad5bg.png"]];
    self.view.backgroundColor = background;
    NSString *cards[5] = {@"blue",@"green",@"red",@"white",@"yellow"};
    int randomNumber = arc4random() % 5;
    NSLog(@"%d",randomNumber);
    cardBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",cards[randomNumber]]];
    if(randomNumber == 0)
    {
        username.textColor = [UIColor whiteColor];
        userWishWords.textColor = [UIColor whiteColor];
    }else
    {
        username.textColor = [UIColor blackColor];
        userWishWords.textColor = [UIColor blackColor];
    }
    
    NSString *userFirstname = [self.userInfo getFirstname];
    NSString *userLastname = [self.userInfo getLastname];
    NSString *userFullName = [NSString stringWithFormat:@"%@  %@",userFirstname,userLastname];
    for(int i=0; i < userFirstname.length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [userFirstname substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
             userFullName = [NSString stringWithFormat:@"%@ %@",userLastname,userFirstname];
        }
    }
    
    for(int i=0; i < userLastname.length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [userLastname substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            userFullName = [NSString stringWithFormat:@"%@ %@",userLastname,userFirstname];
        }
    }
    username.text = userFullName;
    
    userWishWords.text = [self.userInfo getWishwords];
    
    userPhoto.image = [UIImage imageWithContentsOfFile:[self.userInfo getUserPhotoDir]];
    
    userWishWords.editable = NO;
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

- (IBAction)confirm2Push:(id)sender {
    NSString *response = [self.service pushUserCard2Server];
    if([response isEqualToString:@"success"])
    {
        [self performSegueWithIdentifier:@"endProcess" sender:self];
    }
}

@end
