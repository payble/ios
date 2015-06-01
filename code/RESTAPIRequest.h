//
//  RESTAPIRequest.h
//  GoBusyBee Project
//
//  Created by Balvinder on 5/7/12.
//  Copyright 2012 Pericent Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TaxiOrderDataService.h"

@interface RESTAPIRequest : NSObject {
	
	NSURL* url;
	NSMutableData* receivedData;
	NSURLConnection* conn;
	id handler;
	SEL action;

}
@property (retain, nonatomic) NSURL* url;
@property (retain, nonatomic) NSMutableData* receivedData;
@property (retain, nonatomic) id handler;
@property SEL action;

+ (RESTAPIRequest *)createRequest:(id)handler action:(SEL)action urlString:(NSString *)urlString;
- (void) sendPostDataWithImage:(NSString *)request1 withdate:(NSData*)propic withImageName:(NSString*)imagename;
- (void) sendPostDataWithVideo:(NSString *)request1 withdate:(NSData*)propic  withVideoName:(NSString*)videoname  withImagrThumnail:(NSData*)thumnail withImageName:(NSString*)imagename ;
- (BOOL)cancel;
- (void)send;
- (void) sendPostData:(NSData *)postData; 
- (void)handleError:(NSError*)error;

@end
