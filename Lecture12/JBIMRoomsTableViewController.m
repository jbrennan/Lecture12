//
//  JBIMRoomsTableViewController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-23.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBIMRoomsTableViewController.h"
#import "JBIMClient.h"


@interface JBIMRoomsTableViewController () <NSNetServiceDelegate>

@property (nonatomic, strong) JBIMClient *networkClient;

@end

@implementation JBIMRoomsTableViewController
@synthesize networkClient = _networkClient;
@synthesize netService = _netService;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Rooms";
	
}


- (void)setNetService:(NSNetService *)netService {
	if (netService == _netService)
		return;
	
	_netService = netService;
	
	_netService.delegate = self;
	[_netService resolveWithTimeout:0];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


#pragma mark -
#pragma mark NSNetServiceDelegate methods

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
	// Now ask for the addresses, and get the first one
	NSArray *addresses = [sender addresses];
	NSData *info = [addresses objectAtIndex:0];
	
	self.networkClient = [[JBIMClient alloc] initWithHost:info];
	[self.networkClient startNetworkConnection];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
}


- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	NSLog(@"Room could not resolve a connection! %@", errorDict);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    
	
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *d = [NSDictionary dictionaryWithObject:@"HALLO" forKey:@"greeting"];
//	NSData *data = [NSJSONSerialization dataWithJSONObject:d options:kNilOptions error:NULL];
//	
//	[self.communicationClient sendMessage:data];
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
