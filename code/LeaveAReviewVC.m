//
//  LeaveAReviewVC.m
//  kentApp
//
//  Created by N@kuL on 10/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "LeaveAReviewVC.h"
#import "ASIHTTPRequest.h"
#import "QAUtils.h"
#import "DSActivityView.h"
#import "JSON.h"

@interface LeaveAReviewVC ()

@end

@implementation LeaveAReviewVC
@synthesize dicRestaurentDetails3;
@synthesize starRatingImage = _starRatingImage;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    viewLeaveReview.layer.cornerRadius=5.0f;
    viewLeaveReview.clipsToBounds=YES;
    
    strStarValue=@"0.0";
    
    
    
    _starRatingImage.backgroundColor=[UIColor whiteColor];
    _starRatingImage.starImage = [UIImage imageNamed:@"greystar.png"];
    _starRatingImage.starHighlightedImage = [UIImage imageNamed:@"star.png"];
    _starRatingImage.maxRating = 5.0;
    _starRatingImage.delegate = self;
    _starRatingImage.horizontalMargin = 12;
    _starRatingImage.editable=YES;
    _starRatingImage.rating= 0.0;
    _starRatingImage.displayMode=EDStarRatingDisplayFull;
    [self starsSelectionChanged:_starRatingImage rating:0.0];
    // This one will use the returnBlock instead of the delegate
    _starRatingImage.returnBlock = ^(float rating )
    {
        NSLog(@"ReturnBlock: Star rating changed to %.1f", rating);
        // For the sample, Just reuse the other control's delegate method and call it
        [self starsSelectionChanged:_starRatingImage rating:rating];
    };
    
    if (IDIOM == IPAD) {
        
        _starRatingImage.frame      =   CGRectMake(screenWidth*0.30, _starRatingImage.frame.origin.y, screenWidth*0.40, _starRatingImage.frame.size.height);
        
        btnBack.titleLabel.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTitle.font               =   [UIFont fontWithName:FONT_TITLE size:22];
        btnDone.titleLabel.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        txtvReview.font             =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtVDetail.font             =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        btnSubmit.titleLabel.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblName.font                =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblCmpny.font               =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblInfo.font                =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
    }else{
        btnBack.titleLabel.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblTitle.font               =   [UIFont fontWithName:FONT_TITLE size:14];
        btnDone.titleLabel.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        txtvReview.font             =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtVDetail.font             =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        btnSubmit.titleLabel.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblName.font                =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblCmpny.font               =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblInfo.font                =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
    }
    
    [self setDetails];
}


-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    
    
    strStarValue = [NSString stringWithFormat:@"%.1f", rating];
//    NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
//    if( [control isEqual:_starRating] )
//        _starRatingLabel.text = ratingString;
//    else
//        _starRatingImageLabel.text = ratingString;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtvReview resignFirstResponder];
}




- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (txtvReview.textColor == [UIColor lightGrayColor])
    {
        txtvReview.text = @"";
        txtvReview.textColor = [UIColor blackColor];
    }
    if ([txtvReview.text isEqualToString:@"Review (Optional)"])
    {
        txtvReview.text = @"";
        txtvReview.textColor = [UIColor blackColor];
    }
    
    txtvReview.layer.borderColor=[UIColor grayColor].CGColor;
    
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(txtvReview.text.length == 0){
        txtvReview.textColor = [UIColor lightGrayColor];
        txtvReview.text = @"Review (Optional)";
        [txtvReview resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
        [txtvReview resignFirstResponder];
        if(txtvReview.text.length == 0)
        {
            txtvReview.textColor = [UIColor lightGrayColor];
            txtvReview.text = @"Review (Optional)";
            [txtvReview resignFirstResponder];
        }
        return NO;
    }
    else
    {
        
        
        //textView.font = [UIFont fontWithName:FONT_NAME_MAIN size:15];
      
        CGRect frame = textView.frame;
        frame.size.height = textView.contentSize.height;
       // textView.frame=frame;
        
        
        if (textView.contentSize.height>200)
        {
            
        }
    }
    
    return YES;
}









-(void)setDetails
{
    lblName.text=[dicRestaurentDetails3 objectForKey:@"restaurant_name"];
}

-(void)userReview
{
    if (![strStarValue isEqualToString:@"0.0"]){
        if([QAUtils IsNetConnected])
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [defaults objectForKey:@"userdataKey"];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSLog(@"%@",arr);
            
            
            
            //URL: http://netleondev.com/kentapi/user/review
            //Method: PUT
            //Request: {"user_id":"3","restaurant_id":"2", "rating":"5","comment":"Awesome food"}
            //Response: reviewed
            
            NSString *strReviewText=txtvReview.text;
            
            if ([strReviewText isEqualToString:@"Review (Optional)"])
            {
                strReviewText=@"";
            }
            
            
            NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"],@"user_id",
                                 strReviewText,@"comment",
                                 strStarValue,@"rating",
                                 [dicRestaurentDetails3 objectForKey:@"restaurant_id"],@"restaurant_id", nil];
            
            [DSBezelActivityView  newActivityViewForView:self.view];
            //[self CallLoginMethodForWebservice:info];
            
            
            
            
            if([QAUtils IsNetConnected])
            {
                NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/review"];
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                
                [request addRequestHeader:@"Content-type" value:@"application/json"];
                [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
                
                [request setRequestMethod:@"PUT"];
                request.delegate=self;
                request.allowCompressedResponse = NO;
                request.useCookiePersistence = NO;
                request.shouldCompressRequestBody = NO;
                request.timeOutSeconds=30;
                NSString *jsonRequest = [info JSONRepresentation];
                
                NSLog(@"jsonRequest is %@", jsonRequest);
                
                //NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
                
                
                
                NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                
                [request setPostBody:[requestData mutableCopy]];
                
                [request startAsynchronous];
            
            
            
            }
            else
            {
                [DSBezelActivityView removeViewAnimated:YES];
                return;
            }
        
        
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please select atleast one star" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark- ASIHTTPRequest response methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSString *responseString = [request responseString];
    
    NSInteger responseInt=[responseString integerValue];
    
    if (responseInt==0)
    {
        // NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"some problem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        
        for (UIViewController *viw in [self.navigationController viewControllers])
        {
            if ([viw isKindOfClass:[HomeVC class]])
            {
                
                [[NSUserDefaults standardUserDefaults ] setObject:@"yes" forKey:@"directHomeKey"];
                [self.navigationController popToViewController:viw animated:YES];
                break;
            }
        }

//        ThanksForReviewVC *thanksOb=[[ThanksForReviewVC alloc]initWithNibName:@"ThanksForReviewVC" bundle:nil];
//        [self.navigationController pushViewController:thanksOb  animated:YES];
        
       
    } // A8064F8C
   
    
    

}



- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSError *error = [request error];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}



#pragma mark- IB_Action


-(IBAction)btnSubmitReviewDidClicked:(id)sender
{
    
    [self userReview];
    
}


-(IBAction)btnCancelDidClicked:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    
    
    for (UIViewController *viw in [self.navigationController viewControllers])
    {
        if ([viw isKindOfClass:[HomeVC class]])
        {
            [self.navigationController popToViewController:viw animated:YES];
            break;
        }
    }

}

-(IBAction)btnDoneDidClicked:(id)sender
{
    
    for (UIViewController *viw in [self.navigationController viewControllers])
    {
        if ([viw isKindOfClass:[HomeVC class]])
        {
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"yes" forKey:@"directHomeKey"];
            [self.navigationController popToViewController:viw animated:YES];
            break;
        }
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
