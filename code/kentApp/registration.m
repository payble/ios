//
//  registration.m
//  kentApp
//
//  Created by pericent on 12/18/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import "registration.h"
#import "Api_connect.h"
#import "QAUtils.h"
#import "SBJSON.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

#import "HomeVC.h"

@interface registration ()

@end

@implementation registration


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"FONT NAME :: %@",FONT_NAME_MAIN);
    
    if ( IDIOM == IPAD ) {
        firstname.font  =  [UIFont fontWithName:FONT_NAME_MAIN size:22];
        email.font      =  [UIFont fontWithName:FONT_NAME_MAIN size:22];
        mobile.font     =  [UIFont fontWithName:FONT_NAME_MAIN size:22];
        password.font   =  [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        nameLbl.font    =  [UIFont fontWithName:FONT_NAME_MAIN size:22];
        emailLbl.font   =  [UIFont fontWithName:FONT_NAME_MAIN size:22];
        mobileLbl.font  =  [UIFont fontWithName:FONT_NAME_MAIN size:22];
        passLbl.font    =  [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        
        fbCnctLbl.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:25];
        detailLbl.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        orLbl.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        registerBtn.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:25];
        backButton.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTitle.font   =   [UIFont fontWithName:FONT_TITLE size:22];
        
        lblTitle.frame  =   CGRectMake(lblTitle.frame.origin.x-30, lblTitle.frame.origin.y, lblTitle.frame.size.width, lblTitle.frame.size.height);
        fbButton.frame  =   CGRectMake(18, 70, 285, 90);
        fbCnctLbl.frame =   CGRectMake(86, 94, 177, 21);
        
        
    }else{
        firstname.font  =  [UIFont fontWithName:FONT_NAME_MAIN size:14];
        email.font      =  [UIFont fontWithName:FONT_NAME_MAIN size:14];
        mobile.font     =  [UIFont fontWithName:FONT_NAME_MAIN size:14];
        password.font   =  [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        nameLbl.font    =  [UIFont fontWithName:FONT_NAME_MAIN size:14];
        emailLbl.font   =  [UIFont fontWithName:FONT_NAME_MAIN size:14];
        mobileLbl.font  =  [UIFont fontWithName:FONT_NAME_MAIN size:14];
        passLbl.font    =  [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        
        fbCnctLbl.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        detailLbl.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        orLbl.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        registerBtn.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        backButton.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblTitle.font   =   [UIFont fontWithName:FONT_TITLE size:14];
    }
    
    imgVArrow.image=[UIImage imageNamed:@"rightarrow.png"];
    
    ViewRegistration.layer.cornerRadius=3.0f;
    ViewRegistration.clipsToBounds=YES;
    
    act.hidden=YES;
    
  
}


//#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if (textField.tag==100)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
        
    }
    return YES;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self keyboardShow];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self keyboardHide];
    
    return YES;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [firstname resignFirstResponder];
    [email resignFirstResponder];
    [password resignFirstResponder];
    [mobile resignFirstResponder];
    
    [self keyboardHide];
    
}



#pragma mark-keyboard show and hide

