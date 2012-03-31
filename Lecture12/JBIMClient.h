//
//  JBIMClient.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-23.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const JBIMClientApplicationClosingNotification;

@class JBMessage;

typedef void(^JBIMClientMessageCallback)(JBMessage *responseMessage);

@interface JBIMClient : NSObject

- (id)initWithHost:(NSData *)address;
- (void)startNetworkConnectionWithLoginName:(NSString *)loginName loginCallbackHandler:(JBIMClientMessageCallback)callback usersChangedCallback:(JBIMClientMessageCallback)changedCallback textMessageReceivedCallback:(JBIMClientMessageCallback)textMessageReceivedCallback;

- (void)sendMessage:(JBMessage *)message withCallbackHandler:(JBIMClientMessageCallback)callback;

@end
