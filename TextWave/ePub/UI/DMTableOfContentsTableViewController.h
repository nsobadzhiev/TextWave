//
//  DMTableOfContentsTableViewController.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/16/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMTableOfContentsDataSource.h"

@class DMTableOfContentsTableViewController;

@protocol DMTableOfContentsTableViewControllerDelegate <NSObject>

- (void)tableOfContentsController:(DMTableOfContentsTableViewController*)tocController
            didSelectItemWithPath:(NSString*)path;

@end

@interface DMTableOfContentsTableViewController : UITableViewController <DMTableOfContentsDelegate>
{
    NSString* publicationPath;
}

@property (nonatomic, weak) id<DMTableOfContentsTableViewControllerDelegate> delegate;

- (id)initWithPublicationPath:(NSString*)pubPath;

@end
