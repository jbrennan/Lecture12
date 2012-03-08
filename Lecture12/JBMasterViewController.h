//
//  JBMasterViewController.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-08.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBDetailViewController;

@interface JBMasterViewController : UITableViewController

@property (strong, nonatomic) JBDetailViewController *detailViewController;

@end
