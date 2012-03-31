//
//  JBChatTableViewViewController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-27.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBChatTableViewViewController.h"
#import "JBChatRoom.h"
#import "JBChatMessage.h"
#import "JBIMClient.h"
#import "JBMessage.h"


@interface JBChatTableViewViewController ()

@end

@implementation JBChatTableViewViewController
@synthesize tableView = _tableView;
@synthesize keyboardView = _keyboardView;
@synthesize sendButton = _sendButton;
@synthesize textField = _textField;
@synthesize chatRoom = _chatRoom;
@synthesize client = _client;
@synthesize userName = _userName;



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
	
	self.title = self.chatRoom.recipient;
	
	//self.textField.inputAccessoryView = self.keyboardView;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	
	// Also listen for a notification signalling a new chat message has arrived
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageHasArrived:) name:JBChatRoomDidAddMessageNotification object:nil];
	
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.textField resignFirstResponder];
}


- (void)messageHasArrived:(NSNotification *)sender {
	NSLog(@"Heard notification about new message arriving. Reloading the tableView");
	[self.tableView reloadData];
	NSIndexPath *path = [NSIndexPath indexPathForRow:[self.chatRoom.chatMessages count] - 1 inSection:0];
	[self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[self.tableView flashScrollIndicators];
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
	NSNumber *animationCurveNumber = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
	
	
	[UIView animateWithDuration:animationDuration delay:0 options:[animationCurveNumber integerValue] animations:^{
		CGRect b = self.view.bounds;
		CGRect tableFrame = b;
		tableFrame.size.height -= self.keyboardView.bounds.size.height;
		
		CGRect k = self.keyboardView.bounds;
		k.origin.y = tableFrame.size.height;
		
		self.tableView.frame = tableFrame;
		self.keyboardView.frame = k;
	} completion:nil];
	
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self.chatRoom chatMessages] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	JBChatMessage *message = [self.chatRoom.chatMessages objectAtIndex:indexPath.row];
	
	cell.textLabel.textAlignment = [message.recipient isEqualToString:self.userName]? UITextAlignmentLeft : UITextAlignmentRight;
    
    cell.textLabel.text = message.text;
	
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}




- (IBAction)sendMessageWasPressed:(UIButton *)sender {
	if (![self.textField.text length])
		return;
	
	
	NSLog(@"Lets send a message!");
	
	NSDictionary *header = [NSDictionary dictionaryWithObject:kJBMessageHeaderTypeText forKey:kJBMessageHeaderType];
	NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:self.userName, kJBMessageBodyTypeSender, self.chatRoom.recipient, kJBMessageBodyTypeReceiver, self.textField.text, kJBMessageBodyTypeMessage, nil];
	
	JBMessage *message = [JBMessage messageWithHeader:header body:body];
	
	[self.client sendMessage:message withCallbackHandler:^(JBMessage *responseMessage) {
		NSLog(@"Chat message successfully sent.");
		[self.tableView reloadData];
	}];
	
	
	// Also, add this message to our chatroom object
	JBChatMessage *chat = [[JBChatMessage alloc] init];
	chat.text = self.textField.text;
	chat.timestamp = [NSDate date];
	chat.sender = self.userName;
	chat.recipient = self.chatRoom.recipient;
	chat.read = YES;
	
	[self.chatRoom addChatMessagesObject:chat];
	[self.tableView reloadData];
	NSIndexPath *path = [NSIndexPath indexPathForRow:[self.chatRoom.chatMessages count] - 1 inSection:0];
	[self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	self.textField.text = @"";
	
}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	return NO;
//}






































@end
