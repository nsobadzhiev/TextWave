//
//  DMContainerFileParser.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/6/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMContainerFileParser.h"
#import "DDXMLNode+ChildForName.h"
#import "DMePubItem.h"
#import "DMSpineItem.h"

// XML root elements
static NSString* const k_packageTagName = @"package";
static NSString* const k_manifestTagName = @"manifest";
static NSString* const k_metaDataTagName = @"metadata";
static NSString* const k_spineTagName = @"spine";
static NSString* const k_titleTagName = @"dc:title";
static NSString* const k_creatorTagName = @"dc:creator";
static NSString* const k_coverImageTagName = @"cover-image";
static NSString* const k_coverTagName = @"cover";
static NSString* const k_versionAttrName = @"version";
static NSString* const k_xhtmlItemAttrValue = @"application/xhtml+xml";

// Manifest item attributes
static NSString* const k_manifestItemAttrName = @"media-type";
static NSString* const k_itemIdAttrName = @"id";
static NSString* const k_hrefAttrName = @"href";
static NSString* const k_propertiesAttrName = @"properties";
static NSString* const k_propertiesAttrNavValue = @"nav";
static NSString* const k_propertiesAttrNcxValue = @"application/x-dtbncx+xml";
static NSString* const k_propertiesAttrImagePrefix = @"image/";

// Spine item attributes
static NSString* const k_itemIdRefAttrName = @"idref";

@interface DMContainerFileParser ()

- (DDXMLElement*)packageElement;
- (DDXMLElement*)manifestElement;
- (DDXMLElement*)metadataElement;
- (DDXMLElement*)spineElement;

- (DMContainerItem*)itemForId:(NSString*)itemID
                      inArray:(NSArray*)items;
- (BOOL)itemsArray:(NSArray*)items
        containsId:(NSString*)itemID;
- (DMePubItem*)epubItemFromXml:(DDXMLElement*)xmlNode;

@end

@implementation DMContainerFileParser

@synthesize epubHtmlItems;
@synthesize spineItems;

- (id)init
{
    self = [self initWithData:nil];
    return self;
}

- (id)initWithData:(NSData*)containerData
{
    self = [super init];
    if (self)
    {
        NSError* parseError = nil;
        containerXml = [[DDXMLDocument alloc] initWithData:containerData
                                                   options:0
                                                     error:&parseError];
        if (parseError != nil)
        {
            NSLog(@"Failed to parse container XML: %@", parseError.description);
            return nil;
        }
    }
    return self;
}

- (DMePubItem*)epubItemForSpineElement:(DMSpineItem*)spineItem
{
    NSArray* allItems = self.epubHtmlItems;
    return (DMePubItem*)[self itemForId:spineItem.itemID
                                inArray:allItems];
}

- (NSString*)epubTitle
{
    DDXMLElement* metadataElement = [self metadataElement];
    DDXMLNode* titleNode = [metadataElement childForName:k_titleTagName];
    NSString* title = [titleNode stringValue];
    return title;
}

- (NSString*)epubAuthor
{
    DDXMLElement* metadataElement = [self metadataElement];
    DDXMLNode* creatorNode = [metadataElement childForName:k_creatorTagName];
    NSString* author = [creatorNode stringValue];
    return author;
}

- (NSString*)epubCover
{
    NSArray* manifestEntries = [[self manifestElement] children];
    for (DDXMLElement* item in manifestEntries)
    {
        DDXMLNode* idNode = [item attributeForName:k_itemIdAttrName];
        NSString* idValue = [idNode stringValue];
        DDXMLNode* mimeTypeNode = [item attributeForName:k_manifestItemAttrName];
        // Check for both k_coverTagName and k_coverImageTagName - 
        // they can both reference the cover image. However, make sure to
        // check the mime type - only return images, not web pages
        NSString* mimeTypeValue = [mimeTypeNode stringValue];
        if (([idValue isEqualToString:k_coverTagName] ||
            [idValue isEqualToString:k_coverImageTagName]) &&
            [mimeTypeValue hasPrefix:k_propertiesAttrImagePrefix])
        {
            DDXMLNode* hrefNode = [item attributeForName:k_hrefAttrName];
            NSString* hrefValue = [hrefNode stringValue];
            return hrefValue;
        }
    }
    return nil;
}

- (NSString*)epubVersion
{
    DDXMLElement* packageElement = [self packageElement];
    DDXMLNode* epubVersionNode = [packageElement attributeForName:k_versionAttrName];
    return [epubVersionNode stringValue];
}

- (NSArray*)epubItems
{
    if (epubItems == nil)
    {
        NSArray* manifestEntries = [[self manifestElement] children];
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:manifestEntries.count];
        for (DDXMLElement* item in manifestEntries)
        {
            if ([item isKindOfClass:[DDXMLElement class]] == NO)
            {
                continue;
            }
            DMePubItem* epubItem = [self epubItemFromXml:item];
            [items addObject:epubItem];
        }
        epubItems = items;
    }
    return epubItems;
}

