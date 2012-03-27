//
//  JBIMClient.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-23.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBMessage;

typedef void(^JBIMClientMessageCallback)(JBMessage *responseMessage);

@interface JBIMClient : NSObject

- (id)initWithHost:(NSData *)address;
- (void)startNetworkConnectionWithLoginName:(NSString *)loginName callbackHandler:(JBIMClientMessageCallback)callback;

- (void)sendMessage:(JBMessage *)message withCallbackHandler:(JBIMClientMessageCallback)callback;

@end
