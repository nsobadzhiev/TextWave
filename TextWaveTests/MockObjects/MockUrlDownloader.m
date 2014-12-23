//
//  MockUrlDownloader.m
//  LazyReader
//
//  Created by Nikola Sobadjiev on 5/29/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "MockUrlDownloader.h"

@implementation MockUrlDownloader

- (void)createAndStartRequest
{
    return;
}

-(void) downloadResource
{
    [super downloadResource];
    if (self.shouldSimulateCompletion)
    {
        [self connectionDidFinishLoading:nil];
    }
    if (self.shouldSimulateFailure)
    {
        [self connection:nil 
        didFailWithError:nil];
    }
}

@end
