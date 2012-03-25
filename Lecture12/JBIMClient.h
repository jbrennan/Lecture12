//
//  JBIMClient.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-23.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBMessage;
@interface JBIMClient : NSObject

- (id)initWithHost:(NSData *)address;
- (void)startNetworkConnection;

- (void)sendMessage:(JBMessage *)message;

@end