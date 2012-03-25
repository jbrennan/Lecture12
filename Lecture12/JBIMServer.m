//
//  JBIMServer.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-23.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBIMServer.h"
#import "GCDAsyncSocket.h"
#import "JBMessage.h"


#define kClientSocketReadTag 100
#define kClientSocketWriteTag 101

typedef JBMessage *(^JBEventHandlerBlock)(id event);


@interface JBIMServer () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *listenSocket;
@property (nonatomic, strong) NSMutableArray *clientSockets;
@property (nonatomic, strong) NSMutableDictionary *reactors;

- (JBMessage *)responseMessageByProcessingMessage:(JBMessage *)message;
- (NSArray *)recipientsForSourceMessage:(JBMessage *)message;
- (void)writeResponse:(JBMessage *)response toRecipients:(NSArray *)recipients;
- (void)addEventType:(NSString *)type handler:(JBEventHandlerBlock)handler;

@end

@implementation JBIMServer
@synthesize listenSocket = _listenSocket;
@synthesize clientSockets = _clientSockets;
@synthesize reactors = _reactors;


- (void)startServer {
	
	self.clientSockets = [NSMutableArray array];
	self.reactors = [NSMutableDictionary dictionary];
	
	self.listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	NSInteger DEFAULT_PORT = 8080;
	NSError *error = nil;
	if (![self.listenSocket acceptOnPort:DEFAULT_PORT error:&error]) {
		NSLog(@"Error starting the Server Socket: %@", [error userInfo]);
	}
	NSLog(@"Server socket started!");
	
	
	// Add event handlers for different message types
	[self addEventType:kJBMessageHeaderTypeLogin handler:^JBMessage *(id event) {
		//JBMessage *message = [event message];
		return nil;
	}];
	
}


- (JBMessage *)responseMessageByProcessingMessage:(JBMessage *)message {
	
	
	// Figure out what type of message this is, and create an appropriate response
	
	
	return nil;
}


- (NSArray *)recipientsForSourceMessage:(JBMessage *)message {
	return nil;
}


- (void)writeResponse:(JBMessage *)response toRecipients:(NSArray *)recipients {
	for (GCDAsyncSocket *socket in recipients) {
		NSData *data = [response JSONData];
		[socket writeData:data withTimeout:-1 tag:kClientSocketWriteTag];
	}
}


- (void)addEventType:(NSString *)type handler:(JBEventHandlerBlock)handler {
	[self.reactors setValue:[handler copy] forKey:type];
}


#pragma mark -
#pragma mark GCDAsyncSocketDelegate methods
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
	
	NSLog(@"Server: Accepted a new client socket.");
	
	[self.clientSockets addObject:newSocket];
	
	
	// Set up some data to go along with that client's socket. We can pull this out later when the user has logged in.
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[newSocket setUserData:dictionary];
	
	// Get the new socket to start reading.. we're trying to listen for the client's login message
	[newSocket readDataWithTimeout:-1 tag:kClientSocketReadTag];
	
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	// Assume it's all JSON Data
	
	NSLog(@"Gonna readddddd %lu", tag);
	
	
	switch (tag) {
		case kClientSocketReadTag: {
			
			// Read the object
			JBMessage *message = [JBMessage messageWithJSONData:data];
			// Process it
			JBMessage *response = [self responseMessageByProcessingMessage:message];
			// Write a response
			[self writeResponse:response toRecipients:[self recipientsForSourceMessage:message]];
			break;
			
		}
			
		default: break;
	}
	
	
	NSError *error = nil;
	NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	if (nil == dictionary) {
		NSLog(@"There was an error reading data from a client socket! %@", [error userInfo]);
		return;
	}
	
	NSLog(@"Object received from a client: %@", dictionary);
	
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
	if (sock != self.listenSocket) {
		NSLog(@"A client has disconnected");
		[self.clientSockets removeObject:sock];
		
		// Now inform every other client this one has disconnected....
	}
}




@end
