//
//  ConnectionStore.h
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionStore : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

-(void) getDataForConnectionWithURL:(NSURL*)url handler:(void (^)(NSData*))completionHandler;
-(void) showMessageIfInternetConnectionIsUnavailable;

@end
