//
//  DMePubPageViewController.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMePubManager.h"
#import "DMePubItemIterator.h"
#import "DMBookmarkManager.h"

@interface DMePubPageViewController : UIViewController <UIPageViewControllerDataSource>
{
    DMePubItemIterator* itemIterator;
    DMBookmarkManager* bookmarkManager;
    NSString* _selectedItem;
}

@property (nonatomic, strong) UIPageViewController* pageViewController;
@property (nonatomic, strong) DMePubManager* epubManager;
@property (nonatomic, strong) NSString* selectedItem;
@property (nonatomic, assign) NSUInteger selectedIndex;

- (instancetype)initWithEpubManager:(DMePubManager*)epubManager;

- (BOOL)loadBookmarkPosition;

@end
