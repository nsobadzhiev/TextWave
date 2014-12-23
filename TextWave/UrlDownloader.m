//
//  UrlDownloader.m
//  DropboxBrowser
//
//  Created by Nikola Sobadjiev on 4/25/13.
//  Copyright (c) 2013 Nikola Sobadjiev. All rights reserved.
//

#import "UrlDownloader.h"

// the timeout (in seconds) that the request waits before considering
// that the request has failed
static const float k_connectionTimeout = 120.0f;

@interface UrlDownloader (PrivateMethods)

// delegates
- (void)notifyDelegateDownloadedData:(NSData*)data;
- (void)notifyDelegateDownloadFailedWithError:(NSError*)error;

@end

@implementation UrlDownloader

@synthesize delegate;

- (instancetype)initWithPath:(NSString*)urlPathStr
{
    self = [super init];
    if (self)
    {
        _urlPath = urlPathStr;
        _loading = NO;
    }
    return self;
}

- (void)createAndStartRequest
{
    NSString *normalizedURL = [self.urlPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL * theURL = [[NSURL alloc] initWithString:[normalizedURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:k_connectionTimeout];
    
    [theRequest setHTTPMethod:@"GET"];
	[theRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest
                                                                 delegate:self];
    [connection start];
}

-(void) downloadResource
{
    if (self.urlPath == nil)
    {
        // creating an NSURL with a nil string throws an exception. Prevent that
        // and notify the delegate that the request failed
        [self notifyDelegateDownloadFailedWithError:nil];
        return;
    }
    [self createAndStartRequest];
    _loading = YES;
}

#pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _loading = NO;
    [self notifyDelegateDownloadedData:responseData];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    _loading = NO;
    [self notifyDelegateDownloadFailedWithError:error];
}

#pragma mark PrivateMethods

- (void)notifyDelegateDownloadedData:(NSData*)data
{
    if ([delegate respondsToSelector:@selector(urlDownloader:didDownloadData:)])
    {
        [delegate urlDownloader:self
                didDownloadData:data];
    }
}

- (void)notifyDelegateDownloadFailedWithError:(NSError*)error
{
    if ([delegate respondsToSelector:@selector(urlDownloader:didFailWithError:)])
    {
        [delegate urlDownloader:self
               didFailWithError:error];
    }
}

@end
