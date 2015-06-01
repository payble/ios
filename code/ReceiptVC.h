//
//  ReceiptVC.h
//  kentApp
//
//  Created by N@kuL on 08/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptCustomeCell.h"


@interface ReceiptVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblPending;
    IBOutlet UITableView *tblProcessed;
    
    NSMutableArray *arrForPending;
    NSMutableArray *arrForProcessed;
    
    IBOutlet UILabel *lblPending;
    IBOutlet UILabel *lblProcessed;

    NSMutableArray *arrForCardList;
    
    ReceiptCustomeCell *cell;
    
    IBOutlet UILabel *lblFooter;
    IBOutlet UIScrollView *scrollView;
    NSString *strType;
    NSString *strCheck;
    
    IBOutlet UIButton *btnBack;
    IBOutlet UILabel *lblTitle;
}

-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnReciptDetailDidClicked:(id)sender;

@end
