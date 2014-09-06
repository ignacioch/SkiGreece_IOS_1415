//
//  LocalAPI.m
//  Ski Greece
//
//  Created by VimaTeamGr on 10/21/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "LocalAPI.h"

//the web location of the service
#define kAPIHost @"http://www.vimateam.gr/projects/skigreece_backup"
//#define kAPIHost @"http://localhost:8888/"
//#define kAPIPath @"nearby/"
#define kAPIPath @"nearby/"

@implementation LocalAPI

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(LocalAPI*)sharedInstance
{
    static LocalAPI *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    
    return sharedInstance;
}

-(LocalAPI*)init
{
    //call super init
    self = [super init];
    
    if (self != nil) {
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    
    NSMutableURLRequest *apiRequest =
    [self multipartFormRequestWithMethod:@"POST"
                                    path:kAPIPath
                              parameters:params
               constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
               }];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        NSLog(@"LocalAPI: This is failing : %@",[NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

-(NSURL*)urlForImageWithId:(int)IdPhoto{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@images/%d.jpg",
                           kAPIHost, kAPIPath, IdPhoto
                           ];
    NSLog(@"Trying to open url:%@",urlString);
    return [NSURL URLWithString:urlString];
}

@end
