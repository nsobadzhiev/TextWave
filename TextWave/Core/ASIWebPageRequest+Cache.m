//
//  ASIWebPageRequest+Cache.m
//  TextWave
//
//  Created by Nikola Sobadjiev on 3/9/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

#import "ASIWebPageRequest+Cache.h"
#import "ASIDownloadCache.h"

@implementation ASIWebPageRequest (Cache)

- (void)setupCache
{
    ASIDownloadCache* cache = [[ASIDownloadCache alloc] init];
    cache.defaultCachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
    cache.storagePath = self.downloadDestinationPath;
    self.downloadCache = cache;
}

@end
