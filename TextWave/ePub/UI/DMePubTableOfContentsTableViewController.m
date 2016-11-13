//
//  DMePubTableOfContentsTableViewController.m
//  TextWave
//
//  Created by Nikola Sobadjiev on 1/11/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubTableOfContentsTableViewController.h"

@interface DMePubTableOfContentsTableViewController ()

@end

@implementation DMePubTableOfContentsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tocDataSource = [[DMTableOfContentsDataSource alloc] initWithEpubPath:publicationPath];
    tocDataSource.delegate = self;
    self.tableView.dataSource = tocDataSource;
    self.tableView.delegate = tocDataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
