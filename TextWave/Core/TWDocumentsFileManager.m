//
//  TWDocumentsFileManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "TWDocumentsFileManager.h"

@implementation TWDocumentsFileManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.fileSystemManager = (id<TWFileSystemManager>)[NSFileManager defaultManager];
    }
    return self;
}

- (NSArray*)allDocuments
{
    NSArray* allDocumentPaths = [self allDocumentPaths];
    NSMutableArray* allDocumentNames = [NSMutableArray arrayWithCapacity:allDocumentPaths.count];
    for (NSString* documentPath in allDocumentPaths) 
    {
        NSString* documentName = documentPath.lastPathComponent;
        if (documentName.length > 0)
        {
            [allDocumentNames addObject:documentPath.lastPathComponent];
        }
    }
    return [NSArray arrayWithArray:allDocumentNames];
}

- (NSArray*)allDocumentPaths
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSURL *directoryURL = [NSURL fileURLWithPath:documentsDirectory];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    NSDirectoryEnumerator *fileEnumerator = [self.fileSystemManager enumeratorAtURL:directoryURL
                                                         includingPropertiesForKeys:keys
                                                                            options:0
                                                                       errorHandler:^(NSURL *url, NSError *error) {
                                                                           return YES;
                                                                       }];
    NSMutableArray* allFiles = [NSMutableArray arrayWithCapacity:100];
    for (NSURL *url in fileEnumerator) 
    { 
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) 
        {
            // handle error
        }
        else if (! [isDirectory boolValue]) 
        {
            [allFiles addObject:url.absoluteString];
        }
    }
    
    return [NSArray arrayWithArray:allFiles];
}

- (NSData*)contentsOfFile:(NSString*)filePath
{
    return [self.fileSystemManager contentsAtPath:filePath];
}

- (NSString*)fullPathForFileWithName:(NSString*)fileName
{
    NSArray* documentsPath = [self allDocumentPaths];
    for (NSString* document in documentsPath)
    {
        NSString* docName = document.lastPathComponent;
        if ([fileName isEqualToString:docName])
        {
            return document;
        }
    }
    return nil;
}

@end
