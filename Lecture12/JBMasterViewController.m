//
//  JBMasterViewController.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-08.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBMasterViewController.h"
#import "JBDetailViewController.h"
#import "JBPerson.h"
#import "JBPersonTableViewCell.h"
#import "JBMessageViewController.h"


@interface JBMasterViewController ()
@property (nonatomic, strong) NSMutableArray *names;
@end



@implementation JBMasterViewController {
	BOOL _last;
}
@synthesize detailViewController = _detailViewController;
@synthesize names = _names;
@synthesize firstNameSorter = _firstNameSorter;
@synthesize lastNameSorter = _lastNameSorter;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Names";
	
	
	JBPerson *jason = [[JBPerson alloc] init];
	jason.firstName = @"Jason";
	jason.lastName = @"Brennan";
	
	JBPerson *zaphod = [[JBPerson alloc] init];
	zaphod.firstName = @"Zaphod";
	zaphod.lastName = @"Beeblebrox";
	
	JBPerson *ford = [[JBPerson alloc] init];
	ford.firstName = @"Ford";
	ford.lastName = @"Prefect";
	
	//NSArray *n = [NSArray arrayWithObjects:jason, zaphod, ford, nil];
	
	self.firstNameSorter = ^NSComparisonResult(id obj1, id obj2) {
		return [[(JBPerson *)obj1 firstName] compare:[(JBPerson *)obj2 firstName]];
	};
	
	self.lastNameSorter = ^NSComparisonResult(id obj1, id obj2) {
		return [[(JBPerson *)obj1 lastName] compare:[(JBPerson *)obj2 lastName]];
	};
	
	self.names = [NSMutableArray array];//[n sortedArrayUsingComparator:self.firstNameSorter];
	_last = NO;
	
	
	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"First", @"Last", nil]];
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	segment.selectedSegmentIndex = 0;
	[segment addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
	
	
	self.navigationItem.titleView = segment;
	
	
	// Start fetching the data
	NSOperationQueue *q = [[NSOperationQueue alloc] init];
	for (NSInteger i = 1; i < 6; i++) {
		// start the operation
		NSString *urlString = [NSString stringWithFormat:@"http://sikaman.dyndns.org:8888/courses/2601/data/%i.txt", i];
		[q addOperationWithBlock:^{
			NSArray *people = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:urlString]];
			NSLog(@"%@", people);
			
			JBPerson *person = [[JBPerson alloc] init];
			person.firstName = [people objectAtIndex:0];
			person.lastName = [people objectAtIndex:1];
			person.phone = [people objectAtIndex:2];
			
			[self.names addObject:person];
			[self.names sortUsingComparator:(_last ? self.lastNameSorter : self.firstNameSorter)];
			[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
			
		}];
	}
	
	
	
	// Manually present the messages controller
	JBMessageViewController *messages = [[JBMessageViewController alloc] initWithNibName:@"JBMessageViewController" bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:messages];
	[self presentModalViewController:nav animated:YES];
	
	
	
}


- (void)segmentDidChange:(UISegmentedControl *)sender {
//	self.names = [self.names s:(sender.selectedSegmentIndex == 0? self.firstNameSorter : self.lastNameSorter)];
	[self.names sortUsingComparator:(sender.selectedSegmentIndex == 0? self.firstNameSorter : self.lastNameSorter)];
	_last = sender.selectedSegmentIndex == 1;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.names count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    JBPersonTableViewCell *cell = (JBPersonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[JBPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
	cell.lastNameBold = _last;
    cell.person = [self.names objectAtIndex:indexPath.row];
	//cell.imageView.image = [UIImage imageNamed:@"cat"];
	
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