-(void)keyboardShow
{
    UIView *view=self.view;
    
    [UIView animateWithDuration:.3
                          delay:.1
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         CGRect frame = view.frame;
                         frame.origin.y = -50;
                         frame.origin.x = 0;
                         view.frame = frame;
                     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
    
}

-(void)keyboardHide
{
    UIView *view=self.view;
    
    [UIView animateWithDuration:.3
                          delay:.1
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         CGRect frame = view.frame;
                         frame.origin.y = 0;
                         frame.origin.x = 0;
                         view.frame = frame;
                     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
}





#pragma mark- IB_Action


-(IBAction)btnFaceBookLoging_didPressed:(id)sender
{
    
    //[self loginWithFacebook];
    
    
    if([QAUtils IsNetConnected])
    {
        if (!FBSession.activeSession.isOpen)
        {
            //switchfacebook.userInteractionEnabled=NO;
            // if the session is closed, then we open it here, and establish a handler for state changes
            // NSArray *permissions = [NSArray arrayWithObjects:@"email",@"user_birthday", nil];
            
            NSArray *permissions = [NSArray arrayWithObjects:@"public_profile",@"read_friendlists",@"email",@"user_friends",@"user_birthday", nil];
            
            /*     { "public_profile",
             "read_friendlists",   public_profile
             "email",
             "user_friends" ,"user_birthday","friends_photos","friends_checkins"};
             
             */
            
            [FBSession openActiveSessionWithReadPermissions:permissions
                                               allowLoginUI:YES
                                          completionHandler:^(FBSession *session,
                                                              FBSessionState state,
                                                              NSError *error)
             {
                 if (error)
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                         message:error.localizedDescription
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                     [alertView show];
                 }
                 else if (session.isOpen)
                 {
                     
                     [DSBezelActivityView newActivityViewForView:self.view];
                     [self makeRequestForUserData];
                     
                     
                 }
             }];
        }
        else
        {
            [DSBezelActivityView newActivityViewForView:self.view];
            
            [self makeRequestForUserData];
            
            /* handle the result */
        }

    }
    else
    {
        [DSBezelActivityView removeViewAnimated:YES];
        return;
    }
 
    
    
}

- (void)makeRequestForUserData
{
    
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            [DSBezelActivityView removeViewAnimated:YES];
            
            // Success! Include your code to handle the results here
            NSLog(@"%@",[NSString stringWithFormat:@"user info: %@", result]);
            
            [[NSUserDefaults standardUserDefaults]setObject:result forKey:@"userFacebookData"];
            
            NSArray *allKeys=[result allKeys];
            int i=0;
            for (NSString *str in allKeys)
            {
                if ([str isEqualToString:@"phone_number" ])
                {
                    i=1;
                    break;
                }
               
            }
            
            
            
            int j=0;
            for (NSString *str in allKeys)
            {
                if ([str isEqualToString:@"email" ])
                {
                    j=1;
                    break;
                }
                
            }
            
            
            
            NSDictionary *inputData;
            
            if (i==0)
            {
                
               // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Unable to fatch Phone number. Please do manual registration." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
               // [alert show];
                
                
                if (j==0)
                {
                    NSString *strEmail=[NSString stringWithFormat:@"%@%@@facebook.com",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]];
                    
                    inputData = [NSDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"first_name"], @"first_name",
                                 @"1234567890", @"phone_number",
                                 strEmail, @"email",
                                 @"123456",@"password",
                                 [result objectForKey:@"id"],@"facebook_id",
                                 [result objectForKey:@"last_name"],@"last_name",nil];

                }
                else
                {
                    inputData = [NSDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"first_name"], @"first_name",
                                 @"1234567890", @"phone_number",
                                 [result objectForKey:@"email"], @"email",
                                 @"123456",@"password",
                                 [result objectForKey:@"id"],@"facebook_id",
                                 [result objectForKey:@"last_name"],@"last_name",nil];

                }
                
                
            }
            else
            {
                
                if (j==0)
                {
                    inputData = [NSDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"first_name"], @"first_name",
                                 [result objectForKey:@"phone_number"], @"phone_number",
                                 [result objectForKey:@"id"], @"email",
                                 @"123456",@"password",
                                 [result objectForKey:@"id"],@"facebook_id",
                                 [result objectForKey:@"last_name"],@"last_name",nil];
                    
                }
                else
                {
                    
                    inputData = [NSDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"first_name"], @"first_name",
                                 [result objectForKey:@"phone_number"], @"phone_number",
                                 [result objectForKey:@"email"], @"email",
                                 @"123456",@"password",
                                 [result objectForKey:@"id"],@"facebook_id",
                                 [result objectForKey:@"last_name"],@"last_name",nil];
                }
                
              
                
              
            }
            
         
            [DSBezelActivityView newActivityViewForView:self.view];
            
            
            NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            
            [request addRequestHeader:@"Content-type" value:@"application/json"];
            [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
            
            [request setRequestMethod:@"PUT"];
            request.delegate=self;
            request.allowCompressedResponse = NO;
            request.useCookiePersistence = NO;
            request.shouldCompressRequestBody = NO;
            
            
            NSString *jsonRequest = [inputData JSONRepresentation];
            
            NSLog(@"jsonRequest is %@", jsonRequest);
            
            //NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
            
            
            
            NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setPostBody:[requestData mutableCopy]];
            
            [request startSynchronous];

            
            
            
    
            
          //  HomeVC *obHome = [[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
          //  [self.navigationController pushViewController:obHome animated:YES];
            
   
        }
        else
        {
            [DSBezelActivityView removeViewAnimated:YES];
            
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"%@",[NSString stringWithFormat:@"error %@", error.description]);
        }
    }];
}






