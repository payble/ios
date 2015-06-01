//
//  CreateReservationVC.m
//  kentApp
//
//  Created by N@kuL on 19/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "CreateReservationVC.h"
#import "ASIHTTPRequest.h"
#import "DSActivityView.h"
#import "JSON.h"
#import "Indicator.h"
@interface CreateReservationVC ()
{
    Indicator * indicator;
}

@end

@implementation CreateReservationVC
@synthesize dicRest5;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // indicator = [[Indicator alloc] initWithFrame:self.view.bounds];
   // [self.view addSubview:indicator];
   // indicator.hidden = YES;
    
    backdateView.layer.cornerRadius=5.0f;
    backdateView.clipsToBounds=YES;
    
    
    OptionView.layer.cornerRadius=3.0f;
    OptionView.clipsToBounds=YES;
    
    if (IDIOM == IPAD) {
        lblFStartDate.frame =   CGRectMake(lblFStartDate.frame.origin.x+9, lblFStartDate.frame.origin.y, lblFStartDate.frame.size.width, lblFStartDate.frame.size.height);
        lblFStartTime.frame =   CGRectMake(lblFStartTime.frame.origin.x+1, lblFStartTime.frame.origin.y, lblFStartTime.frame.size.width, lblFStartTime.frame.size.height);
        txtFPrtySize.frame =   CGRectMake(txtFPrtySize.frame.origin.x-20, txtFPrtySize.frame.origin.y, txtFPrtySize.frame.size.width+20, txtFPrtySize.frame.size.height);
        lblFStartDate.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFStartTime.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFEndtDate.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFEndTime.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFPartySize.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFPrtySize.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        createReservationBtn.titleLabel.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTitle.font =   [UIFont fontWithName:FONT_TITLE size:22];
    }else{
        lblFStartDate.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFStartTime.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFEndtDate.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFEndTime.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFPartySize.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFPrtySize.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        createReservationBtn.titleLabel.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblTitle.font =   [UIFont fontWithName:FONT_TITLE size:14];
    }
    
    txtFPrtySize.keyboardType   =   UIKeyboardTypeNumberPad;
    txtFPrtySize.delegate       =   self;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtFPrtySize resignFirstResponder];
}

