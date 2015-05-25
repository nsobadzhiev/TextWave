//
//  DMBookmarkManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/15/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMBookmarkManager.h"

static NSString* const k_bookmarksUserDefaultsKey = @"Bookmarks";

@implementation DMBookmarkManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadBookmarks];
        if (bookmarks == nil)
        {
            bookmarks = [[NSMutableArray alloc] initWithCapacity:30];
        }
    }
    return self;
}

- (NSArray*)allBookmarks
{
    return [NSArray arrayWithArray:bookmarks];
}

- (void)addBookmark:(DMBookmark*)bookmark
{
    [bookmarks addObject:bookmark];
}

- (void)addSystemBookmark:(DMBookmark*)bookmark
{
    bookmark.type = DMBookmarkTypeSystem;
    NSString* bookmarkedBook = bookmark.fileName;
    [self removeSystemBookmarkForFile:bookmarkedBook];
    [self addBookmark:bookmark];
}

- (void)removeBookmark:(DMBookmark*)bookmark
{
    if (bookmark != nil)
    {
        [bookmarks removeObject:bookmark];
    }
}

- (void)removeBookmarksForFile:(NSString*)fileName
{
    for (DMBookmark* bookmark in [self bookmarksForPath:fileName])
    {
        if ([bookmark.fileName isEqualToString:fileName])
        {
            [bookmarks removeObject:bookmark];
        }
    }
}

- (void)removeSystemBookmarkForFile:(NSString*)fileName
{
    DMBookmark* systemBookmark = [self systemBookmarkForPath:fileName];
    [self removeBookmark:systemBookmark];
}

- (void)removeBookmarks
{
    [bookmarks removeAllObjects];
}

- (NSArray*)bookmarksForPath:(NSString*)path
{
    NSMutableArray* bookmarksForFile = [NSMutableArray arrayWithCapacity:30];
    for (DMBookmark* bookmark in bookmarks)
    {
        if ([bookmark.fileName isEqualToString:path])
        {
            [bookmarksForFile addObject:bookmark];
        }
    }
    return [NSArray arrayWithArray:bookmarksForFile];
}

- (DMBookmark*)systemBookmarkForPath:(NSString*)path
{
    for (DMBookmark* bookmark in bookmarks)
    {
        if (bookmark.type == DMBookmarkTypeSystem &&
            [bookmark.fileName isEqualToString:path])
        {
            return bookmark;
        }
    }
    return nil;
}

- (void)saveBookmarks
{
    // TODO: Saving bookmarks might overwrite some changed made by
    // other bookmark managers
    NSData* encodedBookmarks = [NSKeyedArchiver archivedDataWithRootObject:bookmarks];
    [[NSUserDefaults standardUserDefaults] setObject:encodedBookmarks
                                              forKey:k_bookmarksUserDefaultsKey];
}

- (void)loadBookmarks
{
    NSData* encodedBookmarks = [[NSUserDefaults standardUserDefaults] objectForKey:k_bookmarksUserDefaultsKey];
    if (encodedBookmarks != nil && [encodedBookmarks isKindOfClass:[NSData class]])
    {
        bookmarks = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:encodedBookmarks];
    }
}

@end
