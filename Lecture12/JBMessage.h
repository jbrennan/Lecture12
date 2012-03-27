//
//  JBMessage.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-25.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kJBMessageHeaderType;
extern NSString *const kJBMessageHeaderTypeLogin;
extern NSString *const kJBMessageTypeLogout;
extern NSString *const kJBMessageHeaderTypeText;
extern NSString *const kJBMessageBodyTypeSender;
extern NSString *const kJBMessageBodyTypeUsers;
extern NSString *const kJBMessageBodyTypeReceiver;
extern NSString *const kJBMessageBodyTypeMessage;

@interface JBMessage : NSObject

@property (nonatomic, strong) NSDictionary *header;
@property (nonatomic, strong) NSDictionary *body;


+ (id)messageWithHeader:(NSDictionary *)header body:(NSDictionary *)body;
+ (id)messageWithJSONData:(NSData *)data;
- (NSData *)JSONData;

@end
