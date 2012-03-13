//
//  JBPersonTableViewCell.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-08.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBPerson;
@interface JBPersonTableViewCell : UITableViewCell
@property (nonatomic, strong) JBPerson *person;
@property (nonatomic, assign, getter = isLastNameBold) BOOL lastNameBold;
@end
