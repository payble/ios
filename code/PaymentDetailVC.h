//
//  PaymentDetailVC.h
//  kentApp
//
//  Created by N@kuL on 08/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

#import "WebServiceConnection.h"
#import "URL.h"
#import "DSActivityView.h"

#import "RNBlurModalView.h"

@interface PaymentDetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    WebServiceConnection *connection;
    
    IBOutlet UITextField *txtFCard;
    IBOutlet UITextField *txtFUserNAme;
    IBOutlet UITextField *txtFCc_no;
    IBOutlet UITextField *txtFExpiry;
    IBOutlet UITextField *txtFCVV;
    
    
    IBOutlet UITextField *txtFCardShowDetail;
    IBOutlet UITextField *txtFUserNAmeShowDetail;
    IBOutlet UITextField *txtFCc_noShowDetail;
    IBOutlet UITextField *txtFExpiryShowDetail;
    IBOutlet UITextField *txtFCVVShowDetail;
    
    IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnDone;
    IBOutlet UIButton *btnOnCardType;
    IBOutlet UIButton *btnOnExpiry;
    
    IBOutlet UILabel *lblDetails;
    
    IBOutlet UILabel *lblCrdType;
    IBOutlet UILabel *lblCrdName;
    IBOutlet UILabel *lblCrdCc_no;
    IBOutlet UILabel *lblCrdExpiry;
    IBOutlet UILabel *lblCrdFccv;
    
    IBOutlet UILabel *lblCrdTypeShowDetail;
    IBOutlet UILabel *lblCrdNameShowDetail;
    IBOutlet UILabel *lblCrdCc_noShowDetail;
    IBOutlet UILabel *lblCrdExpiryShowDetail;
    IBOutlet UILabel *lblCrdFccvShowDetail;
    
    IBOutlet UIView *viewaymentDetail;
    IBOutlet UIView *viewCArd;
    
    IBOutlet UIButton *btnBack;
    IBOutlet UILabel *lblTitle;
    
    RNBlurModalView *modal;
    
    NSArray *arrCardNames;
    
    
    UIPickerView *myPickerView;
    NSMutableArray *arrYear;
    NSMutableArray *arrMonth;

    
    NSString *strMonth;
    NSString *strYear;
    NSString *strType;
    NSString *strBtnDone;

    
    

}
@property(nonatomic,weak)NSString *strIsFirstCard;

@property(nonatomic,weak)NSString *strCradType;
@property(nonatomic,weak)NSDictionary *diccardDetailData;

-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnDoneClicked:(id)sender;
-(IBAction)btnSaveClicked:(id)sender;


-(IBAction)btn_cardTypeDidClicked:(id)sender;
-(IBAction)btn_ExpirationDidClicked:(id)sender;


@end