-(IBAction)btnArraowClicked:(id)sender
{
//    NSString *errorMessage;
    
    [self keyboardHide];
    
    password.text=[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([[firstname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| firstname.text==nil)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter first name." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [firstname becomeFirstResponder];
    }
    else if([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| email.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter email." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [email becomeFirstResponder];

    }
    else if(![self NSStringIsValidEmail:email.text])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter valid email." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [email becomeFirstResponder];

    }
    else if([[mobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| mobile.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter mobile number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [mobile becomeFirstResponder];

    }
    else if (mobile.text.length<10)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter proper mobile number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [mobile becomeFirstResponder];

    }
    else if([[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| password.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter password." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [password becomeFirstResponder];

    }
    else if (password.text.length<5)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter min 5 characters in password." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [password becomeFirstResponder];

    }
    else
    {
       
        
        
      /*  self.navigationController.view.userInteractionEnabled=NO;
        Api_connect *api=[Api_connect serviceStart];

        [api registerUser:firstname.text phone_number:mobile.text email:email.text password:password.text onTarget:self action:@selector(registerresult:)];
        
        profile *profileObj = [[profile alloc]init];
        [self.navigationController pushViewController:profileObj animated:YES];
       
       */
        
        if([QAUtils IsNetConnected])
        {
            [DSBezelActivityView newActivityViewForView:self.view];
            
            NSDictionary *inputData = [NSDictionary dictionaryWithObjectsAndKeys:firstname.text, @"first_name",
                                       mobile.text, @"phone_number",
                                       email.text, @"email",
                                       password.text,@"password", nil];
            
            act.hidden=NO;

            [act startAnimating];
            // [DSBezelActivityView  newActivityViewForView:ViewRegistration];
            
           
            
            
           // [self.view setUserInteractionEnabled:NO];
           // loadingview=[LoadingView loadingViewInView:self.view withBGColor:[UIColor clearColor] withMessage:@"Please wait..."];
            
            
            NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            
            [request addRequestHeader:@"Content-type" value:@"application/json"];
            [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
            
            [request setRequestMethod:@"PUT"];
            request.delegate=self;
            request.allowCompressedResponse = NO;
            request.useCookiePersistence = NO;
            request.shouldCompressRequestBody = NO;
            request.timeOutSeconds=60;
            
            NSString *jsonRequest = [inputData JSONRepresentation];
            
            NSLog(@"jsonRequest is %@", jsonRequest);
            
            //NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
            
            
            
            NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setPostBody:[requestData mutableCopy]];
            
            [request startSynchronous];
            NSError *error = [request error];
            
            if (!error)
            {
                NSString *response = [request responseString];
            }

        }
        else
        {
            [DSBezelActivityView removeViewAnimated:YES];
            return;
        }
        
        
        
        
  
    }
    
        

}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
      [DSBezelActivityView removeViewAnimated:YES];
    
    [act stopAnimating];
    act.hidden=YES;
    
    [loadingview removeView];
    
    NSString *responseString = [request responseString];
    
     NSData *responseData = [request responseData];
   // NSNumber *useris=[responseString intValue];
    
    
    NSError *e=nil;
    
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&e];
    
    if (!jsonArray)
    {
        NSLog(@"errorNkl==%@",e);
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"server error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ([responseString isEqualToString:@"Email already exists!"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:responseString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else if([responseString isEqualToString:@"{\"error\":\"Email address is not valid.\"}"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Email address is not valid." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([responseString isEqualToString:@"{\"error\":\"Email already exists!\"}"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Email already exists!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:data forKey:@"userdataKey"];
            
            HomeVC *Home=[[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
            [self.navigationController pushViewController:Home animated:YES];
            
        }

    }

    
    
    
       // Use when fetching binary data
   
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
      [DSBezelActivityView removeViewAnimated:YES];
    
    NSError *error = [request error];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

    
    




-(void)registerresult:(id)sender
{
    act.hidden=YES;
    [act stopAnimating];
    self.navigationController.view.userInteractionEnabled=YES;
    if([sender isKindOfClass:[NSError class]])
    {
        
        NSLog(@"Error occur=>%@",[sender localizedDescription]);
        //CustomMessage *cav=[[CustomMessage alloc] init];
        //[cav show:[sender localizedDescription] inView:self.view delay:2 lYAxis:100];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[sender localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        //[self checkLoadingView];
        
    }
    else
    {
        // [self checkLoadingView];
        NSLog(@"sender%@",sender);
        if (![sender isEqualToString:@""]) {
            
            NSString *jsonString=[NSString stringWithString:sender];
            SBJSON *jsonParser=[[SBJSON alloc] init];
            id output1=[jsonParser objectWithString:jsonString error:nil];
            if([[NSString stringWithFormat:@"%@",[output1 objectForKey:@"result"]] isEqualToString:@"1"] )
            {
                [[NSUserDefaults standardUserDefaults]setObject:[output1 objectForKey:@"data"] forKey:@"userdata"];
                [[NSUserDefaults standardUserDefaults]synchronize];
               // HomeScreen *h=[[HomeScreen alloc]init];
               // [self.navigationController pushViewController:h animated:YES];
                
            }
            else
            {
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[output1 objectForKey:@"message"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    
}



//-(BOOL) isPasswordValid:(NSString *)pwd {
//    if ( [pwd length]<6 || [pwd length]>32 ) return NO;  // too long or too short
//    NSRange rang;
//    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
//    if ( !rang.length ) return NO;  // no letter
//    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
//    if ( !rang.length )  return NO;  // no number;
//    return YES;
//}

- (BOOL)myMobileNumberValidate:(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}




-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



-(IBAction)back:(id)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

    
    //[self.navigationController popViewControllerAnimated:YES];
    
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
