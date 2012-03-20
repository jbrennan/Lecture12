//
//  JBMessageViewController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-15.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBMessageViewController.h"
#import "JBCommunicationController.h"

@interface JBMessageViewController ()
@property (nonatomic, strong) JBCommunicationController *communicationController;
@end

@implementation JBMessageViewController
@synthesize messageTextField;
@synthesize messageButton;
@synthesize communicationController = _communicationController;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"Messages";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	[self.messageTextField becomeFirstResponder];
	
	self.communicationController = [[JBCommunicationController alloc] init];
	[self.communicationController startNetworkCommunication];
	
	[self.communicationController setMessageRecievedCallback:^(id payload, NSError *error) {
		if (nil != error) {
			NSLog(@"Error when recieving the message! %@", [error userInfo]);
			return;
		}
		
		NSLog(@"Got the message! %@", payload);
		
	}];
	
	
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
	
	[self.communicationController sendMessage:self.messageTextField.text];
	self.messageTextField.text = @"";
}



@end
