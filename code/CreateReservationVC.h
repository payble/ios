//
//  CreateReservationVC.h
//  kentApp
//
//  Created by N@kuL on 19/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateReservationVC : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    
    UIDatePicker *datePicker;
    
    IBOutlet UILabel *lblFStartDate;
    IBOutlet UILabel *lblFStartTime;
    IBOutlet UILabel *lblFEndtDate;
    IBOutlet UILabel *lblFEndTime;
    IBOutlet UILabel *lblFPartySize;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnBack;

    IBOutlet UITextField *txtFPrtySize;
    
    IBOutlet UIView *OptionView;
    IBOutlet UIView *backdateView;
    
    IBOutlet UIDatePicker *datepicker1;
    
    IBOutlet UIButton *createReservationBtn;
    
    
    NSString *strType;
}

@property(nonatomic,weak) NSDictionary *dicRest5;


-(IBAction)back:(id)sender;
-(IBAction)btn_calendarTimeClicked:(UIButton*)sender;
-(IBAction)btn_CreateReservationClicked:(UIButton*)sender;

@end
