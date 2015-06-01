//
//  reviewCell.h
//  kentApp
//
//  Created by N@kuL on 06/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reviewCell : UITableViewCell

{
    
}



@property(nonatomic,weak)IBOutlet UITextView *txtVReviews;
@property(nonatomic,weak)IBOutlet UILabel *lblTimeAgo;
@property(nonatomic,weak)IBOutlet UIImageView *imgVProPick;



//@property(nonatomic,weak)IBOutlet UIButton *btnStar1;
//@property(nonatomic,weak)IBOutlet UIButton *btnStar2;
//@property(nonatomic,weak)IBOutlet UIButton *btnStar3;
//@property(nonatomic,weak)IBOutlet UIButton *btnStar4;
//@property(nonatomic,weak)IBOutlet UIButton *btnStar5;



@property(nonatomic,weak)IBOutlet UIImageView *imgStar1;
@property(nonatomic,weak)IBOutlet UIImageView *imgStar2;
@property(nonatomic,weak)IBOutlet UIImageView *imgStar3;
@property(nonatomic,weak)IBOutlet UIImageView *imgStar4;
@property(nonatomic,weak)IBOutlet UIImageView *imgStar5;

@end
