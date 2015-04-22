//
//  DMBookmark.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSNumber BookmarkPosition;

enum DMBookmarkType {
    DMBookmarkTypeNone,             // unspecified
    DMBookmarkTypeSystem,           // a bookmark the system made automatically
    DMBookmarkTypeUserDefined       // a bookmark creadted by the user
};

@interface DMBookmark : NSObject <NSCoding>

@property (nonatomic, strong) NSString* fileName;
@property (nonatomic, strong) BookmarkPosition* filePosition;
@property (nonatomic, strong) NSString* fileSection;
@property (nonatomic, assign) enum DMBookmarkType type;

- (instancetype)initWithFileName:(NSString*)fileName
                         section:(NSString*)section
                        position:(BookmarkPosition*)position
                            type:(enum DMBookmarkType)type;

@end
