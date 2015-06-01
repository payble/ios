//
//  CardCell.h
//  kentApp
//
//  Created by N@kuL on 20/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *btnStar1;

@property (weak, nonatomic)IBOutlet UITableView *tbleCard;
@property (weak, nonatomic)IBOutlet UILabel *lblCardNAme;
@property (weak, nonatomic)IBOutlet UILabel *lblCarsNumber;
@property (weak, nonatomic)IBOutlet UIImageView *imgVCardIamge;

@end
