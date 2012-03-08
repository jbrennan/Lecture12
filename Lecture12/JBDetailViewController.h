//
//  JBDetailViewController.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-08.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
