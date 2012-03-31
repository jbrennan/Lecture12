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
@property (nonatomic, strong) UILabel *phoneLabel;

- (void)commonHighlighting:(BOOL)selected;

@end


@implementation JBPersonTableViewCell
@synthesize person = _person;
@synthesize firstNameLabel = _firstNameLabel;
@synthesize lastNameLabel = _lastNameLabel;
@synthesize lastNameBold = _lastNameBold;
@synthesize phoneLabel = _phoneLabel;
@synthesize userImageView = _userImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		self.firstNameLabel.textColor = [UIColor darkTextColor];
		self.lastNameLabel.textColor = [UIColor darkTextColor];
		
		self.phoneLabel.textColor = [UIColor lightTextColor];
		self.phoneLabel.textAlignment = UITextAlignmentRight;
		
		self.userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		
		[self.contentView addSubview:self.firstNameLabel];
		[self.contentView addSubview:self.lastNameLabel];
		[self.contentView addSubview:self.phoneLabel];
		[self.contentView addSubview:self.userImageView];
		
		self.lastNameBold = YES;
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	[self commonHighlighting:selected];
	
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	[self commonHighlighting:highlighted];
}


- (void)commonHighlighting:(BOOL)selected {
	UIColor *backgroundColor = [UIColor clearColor];
	UIColor *textColor = [UIColor darkTextColor];
	UIColor *phoneColor = [UIColor lightGrayColor];
	
	if (selected) {
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
		phoneColor = [UIColor whiteColor];
	}
	
	self.firstNameLabel.backgroundColor = backgroundColor;
	self.firstNameLabel.textColor = textColor;
	
	self.lastNameLabel.backgroundColor = backgroundColor;
	self.lastNameLabel.textColor = textColor;
	
	self.phoneLabel.backgroundColor = backgroundColor;
	self.phoneLabel.textColor = phoneColor;
}


#define PADDING 20.0f
- (void)setPerson:(JBPerson *)person {
	if (_person == person)
		return;
	_person = person;
	
	self.firstNameLabel.text = person.firstName;
	self.lastNameLabel.text = person.lastName;
	self.phoneLabel.text = person.phone;
	
	[self setNeedsLayout];
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect b = self.contentView.bounds;
	b.size.width = b.size.height; // make it a square
	self.userImageView.frame = b;
	
	CGRect remaining = self.contentView.bounds;
	remaining.size.width -= b.size.width;
	remaining.origin.x = b.size.width;
	
	CGRect r = CGRectInset(remaining, 10, 10);
	CGRect f = r;
	
	[self.firstNameLabel sizeToFit];
	[self.lastNameLabel sizeToFit];
	[self.phoneLabel sizeToFit];
	
	//f.origin.y = (f.size.height / 2.0f) - (self.firstNameLabel.bounds.size.height / 2.0f);
	f.size.width = self.firstNameLabel.bounds.size.width;
	//f.size.height = self.firstNameLabel.bounds.size.height;
	self.firstNameLabel.frame = f;
	
	f.origin.x += f.size.width + 5.0f;
	f.size.width = self.lastNameLabel.bounds.size.width;
	self.lastNameLabel.frame = f;
	
	b = self.phoneLabel.bounds;
	f.origin.x = r.size.width - b.size.width;
	f.size.width = b.size.width;
	self.phoneLabel.frame = f;
	
	
	
	
	
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
