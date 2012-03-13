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

- (void)commonHighlighting:(BOOL)selected;

@end


@implementation JBPersonTableViewCell
@synthesize person = _person;
@synthesize firstNameLabel = _firstNameLabel;
@synthesize lastNameLabel = _lastNameLabel;
@synthesize lastNameBold = _lastNameBold;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		self.firstNameLabel.textColor = [UIColor blackColor];
		//self.firstNameLabel.backgroundColor = [UIColor yellowColor];
		self.lastNameLabel.textColor = [UIColor blackColor];
		
		[self.contentView addSubview:self.firstNameLabel];
		[self.contentView addSubview:self.lastNameLabel];
		
		self.lastNameBold = YES;
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	[self commonHighlighting:selected];
	
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	[self commonHighlighting:highlighted];
}


- (void)commonHighlighting:(BOOL)selected {
	UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *textColor = [UIColor darkTextColor];
	
	if (selected) {
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
	}
	
	self.firstNameLabel.backgroundColor = backgroundColor;
	self.firstNameLabel.textColor = textColor;
	self.lastNameLabel.backgroundColor = backgroundColor;
	self.lastNameLabel.textColor = textColor;
}


#define PADDING 20.0f
- (void)setPerson:(JBPerson *)person {
	if (_person == person)
		return;
	_person = person;
	
	self.firstNameLabel.text = person.firstName;
	self.lastNameLabel.text = person.lastName;
	
	[self setNeedsLayout];
	
//	[self.firstNameLabel sizeToFit];
//	[self.lastNameLabel sizeToFit];
//	
//	CGRect firstFrame = self.firstNameLabel.frame;
//	firstFrame.origin.x = PADDING;
//	CGRect secondFrame = self.lastNameLabel.frame;
//	
//	secondFrame.origin.x += firstFrame.size.width + PADDING / 2.0f;
//	self.firstNameLabel.frame = firstFrame;
//	self.lastNameLabel.frame = secondFrame;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect r = CGRectInset(self.contentView.bounds, 10, 10);
	CGRect f = r;
	
	[self.firstNameLabel sizeToFit];
	[self.lastNameLabel sizeToFit];
	
	//f.origin.y = (f.size.height / 2.0f) - (self.firstNameLabel.bounds.size.height / 2.0f);
	f.size.width = self.firstNameLabel.bounds.size.width;
	//f.size.height = self.firstNameLabel.bounds.size.height;
	self.firstNameLabel.frame = f;
	
	f.origin.x += f.size.width + PADDING / 2.0f;
	f.size.width = self.lastNameLabel.bounds.size.width;
	self.lastNameLabel.frame = f;
	
	
	
}


- (void)setLastNameBold:(BOOL)newBold {
	if (_lastNameBold == newBold)
		return;
	
	_lastNameBold = newBold;
	if (newBold) {
		self.firstNameLabel.font = [UIFont systemFontOfSize:18.0f];
		self.lastNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	} else {
		self.firstNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
		self.lastNameLabel.font = [UIFont systemFontOfSize:18.0f];
	}
}


@end
