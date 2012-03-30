//
//  JBChatTableViewViewController.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-27.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBChatRoom;
@class JBIMClient;
@interface JBChatTableViewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) JBChatRoom *chatRoom;
@property (nonatomic, strong) JBIMClient *client;
@property (nonatomic, strong) NSString *userName;


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *keyboardView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UITextField *textField;


- (IBAction)sendMessageWasPressed:(UIButton *)sender;
@end
