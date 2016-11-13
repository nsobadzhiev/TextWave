//
//  DMePubPageViewController.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubPageViewController.h"
#import "DMePubItemViewController.h"

@interface DMePubPageViewController ()

- (void)saveBookmark:(DMePubItem*)epubItem;
- (void)openItemAtPath:(NSString*)path;

@end

@implementation DMePubPageViewController

@synthesize selectedItem = _selectedItem;

- (instancetype)initWithEpubManager:(DMePubManager*)epubManager
{
    self = [super initWithNibName:nil
                           bundle:nil];
    if (self)
    {
        self.epubManager = epubManager;
        bookmarkManager = [[DMBookmarkManager alloc] init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithEpubManager:nil];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        bookmarkManager = [[DMBookmarkManager alloc] init];
    }
    return self;
}

- (void)setEpubManager:(DMePubManager *)epubManager
{
    if (self.epubManager != epubManager)
    {
        _epubManager = epubManager;
        itemIterator = [[DMePubItemIterator alloc] initWithEpubManager:self.epubManager];
    }
}

- (NSString*)selectedItem
{
    DMePubItem* currentItem = [itemIterator currentItem];
    return currentItem.href;
}

- (void)setSelectedItem:(NSString *)selectedItem
{
    if (_selectedItem != selectedItem)
    {
        _selectedItem = selectedItem;
        [self openItemAtPath:selectedItem];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex)
    {
        _selectedIndex = selectedIndex;
        [self openItemAtIndex:_selectedIndex];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    DMePubItem* nextItem = [itemIterator currentItem];
    if ([itemIterator currentItem] == nil)
    {
        nextItem = [itemIterator nextObject];
    }
    UIViewController* firstPage = [[DMePubItemViewController alloc] initWithEpubItem:nextItem
                                                                              anchor:nil
                                                                      andEpubManager:self.epubManager];
    [self.pageViewController setViewControllers:@[firstPage]
                                      direction:UIPageViewControllerNavigationDirectionForward 
                                       animated:YES 
                                     completion:nil];
    [self.view addSubview:self.pageViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)loadSystemBookmarkPosition
{
    DMBookmark* bookmark = [bookmarkManager systemBookmarkForPath:[self.epubManager.epubPath lastPathComponent]];
    if (bookmark)
    {
        [self openItemAtPath:bookmark.fileSection];
    }
    return (bookmark != nil);
}

#pragma mark - UIPageViewController

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[DMePubItemViewController class]])
    {
        DMePubItemViewController* currentController = (DMePubItemViewController*)viewController;
        DMePubItem* currentItem = [itemIterator currentItem];
        DMePubItem* viewControllerItem = [currentController epubItem];
        
        if ([viewControllerItem isEqual:currentItem] == NO)
        {
            [itemIterator goToItemWithPath:viewControllerItem.href];
        }
    }
    DMePubItem* previousItem = [itemIterator previousItem];
    UIViewController* previousController = nil;
    if (previousItem != nil)
    {
        previousController = [[DMePubItemViewController alloc] initWithEpubItem:previousItem
                                                                         anchor:nil
                                                                 andEpubManager:self.epubManager];
    }
    return previousController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
       viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[DMePubItemViewController class]])
    {
        DMePubItemViewController* currentController = (DMePubItemViewController*)viewController;
        DMePubItem* currentItem = [itemIterator currentItem];
        DMePubItem* viewControllerItem = [currentController epubItem];
        
        if (viewControllerItem != nil &&
            [viewControllerItem isEqual:currentItem] == NO)
        {
            [itemIterator goToItemWithPath:viewControllerItem.href];
        }
    }
    DMePubItem* nextItem = [itemIterator nextObject];
    if (nextItem != nil)
    {
        return [[DMePubItemViewController alloc] initWithEpubItem:nextItem
                                                           anchor:nil
                                                   andEpubManager:self.epubManager];
    }
    else
    {
        return nil;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        // if the page turn completes, save the location as a bookmark
        DMePubItem* currentItem = [(DMePubItemViewController*)[pageViewController.viewControllers firstObject] epubItem];
        [self saveBookmark:currentItem];
    }
}

#pragma mark - PrivateMethods

- (void)saveBookmark:(DMePubItem*)epubItem
{
    [bookmarkManager removeSystemBookmarkForFile:[self.epubManager.epubPath lastPathComponent]];
    DMBookmark* updatedBookmark = [[DMBookmark alloc] initWithFileName:[self.epubManager.epubPath lastPathComponent]
                                                               section:epubItem.href 
                                                              position:nil
                                                                  type:DMBookmarkTypeSystem];
    [bookmarkManager addBookmark:updatedBookmark];
    [bookmarkManager saveBookmarks];
}

- (void)openItemAtPath:(NSString*)path
{
    // the path might contain an anchor (hyperlink inside the document)
    // strip that, set the correct item in the iterator and pass the archor value to
    // the page
    // TODO: extract anchor stripping out of here
    NSRange hashRange = [path rangeOfString:@"#"];
    NSString* anchor = nil;
    NSString* targetItemPath = path;
    if (hashRange.location != NSNotFound) {
        anchor = [path substringFromIndex:hashRange.location];
        targetItemPath = [path substringToIndex:hashRange.location];
    }
    NSInteger previousIndex = [itemIterator currentIndex];
    [itemIterator goToItemWithPath:targetItemPath];
    NSInteger nextIndex = [itemIterator currentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self openCurrentItemFromIndex:previousIndex toIndex:nextIndex anchor:anchor];
    });  
}

- (void)openItemAtIndex:(NSUInteger)epubIndex
{
    NSInteger previousIndex = [itemIterator currentIndex];
    [itemIterator goToItemWithIndex:epubIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self openCurrentItemFromIndex:previousIndex toIndex:epubIndex anchor:nil];
    });  
}

- (void)openCurrentItemFromIndex:(NSInteger)previousIndex
                         toIndex:(NSInteger)nextIndex
                          anchor:(NSString*)docSection
{
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionReverse;
    if (previousIndex < nextIndex)
    {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    DMePubItemViewController* selectedItemController = [[DMePubItemViewController alloc] initWithEpubItem:[itemIterator currentItem]
                                                                                                   anchor:docSection
                                                                                           andEpubManager:self.epubManager];
    [self.pageViewController setViewControllers:@[selectedItemController]
                                      direction:direction 
                                       animated:YES 
                                     completion:nil];
}

@end
