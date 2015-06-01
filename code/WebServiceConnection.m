//
//
//  DirectVet
//
//  Created by DirectVet on 6/16/14.
//  Copyright (c) 2014 DirectVet. All rights reserved.
//

#import "WebServiceConnection.h"
#import "URL.h"

typedef void (^myBlock)(NSDictionary *receivedData);

@interface WebServiceConnection ()
{
    NSMutableData *recievedDataByConnection;
    myBlock outputBlock;
}

@end


@implementation WebServiceConnection

+(id)connectinManager
{
    WebServiceConnection *newConnection=nil;
    //static dispatch_once_t onceToken;
    newConnection=[[self alloc]init];
//    dispatch_once(&onceToken,^{
//        
//    });
    NSLog(@"connection %@ self %@",newConnection, self);
    return newConnection;
}

-(id)init
{
    if (self=[super init]) {
        stringUrl=[[NSString alloc]init];
        queue=[[NSOperationQueue alloc]init];
        alertView=[UIAlertView alloc];
        receivedData=[[NSDictionary alloc]init];
        recievedDataByConnection = [[NSMutableData alloc] init];
        request=[[NSMutableURLRequest alloc]init];
            }
    return self;
}

-(void)cancelRequest
{
    recievedDataByConnection = nil;
    [urlConnection cancel];
    recievedDataByConnection = [[NSMutableData alloc] init];
}

-(void)startConectionToUploadImageWithString:(NSString*)stringurl imageData:(NSData *)imageData HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction{
    
    [self cancelRequest];
    NSLog(@"%@",stringurl);
    NSLog(@"params %@",params);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]];
    
    [request setURL:[NSURL URLWithString:stringurl]];
    [request setHTTPMethod:@"POST"];
    //[request setHTTPBody:[urlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    for (NSString *param in params) {
        
        [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadfile\"; filename=\"%@.jpg\"\r\n",@"text"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imageData]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    outputBlock = outputFunction;
    
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [urlConnection start];
    });

}


-(void)startConectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction
{
    //NSData *jsonData;
    [self cancelRequest];
    NSLog(@"%@",recievedDataByConnection);
    NSLog(@"params %@",params);
    NSMutableString *stringParams = [[NSMutableString alloc] init];
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        //jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        
        for (NSString *key in [params allKeys]) {
            [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
        }
        NSLog(@"%@",stringParams);
        stringUrl=stringurl;
    }else if([paramStringMethodType isEqualToString:Get_type]){
        
        if ([params count]>0) {
            
            for (NSString *key in [params allKeys]) {
                [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
            }
            stringUrl=[NSString stringWithFormat:@"%@?%@",stringurl,stringParams];
        }else{
            stringUrl=stringurl;
        }
        
    }
    else if([paramStringMethodType isEqualToString:Put_type]){
        
        for (NSString *key in [params allKeys]) {
            [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
        }
        NSLog(@"%@",stringParams);
        stringUrl=stringurl;
        
    }

    
    NSLog(@"url %@",stringUrl);
    
    url=[NSURL URLWithString:stringUrl];
    [request setURL:url];
    [request setHTTPMethod:paramStringMethodType];
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        [request setHTTPBody:[stringParams dataUsingEncoding:NSUTF8StringEncoding]];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    outputBlock = outputFunction;
    
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [urlConnection start];
    });
    
    
    
    
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        
//        NSLog(@"Response: %@",response);
//        NSLog(@"Error : %@",connectionError);
//        NSLog(@"data %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//        
//        
//        NSLog(@"respnse desc %@",((NSHTTPURLResponse *)response).description);
//        
//        if ([data length]>0 && connectionError==nil && ((NSHTTPURLResponse *)response).statusCode == 200) {
//            
//            receivedData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
//            
//            
//            
//            
//        }else if (((NSHTTPURLResponse *)response).statusCode != 200 && response != nil)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//            [[alertView initWithTitle:@"Connection Error" message:@"There is some error in connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            });
//            
//            receivedData = @{@"Connection Error":@"There is some error in connection"};
//        }else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[alertView initWithTitle:@"Connection Error" message:[connectionError localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            });
//            
//            receivedData = @{@"Connection Error":[connectionError localizedDescription]};
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            outputFunction((NSDictionary *)receivedData);
//        });
//        
//    }];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[alertView initWithTitle:@"Connection Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    });
    
    receivedData = @{@"Connection Error":[error localizedDescription]};
    
    dispatch_async(dispatch_get_main_queue(), ^{
        outputBlock((NSDictionary *)receivedData);
    });
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (((NSHTTPURLResponse *)response).statusCode != 200 && response != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[alertView initWithTitle:@"Connection Error" message:@"There is some error in connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        });
        
        receivedData = @{@"Connection Error":@"There is some error in connection"};
        dispatch_async(dispatch_get_main_queue(), ^{
            outputBlock((NSDictionary *)receivedData);
        });
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [recievedDataByConnection appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    receivedData=[NSJSONSerialization JSONObjectWithData:recievedDataByConnection options:kNilOptions error:nil];
    
    if (receivedData == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[alertView initWithTitle:@"Connection Error" message:@"There is some error in connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        });
        
        receivedData = @{@"Connection Error":@"There is some error in connection. Please try again later."};
        dispatch_async(dispatch_get_main_queue(), ^{
            outputBlock((NSDictionary *)receivedData);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            outputBlock((NSDictionary *)receivedData);
        });
    }
    
    
    
}


@end
