//
//  JBCommunicationController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-15.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBCommunicationController.h"

#define BUFFER_SIZE 1024

@interface JBCommunicationController () <NSStreamDelegate>

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) NSInteger port;

- (void)inputStreamHandleEvent:(NSStreamEvent)eventCode;
- (void)outputStreamHandleEvent:(NSStreamEvent)eventCode;

@end


@implementation JBCommunicationController
@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;
@synthesize messageRecievedCallback = _messageRecievedCallback;
@synthesize host = _host;
@synthesize port = _port;

- (id)initWithServerAddress:(NSString *)address port:(NSInteger)port {
	if ((self = [super init])) {
		self.host = address;
		self.port = port;
	}
	
    return self;
}


- (void)startNetworkCommunication {
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	
	CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.host, self.port, &readStream, &writeStream);
	self.inputStream = (__bridge NSInputStream *)readStream;
	self.outputStream = (__bridge NSOutputStream *)writeStream;
	
	[self.inputStream setDelegate:self];
	[self.outputStream setDelegate:self];
	
	[self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	[self.inputStream open];
	[self.outputStream open];
	
	NSLog(@"Started stuff!");
}


- (void)sendMessage:(id)message {
	NSString *m = [message description];
	
	NSData *messageData = [m dataUsingEncoding:NSUTF8StringEncoding];
	[self.outputStream write:[messageData bytes] maxLength:[messageData length]];
}


- (void)readMessageFromInputStream {
	uint8_t buffer[BUFFER_SIZE];
	NSUInteger len;
	
	while ([self.inputStream hasBytesAvailable]) {
		len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
		if (len > 0) {
			NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
			
			if (nil != output) {
				if (nil != self.messageRecievedCallback) {
					self.messageRecievedCallback(output, nil);
				}
			}
		}
	}
}



- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
	if (aStream == self.inputStream)
		[self inputStreamHandleEvent:eventCode];
	else if (aStream == self.outputStream)
		[self outputStreamHandleEvent:eventCode];
	else
		NSLog(@"Unknown stream with event: %d", eventCode);
}


- (void)inputStreamHandleEvent:(NSStreamEvent)eventCode {
	switch (eventCode) {
			
		case NSStreamEventOpenCompleted: {
			NSLog(@"Input Stream has opened");
			break;
		}
			
			
		case NSStreamEventHasBytesAvailable: {
			[self readMessageFromInputStream];
			break;
		}
			
		case NSStreamEventEndEncountered: {
			NSLog(@"Input event ended");
			break;
		}
			
			
		case NSStreamEventErrorOccurred: {
			NSLog(@"Input stream error %@", [[self.inputStream streamError] localizedDescription]);
			break;
		}
			
			
		default: break;
	}
}


- (void)outputStreamHandleEvent:(NSStreamEvent)eventCode {
	switch (eventCode) {
			
		case NSStreamEventOpenCompleted: {
			NSLog(@"Output stream has opened");
			break;
		}
			
			
		case NSStreamEventHasSpaceAvailable: {
			break;
		}
			
		case NSStreamEventEndEncountered: {
			break;
		}
			
			
		case NSStreamEventErrorOccurred: {
			NSLog(@"Output error %@", [[self.outputStream streamError] localizedDescription]);
			break;
		}
			
			
		default: break;
	}
}


@end
