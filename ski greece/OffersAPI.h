//
//  OffersAPI.h
//  Ski Greece
//
//  Created by VimaTeamGr on 11/10/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"

//JSON Request completion
//API call completion block with result as json
typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface OffersAPI : AFHTTPClient

//send an API command to the server
+(OffersAPI*)sharedInstance;

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

-(NSURL*)urlForImageWithId:(int)IdPhoto;

@end
