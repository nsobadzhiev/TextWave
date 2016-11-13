//
//  DMDocumentsViewController.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWDocumentsFileManager.h"

@interface DMDocumentsViewController : UITableViewController

@property (nonatomic, strong) TWDocumentsFileManager* fileManager;

@end