- (NSArray*)epubHtmlItems
{
    if (epubHtmlItems == nil)
    {
        NSArray* epubEntries = [self epubItems];
        NSMutableArray* htmlEntries = [NSMutableArray arrayWithCapacity:epubEntries.count];
        for (DMePubItem* item in epubEntries)
        {
            if ([item.mediaType isEqualToString:k_xhtmlItemAttrValue])
            {
                [htmlEntries addObject:item];
            }
        }
        epubHtmlItems = htmlEntries;
    }
    return epubHtmlItems;
}

- (NSArray*)spineItems
{
    if (spineItems == nil)
    {
        NSArray* spineEntries = [[self spineElement] children];
        NSMutableArray* spineItemsArray = [NSMutableArray arrayWithCapacity:spineEntries.count];
        for (DDXMLElement* item in spineEntries)
        {
            DDXMLNode* itemIdNode = [item attributeForName:k_itemIdRefAttrName];
            NSString* itemId = [itemIdNode stringValue];
            
            DMSpineItem* spineItem = [DMSpineItem spineItemWithID:itemId];
            [spineItemsArray addObject:spineItem];
        }
        spineItems = spineItemsArray;
    }
    return spineItems;
}

- (NSArray*)filteredSpineItems
{
    NSArray* allItems = self.epubHtmlItems;
    NSArray* spineItemsArray = self.spineItems;
    NSMutableArray* filteredSpine = [NSMutableArray arrayWithCapacity:allItems.count];
    for (DMSpineItem* spineItem in spineItemsArray)
    {
        if ([self itemsArray:allItems
                  containsId:spineItem.itemID] == YES)
        {
            [filteredSpine addObject:spineItem];
        }
    }
    return [NSArray arrayWithArray:filteredSpine];
}

- (DMePubItem*)navigationItem
{
    NSArray* manifestEntries = [[self manifestElement] children];
    for (DDXMLElement* item in manifestEntries)
    {
        DDXMLNode* propertyNode = [item attributeForName:k_propertiesAttrName];
        DDXMLNode* mediaTypeNode = [item attributeForName:k_manifestItemAttrName];
        NSString* propertyValue = [propertyNode stringValue];
        NSString* mediaType = [mediaTypeNode stringValue];
        if ([propertyValue isEqualToString:k_propertiesAttrNavValue] ||
            [mediaType isEqualToString:k_propertiesAttrNcxValue])
        {
            return [self epubItemFromXml:item];
        }
    }
    return nil;
}

#pragma mark PrivateMethods

- (DDXMLElement*)packageElement
{
    DDXMLElement* packageElement = (DDXMLElement*)[containerXml childForName:k_packageTagName];
    return packageElement;
}

- (DDXMLElement*)manifestElement
{
    DDXMLElement* packageElement = [self packageElement];
    DDXMLElement* manifestElement = (DDXMLElement*)[packageElement childForName:k_manifestTagName];
    return manifestElement;
}

- (DDXMLElement*)metadataElement
{
    DDXMLElement* packageElement = [self packageElement];
    DDXMLElement* metaDataElement = (DDXMLElement*)[packageElement childForName:k_metaDataTagName];
    return metaDataElement;
}

- (DDXMLElement*)spineElement
{
    DDXMLElement* packageElement = [self packageElement];
    DDXMLElement* spineElement = (DDXMLElement*)[packageElement childForName:k_spineTagName];
    return spineElement;
}

- (DMContainerItem*)itemForId:(NSString*)itemID
                      inArray:(NSArray*)items
{
    for (DMContainerItem* item in items)
    {
        if ([item.itemID isEqualToString:itemID])
        {
            return item;
        }
    }
    return nil;
}

- (BOOL)itemsArray:(NSArray*)items
        containsId:(NSString*)itemID
{
    return ([self itemForId:itemID
                   inArray:items] != nil);
}

- (DMePubItem*)epubItemFromXml:(DDXMLElement*)xmlNode
{
    DDXMLNode* mediaTypeNode = [xmlNode attributeForName:k_manifestItemAttrName];
    NSString* itemMediaType = [mediaTypeNode stringValue];
    
    DDXMLNode* itemIdNode = [xmlNode attributeForName:k_itemIdAttrName];
    NSString* itemId = [itemIdNode stringValue];
    
    DDXMLNode* hrefNode = [xmlNode attributeForName:k_hrefAttrName];
    NSString* itemPath = [hrefNode stringValue];
    
    DMePubItem* epubItem = [DMePubItem ePubItemWithId:itemId mediaType:itemMediaType href:itemPath];
    return epubItem;
}

@end
