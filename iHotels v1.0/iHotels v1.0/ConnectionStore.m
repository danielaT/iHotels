//
//  ConnectionStore.m
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "ConnectionStore.h"

@interface ConnectionStore()

@property NSMutableData* connectionData;

@property (nonatomic, copy) void (^callback)();

@end

@implementation ConnectionStore

@synthesize callback=_callback;

@synthesize connectionData=_connectionData;

-(void) getDataForConnectionWithURL:(NSURL*)url handler:(void (^)(NSData*))ch {
    self.connectionData = [NSMutableData data];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    
    self.callback = ch;
    
    if (connection) {
        self.connectionData = [NSMutableData data];
    }
    else {
        // error
    }
}

// clear the connectionData when a request to a new url is made
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.connectionData setLength:0];
}

// append data to connectionData
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.connectionData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.connectionData = nil;
    // error
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.callback(self.connectionData);
}

@end
