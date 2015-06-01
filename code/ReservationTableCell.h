//
//  ReservationTableCell.h
//  kentApp
//
//  Created by N@kuL on 23/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationTableCell : UITableViewCell
{
    
}

@property(weak,nonatomic)IBOutlet UILabel *lblRestauName;
@property(weak,nonatomic)IBOutlet UILabel *lblStardDate;
@property(weak,nonatomic)IBOutlet UILabel *lblStardTime;
@property(weak,nonatomic)IBOutlet UILabel *lblEndDate;
@property(weak,nonatomic)IBOutlet UILabel *lblEndTime;
@property(weak,nonatomic)IBOutlet UILabel *lblPartSize;







@end
