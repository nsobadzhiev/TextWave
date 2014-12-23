//
//  DMTableOfContentsV2.h
//  TextWave
//
//  Created by Nikola Sobadjiev on 11/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMTableOfContents.h"

@interface DMTableOfContentsV2 : DMTableOfContents
{
    NSArray* allItems;
    NSArray* topLevelItems;
}

@end
