//
//  JBMessageViewController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-15.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBMessageViewController.h"

@interface JBMessageViewController ()

@end

@implementation JBMessageViewController
@synthesize messageTextField;
@synthesize messageButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"Messages";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	[self.messageTextField becomeFirstResponder];
	
}


- (void)done:(id)sender {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setMessageTextField:nil];
    [self setMessageButton:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)messageButtonWasPressed:(UIButton *)sender {
}



@end
