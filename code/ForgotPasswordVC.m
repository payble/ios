//
//  ForgotPasswordVC.m
//  kentApp
//
//  Created by N@kuL on 31/12/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ( IDIOM == IPAD ) {
        emailLbl.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        resetPassButton.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFEmail.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        backButton.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTitle.font  =   [UIFont fontWithName:FONT_TITLE size:22];
        txtFEmail.frame =   CGRectMake(txtFEmail.frame.origin.x, txtFEmail.frame.origin.y+5, txtFEmail.frame.size.width, txtFEmail.frame.size.height);
        
    }else{
        emailLbl.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        resetPassButton.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFEmail.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        backButton.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblTitle.font  =   [UIFont fontWithName:FONT_TITLE size:15];
    }
    
    viewForgotPwd.layer.cornerRadius=3.0f;
    viewForgotPwd.clipsToBounds=YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtFEmail resignFirstResponder];
}


#pragma mark- IB_Action
-(IBAction)btnArrowDidClicked:(id)sender
{
   
    if([[txtFEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFEmail.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter email." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![Validate isValidEmailId:txtFEmail.text])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter correct email." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [DSBezelActivityView newActivityViewForView:self.view];
        
        NSDictionary *info=[[NSDictionary alloc]initWithObjectsAndKeys:txtFEmail.text,@"email", nil];
        
        NSString *strUrl=@"http://netleondev.com/kentapi/user/forgotpassword";
        NSURL *url=[NSURL URLWithString:strUrl];
        
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:url];
        
        [request addRequestHeader:@"Content-type" value:@"application/json"];
        [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
        request.requestMethod=@"POST";
        request.timeOutSeconds=30;
        
        NSString *jsonString=[info JSONRepresentation];
        NSData *requestData=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setPostBody:[requestData mutableCopy]];
        request.delegate=self;
        request.allowCompressedResponse = NO;
        request.useCookiePersistence = NO;
        request.shouldCompressRequestBody = NO;
        [request startAsynchronous];
        
        
    }

    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    
    NSString *responseString = [request responseString];
    
    NSData *responseData = [request responseData];
    
    
    
    NSError *e=nil;
    
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&e];
    
    if (!jsonArray)
    {
        NSLog(@"errorNkl==%@ [e localizedDescription]=%@",e,[e localizedDescription]);
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"server error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[dic objectForKey:@"success"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];

    }
    
   
    
  
    
     [DSBezelActivityView removeViewAnimated:YES];

    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSError *error = [request error];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


-(IBAction)btnCancelDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
