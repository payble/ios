//
//  ReceiptCustomeCell.h
//  kentApp
//
//  Created by N@kuL on 13/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptCustomeCell : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lblDate;
@property(nonatomic,weak)IBOutlet UILabel *lblRestaurentName;
@property(nonatomic,weak)IBOutlet UILabel *lblPrice;
@property(nonatomic,weak)IBOutlet UILabel *lblDecimalPoint;



@end
