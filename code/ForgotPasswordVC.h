//
//  ForgotPasswordVC.h
//  kentApp
//
//  Created by N@kuL on 31/12/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSActivityView.h"
#import "Validate.h"

@interface ForgotPasswordVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtFEmail;
    
    IBOutlet UIView     *viewForgotPwd;
    IBOutlet UILabel    *emailLbl;
    IBOutlet UIButton   *resetPassButton;
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *lblTitle;
    
}

-(IBAction)btnArrowDidClicked:(id)sender;
-(IBAction)btnCancelDidClicked:(id)sender;

@end
