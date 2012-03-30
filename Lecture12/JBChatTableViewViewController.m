//
//  JBChatTableViewViewController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-27.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBChatTableViewViewController.h"

@interface JBChatTableViewViewController ()

@end

@implementation JBChatTableViewViewController
@synthesize tableView = _tableView;
@synthesize keyboardView = _keyboardView;
@synthesize sendButton = _sendButton;
@synthesize textField = _textField;
@synthesize chatRoom = _chatRoom;
@synthesize client = _client;



- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setKeyboardView:nil];
    [self setSendButton:nil];
    [self setTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Chat";
	
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = @"Some message!";
	
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}




- (IBAction)sendMessageWasPressed:(UIButton *)sender {
	NSLog(@"Lets send a message!");
}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	return NO;
//}


@end
