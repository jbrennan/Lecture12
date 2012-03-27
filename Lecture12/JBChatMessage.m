//
//  JBChatMessage.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-27.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBChatMessage.h"

@implementation JBChatMessage

@synthesize sender = _sender;
@synthesize recipient = _recipient;
@synthesize timestamp = _timestamp;
@synthesize text = _text;
@synthesize read = _read;


- (void)setMessageRead {
	self.read = YES;
}

@end
