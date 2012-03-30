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
	
	//self.textField.inputAccessoryView = self.keyboardView;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.textField resignFirstResponder];
}



- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
	
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTableViewFrame = self.view.bounds;
	CGRect newKeyboardViewFrame = self.keyboardView.bounds;
    newTableViewFrame.size.height = keyboardTop - self.view.bounds.origin.y - newKeyboardViewFrame.size.height;
	newKeyboardViewFrame.origin.y = newTableViewFrame.size.height;
	
	
    
    
	// Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
	NSNumber *animationCurveNumber = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    

	[UIView animateWithDuration:animationDuration delay:0 options:[animationCurveNumber integerValue] animations:^{
		self.tableView.frame = newTableViewFrame;
		self.keyboardView.frame = newKeyboardViewFrame;
	} completion:^(BOOL finished) {
		[self.tableView flashScrollIndicators];
	}];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.tableView.frame = self.view.bounds;
    
    [UIView commitAnimations];
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
