//
//  JBImageCache.h
//  Lecture12
//
//  Created by Jason Brennan on 12-03-30.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^JBImageCacheCompletionBlock)(NSString *string, UIImage *image);


@interface JBImageCache : NSObject

- (void)loadImageForString:(NSString *)string completionHandler:(JBImageCacheCompletionBlock)completionBlock;

@end
