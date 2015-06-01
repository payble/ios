//
//  login.m
//  kentApp
//
//  Created by pericent on 12/18/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import "login.h"
#import "HomeVC.h"
#import "ForgotPasswordVC.h"
#import "JSON.h"

@interface login ()

@end

@implementation login

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
//        LetterGothicStd-Bold
    }
    
    
    if ( IDIOM == IPAD ) {
        //LetterGothicStd-Bold 20.0
        /* do something specifically for iPad. */
        fbButton.frame  =   CGRectMake(18, 101, 285, 90);
        fbCnctLbl.frame =   CGRectMake(86, 125, 177, 21);
        emailLbl.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        passwordLbl.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        orLbl.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        forgetPassButton.titleLabel.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:25];
        loginButton.titleLabel.font         =   [UIFont fontWithName:FONT_NAME_MAIN size:25];
        fbCnctLbl.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:25];
        emailtext.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        passwordtext.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        backButton.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTitle.font  =   [UIFont fontWithName:FONT_TITLE size:22];
    }else{
        emailLbl.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        passwordLbl.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        orLbl.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        forgetPassButton.titleLabel.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        loginButton.titleLabel.font         =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        fbCnctLbl.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        emailtext.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        passwordtext.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        backButton.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblTitle.font  =   [UIFont fontWithName:FONT_TITLE size:14];
    }
    
    ViewLogin.layer.cornerRadius=3.0f;
    ViewLogin.clipsToBounds=YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [emailtext resignFirstResponder];
    [passwordtext resignFirstResponder];
   
}


#pragma mark- IB_Action

