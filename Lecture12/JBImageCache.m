//
//  JBImageCache.m
//  Lecture12
//
//  Created by Jason Brennan on 12-03-30.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBImageCache.h"
#import <dispatch/dispatch.h>

// unicorns are way more fun than actual pictures. Plus, this works with any NSString you can throw at it, instead of hardcoded values on some server. Far more flexible, yeah?
#define kImageURL @"http://unicornify.appspot.com/avatar/%@?s=128"

@interface JBImageCache ()
@property (strong) NSMutableDictionary *cachedImages;
- (NSString *)stringToHex:(NSString *)str;
@end


@implementation JBImageCache
@synthesize cachedImages;

- (id)init {
    self = [super init];
    if (self) {
        self.cachedImages = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)loadImageForString:(NSString *)string completionHandler:(JBImageCacheCompletionBlock)completionBlock {
	
	// The benefit to using GCD here is not only will this be done asyncronously,
	// but all this code will be dispatched to different worker threads as they become available.
	// Meaning, if we're trying to load a bunch of cells, GCD will maximize the number of threads
	// and make best use of the available cores automatically.
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
		// Async code
		UIImage *image = [self.cachedImages objectForKey:string];
		
		if (nil == image) {
			// load it off the internet
			NSString *hex = [self stringToHex:string];
			NSString *urlString = [NSString stringWithFormat:kImageURL, hex];
			NSURL *url = [NSURL URLWithString:urlString];
			
			// indicate to the user the image is loading
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
			if (nil == image) {
				NSLog(@"Error loading image :(");
			} else {
				// cache the image now
				[self.cachedImages setObject:image forKey:string];
			}
		}
		
		dispatch_sync(dispatch_get_main_queue(),^() {
			// Main Queue code
			completionBlock(string, image);
		});
		
	});
	
}

// c.f.: http://stackoverflow.com/questions/3056757/how-to-convert-an-nsstring-to-hex-values
- (NSString *)stringToHex:(NSString *)str {   
    
	NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    
	[str getCharacters:chars];
	
    NSMutableString *hexString = [[NSMutableString alloc] init];
	
    for (NSUInteger i = 0; i < len; i++) {
        [hexString appendFormat:@"%02x", chars[i]];
    }
	
    free(chars);
	
    return hexString;
}

@end
