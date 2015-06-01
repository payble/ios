//
//  QARestIntraction.m
//  quizApp
//
//  Created by Mac5 on 11/17/14.
//
//

#import "QARestIntraction.h"

@implementation QARestIntraction
+(void)GetDataForMethod:(NSDictionary *)dicOfParameters strMethod:(NSString *)strMethod authentication:(BOOL)Header withCompletion:(void (^)(id data))completion WithFailure:(void (^)(NSString *error))failure
{
    if([QAUtils IsNetConnected])
    {
      
        
          NSString* apiEndpoint= [NSString stringWithFormat:@"%@%@",MAIN_QA_SERVICE_URL,strMethod];
        
        // NSLog(@"apiEndpoint %@ dicOfParameters %@",apiEndpoint,dicOfParameters);
        
        ASIFormDataRequest* _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:apiEndpoint]];
        __weak ASIFormDataRequest* request =_request;
        if (dicOfParameters.count==0)
        {
            request.requestMethod = @"GET";
        }
        else if ([strMethod isEqualToString:@"user/register"]||[strMethod isEqualToString:@"user/review"])
        {
            request.requestMethod=@"PUT";
        }
        else
        {
            request.requestMethod = @"POST";
        }
        
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
        
//        if(Header)
//        {
//            [request addRequestHeader:@"Authorization"
//                                value:[NSString stringWithFormat:@"Basic %@",
//                                       [ASIHTTPRequest base64forData:
//                                        [[NSString stringWithFormat:@"%@:%@",UCGetUserUname(), UCGetUserPassword()]
//                                         dataUsingEncoding:NSUTF8StringEncoding]]]];
//        }
        
        for (id keyss in dicOfParameters)
        {
            if ([keyss isEqualToString:@"profile_pic"])
            {
                
                [request setData:[dicOfParameters valueForKey:keyss] withFileName:@"png" andContentType:@"png/jpeg" forKey:@"profile_pic"];
            }
            else{
                [request addPostValue:[dicOfParameters valueForKeyPath:keyss] forKey:keyss];
            }
        }
        //[request appendPostData:[strPostBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request startAsynchronous];
        [request setCompletionBlock:^{
            // NSLog(@"%@",request.responseString);
            //NSString *responseString = [request responseString];
            NSData *Data = [request responseData];
            NSDictionary* responseData =[NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:nil];
           // NSArray *responseData=[NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:nil];
            
           // NSString *strid=[[responseData objectAtIndex:0]objectForKey:@"id"];
            
            
            NSLog(@"responseData: %@", responseData);
            
              if (responseData.count>0)
             {
             completion(responseData );
             }
             else if ([responseData isEqual:[NSNull null]])
             {
             failure(@"Server error");
             }
             else
             {
             completion(responseData);
             }
            
          /*  if (responseData.count>0&&[responseData objectForKey:@"response"] && [[responseData objectForKey:@"response"] objectForKey:@"responsepacket"])
            {
                completion([[responseData objectForKey:@"response"] objectForKey:@"responsepacket"]);
            }
            else if ([responseData isEqual:[NSNull null]])
            {
                failure(@"Server error");
            }
            else
            {
                completion(responseData);
            }*/
        }];
        [request setFailedBlock:^{
            
            failure(request.error.localizedDescription);
        }];
    }
    else
    {
        [DSBezelActivityView removeViewAnimated:YES];
        // [PYUtils showAlert:MESSAGE_NET_NOT_AVAILABLE];
        return;
    }
}

@end


