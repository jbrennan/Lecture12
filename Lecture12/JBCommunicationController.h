//
//  JBCommunicationController.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-15.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_PORT 8080

typedef void(^JBCommunicationCallback)(id payload, NSError *error);

@class NSInputStream, NSOutputStream;
@interface JBCommunicationController : NSObject

@property (nonatomic, copy) JBCommunicationCallback messageRecievedCallback;

- (id)initWithServerAddress:(NSString *)address port:(NSInteger)port;
- (void)startNetworkCommunication;
- (void)stop;

- (void)sendMessage:(id)message;

@end
