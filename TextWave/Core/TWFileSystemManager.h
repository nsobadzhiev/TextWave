//
//  TWFileSystemManager.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWFileSystemManager <NSObject>

@required

- (NSArray*)contentsOfDirectoryAtPath:(NSString*)path 
                                error:(NSError**)error;
- (NSDirectoryEnumerator *)enumeratorAtURL:(NSURL *)url 
                includingPropertiesForKeys:(NSArray *)keys 
                                   options:(NSDirectoryEnumerationOptions)mask 
                              errorHandler:(BOOL (^)(NSURL *url, NSError *error))handler NS_AVAILABLE(10_6, 4_0);
- (NSData*)contentsAtPath:(NSString*)path;
- (BOOL)copyItemAtURL:(NSURL *)srcURL 
                toURL:(NSURL *)dstURL 
                error:(NSError **)error;

@end
