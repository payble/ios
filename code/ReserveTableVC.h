//
//  ReserveTableVC.h
//  kentApp
//
//  Created by N@kuL on 26/12/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserveTableVCell.h"


@interface ReserveTableVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIButton *btnStar1;
    IBOutlet UIButton *btnStar2;
    IBOutlet UIButton *btnStar3;
    IBOutlet UIButton *btnStar4;
    IBOutlet UIButton *btnStar5;
    IBOutlet UIButton *btnReserveTable;
    
    
    
    IBOutlet UILabel *lblCity;
    IBOutlet UILabel *lblReviews;
    IBOutlet UILabel *lblPhoneNo;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblMinWait;
    
    IBOutlet UITableView *tlbV;
    
    IBOutlet ReserveTableVCell *cell;
}
-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnReservTableDidClicked:(id)sender;
@end
