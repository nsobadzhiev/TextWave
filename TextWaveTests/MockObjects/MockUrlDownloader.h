//
//  MockUrlDownloader.h
//  LazyReader
//
//  Created by Nikola Sobadjiev on 5/29/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "UrlDownloader.h"

@interface MockUrlDownloader : UrlDownloader

@property (nonatomic, readonly) NSString* path;
@property (nonatomic, assign) BOOL shouldSimulateCompletion;
@property (nonatomic, assign) BOOL shouldSimulateFailure;

@end
