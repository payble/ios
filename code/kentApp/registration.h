//
//  registration.h
//  kentApp
//
//  Created by pericent on 12/18/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DSActivityView.h"
#import "LoadingView.h"

#import <FacebookSDK/FacebookSDK.h>

@interface registration : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *imgVArrow;
   
    IBOutlet UITextField *firstname;
    IBOutlet UITextField *email;
    IBOutlet UITextField *mobile;
    IBOutlet UITextField *password;
    
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *emailLbl;
    IBOutlet UILabel *mobileLbl;
    IBOutlet UILabel *passLbl;
    
    IBOutlet UILabel *detailLbl;
    IBOutlet UIButton *registerBtn;
    
    IBOutlet UIButton *fbButton;
    IBOutlet UILabel *fbCnctLbl;
    IBOutlet UILabel *orLbl;
    
    IBOutlet UIView *ViewRegistration;
    
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *backButton;

    
    IBOutlet UIActivityIndicatorView *act ;
    LoadingView *loadingview;
}



-(IBAction)btnArraowClicked:(id)sender;

@end
