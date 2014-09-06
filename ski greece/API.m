//
//  API.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/15/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "API.h"

//the web location of the service
#define kAPIHost @"http://www.vimateam.gr/projects/skigreece"
//#define kAPIHost @"http://localhost:8888/"
#define kAPIPath @"community/"

@implementation API

@synthesize user;

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(API*)sharedInstance
{
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    
    return sharedInstance;
}

#pragma mark - init
//intialize the API class with the destination host name

-(API*)init
{
    //call super init
    self = [super init];
    
    if (self != nil) {
        //initialize the object
        user = nil;
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

-(BOOL)isAuthorized
{
    //NSLog(@"API: isAuthorized:%d",[[user objectForKey:@"IdUser"] intValue]);
    return [[user objectForKey:@"IdUser"] intValue]>0;
}

-(int)getUserid{
    //NSLog(@"API: isAuthorized:%d",[[user objectForKey:@"IdUser"] intValue]);
    return [[user objectForKey:@"IdUser"] intValue];
}

-(int)getUserKm{
    //NSLog(@"API: isAuthorized:%d",[[user objectForKey:@"IdUser"] intValue]);
    return [[user objectForKey:@"km"] intValue];
}

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    NSData* uploadFile = nil;
    if ([params objectForKey:@"file"]) {
        uploadFile = (NSData*)[params objectForKey:@"file"];
        [params removeObjectForKey:@"file"];
    }
    
    NSMutableURLRequest *apiRequest =
    [self multipartFormRequestWithMethod:@"POST"
                                    path:kAPIPath
                              parameters:params
               constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                   //TODO: attach file if needed
                   if (uploadFile) {
                       [formData appendPartWithFileData:uploadFile
                                                   name:@"file"
                                               fileName:@"photo.jpg"
                                               mimeType:@"image/jpeg"];
                   }
               }];
    //NSLog(@"This is the url %@", apiReques);
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        //NSLog(@"This is the response %@", responseObject);
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        NSLog(@"This is failing : %@",[NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

//in API.m
-(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb {
    NSString* urlString = [NSString stringWithFormat:@"%@/%@upload/%@%@.jpg",
                           kAPIHost, kAPIPath, IdPhoto, (isThumb)?@"-thumb":@""
                           ];
    return [NSURL URLWithString:urlString];
}

@end
