//
//  LocalAPI.h
//  Ski Greece
//
//  Created by VimaTeamGr on 10/21/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFNetworking.h"

//API call completion block with result as json
typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface LocalAPI : AFHTTPClient

//send an API command to the server
+(LocalAPI*)sharedInstance;

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

-(NSURL*)urlForImageWithId:(int)IdPhoto;


@end
