//
//  JBPersonTableViewCell.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-08.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBPersonTableViewCell.h"
#import "JBPerson.h"


@interface JBPersonTableViewCell ()
@property (nonatomic, strong) UILabel *firstNameLabel;
@property (nonatomic, strong) UILabel *lastNameLabel;
@end


@implementation JBPersonTableViewCell
@synthesize person = _person;
@synthesize firstNameLabel = _firstNameLabel;
@synthesize lastNameLabel = _lastNameLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		self.firstNameLabel.textColor = [UIColor blackColor];
		self.lastNameLabel.textColor = [UIColor blackColor];
		
		[self.contentView addSubview:self.firstNameLabel];
		[self.contentView addSubview:self.lastNameLabel];
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setPerson:(JBPerson *)person {
	if (_person == person)
		return;
	_person = person;
	
	self.firstNameLabel.text = person.firstName;
	self.lastNameLabel.text = person.lastName;
	
	[self.firstNameLabel sizeToFit];
	[self.lastNameLabel sizeToFit];
	
}


@end
