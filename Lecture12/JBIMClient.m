//
//  JBIMClient.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-23.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBIMClient.h"
#import "GCDAsyncSocket.h"


@interface JBIMClient () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSData *address;

@end


@implementation JBIMClient
@synthesize clientSocket = _clientSocket;
@synthesize address = _address;



- (id)initWithHost:(NSData *)address {
	if ((self = [super init])) {

		self.address = address;
		self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		
	}
	
    return self;
}


- (void)startNetworkConnection {
	NSError *error = nil;
	if (![self.clientSocket connectToAddress:self.address error:&error]) {
		NSLog(@"Error connecting to server: %@", [error userInfo]);
		return;
	}
	
	NSLog(@"Going to connect to the host");
	
	NSDictionary *d = [NSDictionary dictionaryWithObject:@"Login" forKey:@"type"];
	NSDictionary *e = [NSDictionary dictionaryWithObject:@"HALLO" forKey:@"greeting"];
	
	NSError *jError = nil;
	NSData *b = [NSJSONSerialization dataWithJSONObject:d options:kNilOptions error:&jError];
	if (nil == b) {
		NSLog(@"There was an error creating the JSON data %@", [jError userInfo]);
	}
	
	NSData *f = [NSJSONSerialization dataWithJSONObject:e options:kNilOptions error:NULL];
	
	[self.clientSocket writeData:b withTimeout:-1 tag:99];
	[self.clientSocket writeData:f withTimeout:-1 tag:98];
	
}


#pragma mark -
#pragma mark GCDAsyncSocketDelegate methods

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
	NSLog(@"Did connect to the server!");
}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
	NSLog(@"Did write some data for tag: %lu", tag);
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSLog(@"Got data for tag: %lu", tag);
	
	NSString *j = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"%@", j);
}


@end
