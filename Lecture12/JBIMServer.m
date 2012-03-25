//
//  JBIMServer.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-23.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBIMServer.h"
#import "GCDAsyncSocket.h"


@interface JBIMServer () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *listenSocket;
@property (nonatomic, strong) NSMutableArray *clientSockets;

@end

@implementation JBIMServer
@synthesize listenSocket = _listenSocket;
@synthesize clientSockets = _clientSockets;


- (void)startServer {
	
	self.clientSockets = [NSMutableArray array];
	
	self.listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	NSInteger DEFAULT_PORT = 8080;
	NSError *error = nil;
	if (![self.listenSocket acceptOnPort:DEFAULT_PORT error:&error]) {
		NSLog(@"Error starting the Server Socket: %@", [error userInfo]);
	}
	NSLog(@"Server socket started!");
}


- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
	
	NSLog(@"Server: Accepted a new client socket.");
	
	[self.clientSockets addObject:newSocket];
	[newSocket readDataWithTimeout:-1 tag:999];
	[newSocket readDataWithTimeout:-1 tag:998];
	
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	// Assume it's all JSON Data
	
	NSLog(@"Gonna readddddd %lu", tag);
	
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
