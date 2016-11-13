//
//  DMePubManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubManager.h"
#import "DMePubURLProtocol.h"

@interface DMePubManager ()

- (DMRootFileParser*)rootFileParser;
- (DMContainerFileParser*)contentsParser;
- (DMTableOfContents*)nagivationParser;

@end

@implementation DMePubManager

- (instancetype)initWithEpubPath:(NSString*)epubPath
{
    self = [super init];
    if (self)
    {
        epubFileManager = [[DMePubFileManager alloc] initWithEpubPath:epubPath];
        _epubPath = epubPath;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithEpubPath:nil];
}

+ (void)initialize
{
    [NSURLProtocol registerClass:[DMePubURLProtocol class]];
}

- (void)openEpubWithPath:(NSString*)path
{
    // invalidate old objects
    rootFileParser = nil;
    contentsParser = nil;
    navigationParser = nil;
    
    [epubFileManager openEpubWithPath:path];
    _epubPath = path;
}

- (BOOL)isOpen
{
    return epubFileManager.fileOpen;
}

- (NSString*)rootFilePath
{
    DMRootFileParser* rootParser = [self rootFileParser];
    return [rootParser mainRootFileLocation];
}

- (NSArray*)epubHtmlItems
{
    DMContainerFileParser* contents = [self contentsParser];
    return [contents epubHtmlItems];
}

- (NSArray*)spineItems
{
    DMContainerFileParser* contents = [self contentsParser];
    return [contents spineItems];
}

- (NSArray*)filteredSpineItems
{
    DMContainerFileParser* contents = [self contentsParser];
    return [contents filteredSpineItems];
}

- (DMePubItem*)navigationItem
{
    DMContainerFileParser* contents = [self contentsParser];
    return [contents navigationItem];
}

- (NSString*)navigationTitle
{
    DMTableOfContents* navParser = [self nagivationParser];
    return [navParser title];
}

- (NSArray*)navigationTopLevelItems
{
    DMTableOfContents* navParser = [self nagivationParser];
    return [navParser topLevelItems];
}

- (NSArray*)allNavigationItems
{
    DMTableOfContents* navParser = [self nagivationParser];
    return [navParser allItems];
}

- (NSData*)rootFileDataWithError:(NSError**)error;
{
    NSString* rootFilePath = [self rootFilePath];
    return [epubFileManager contentXmlWithName:rootFilePath
                                         error:error];
}

- (NSString*)titleWithError:(NSError**)error
{
    DMContainerFileParser* contents = [self contentsParser];
    return [contents epubTitle];
}

- (NSString*)authorWithError:(NSError**)error
{
    DMContainerFileParser* contents = [self contentsParser];
    return [contents epubAuthor];
}

- (UIImage*)coverWithError:(NSError**)error
{
    DMContainerFileParser* contents = [self contentsParser];
    NSString* coverPath = [contents epubCover];
    NSData* coverData = [self dataForFileAtPath:coverPath
                                          error:error];
    coverImage = [UIImage imageWithData:coverData];
    return coverImage;
}

- (NSString*)mimeTypeForPath:(NSString*)path
{
    DMContainerFileParser* contents = [self contentsParser];
    NSArray* allResources = [contents epubItems];
    for (DMePubItem* resource in allResources)
    {
        if ([resource.href isEqualToString:path])
        {
            return resource.mediaType;
        }
    }
    return nil;
}

- (DMePubItem*)epubItemForSpineElement:(DMSpineItem*)spineItem
{
    DMContainerFileParser* contents = [self contentsParser];
    return [contents epubItemForSpineElement:spineItem];
}

- (NSData*)dataForFileAtPath:(NSString*)filePath
                       error:(NSError**)error
{
    NSString* absoluteFilePath = [self relativePathToResources:filePath];
    return [epubFileManager contentXmlWithName:absoluteFilePath
                                         error:error];
}

- (NSURL*)fullUrlForResource:(NSString*)fileName
{
    // Don't append any intermediate direcotries that might
    // exist inside the EPUB zip structure - the DMURLProtocol
    // is going to take care of that
    NSString* epubPath = self.epubPath;
    NSString* absoluteFilePath = [epubPath stringByAppendingFormat:@"/%@", fileName];
    NSString* absoluteEpubPath = [NSString stringWithFormat:@"epub:/%@", absoluteFilePath];
    NSURL* epubFileURL = [NSURL URLWithString:absoluteEpubPath];
    return epubFileURL;
}

#pragma mark PrivateMethods

- (DMRootFileParser*)rootFileParser
{
    if (rootFileParser == nil)
    {
        NSError* containerFileError = nil;
        NSData* containerXmlData = [epubFileManager containerXmlWithError:&containerFileError];
        if (containerFileError != nil)
        {
            NSLog(@"Failed to retrieve container.xml: %@", containerFileError.localizedDescription);
            return nil;
        }
        rootFileParser = [[DMRootFileParser alloc] initWithContainerXml:containerXmlData];
    }
    return rootFileParser;
}

- (DMContainerFileParser*)contentsParser
{
    if (contentsParser == nil)
    {
        NSError* contentsFileError = nil;
        NSData* contentsData = [self rootFileDataWithError:&contentsFileError];
        if (contentsFileError != nil)
        {
            NSLog(@"Failed to retrieve container.xml: %@", contentsFileError.localizedDescription);
            return nil;
        }
        contentsParser = [[DMContainerFileParser alloc] initWithData:contentsData];
    }
    return contentsParser;
}

- (DMTableOfContents*)nagivationParser
{
    if (navigationParser == nil)
    {
        NSError* navFileError = nil;
        DMePubItem* navItem = [self navigationItem];
        NSData* contentsData = [self dataForFileAtPath:navItem.href
                                                 error:&navFileError];
        if (navFileError != nil)
        {
            NSLog(@"Failed to retrieve container.xml: %@", navFileError.localizedDescription);
            return nil;
        }
        navigationParser = [[DMTableOfContents alloc] initWithData:contentsData];
    }
    return navigationParser;
}

- (NSString*)relativePathToResources:(NSString*)resourceFileName
{
    NSString* rootFilePath = [self rootFilePath];
    NSString* rootFileDir = [rootFilePath stringByDeletingLastPathComponent];
    NSString* relativeFilePath = [rootFileDir stringByAppendingPathComponent:resourceFileName];
    return relativeFilePath;
}

@end
