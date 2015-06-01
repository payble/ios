//
//  RESTAPIRequest.m
//  ituneUniversity
//
//  Created by Balvinder on 5/7/12.
//  Copyright 2012 Pericent Softwares. All rights reserved.
//

#import "RESTAPIRequest.h"
#import "JSON.h"
#import "ServerReachability.h"
#import "JsonReader.h"

@implementation RESTAPIRequest

@synthesize handler, url, receivedData, action;


+ (RESTAPIRequest*) createRequest: (id) handler action: (SEL) action urlString: (NSString*) urlString {
	RESTAPIRequest* restRequest = [[RESTAPIRequest alloc] init];
	
	restRequest.url = [NSURL URLWithString: urlString];
	restRequest.handler = handler;
	restRequest.action = action;
	return restRequest;
}	

// Sends the request via HTTP.
- (void) send
{
	
	// Make sure the network is available
	if([ServerReachability connectedToNetwork] == NO)
    {
		NSError* error = [NSError errorWithDomain:@"Taxibuddy" code:400 userInfo:[NSDictionary dictionaryWithObject:@" Sorry! no network found " forKey:NSLocalizedDescriptionKey]];
		[self handleError: error];
	}
	
	// Make sure we can reach the host
	else /*if([ServerReachability hostAvailable:url.host] == NO) {
		NSError* error = [NSError errorWithDomain:@"Taxibuddy" code:410 userInfo:[NSDictionary dictionaryWithObject:@" Server is not available " forKey:NSLocalizedDescriptionKey]];
		[self handleError: error];
	}
         else */{
		
		// Create the request
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
													cachePolicy:NSURLRequestReturnCacheDataElseLoad
												timeoutInterval:300000];
		
		// Create the connection
		conn = [[NSURLConnection alloc] initWithRequest: urlRequest delegate: self];
		
		if(conn) {
            NSLog(@"1");
			receivedData = [[NSMutableData data] retain];
            NSLog(@"Received Data %@",receivedData);
            NSLog(@"2");
		} else {
            NSLog(@"3");
			// We will want to call the onerror method selector here...
			if(self.handler != nil) {
                NSLog(@"4");
				NSError* error = [NSError errorWithDomain:@"Taxibuddy" code:404 userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"Could not create connection", NSLocalizedDescriptionKey,nil]];
                NSLog(@"5");
				[self handleError: error];
                NSLog(@"6");
			}
		}
	}
}

//send request with data via post method of request



- (void) sendPostDataWithImage:(NSString *)request1 withdate:(NSData*)propic withImageName:(NSString*)imagename  {
    
    NSLog(@"inside sendPostData and result---------------");
    // Make sure the network is available
    if([ServerReachability connectedToNetwork] == NO) {
        NSError* error = [NSError errorWithDomain:@"GoBusyBees" code:400 userInfo:[NSDictionary dictionaryWithObject:@" Sorry! no network found " forKey:NSLocalizedDescriptionKey]];
        [self handleError: error];
    }
    
    // Make sure we can reach the host
    else if([ServerReachability hostAvailable:url.host] == NO) {
        NSError* error = [NSError errorWithDomain:@"GoBusyBees" code:410 userInfo:[NSDictionary dictionaryWithObject:@" Server is not available " forKey:NSLocalizedDescriptionKey]];
        [self handleError: error];
    }else {
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:5000];
        
        NSString *stringBoundary = @"*****";
        // header value
        NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
        // set header
        [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
        // create data
        NSMutableData *postBody = [NSMutableData data];
        // media part
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Disposition: form-data; name=\"request\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithString:request1] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"photo\";filename=\"%@\"\r\n",imagename] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:propic];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postBody];
        
        
        
        // Create the connection
        conn = [[NSURLConnection alloc] initWithRequest: request delegate: self];
        if(conn) {
            receivedData = [[NSMutableData data] retain];
        } else {
            // We will want to call the onerror method selector here...
            if(self.handler != nil) {
                NSError* error = [NSError errorWithDomain:@"GoBusyBees" code:404 userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"Could not create connection", NSLocalizedDescriptionKey,nil]];
                [self handleError: error];
            }
        }
        
    }
}





//send request with data via post method of request



