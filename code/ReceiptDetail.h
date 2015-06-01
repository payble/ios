//
//  ReceiptDetail.h
//  kentApp
//
//  Created by N@kuL on 10/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LeaveAReviewVC.h"
#import "RNBlurModalView.h"

@interface ReceiptDetail : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UIButton *btnBack;
    IBOutlet UILabel *lblTitle;
    
    IBOutlet UITextView *textVAddress;
    IBOutlet UITextField *txtfTip;
    IBOutlet UILabel *lblTipPoint;
    IBOutlet UILabel *lblInfo;
    
    IBOutlet UITextView *textVAddressProcessed;
    IBOutlet UITextField *txtfTipProcessed;
    IBOutlet UILabel *lblTipProcessedPoint;
    
    IBOutlet UILabel *lblCompanyNmae;
    IBOutlet UILabel *lblPhone;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblPayment;
    IBOutlet UILabel *lblSubtotal;
    IBOutlet UILabel *lblSubtotalPoint;
    IBOutlet UILabel *lblTax;
    IBOutlet UILabel *lblTaxPoint;
    IBOutlet UILabel *lblTotal;
    IBOutlet UILabel *lblTotalPoint;
    IBOutlet UILabel *lblDeliveryLabel;
    IBOutlet UILabel *lblDeliveryValue;
    IBOutlet UILabel *lblkentFeePoint;
    
    IBOutlet UILabel *lblCompanyNmaeProcessed;
    IBOutlet UILabel *lblPhoneProcessed;
    IBOutlet UILabel *lblUserNameProcessed;
    IBOutlet UILabel *lblPaymentProcessed;
    IBOutlet UILabel *lblSubtotalProcessed;
    IBOutlet UILabel *lblTaxProcessed;
    IBOutlet UILabel *lblTotalProcessed;
    IBOutlet UILabel *lblDeliveryLabelProcessed;
    IBOutlet UILabel *lblDeliveryValueProcessed;
    
    
    IBOutlet UILabel *lblSubtotalProcessedPoint;
    IBOutlet UILabel *lblTaxProcessedPoint;
    IBOutlet UILabel *lblTotalProcessedPoint;
    IBOutlet UILabel *lblkentFeeProcessedPoint;
    
    IBOutlet UIButton *btnPAy;
    
    
    
   
    NSDictionary *dicForCard;
    
    IBOutlet UIView *receiptView;
    IBOutlet UIView *viewReceiptBackWithPay;
 
    
    NSString *strType;
    
    

    RNBlurModalView *modal;
    
    
    IBOutlet UILabel *lblUCmpny;
    IBOutlet UILabel *lblUPhone;
    IBOutlet UILabel *lblUAddress;
    IBOutlet UILabel *lblUName;
    IBOutlet UILabel *lblUPayments;
    IBOutlet UILabel *lblUSummary;
    IBOutlet UILabel *lblUSubtotal;
    IBOutlet UILabel *lblUTax;
    IBOutlet UILabel *lblUFee;
    IBOutlet UILabel *lblUTip;
    IBOutlet UILabel *lblUTotal;
    
    IBOutlet UILabel *lblDCmpny;
    IBOutlet UILabel *lblDPhone;
    IBOutlet UILabel *lblDAddress;
    IBOutlet UILabel *lblDName;
    IBOutlet UILabel *lblDPayments;
    IBOutlet UILabel *lblDSummary;
    IBOutlet UILabel *lblDSubtotal;
    IBOutlet UILabel *lblDTax;
//    IBOutlet UILabel *lblDFee;
    IBOutlet UILabel *lblDTip;
    IBOutlet UILabel *lblDTotal;

    
    IBOutlet UIView *viewReceiptBackWithPayProcessed;
    
    
}


@property(nonatomic,weak) NSDictionary *dicRestaurentDetail2;
@property(nonatomic,weak) NSMutableArray *arrForCArdList;


-(IBAction)btnPayDidClicked:(id)sender;
-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btn_SelectCardDidClicked:(id)sender;


@end