#pragma mark- ASIHTTP Request delegate method
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [DSBezelActivityView removeViewAnimated:YES];

    
    NSString *responseString = [request responseString];
    
    NSData *responseData = [request responseData];
    // NSNumber *useris=[responseString intValue];
    
    
    NSError *e=nil;
    
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&e];
    
    if (!jsonArray)
    {
        
        
        if (responseString.length>0 && responseString.length<7 )
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Successfully reserved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AfterReservation" object:self];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"errorNkl==%@",e);
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"server error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
       if([responseString isEqualToString:@"{\"error\":\"Bad Request!\"}"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Bad Request!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([responseString isEqualToString:@"{\"error\":\"You already have Reservation!\"}"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"You already have Reservation!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([responseString isEqualToString:@"{\"error\":\"Please enter proper data format!\"}"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter proper data format!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([responseString intValue]/[responseString intValue]==1)
        {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
            
           
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Some error occured!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];

        }
        
    }
    
    
    
    
    // Use when fetching binary data
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSError *error = [request error];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


- (void)alertViewCancel:(UIAlertView *)alertView
{
   
}




#pragma mark-IB_Action


-(IBAction)btn_calendarTimeClicked:(UIButton*)sender
{
    if(sender.tag==10)//startDate
    {
         datepicker1.minimumDate=[NSDate date];
        datepicker1.datePickerMode=UIDatePickerModeDate;
        
        strType=@"startDate";
    }
    else if(sender.tag==20)//startTime
    {
        datepicker1.datePickerMode=UIDatePickerModeTime;

        
        strType=@"startTime";
    }
    else if(sender.tag==30) //endDate
    {
         datepicker1.minimumDate=[NSDate date];
        datepicker1.datePickerMode=UIDatePickerModeDate;

        
        strType=@"endDate";
    }
    else if(sender.tag==40)//endTime
    {
        datepicker1.datePickerMode=UIDatePickerModeTime;
        strType=@"endTime";
    }
   
    [self openPicker];
}



-(void)openPicker
{
    
    OptionView.hidden=NO;
    
    [UIView animateWithDuration:0.3 animations:^{ CGRect rect=OptionView.frame;
        rect.origin.y=self.navigationController.view.frame.size.height-OptionView.frame.size.height;
        
        OptionView.frame=rect;} completion:nil];
    
}

-(IBAction)saveMethod:(UIButton *)sender
{
    //[self hideview];
    
    if ([strType isEqualToString:@"startDate"])
    {
       
        
        OptionView.hidden=YES;
        [UIView animateWithDuration:0.3 animations:^{ CGRect rect=OptionView.frame;
            rect.origin.y=self.navigationController.view.frame.size.height;
            OptionView.frame=rect;} completion:nil];
        
        
        NSDate *selectedDate = [datepicker1 date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // [formatter setDateFormat:@"yyyy-MM-dd"];
         [formatter setDateFormat:@"MM/dd/yyyy"];
        NSString *stringFromDate = [formatter stringFromDate:selectedDate];

        lblFStartDate.text=stringFromDate;
    }
    else if([strType isEqualToString:@"endDate"])
    {
        
       // datepicker1.minimumDate=[NSDate date];
        
        OptionView.hidden=YES;
        [UIView animateWithDuration:0.3 animations:^{ CGRect rect=OptionView.frame;
            rect.origin.y=self.navigationController.view.frame.size.height;
            OptionView.frame=rect;} completion:nil];
        
        
        NSDate *selectedDate = [datepicker1 date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       // [formatter setDateFormat:@"yyyy-MM-dd"];
         [formatter setDateFormat:@"MM/dd/yyyy"];
        NSString *stringFromDate = [formatter stringFromDate:selectedDate];

        lblFEndtDate.text=stringFromDate;
    }
    else if([strType isEqualToString:@"startTime"])
    {
        
      // 2014-12-11 01:18:59","end_datetime": "2014-12-11 04:18:59"}
        
        OptionView.hidden=YES;
        [UIView animateWithDuration:0.3 animations:^{ CGRect rect=OptionView.frame;
            rect.origin.y=self.navigationController.view.frame.size.height;
            OptionView.frame=rect;} completion:nil];
        
        //datepicker1.datePickerMode = UIDatePickerModeTime;

        NSDate *selectedDate = [datepicker1 date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        NSString *stringFromDate = [formatter stringFromDate:selectedDate];
        
        lblFStartTime.text=stringFromDate;
    }
    else if([strType isEqualToString:@"endTime"])
    {
        
        //datepicker1.m=[NSDate date];
        
        OptionView.hidden=YES;
        [UIView animateWithDuration:0.3 animations:^{ CGRect rect=OptionView.frame;
            rect.origin.y=self.navigationController.view.frame.size.height;
            OptionView.frame=rect;} completion:nil];
        
        
        
        NSDate *selectedDate = [datepicker1 date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        NSString *stringFromDate = [formatter stringFromDate:selectedDate];
        
        lblFEndTime.text=stringFromDate;
    }



}


-(IBAction)cancelMethod:(id)sender
{
    
    OptionView.hidden=YES;
    [UIView animateWithDuration:0.3 animations:^{ CGRect rect=OptionView.frame;
        rect.origin.y=self.navigationController.view.frame.size.height;
        OptionView.frame=rect;} completion:nil];
    
}




-(IBAction)btn_CreateReservationClicked:(UIButton*)sender
{
    [txtFPrtySize resignFirstResponder];
    
    if ([lblFStartDate.text isEqualToString:@"Select start date"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please select start date" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    else if ([lblFStartTime.text isEqualToString:@"Select start time"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please select  start time" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    else if ([lblFEndtDate.text isEqualToString:@"Select end date"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please select end date" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    else if ([lblFEndTime.text isEqualToString:@"Select end time"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please select end time" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    else if ([[txtFPrtySize.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Party size can not be empty" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
        [txtFPrtySize becomeFirstResponder];

        
    }
    else
    {
        
        
        NSString *startDate=[NSString stringWithFormat:@"%@",lblFStartDate.text];
        NSString *endDate=[NSString stringWithFormat:@"%@",lblFEndtDate.text];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        NSDate *firstDate = [formatter dateFromString:startDate];; // it will give you current date
        NSDate *secondDate = [formatter dateFromString:endDate]; // your date
        
        NSComparisonResult result;
        //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
        
        result = [firstDate compare:secondDate]; // comparing two dates
        int flag=0;
        
        if(result==NSOrderedAscending)
        {
            
            NSLog(@"firstDate is less");
            flag=1;
            int partySize=[txtFPrtySize.text intValue];
            int minPartSize=[[dicRest5 objectForKey:@"min_party_size"] intValue];
            int maxPartSize=[[dicRest5 objectForKey:@"max_party_size"] intValue];
            
            NSString *msg=[NSString stringWithFormat:@"Party size should be minimum %d to maximum %d",minPartSize,maxPartSize];
            
            
            if (partySize<minPartSize || partySize>maxPartSize )
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                
                [txtFPrtySize becomeFirstResponder];
            }
            else
            {
                [DSBezelActivityView newActivityViewForView:self.view];
                //indicator.hidden=NO;
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [defaults objectForKey:@"userdataKey"];
                NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                // NSLog(@"%@",arr);
                
                
                NSArray *arrStartDate=[lblFStartDate.text componentsSeparatedByString:@"/"];
                NSArray *arrEndDate=[lblFEndtDate.text componentsSeparatedByString:@"/"];
                
                // NSString *strStartDAte=[NSString stringWithFormat:@"%@-%@-%@",[arrStartDate objectAtIndex:2],[arrStartDate objectAtIndex:0],[arrStartDate objectAtIndex:1]];
                
                NSString *strStartDateTime=[NSString stringWithFormat:@"%@-%@-%@ %@",[arrStartDate objectAtIndex:2],[arrStartDate objectAtIndex:0],[arrStartDate objectAtIndex:1],lblFStartTime.text];
                NSString *strEndDateTime=[NSString stringWithFormat:@"%@-%@-%@ %@",[arrEndDate objectAtIndex:2],[arrEndDate objectAtIndex:0],[arrEndDate objectAtIndex:1],lblFEndTime.text];
                
                //NSString *d1=[self changeformate_string24hr:strStartDateTime];
                
                
                [NSString stringWithFormat:@"%@ %@ ",[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"],[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"last_name"]];
                
                
                NSDictionary *inputData=[NSDictionary dictionaryWithObjectsAndKeys:[self changeformate_string24hr:strStartDateTime], @"start_datetime",
                                         [self changeformate_string24hr:strEndDateTime], @"end_datetime",
                                         txtFPrtySize.text, @"party_size",
                                         [[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"],@"user_id",
                                         [dicRest5 objectForKey:@"id"],@"restaurant_id",nil];
                
                
                //    ","start_datetime": "2014-12-11 01:18:59","end_datetime": "2014-12-11 04:18:59"
                
                NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/restaurant/reservation"];
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                
                [request addRequestHeader:@"Content-type" value:@"application/json"];
                [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
                
                [request setRequestMethod:@"PUT"];
                request.delegate=self;
                request.allowCompressedResponse = NO;
                request.useCookiePersistence = NO;
                request.shouldCompressRequestBody = NO;
                
                
                NSString *jsonRequest = [inputData JSONRepresentation];
                
                NSLog(@"jsonRequest is %@", jsonRequest);
                
                //NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
                
                
                
                NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                
                [request setPostBody:[requestData mutableCopy]];
                
                [request startSynchronous];
            }

            
        }
        else if(result==NSOrderedDescending)
        {
            NSLog(@"secondDate is less");
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"End reservation date can't be less than start date." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            NSLog(@"Both dates are same");
            
            NSString *startTime = lblFStartTime.text;
            NSString *endTime= lblFEndTime.text;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"hh:mm a"];
            
            NSDate *dateSstartTime= [formatter dateFromString:startTime];
            NSDate *dateEndTime = [formatter dateFromString:endTime];
            
            NSComparisonResult result = [dateSstartTime compare:dateEndTime];
            if(result == NSOrderedDescending)
            {
                NSLog(@"dateSstartTime is later than dateEndTime");
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Start time of reservation  can't be less than end time of reservation." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
            else if(result == NSOrderedAscending)
            {
                NSLog(@"dateEndTime is later than dateSstartTime");
                
                flag=1;
            }
            else
            {
                NSLog(@"dateStartTime is equal to dateEndTime");
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Start and end reservation time can't be same." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }

            
            if(flag==1)
            {
                
                
                int partySize=[txtFPrtySize.text intValue];
                int minPartSize=[[dicRest5 objectForKey:@"min_party_size"] intValue];
                int maxPartSize=[[dicRest5 objectForKey:@"max_party_size"] intValue];
                
                NSString *msg=[NSString stringWithFormat:@"Party size should be minimum %d to maximum %d",minPartSize,maxPartSize];

                
                if (partySize<minPartSize || partySize>maxPartSize )
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                    [alert show];
                    
                    [txtFPrtySize becomeFirstResponder];
                }
                else
                {
                    [DSBezelActivityView newActivityViewForView:self.view];
                    //indicator.hidden=NO;
                    
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSData *data = [defaults objectForKey:@"userdataKey"];
                    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    // NSLog(@"%@",arr);
                    
                    
                    NSArray *arrStartDate=[lblFStartDate.text componentsSeparatedByString:@"/"];
                    NSArray *arrEndDate=[lblFEndtDate.text componentsSeparatedByString:@"/"];
                    
                    // NSString *strStartDAte=[NSString stringWithFormat:@"%@-%@-%@",[arrStartDate objectAtIndex:2],[arrStartDate objectAtIndex:0],[arrStartDate objectAtIndex:1]];
                    
                    NSString *strStartDateTime=[NSString stringWithFormat:@"%@-%@-%@ %@",[arrStartDate objectAtIndex:2],[arrStartDate objectAtIndex:0],[arrStartDate objectAtIndex:1],lblFStartTime.text];
                    NSString *strEndDateTime=[NSString stringWithFormat:@"%@-%@-%@ %@",[arrEndDate objectAtIndex:2],[arrEndDate objectAtIndex:0],[arrEndDate objectAtIndex:1],lblFEndTime.text];
                    
                    //NSString *d1=[self changeformate_string24hr:strStartDateTime];
                    
                    
                    [NSString stringWithFormat:@"%@ %@ ",[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"],[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"last_name"]];
                    
                    
                    NSDictionary *inputData=[NSDictionary dictionaryWithObjectsAndKeys:[self changeformate_string24hr:strStartDateTime], @"start_datetime",
                                             [self changeformate_string24hr:strEndDateTime], @"end_datetime",
                                             txtFPrtySize.text, @"party_size",
                                             [[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"],@"user_id",
                                             [dicRest5 objectForKey:@"id"],@"restaurant_id",nil];
                    
                    
                    //    ","start_datetime": "2014-12-11 01:18:59","end_datetime": "2014-12-11 04:18:59"
                    
                    NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/restaurant/reservation"];
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                    
                    [request addRequestHeader:@"Content-type" value:@"application/json"];
                    [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
                    
                    [request setRequestMethod:@"PUT"];
                    request.delegate=self;
                    request.allowCompressedResponse = NO;
                    request.useCookiePersistence = NO;
                    request.shouldCompressRequestBody = NO;
                    
                    
                    NSString *jsonRequest = [inputData JSONRepresentation];
                    
                    NSLog(@"jsonRequest is %@", jsonRequest);
                    
                    //NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/register"];
                    
                    
                    
                    NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                    
                    [request setPostBody:[requestData mutableCopy]];
                    
                    [request startSynchronous];
                }

            }
                
          
            
        }
        
        
       
    }

    
    

}


-(NSString *)changeformate_string24hr:(NSString *)date
{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    [df setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSDate* wakeTime = [df dateFromString:date];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    return [df stringFromDate:wakeTime];
    
}


-(IBAction)back:(id)sender{
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    // Prevent invalid character input, if keyboard is numberpad
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }
    }
    
    return YES;
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
