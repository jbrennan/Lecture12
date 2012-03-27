//
//  JBChatRoom.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-27.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBChatMessage;
@interface JBChatRoom : NSObject

@property (nonatomic, strong) NSString *recipient; // The username of the buddy you're talking to
@property (nonatomic, strong) NSMutableArray *chatMessages;

- (void)addChatMessagesObject:(JBChatMessage *)chatMessage;
- (void)setAllMessagesRead;
- (BOOL)hasUnreadMessage;

@end
