//
//  JBChatRoom.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-27.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBChatRoom.h"
#import "JBChatMessage.h"

NSString *const JBChatRoomDidAddMessageNotification = @"JBChatRoomDidAddMessage";
NSString *const JBChatRoomDidCloseNotification = @"JBChatRoomDidClose";

@implementation JBChatRoom
@synthesize chatMessages = _chatMessages;
@synthesize recipient = _recipient;


- (id)init {
	if ((self = [super init])) {
		self.chatMessages = [NSMutableArray array];
	}
	
    return self;
}


- (void)addChatMessagesObject:(JBChatMessage *)chatMessage {
	[self.chatMessages addObject:chatMessage];
	
	// Sort the messages by date
	[self.chatMessages sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [[(JBChatMessage *)obj1 timestamp] compare:[(JBChatMessage *)obj2 timestamp]];
	}];
}


- (void)setAllMessagesRead {
	[self.chatMessages makeObjectsPerformSelector:@selector(setMessageRead)];
}


- (BOOL)hasUnreadMessage {
	for (JBChatMessage *message in self.chatMessages) {
		if (!message.read)
			return YES;
	}
	
	return NO;
}


@end
