//
//  UploadClass.m
//  kentApp
//
//  Created by pericentmac on 4/1/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "UploadClass.h"
#import "WebServiceConnection.h"

@implementation UploadClass
+ (BOOL)uploadImage:(NSString*)strbase64
{
    NSString *urlString=[NSString stringWithFormat:@"http://netleondev.com/kentapi/user/updateUserImage"];
    NSDictionary *urlParam=@{@"user_id":@"104",@"ImageName":@"test.png",@"base64":strbase64};
    
    WebServiceConnection * connection = [WebServiceConnection connectinManager];
    [connection startConectionWithString:urlString HttpMethodType:@"POST" HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        NSLog(@"%@",receivedData);
        
    }];
    return YES;
}
@end
