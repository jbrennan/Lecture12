//
//  JBUser.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-25.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDAsyncSocket;
@interface JBUser : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) GCDAsyncSocket *socket;

@end