-(IBAction)btnLogin_didPressed:(id)sender
{
    //emailtext.text=@"nakul3@gmail.com";
    //passwordtext.text=@"123456";
    
    emailtext.text=[emailtext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    passwordtext.text=[passwordtext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self.view endEditing:YES];
    if (!(emailtext.text.length==0))
    {
        if (![Validate isValidEmailId:emailtext.text])
        {
            [QAUtils showAlert:@"Please enter valid email."];
        }
        else
        {
            if ((passwordtext.text.length>=5))
            {
                NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:emailtext.text,@"email",passwordtext.text,@"password", nil];
                [DSBezelActivityView  newActivityViewForView:self.view];
                //[self CallLoginMethodForWebservice:info];
                
                
                 if([QAUtils IsNetConnected])
                 {
                     NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/autenticate"];
                     ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                     
                     [request addRequestHeader:@"Content-type" value:@"application/json"];
                     [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
                     
                     [request setRequestMethod:@"POST"];
                     request.delegate=self;
                     request.allowCompressedResponse = NO;
                     request.useCookiePersistence = NO;
                     request.shouldCompressRequestBody = NO;
                     request.timeOutSeconds=60;
                     NSString *jsonRequest = [info JSONRepresentation];
                     
                     NSLog(@"jsonRequest is %@", jsonRequest);
                     
                     //NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
                     
                     
                     
                     NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                     
                     [request setPostBody:[requestData mutableCopy]];
                     
                     [request startAsynchronous];
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
            else if ((passwordtext.text.length==0))
            {
                [passwordtext becomeFirstResponder];
                
                [QAUtils showAlert:@"Please enter password."];
                
                return;
            }
            else
            {
                
                [passwordtext becomeFirstResponder];
                
                [QAUtils showAlert:@"Please enter min 5 characters in password."];
                
                return;
                
                
            }
        }

      
    }
    else
    {
        [emailtext becomeFirstResponder];
        
        [QAUtils showAlert:@"Please enter email."];
        return;
    }
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    
    NSString *responseString = [request responseString];
    
    NSLog(@"LoginResponse=>%@",[responseString JSONValue]);
    
    NSLog(@"responseString==>%@",responseString);
    
     NSData *responseData = [request responseData];
    
    if(![[responseString JSONValue] isKindOfClass:[SBJSON class]])
    {
        NSLog(@"Nakul%@",[request JSONRepresentation]);
    }
    
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
     
        
        
        if([responseString isEqualToString:@"{\"error\":\"Email address & Password not matched.\"}"])
        {
            
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[dic objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
       else if([responseString isEqualToString:@"{\"error\":\"Email address & Facebook id not matched.\"}"])
        {
            
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[dic objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else if (responseString.length==0)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Error to get response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
            
            NSLog(@"Dict :: %@",dic);
            
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:data forKey:@"userdataKey"];
            
            HomeVC *Home=[[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
            [self.navigationController pushViewController:Home animated:YES];
            
        }
        

    }
//
    
    
//    if(![[responseString JSONValue] isKindOfClass:[NSDictionary class]]){
//        
//        NSDictionary *dict = [responseString JSONFragmentValue];
//        
//        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Server error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//        
//    }
    
   
    
    
   /*
    NSArray *arrKey=[dic allKeys];
    
    int flag=0;
    
    for (NSString *str in arrKey)
    {
        if ([str isEqualToString:@"error"])
        {
            flag=1;
            break;
        }
    }
    
    if (flag==0)
    {
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"userdata"];
        
        HomeVC *Home=[[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
        [self.navigationController pushViewController:Home animated:YES];
    }
    else
    {
        
       
    }
    */
   
   
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSError *error = [request error];
    
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}



-(IBAction)btnFaceBookLoging_didPressed:(id)sender
{
    
    //[self loginWithFacebook];
    if([QAUtils IsNetConnected])
    {
        if (!FBSession.activeSession.isOpen)
        {
    //switchfacebook.userInteractionEnabled=NO;
    // if the session is closed, then we open it here, and establish a handler for state changes
    //NSArray *permissions = [NSArray arrayWithObjects:@"email",@"user_birthday", nil];
    
    
    
        NSArray * permissions = @[@"public_profile", @"email", @"user_friends"];
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
         [self makeRequestForUserData];
        
        [DSBezelActivityView removeViewAnimated:YES];
        return;
    }
    
   

}
else
{
    [DSBezelActivityView newActivityViewForView:self.view];
    
    [self makeRequestForUserData];
    
    /* handle the result */
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
            
            // [self performSegueWithIdentifier:@"HomePageSegue" sender:nil];
            
            
            
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

            
            
//            if (i==0)
//            {
//              //  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Unable to fatch Phone number.First do manual registration ." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//              //  [alert show];   @"1234567890"
//                
//                
//                
//            }
//            else
//            {
            
            [DSBezelActivityView  newActivityViewForView:self.view];
            
            NSDictionary *info;
            
            if (j==0)
            {
                 NSString *strEmail=[NSString stringWithFormat:@"%@%@@facebook.com",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]];
                
                 info=[NSDictionary dictionaryWithObjectsAndKeys:strEmail,@"email",[result objectForKey:@"id"],@"facebook_id", nil];
            }
            else
            {
                 info=[NSDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"email"],@"email",[result objectForKey:@"id"],@"facebook_id", nil];
            }
            
            
                [DSBezelActivityView  newActivityViewForView:self.view];
                //[self CallLoginMethodForWebservice:info];
                
                
                NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/facebooklogin"];
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                
                [request addRequestHeader:@"Content-type" value:@"application/json"];
                [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
                
                [request setRequestMethod:@"POST"];
                request.delegate=self;
                request.allowCompressedResponse = NO;
                request.useCookiePersistence = NO;
                request.shouldCompressRequestBody = NO;
                
                NSString *jsonRequest = [info JSONRepresentation];
                
                NSLog(@"jsonRequest is %@", jsonRequest);
                
                //NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
                
                
                
                NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                
                [request setPostBody:[requestData mutableCopy]];
                
                [request startAsynchronous];
          //  }
            
            
           
          /*  NSError *error = [request error];
            
            if (!error)
            {
                NSString *response = [request responseString];
            }

            */
            
            
         //   HomeVC *obHome = [[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
          //  [self.navigationController pushViewController:obHome animated:YES];
            
            //            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            //            [appDelegate.userdefault setValue:[result valueForKey:@"email"] forKey:@"email"];
            //            [appDelegate.userdefault setValue:[result valueForKey:@"name"] forKey:@"name"];
            //            [appDelegate.userdefault setValue:[result valueForKey:@"username"] forKey:@"username"];
            //            [appDelegate.userdefault setValue:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[result valueForKey:@"id"]] forKey:@"photo"];
            
            //   [self.view setUserInteractionEnabled:NO];
            //  loadingview=[LoadingView loadingViewInView:self.view withBGColor:[UIColor clearColor] withMessage:@"Please wait..."];
            // ap =[[apiconnect alloc]init];
            //  [ap getuserbyemail:[appDelegate.userdefault valueForKey:@"email"]  onTarget:self action:@selector(loginvierifire:)];
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

-(IBAction)btnForgotPassword_didPressed:(id)sender
{
    ForgotPasswordVC *forgotPwd=[[ForgotPasswordVC alloc]initWithNibName:@"ForgotPasswordVC" bundle:nil];
    [self.navigationController pushViewController:forgotPwd animated:YES];
}


-(IBAction)back:(id)sender
{
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
  /*  int flag=0;
    
    for ( UIViewController *viewC in [self.navigationController viewControllers])
    {
        if ([viewC isKindOfClass:[ViewController class]])
        {
            flag=1;
        }
    }
    
    if (flag==0)
    {
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   */
    
}


#pragma mark - Login with facebook

-(void)loginWithFacebook
{
    
    NSArray * permissions = @[@"public_profile", @"email", @"user_friends"];
    if(FBSession.activeSession.isOpen)
    {
        NSLog(@"session open");
        
        [DSBezelActivityView newActivityViewForView:self.view];
        [self performSelector:@selector(getFacebookProfileInfo) withObject:nil afterDelay:0.1];
    }
    else
    {
        NSLog(@"session not open :");
        [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session,FBSessionState status,NSError *error)
         {
             if(error)
             {
                 NSLog(@"session error %@",error);
                 //[self getUserData];
                 
             }
             else// if(FB_ISSESSIONOPENWITHSTATE(status))
             {
                 NSLog(@"session open");
                 
                 [DSBezelActivityView newActivityViewForView:self.view];
                 // strAccessToken=session.accessToken;
                 [self performSelector:@selector(getUserData) withObject:nil afterDelay:0.1];
                 //[self  getUserData];
             }
             
         }];
    }
    
}

-(void)getUserData
{
    
    if(FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error)
             {
                 NSLog(@"FBGraphUser description :%@",[user description]);
                 NSLog(@"UserName :%@",user.name);
                 //NSLog(@"User profileID :%@",user.objectID);
                 NSLog(@"usr_first_name::%@",user.first_name);
                 NSLog(@"usr_last_nmae::%@",user.last_name);
                 NSLog(@"usr_Username::%@",user.username);
                 NSLog(@"usr_b_day::%@",user.birthday);
                 NSLog(@"usr_location::%@",user.location.name);
                 NSLog(@"usr link::%@",user.link);
                 NSLog(@"usr description::%@",user.description);
                 NSLog(@"usr  email::%@",[user objectForKey:@"email"]);
                 
                 NSString *strEm=[NSString stringWithFormat:@"%@",[user objectForKey:@"email"]];
                 
                // {"first_name":"raviKumar","phone_number":"9351264743","email":"ravi1@netleon.com","password":"admin"}
                 
               //  NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:strEm,@"email",@"123456",@"password",@"F",@"loginfrom", nil];
                  NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:user.first_name,@"first_name",
                                      @"123456",@"password",
                                      @"facebook login",@"phone_number",
                                      strEm,@"email", nil];
                 
                 UCSaveDeletePassword();
                 isFacebook=YES;
                 
                 [self CallLoginMethodForWebservice:info];
                 
             }
             else
             {
                 NSLog(@"error facebook :%@",[error localizedDescription]);
                 [[[UIAlertView alloc] initWithTitle:@"" message:@"Network Problem Please try again" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil] show];
             }
         }];
    }
    else
        NSLog(@"session not open");
}

- (void)getFacebookProfileInfo
{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType * facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    // At first, we only ask for the basic read permission
    NSArray * permissions = @[@"public_profile", @"email", @"user_friends"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"599566860165497", ACFacebookAppIdKey, permissions, ACFacebookPermissionsKey, nil];
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType options:dict completion:^(BOOL granted, NSError *error) {
        if (granted && error == nil)
        {
            NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
            NSLog(@"accounts description :%@",accounts);
            ACAccount *FBAccount = [accounts objectAtIndex:0];
            NSLog(@"facebookAccount description : %@",[FBAccount valueForKey:@"username"]);
            NSLog(@"facebookAccount description : %@",[FBAccount valueForKey:@"properties"]);
            NSDictionary *infoTemp=[FBAccount valueForKey:@"properties"];
            NSString *strEm=[NSString stringWithFormat:@"%@",[infoTemp objectForKey:@"ACUIDisplayUsername"]];
            
            
           // NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:strEm,@"email",@"123456",@"password",@"F",@"loginfrom", nil];
            NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:@"fb",@"first_name",
                                @"123456",@"password",
                                @"facebook login",@"phone_number",
                                strEm,@"email", nil];
            
            UCSaveDeletePassword();
            isFacebook=YES;
            [self CallLoginMethodForWebservice:info];
            
        }
        else
        {
            NSLog(@"error facebook is: %@",[error description]);
            
            
            NSString *message = @"The application cannot login at this moment. This is because it cannot reach Facebook or you don't have a Facebook account associated with this device.";
            
            [QAUtils showAlert:message] ;
        }
        
        [DSBezelActivityView removeViewAnimated:YES];
    }];
}

