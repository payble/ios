//
//  login.h
//  kentApp
//
//  Created by pericent on 12/18/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Validate.h"
#import "QAUtils.h"
#import "QARestIntraction.h"
#import "DSActivityView.h"
#import <FacebookSDK/FacebookSDK.h>


@interface login : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *emailtext;
    IBOutlet UITextField *passwordtext;
     BOOL isFacebook;
    
    IBOutlet UIButton *fbButton;
    IBOutlet UILabel *fbCnctLbl;
    IBOutlet UILabel *emailLbl;
    IBOutlet UILabel *passwordLbl;
    IBOutlet UILabel *orLbl;
    IBOutlet UIButton *forgetPassButton;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *lblTitle;
    
     NSMutableArray *arrFBData;
     NSString *strUserId;
 
    IBOutlet UIView *ViewLogin;

    
}

-(IBAction)btnLogin_didPressed:(id)sender;
-(IBAction)btnSignUp_didPressed:(id)sender;
-(IBAction)btnForgotPassword_didPressed:(id)sender;
-(IBAction)btnFaceBookLoging_didPressed:(id)sender;
@end
