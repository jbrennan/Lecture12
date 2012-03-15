//
//  JBMessageViewController.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-15.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBMessageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;

- (IBAction)messageButtonWasPressed:(UIButton *)sender;
@end
