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
#import "JBChatTableViewViewController.h"
#import "JBChatRoom.h"


@interface JBIMRoomsTableViewController () <NSNetServiceDelegate>

@property (nonatomic, strong) JBIMClient *networkClient;
@property (nonatomic, strong) NSMutableArray *chats;

- (void)addChatRoomForUser:(NSString *)user;
- (void)removeChatRoomForUser:(NSString *)user;

@end

@implementation JBIMRoomsTableViewController
@synthesize networkClient = _networkClient;
@synthesize netService = _netService;
@synthesize chats = _chats;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Users";
	self.chats = [NSMutableArray array];
	
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
		
		for (NSString *user in users) {
			[self addChatRoomForUser:user];
		}
		
		NSLog(@"%@ Login succeeded, got users: %@", userName, users);
		[self.tableView reloadData];
		
	} usersChangedCallback:^(JBMessage *responseMessage) {
		
		// The list has either grown or shrunk. We need to update our view accordingly
		NSLog(@"Users changed!");
		
		
		NSString *header = [[responseMessage header] valueForKey:kJBMessageHeaderType];
		if ([header isEqualToString:kJBMessageHeaderTypeLogin]) {
			// it's a login, so look for the new user!
			[self addChatRoomForUser:[[responseMessage body] valueForKey:kJBMessageBodyTypeSender]];
		} else {
			// it's a logout, so see who's logged out and remove them
			[self removeChatRoomForUser:[[responseMessage body] valueForKey:kJBMessageBodyTypeSender]];
		}
		
		[self.tableView reloadData];
		
		
		
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


- (void)addChatRoomForUser:(NSString *)user {
	JBChatRoom *room = [[JBChatRoom alloc] init];
	room.recipient = user;
	[self.chats addObject:room];
}


- (void)removeChatRoomForUser:(NSString *)user {
	JBChatRoom *toRemove = nil;
	for (JBChatRoom *room in self.chats) {
		if ([room.recipient isEqualToString:user]) {
			toRemove = room;
			break;
		}
	}
	
	if (nil != toRemove) {
		[self.chats removeObject:toRemove];
		// Post a notification that this user has now gone offline?
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.chats count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = [[self.chats objectAtIndex:indexPath.row] recipient];
	
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	JBChatTableViewViewController *chatController = [[JBChatTableViewViewController alloc] initWithNibName:@"JBChatTableViewViewController" bundle:nil];
	[self.navigationController pushViewController:chatController animated:YES];
	
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
