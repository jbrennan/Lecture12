//
//  JBIMClient.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-23.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBIMClient.h"
#import "GCDAsyncSocket.h"
#import "JBMessage.h"

#define kMessageSentTag 99
#define kMessageReplyTag 999
#define kMessageFromServer 1

#define IN_CALLBACK_RANGE 1000


@interface JBIMClient () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSData *address;
@property (nonatomic, strong) NSMutableDictionary *messageCallbackHandlers;
@property (nonatomic, copy) JBIMClientMessageCallback loginCallback;
@property (nonatomic, strong) NSString *loginName;

@end


@implementation JBIMClient
@synthesize clientSocket = _clientSocket;
@synthesize address = _address;
@synthesize messageCallbackHandlers = _messageCallbackHandlers;
@synthesize loginCallback = _loginCallback;
@synthesize loginName = _loginName;



- (id)initWithHost:(NSData *)address {
	if ((self = [super init])) {

		self.address = address;
		self.messageCallbackHandlers = [NSMutableDictionary dictionary];
		self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		
	}
	
    return self;
}


- (void)startNetworkConnectionWithLoginName:(NSString *)loginName loginCallbackHandler:(JBIMClientMessageCallback)callback usersChangedCallback:(JBIMClientMessageCallback)changedCallback textMessageReceivedCallback:(JBIMClientMessageCallback)textMessageReceivedCallback; {
	NSError *error = nil;
	self.loginCallback = callback;
	self.loginName = loginName;
	
	[self.messageCallbackHandlers setValue:[changedCallback copy] forKey:kJBMessageHeaderTypeLogin]; // We'll get this message unsolicited from the server.. that's why it's different from self.loginCallback
	[self.messageCallbackHandlers setValue:[changedCallback copy] forKey:kJBMessageHeaderTypeLogout]; // Adding the same block twice, because it'll handle logouts, too (basically any kind of user-list change).
	[self.messageCallbackHandlers setValue:[textMessageReceivedCallback copy] forKey:kJBMessageHeaderTypeText];
	
	if (![self.clientSocket connectToAddress:self.address error:&error]) {
		NSLog(@"Error connecting to server: %@", [error userInfo]);
		return;
	}
	
	NSLog(@"Going to connect to the host");
	
	
}

- (void)sendMessage:(JBMessage *)message withCallbackHandler:(JBIMClientMessageCallback)callback {
	NSData *data = [message JSONData];
	
	long identifierTag = (arc4random() % 5000) + IN_CALLBACK_RANGE;
	[self.messageCallbackHandlers setValue:[callback copy] forKey:[NSString stringWithFormat:@"%l", identifierTag]];
	
	[self.clientSocket writeData:data withTimeout:-1 tag:kMessageSentTag];
	[self.clientSocket readDataWithTimeout:-1 tag:identifierTag];
}


#pragma mark -
#pragma mark GCDAsyncSocketDelegate methods

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
	NSLog(@"Did connect to the server!");
	
	// Now send the login message
	
	NSDictionary *header = [NSDictionary dictionaryWithObject:kJBMessageHeaderTypeLogin forKey:kJBMessageHeaderType];
	NSDictionary *body = [NSDictionary dictionaryWithObject:self.loginName forKey:kJBMessageBodyTypeSender];
	
	JBMessage *message = [JBMessage messageWithHeader:header body:body];
	
	[self sendMessage:message withCallbackHandler:self.loginCallback];
}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
	NSLog(@"Did write some data for tag: %lu", tag);
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSLog(@"Got data for tag: %lu", tag);
	
	
	if (tag > IN_CALLBACK_RANGE) {
	// Get the callback handler for this read
		NSString *identifierString = [NSString stringWithFormat:@"%l", tag];
		JBIMClientMessageCallback callback = [self.messageCallbackHandlers objectForKey:identifierString];
		
		if (nil != callback) {
			NSLog(@"Will execute client callback handler");
			JBMessage *response = [JBMessage messageWithJSONData:data];
			callback(response);
			[self.messageCallbackHandlers removeObjectForKey:identifierString];
		} else {
			NSLog(@"No client callback handler to execute");
		}
		
		NSString *j = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"From server: %@", j);
	} else {
		// it came from something else... dispatch it!
		JBMessage *message = [JBMessage messageWithJSONData:data];
		JBIMClientMessageCallback handler = [self.messageCallbackHandlers objectForKey:[[[message header] valueForKey:kJBMessageHeaderType] uppercaseString]];
		
		if (nil != handler) {
			NSLog(@"Invoking a handler for the Server message");
			handler(message);
		} else {
			NSLog(@"Client: Couldn't find a handler for this message!!!");
			NSString *j = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSLog(@"New From server: %@", j);
		}
		
		

	}
	
	// We also need to tell it to just read generically.
	// Because we might get an event from another user say, like when they log out or log in for example
	[self.clientSocket readDataWithTimeout:-1 tag:kMessageFromServer];
}


@end
