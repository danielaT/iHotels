//
//  ConnectionStore.m
//  iHotels v1.0
//
//  Created by Student14 on 1/31/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "ConnectionStore.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface ConnectionStore()

@property NSMutableData* connectionData;
@property (nonatomic, strong) void (^callback)();

@end

@implementation ConnectionStore

@synthesize callback=_callback;

@synthesize connectionData=_connectionData;

-(void) getDataForConnectionWithURL:(NSURL*)url handler:(void (^)(NSData*))completionHandler {
    self.connectionData = [NSMutableData data];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    
    self.callback = completionHandler;
    
    if (connection) {
        self.connectionData = [NSMutableData data];
    }
    else {
        [self showMessageIfInternetConnectionIsUnavailable];
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
    [self showMessageIfInternetConnectionIsUnavailable];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.callback(self.connectionData);
}

// checks if internet connection is available
- (void)showMessageIfInternetConnectionIsUnavailable
{
    static BOOL checkNetwork = YES;
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
        checkNetwork = NO;
        Boolean success;
        const char *host_name = "ean.com"; // host name for testing the internet connection
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        if (!(success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired))) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Cannot find internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

@end
