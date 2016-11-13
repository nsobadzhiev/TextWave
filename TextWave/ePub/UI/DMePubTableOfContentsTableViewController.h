//
//  DMePubTableOfContentsTableViewController.h
//  TextWave
//
//  Created by Nikola Sobadjiev on 1/11/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

#import "DMTableOfContentsTableViewController.h"
#import "DMTableOfContentsDataSource.h"

@interface DMePubTableOfContentsTableViewController : DMTableOfContentsTableViewController <DMTableOfContentsDelegate>
{
    DMTableOfContentsDataSource* tocDataSource;
}

@end
