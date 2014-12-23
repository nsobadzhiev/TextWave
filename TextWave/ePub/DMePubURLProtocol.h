//
//  DMePubURLProtocol.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/2/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMePubManager.h"

@interface DMePubURLProtocol : NSURLProtocol
{
    DMePubManager* epubManager;
    NSURL* requestUrl;
}

- (NSString*)epubFilePath;
- (NSString*)zipPath;

@end
