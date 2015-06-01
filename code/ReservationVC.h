//
//  ReservationVC.h
//  kentApp
//
//  Created by N@kuL on 08/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReservationTableCell.h"

@interface ReservationVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    id outputUserReservation;
    IBOutlet UITableView *tbleResrvation;
    
    IBOutlet ReservationTableCell *cell;
    
    IBOutlet UILabel *lblRestro;
    IBOutlet UILabel *lblStart;
    IBOutlet UILabel *lblEnd;
    IBOutlet UILabel *lblPartySize;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnBack;
    
}

-(IBAction)btnBackDidClicked:(id)sender;
@end
