//
//  PaymentVC.h
//  kentApp
//
//  Created by N@kuL on 08/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardCell.h"

@interface PaymentVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    IBOutlet UIButton *btnPayment;
    IBOutlet UIButton *btnBack;
    IBOutlet UILabel *lblTitle;
    
    id outputCard;
    
    IBOutlet UITableView *tbleCard;
//    IBOutlet UIButton *btnStar;
//    IBOutlet UILabel *lblCardNAme;
//    IBOutlet UILabel *lblCarsNumber;
//    IBOutlet UIImageView *imgVCardIamge;
    
    IBOutlet CardCell *cell;
    IBOutlet UILabel *lblMessage;
    
    
    IBOutlet UIView *viewForCArd;
    
    NSString *strType;
    NSString *strCradFound;
    
}



-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnAddPaymentDidClicked:(id)sender;

-(IBAction)btn_StarDidClicked:(UIButton*)sender;

@end