- (void) sendPostDataWithVideo:(NSString *)request1 withdate:(NSData*)propic  withVideoName:(NSString*)videoname  withImagrThumnail:(NSData*)thumnail withImageName:(NSString*)imagename {
    
    NSLog(@"inside sendPostData and result---------------");
    // Make sure the network is available
    if([ServerReachability connectedToNetwork] == NO) {
        NSError* error = [NSError errorWithDomain:@"GoBusyBees" code:400 userInfo:[NSDictionary dictionaryWithObject:@" Sorry! no network found " forKey:NSLocalizedDescriptionKey]];
        [self handleError: error];
    }
    
    // Make sure we can reach the host
    else if([ServerReachability hostAvailable:url.host] == NO) {
        NSError* error = [NSError errorWithDomain:@"GoBusyBees" code:410 userInfo:[NSDictionary dictionaryWithObject:@" Server is not available " forKey:NSLocalizedDescriptionKey]];
        [self handleError: error];
    }else {
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:5000];
        
        NSString *stringBoundary = @"*****";
        // header value
        NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
        // set header
        [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
        // create data
        NSMutableData *postBody = [NSMutableData data];
        // media part
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Disposition: form-data; name=\"request\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithString:request1] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"thumb\";filename=\"%@\"\r\n",imagename] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:thumnail];
        
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"video\";filename=\"%@\"\r\n",videoname] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Type: video/mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:propic];
        
        
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postBody];
        
        
        
        // Create the connection
        conn = [[NSURLConnection alloc] initWithRequest: request delegate: self];
        if(conn) {
            receivedData = [[NSMutableData data] retain];
        } else {
            // We will want to call the onerror method selector here...
            if(self.handler != nil) {
                NSError* error = [NSError errorWithDomain:@"GoBusyBees" code:404 userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"Could not create connection", NSLocalizedDescriptionKey,nil]];
                [self handleError: error];
            }
        }
        
    }
}



- (void) sendPostData:(NSData *)postData {

	NSLog(@"inside sendPostData and result---------------");
     NSLog(@"url host  %@",url.host);
	// Make sure the network is available
	if([ServerReachability connectedToNetwork] == NO) {
		NSError* error = [NSError errorWithDomain:@"Farming_App" code:400 userInfo:[NSDictionary dictionaryWithObject:@" Sorry! no network found " forKey:NSLocalizedDescriptionKey]];
		[self handleError: error];
	}
	
	// Make sure we can reach the host
   
	else if([ServerReachability hostAvailable:url.host] == NO) {
		NSError* error = [NSError errorWithDomain:@"Farming_App" code:410 userInfo:[NSDictionary dictionaryWithObject:@" Server is not available " forKey:NSLocalizedDescriptionKey]];
		[self handleError: error];
	}else {
		
		NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request setValue:@"aDRF@F#JG_a34-n3d" forHTTPHeaderField:@"Authorization"];
        
    
        
		[request setURL:url];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:postData];
     
        [request setTimeoutInterval:5000000];
		
		// Create the connection
		conn = [[NSURLConnection alloc] initWithRequest: request delegate: self];
		if(conn) {
			receivedData = [[NSMutableData data] retain];
		} else {
			// We will want to call the onerror method selector here...
			if(self.handler != nil) {
				NSError* error = [NSError errorWithDomain:@"Farming_App" code:404 userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"Could not create connection", NSLocalizedDescriptionKey,nil]];
				[self handleError: error];
			}
		}
	}
}


-(void)handleError:(NSError*)error{
	
	NSLog(@"Error is %@",[error localizedDescription]);
	
	if(self.action!= nil) { 
		
		if(self.handler != nil && [self.handler respondsToSelector: self.action]) {
			[self.handler performSelector: self.action withObject: error];
			
		}
	}
}

// Called when the HTTP socket gets a response.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}

// Called when the HTTP socket received data.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)value {
    [self.receivedData appendData:value];
    NSLog(@"responce --> %@",value);
}

// Called when the HTTP request fails.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[conn release];
	conn = nil;
	[self.receivedData release];
	[self handleError:error];
}

// Called when the connection has finished loading.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSError* error=nil;
	
	// just to see the value in console
    NSLog(@"responce --> %@",self.receivedData);
	NSString* jsonString = [[NSString alloc] initWithData: self.receivedData encoding: NSUTF8StringEncoding];
	
	if (jsonString!=nil) {
		
		if(self.action!= nil) { 
			
			if(self.handler != nil && [self.handler respondsToSelector: self.action]) {
				
				//NSLog(@"Ready to send the result");
               // NSLog(@"Jsonstring-->%@",jsonString);
        [self.handler performSelector: self.action withObject: jsonString];
                NSLog(@"Jsonstring AFTER-->%@",jsonString);
                
             //   TaxiOrderDataService *crosh=[TaxiOrderDataService service];
              //  [crosh postmessage:@"a46af26e749bd96f5174d0518cfc8c22fa5614cfd503a2c9fcdb53ff626d2c3b" withMessage:@"popup" onTarget:self action:@selector(postMessage:)];
				
			}
			
		}else {
			
			NSLog(@"caller of request not exists");
		}
		
		
		
	}else if (error) {
		//Error from server
		NSLog(@"Error in output=>%@",[error localizedDescription]);
		[self handleError:error];
	}
	[jsonString release];
	
	//[jsonParser release];
	
	[self.handler release];
	[conn release];
	conn = nil;
	[self.receivedData release];
}

// Called if the HTTP request receives an authentication challenge.
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
}


// Cancels the HTTP request.
- (BOOL) cancel {
	if(conn == nil) { return NO; }
	[conn cancel];
	[conn release];
	conn = nil;
	return YES;
}


-(void) dealloc{
	[super dealloc];
//	[url release];
    
	
}

@end
