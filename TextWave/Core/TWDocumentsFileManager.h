//
//  TWDocumentsFileManager.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWFileSystemManager.h"

@interface TWDocumentsFileManager : NSObject

@property (nonatomic, strong) id<TWFileSystemManager> fileSystemManager;

- (NSArray*)allDocuments;
- (NSArray*)allDocumentPaths;
- (NSData*)contentsOfFile:(NSString*)filePath;

- (NSString*)fullPathForFileWithName:(NSString*)fileName;

@end
