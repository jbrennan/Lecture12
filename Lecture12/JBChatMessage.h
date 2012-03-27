//
//  JBChatMessage.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-27.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBChatMessage : NSObject

@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *recipient;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL read;

- (void)setMessageRead;

@end
