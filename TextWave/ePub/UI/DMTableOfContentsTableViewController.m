//
//  DMTableOfContentsTableViewController.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/16/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTableOfContentsTableViewController.h"

@interface DMTableOfContentsTableViewController ()

@end

@implementation DMTableOfContentsTableViewController

- (id)initWithPublicationPath:(NSString*)pubPath
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        publicationPath = pubPath;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithPublicationPath:nil];
}

- (void)tableOfContentsDataSource:(DMTableOfContentsDataSource*)source
                didSelectFilePath:(NSString*)path
{
    if ([self.delegate respondsToSelector:@selector(tableOfContentsController:didSelectItemWithPath:)])
    {
        [self.delegate tableOfContentsController:self
                           didSelectItemWithPath:path];
    }
}

@end
