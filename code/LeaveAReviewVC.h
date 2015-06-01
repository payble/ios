//
//  LeaveAReviewVC.h
//  kentApp
//
//  Created by N@kuL on 10/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThanksForReviewVC.h"
#import "EDStarRating.h"
#import "HomeVC.h"

@interface LeaveAReviewVC : UIViewController<UITextViewDelegate,UITextViewDelegate,EDStarRatingProtocol>
{

    
    IBOutlet UILabel *lblName;
    IBOutlet UITextView *txtvReview;
     IBOutlet UIView *viewLeaveReview;

    IBOutlet UIButton *btnBack;
    IBOutlet UILabel  *lblTitle;
    IBOutlet UIButton *btnDone;
    
    IBOutlet UILabel  *lblCmpny;
    IBOutlet UITextView  *txtVDetail;
    IBOutlet UIButton *btnSubmit;
    IBOutlet UILabel  *lblInfo;
    
    NSString *strStarValue;
    
}

@property(nonatomic,weak) NSDictionary *dicRestaurentDetails3;
@property (weak, nonatomic) IBOutlet EDStarRating *starRatingImage;

-(IBAction)btnDoneDidClicked:(id)sender;
-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)btnSubmitReviewDidClicked:(id)sender;

@end
