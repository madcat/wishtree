//
//  WishListViewController.m
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishListViewController.h"
#import "Wish.h"
#import "WishesService.h"
#import "WishDetailViewController.h"

@interface WishListViewController ()
@property (nonatomic,strong) WishesService *service;
@end

@implementation WishListViewController
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
    [wishList reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.wishes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Wishes Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Wish *wish = [self.wishes objectAtIndex:indexPath.row];
    cell.textLabel.text = wish.username;
    cell.detailTextLabel.text  = wish.content;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Wish *wish = [self.wishes objectAtIndex:indexPath.row];
    WishDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"WishDetailView"];
    detailView.idname = wish.idname;
    detailView.username = wish.username;
    detailView.wishContent = wish.content;
    [self.navigationController pushViewController:detailView animated:YES];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row == [self.wishes count] -1)
//    {
//        NSArray *newWishes = [self.service getMoreWishes:self.wishes];
//        self.wishes = newWishes.copy;
//        [wishList reloadData];
//    }
//}

@end
