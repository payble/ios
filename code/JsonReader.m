//
//  JsonReader.m
//  ituneUniversity
//
//  Created by Balvinder on 5/7/12.
//  Copyright 2012 Pericent Softwares. All rights reserved.
//

#import "JsonReader.h"
#import "JSON.h"



@implementation JsonReader

- (id)init {
    self = [super init];
    if (self) {
        return self;
		
    }
    return self;
}

- (id) objectWithUrl:(NSURL *)url
{
	SBJSON *jsonParser=[[[SBJSON alloc] init]autorelease ];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
								cachePolicy:NSURLRequestReturnCacheDataElseLoad
								timeoutInterval:30];
	NSError *error=nil;
	NSURLResponse *URLResponse;
	
	// Fetch the JSON response
	NSData *urlData;
	
	// Make synchronous request
	urlData =   [NSURLConnection sendSynchronousRequest:urlRequest
				returningResponse:&URLResponse error:&error]; 	// Construct a String around the Data from the response
	
	if (error == nil) {
		if ([URLResponse isKindOfClass:[NSHTTPURLResponse class]]) {
			NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) URLResponse;
			int status = [httpResponse statusCode];
			
			// if the call was okay, then invoke the parser
			if ((status >= 200) && (status < 300)) {
				NSString *tempReturn=[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
				
				NSLog(@"JsonString Returned");
				NSMutableString *jsonString=[[NSMutableString alloc] initWithString:[tempReturn stringByReplacingOccurrencesOfString:@":null" withString:@":\"-\""]];
			 	[jsonString setString:[jsonString stringByReplacingOccurrencesOfString:@":\"\"" withString:@":\"-\""]];
			 	[tempReturn release];			
				
				NSError *error2=nil;
				id val=[jsonParser objectWithString:jsonString error:&error2];
				if (val!=nil) {
					[jsonString release];
					
					return val;
				}else {
					[jsonString release];
					return @"No Response from Server";
				}
				
				
			}else {
				return @"No Response from Server";
			}
			
		}
	}else {
		NSLog (@"Connection Failed with Error");
		return [NSString stringWithString:[error localizedDescription]];
	}
	
	return @"No Response from Server";
}


@end

