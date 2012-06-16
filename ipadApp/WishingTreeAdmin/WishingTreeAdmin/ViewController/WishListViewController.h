//
//  WishListViewController.h
//  WishingTreeAdmin
//
//  Created by Brian Chen on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *wishes;
    IBOutlet UITableView *wishList;
}
@property (nonatomic,strong) NSArray *wishes;

@end
