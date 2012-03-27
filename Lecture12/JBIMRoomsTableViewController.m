//
//  JBIMRoomsTableViewController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-23.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBIMRoomsTableViewController.h"
#import "JBIMClient.h"
#import "JBMessage.h"


@interface JBIMRoomsTableViewController () <NSNetServiceDelegate>

@property (nonatomic, strong) JBIMClient *networkClient;
@property (nonatomic, strong) NSMutableArray *loggedInUsers;

@end

@implementation JBIMRoomsTableViewController
@synthesize networkClient = _networkClient;
@synthesize netService = _netService;
@synthesize loggedInUsers = _loggedInUsers;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Users";
	
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
	NSInteger num = arc4random() % 10;
	NSString *userName = [NSString stringWithFormat:@"Jason%d", num];
	[self.networkClient startNetworkConnectionWithLoginName:userName loginCallbackHandler:^(JBMessage *responseMessage) {
		
		// Now logged in, update the room with a list of users
		NSMutableArray *users = [NSMutableArray arrayWithArray:[[responseMessage body] valueForKey:kJBMessageBodyTypeUsers]];
		self.loggedInUsers = users;
		NSLog(@"%@ Login succeeded, got users: %@", userName, users);
		[self.tableView reloadData];
		
	} usersChangedCallback:^(JBMessage *responseMessage) {
		
		// The list has either grown or shrunk. We need to update our view accordingly
		NSLog(@"Users changed!");
		
		
	} textMessageReceivedCallback:^(JBMessage *responseMessage) {
		
		// We got a message from some user
		// Figure out who sent the message,
		// Find the JBChat that corresponds to that user,
		// Add the new message to that Chat
		NSLog(@"We got a text message!");
		
	}];
	
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
	return [self.loggedInUsers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = [[self.loggedInUsers objectAtIndex:indexPath.row] description];
	
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
