//
//  JBCommunicationController.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-15.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JBCommunicationCallback)(id payload, NSError *error);

@class NSInputStream, NSOutputStream;
@interface JBCommunicationController : NSObject

@property (nonatomic, copy) JBCommunicationCallback messageRecievedCallback;

- (void)startNetworkCommunication;

- (void)sendMessage:(id)message;

@end
