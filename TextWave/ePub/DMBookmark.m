//
//  DMBookmark.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMBookmark.h"

static NSString* const k_fileNameEncodingKey = @"bookmarkFileName";
static NSString* const k_fileSectionEncodingKey = @"bookmarkFileSection";
static NSString* const k_filePositionEncodingKey = @"bookmarkFilePosition";
static NSString* const k_fileTypeEncodingKey = @"bookmarkTypePosition";

@implementation DMBookmark

- (instancetype)initWithFileName:(NSString*)fileName
                         section:(NSString*)section
                        position:(BookmarkPosition*)position
                            type:(enum DMBookmarkType)type
{
    self = [super init];
    if (self)
    {
        self.fileName = fileName;
        self.fileSection = section;
        self.filePosition = position;
        self.type = type;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.fileName = [aDecoder decodeObjectForKey:k_fileNameEncodingKey];
        self.fileSection = [aDecoder decodeObjectForKey:k_fileSectionEncodingKey];
        self.filePosition = [aDecoder decodeObjectForKey:k_filePositionEncodingKey];
        self.type = [[aDecoder decodeObjectForKey:k_fileTypeEncodingKey] intValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileName forKey:k_fileNameEncodingKey];
    [aCoder encodeObject:self.fileSection forKey:k_fileSectionEncodingKey];
    [aCoder encodeObject:self.filePosition forKey:k_filePositionEncodingKey];
    [aCoder encodeObject:@(self.type) forKey:k_fileTypeEncodingKey];
}

@end
