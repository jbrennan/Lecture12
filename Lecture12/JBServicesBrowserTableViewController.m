//
//  JBServicesBrowserTableViewController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-20.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBServicesBrowserTableViewController.h"
#import "JBServicesBrowser.h"


@interface JBServicesBrowserTableViewController ()

@property (nonatomic, strong) NSMutableArray *servers;
@property (nonatomic, strong) JBServicesBrowser *servicesBrowser;

@end

@implementation JBServicesBrowserTableViewController
@synthesize servers = _servers;
@synthesize servicesBrowser = _servicesBrowser;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Message Servers";
	
	self.servers = [NSMutableArray array];
	self.servicesBrowser = [[JBServicesBrowser alloc] initWithServicesCallback:^(id servicesFound, BOOL moreComing, NSDictionary *error) {
		if (nil != error) {
			NSLog(@"There was an error browsing for services: %@", error);
			return;
		}
		
		self.servers = servicesFound;
		[self.tableView reloadData];
	}];
	
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.servers count] + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static CGFloat defaultCellSize;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		defaultCellSize = cell.textLabel.font.pointSize;
		NSLog(@"Default size is: %f", defaultCellSize);
    }
    
    if (indexPath.row >= [self.servers count]) {
		// the "Start Service" row
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor blueColor];
		cell.textLabel.text = @"Start new chat server";
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
		cell.accessoryType = UITableViewCellAccessoryNone;
		
	} else {
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.textLabel.textColor = [UIColor darkTextColor];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:defaultCellSize];
		cell.textLabel.text = [[self.servers objectAtIndex:indexPath.row] name];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
	
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row >= [self.servers count]) {
		// start the service
		[self.servicesBrowser publishServiceForUsername:@"Jason's IM Server" publicationCallback:^(id success, NSDictionary *errorDictionary) {
			if (nil != errorDictionary) {
				NSLog(@"There was an error publishing the service! %@", errorDictionary);
				return;
			}
			
			NSLog(@"The service was successfully published!");
			
		}];
	} else {
		// browse the service
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end
