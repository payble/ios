//
//  DirectVet
//
//  Created by DirectVet on 6/16/14.
//  Copyright (c) 2014 DirectVet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebServiceConnection : NSObject<NSURLConnectionDataDelegate>
{
    NSString *stringUrl;
    NSURL *url;
    NSMutableURLRequest *request;
    NSOperationQueue *queue;
    NSURLConnection *urlConnection;
    UIAlertView *alertView;
    id receivedData;
}

+(id)connectinManager;

-(void)startConectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;
-(void)startConectionToUploadImageWithString:(NSString*)stringurl imageData:(NSData *)imageData HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;
-(void)cancelRequest;

@end
