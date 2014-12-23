//
//  DMTableOfContents.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/11/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTableOfContents.h"
#import "DMTableOfContentsV2.h"
#import "DMTableOfContentsV3.h"

@implementation DMTableOfContents

- (instancetype)initWithData:(NSData*)tocData
{
    DMTableOfContentsV3* epub3Toc = [[DMTableOfContentsV3 alloc] initWithData:tocData];
    if (epub3Toc.allItems.count == 0)
    {
        return [[DMTableOfContentsV2 alloc] initWithData:tocData];
    }
    else
    {
        return epub3Toc;
    }
}

- (NSArray*)subItemsForItem:(DMTableOfContentsItem*)item
{
    return nil;
}

- (NSString*)title
{
    return nil;
}

- (NSArray*)topLevelItems
{
    return nil;
}

- (NSArray*)allItems
{
    return nil;
}

@end
