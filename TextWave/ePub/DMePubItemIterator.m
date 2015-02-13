//
//  DMePubItemIterator.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/17/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubItemIterator.h"

@implementation DMePubItemIterator

+ (instancetype)epubIteratorWithEpubManager:(DMePubManager*)epubManager
{
    return [[DMePubItemIterator alloc] initWithEpubManager:epubManager];
}

- (instancetype)initWithEpubManager:(DMePubManager*)_epubManager
{
    self = [super init];
    if (self)
    {
        epubManager = _epubManager;
        spineItemsIterator = [[epubManager spineItems] objectEnumerator];
        currentSpineItemIndex = -1;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithEpubManager:nil];
}

- (id)nextObject
{
    if (currentSpineItemIndex > (NSInteger)([[epubManager spineItems] count] - 2))
    {
        return nil;
    }
    DMSpineItem* currentSpineItem = [[epubManager spineItems] objectAtIndex:++currentSpineItemIndex];
    return [epubManager epubItemForSpineElement:currentSpineItem];
}

- (BOOL)goToItemWithPath:(NSString*)path
{
    currentSpineItemIndex = -1;     // reset the index in order to be able to 
                                    // find items that have already been iterated
    DMePubItem* epubItem = nil;
    while (epubItem = [self nextObject]) 
    {
        currentSpineItemIndex++;
        if ([epubItem.href isEqualToString:path])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)goToItemWithIndex:(NSUInteger)index
{
    NSArray* spineItems = [epubManager spineItems];
    if (index < spineItems.count)
    {
        DMSpineItem* targetSpineItem = [spineItems objectAtIndex:index];
        DMePubItem* targetEpubItem = [epubManager epubItemForSpineElement:targetSpineItem];
        [self goToItemWithPath:targetEpubItem.href];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (DMePubItem*)previousItem
{
    if (currentSpineItemIndex < 1)
    {
        currentSpineItemIndex = -1;
        return nil;
    }
    DMSpineItem* currentSpineItem = [[epubManager spineItems] objectAtIndex:--currentSpineItemIndex];
    return [epubManager epubItemForSpineElement:currentSpineItem];
}

- (DMePubItem*)currentItem
{
    if (currentSpineItemIndex < 0)
    {
        return nil;
    }
    DMSpineItem* currentSpineItem = [[epubManager spineItems] objectAtIndex:currentSpineItemIndex];
    return [epubManager epubItemForSpineElement:currentSpineItem];
}

- (NSInteger)currentIndex
{
    return currentSpineItemIndex;
}

@end
