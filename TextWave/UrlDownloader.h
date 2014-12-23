//
//  UrlDownloader.h
//  DropboxBrowser
//
//  Created by Nikola Sobadjiev on 4/25/13.
//  Copyright (c) 2013 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UrlDownloader;

/*
 * The UrlDownloaderDelegate is a protocol describing all delegate methods
 * that UrlDownloader invokes
 **/

@protocol UrlDownloaderDelegate <NSObject>

@optional
- (void)urlDownloader:(UrlDownloader*)downloader
      didDownloadData:(NSData*)data;
- (void)urlDownloader:(UrlDownloader*)downloader
     didFailWithError:(NSError*)error;

@end

/*
 * UrlDownloader is a class implementing functionality for downloading
 * the contents of a URL asynchroniously.
 **/

@interface UrlDownloader : NSObject <NSURLConnectionDataDelegate>
{
    NSMutableData* responseData;
}

@property (nonatomic, readonly) NSString* urlPath;
@property (nonatomic, readonly) BOOL loading;
@property (nonatomic, weak) id<UrlDownloaderDelegate> delegate;

- (instancetype)initWithPath:(NSString*)urlPathStr;

- (void)createAndStartRequest;  // can be overriden in subclasses to alter the request
                                // should not be called from external classes
- (void)downloadResource;

@end
