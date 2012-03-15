//
//  JBCommunicationController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-15.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBCommunicationController.h"


@interface JBCommunicationController () <NSStreamDelegate>

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

@end


@implementation JBCommunicationController
@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;

- (void)blah {
	[self.inputStream setDelegate:self];
}

@end