#pragma mark - Web service methods
-(void)CallLoginMethodForWebservice:(NSDictionary *)info{
    
    [QARestIntraction GetDataForMethod:info strMethod:@"user/autenticate" authentication:NO withCompletion:^(id data)
     {
         
         if (![[data objectForKey:@"error"] boolValue])
         {
             if (!isFacebook)
             {
                 UCSaveSinglePassword([info valueForKey:@"password"]);
                 UCSaveSingleUserName([info valueForKey:@"email"]);
             }
             else
             {
                 UCSaveSingleUserName([info valueForKey:@"email"]);
                 UCSaveSinglePassword(@"123456");
                 [self callWebServiceForFacebookFriendsSave];
             }
             NSMutableDictionary *info=[NSMutableDictionary new];
             info=[data valueForKey:@"data"];
             [[NSUserDefaults standardUserDefaults]setObject:info forKey:@"userRecords"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             [DSBezelActivityView removeViewAnimated:YES];
             [self performSegueWithIdentifier:@"QADashboardVC" sender:nil];
             
         }
         else
         {
             [DSBezelActivityView removeViewAnimated:YES];
             [QAUtils showAlert:[data objectForKey:@"message"]];
             return ;
         }
     }
                           WithFailure:^(NSString *err)
     {
         [QAUtils showAlert:@"Server Error"];
     }];
    
}

-(void)callWebServiceForFacebookFriendsSave
{
    //NSArray *permissions = [[NSArray alloc] initWithObjects:                            @"user_about_me,user_birthday,user_hometown,user_location,email",nil];
    
    FBRequest* friendsRequest = [FBRequest requestWithGraphPath:@"me/friends" parameters:nil HTTPMethod:@"GET"];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,NSDictionary* result,NSError *error) {
        
        NSArray* friends = [result objectForKey:@"data"];
        NSLog(@"Found: %lu friends", (unsigned long)friends.count);
        for (NSDictionary<FBGraphUser>* friend in friends) {
            
            NSString *strname=[friend.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSDictionary *infoDics=[NSDictionary dictionaryWithObjectsAndKeys:friend.objectID,@"email",strname,@"name",[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?", friend.objectID],@"imageurl",nil];
            
            [arrFBData addObject:infoDics];
            
            NSLog(@"friend name %@ ",friend.name);
            NSLog(@"friend ID:%@",friend.objectID);
            NSLog(@"friend pic url = %@", [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?", friend.objectID]);
        }
        
        [self saveFriendsListToServer];
        
    }];
    
}
-(void)saveFriendsListToServer{
    if (arrFBData.count!=0) {
        NSDictionary *infoTemp=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",arrFBData,@"userfriends",nil];
        NSError * err;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:infoTemp options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *strMethod=[NSString stringWithFormat:@"userfbfriends?data=%@",myString];
        
        [QARestIntraction GetDataForMethod:nil strMethod:strMethod authentication:NO withCompletion:^(id respone){
            
            NSLog(@"response from facebook friends save%@",respone);
        }
         
                               WithFailure:^(NSString *error)
         {
             
             NSLog(@"error from save facebook friends:%@",[error description]);
         }];
    }
    [DSBezelActivityView removeViewAnimated:YES];
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
