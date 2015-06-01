//
//  UploadImage.m
//  kentApp
//
//  Created by pericentmac on 4/1/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "UploadImage.h"
#import "WebServiceConnection.h"

@interface UploadImage ()
{
    WebServiceConnection * connection;
}

@end

@implementation UploadImage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    connection = [WebServiceConnection connectinManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage:) name:@"updateImage" object:self];
}
#pragma mark - WebService Pat Status method
-(void)updateImage:(UIImage *)notification
{
    UIImage  * img =[notification valueForKey:@"dict"];
    NSData *imageData = UIImageJPEGRepresentation(img, .8);
    NSString *imageEncodedString = [imageData base64EncodedStringWithOptions:0];
    
    [self webserviceMethod:imageEncodedString];
}
-(void)webserviceMethod:(NSString *)strBase{
    NSString *urlString=[NSString stringWithFormat:@"http://netleondev.com/kentapi/user/updateUserImage"];
    NSDictionary *urlParam=@{@"user_id":@"104",@"ImageName":@"test.png",@"base64":strBase};
    
    [connection startConectionWithString:urlString HttpMethodType:@"POST" HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        NSLog(@"%@",receivedData);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
