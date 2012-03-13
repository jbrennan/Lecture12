//
//  JBName.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-08.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBPerson.h"

@implementation JBPerson
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;

- (NSString *)fullName {
	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
