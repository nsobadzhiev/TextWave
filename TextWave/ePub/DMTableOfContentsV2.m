//
//  DMTableOfContentsV2.m
//  TextWave
//
//  Created by Nikola Sobadjiev on 11/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTableOfContentsV2.h"
#import "DDXMLNode+ChildForName.h"

static NSString* const k_ncxTag = @"ncx";
static NSString* const k_navMapTag = @"navMap";
static NSString* const k_navPointTag = @"navPoint";
static NSString* const k_textTag = @"text";
static NSString* const k_titleTag = @"docTitle";
static NSString* const k_navLabelTag = @"navLabel";
static NSString* const k_contentTag = @"content";
static NSString* const k_srcTag = @"src";
static NSString* const k_playOrderTag = @"playOrder";

@interface DMTableOfContentsV2 ()

- (DDXMLElement*)navMapItem;
- (NSString*)textContentsOfElement:(DDXMLNode*)element;
- (DMTableOfContentsItem*)tocItemFromXmlNode:(DDXMLElement*)xmlElement
                                  parentItem:(DMTableOfContentsItem*)parent;

@end

@implementation DMTableOfContentsV2

- (NSString*)title
{
    DDXMLNode* titleElement = [tocDocument childForName:k_titleTag];
    return [self textContentsOfElement:titleElement];
}

- (NSArray*)topLevelItems
{
    if (topLevelItems == nil)
    {
        DDXMLElement* navMapElement = [self navMapItem];
        topLevelItems = [self tocItemsFromXmlNode:navMapElement
                                        recursive:NO
                                       parentItem:nil];
    }
    return topLevelItems;
}

- (NSArray*)allItems
{
    if (allItems == nil)
    {
        DDXMLElement* navMapElement = [self navMapItem];
        allItems = [self tocItemsFromXmlNode:navMapElement
                                   recursive:YES
                                  parentItem:nil];
    }
    return allItems;
}

- (instancetype)initWithData:(NSData*)tocData
{
    self = [super init];
    if (self)
    {
        NSError* parseError = nil;
        tocDocument = [[DDXMLDocument alloc] initWithData:tocData
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

- (NSArray*)subItemsForItem:(DMTableOfContentsItem*)item
{
    return item.subItems;
}

- (DDXMLNode*)navMapItem
{
    DDXMLNode* ncxElement = [tocDocument childForName:k_ncxTag];
    return [ncxElement childForName:k_navMapTag];
}

- (NSString*)textContentsOfElement:(DDXMLNode*)element
{
    DDXMLNode* textElement = [element childForName:k_textTag];
    return [textElement stringValue];
}

- (DMTableOfContentsItem*)tocItemFromXmlNode:(DDXMLElement*)xmlElement
                                  parentItem:(DMTableOfContentsItem*)parent
{
    DDXMLNode* navLabelElement = [xmlElement childForName:k_navLabelTag];
    NSString* itemName = [self textContentsOfElement:navLabelElement];
    DDXMLNode* contentElement = [xmlElement childForName:k_contentTag];
    DDXMLNode* sourceAttr = [(DDXMLElement*)contentElement attributeForName:k_srcTag];
    NSString* itemPath = [sourceAttr stringValue];
    DDXMLNode* playOrderElement = [xmlElement childForName:k_playOrderTag];
    NSInteger playOrder = [[playOrderElement stringValue] integerValue];
    DMTableOfContentsItem* tocItem = [[DMTableOfContentsItem alloc] initWithName:itemName
                                                                            path:itemPath
                                                                          parent:parent
                                                                       playOrder:playOrder];
    return tocItem;
}

- (NSArray*)tocItemsFromXmlNode:(DDXMLElement*)xmlElement
                      recursive:(BOOL)recursive
                     parentItem:(DMTableOfContentsItem*)parent
{
    NSArray* topLevelNavItems = [xmlElement elementsForName:k_navPointTag];
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:topLevelNavItems.count];
    for (DDXMLNode* navPoint in topLevelNavItems)
    {
        DMTableOfContentsItem* tocItem = [self tocItemFromXmlNode:(DDXMLElement*)navPoint
                                                       parentItem:parent];
        if (tocItem != nil)
        {
            [items addObject:tocItem];
            if (recursive == YES)
            {
                NSArray* subItems = [self tocItemsFromXmlNode:(DDXMLElement*)navPoint
                                                    recursive:recursive
                                                   parentItem:tocItem];
                if (subItems.count > 0)
                {
                    tocItem.subItems = subItems;
                    [items addObjectsFromArray:subItems];
                }
            }
        }
    }
    return [NSArray arrayWithArray:items];
}

@end
