//
//  PaymentDetailVC.m
//  kentApp
//
//  Created by N@kuL on 08/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "PaymentDetailVC.h"
#import "JSON.h"
#import "QAUtils.h"

@interface PaymentDetailVC ()

@end

@implementation PaymentDetailVC
@synthesize strCradType,diccardDetailData,strIsFirstCard;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  connection = [WebServiceConnection connectinManager];
    
    arrMonth=[NSMutableArray new];
    arrYear=[NSMutableArray new];
    
   /* January Jan.
    February Feb.
    March Mar.
    April Apr.
    May May
    June June
    July July
    August Aug.
    September Sept.
    October Oct.
    November Nov.
    December Dec */
    
    if ([strCradType isEqualToString:@"SeeDetail"])
    {
        //btnSave.hidden=YES;
        
        viewaymentDetail.hidden=NO;
        viewCArd.hidden=YES;
        
        
        [btnDone setTitle:@"EDIT" forState:UIControlStateNormal];
        
//        txtFCard.userInteractionEnabled=NO;
//        txtFUserNAme.userInteractionEnabled=NO;
//        txtFCc_no.userInteractionEnabled=NO;
//        txtFExpiry.userInteractionEnabled=NO;
//        txtFCVV.userInteractionEnabled=NO;
        
//        btnOnCardType.enabled=NO;
//        btnOnExpiry.enabled=NO;
        
        [self showDetailOfCard];
    }
    else if([strCradType isEqualToString:@"addCard"])
    {
       // btnSave.hidden=NO;
        viewaymentDetail.hidden=YES;
        viewCArd.hidden=NO;
        
        [btnDone setTitle:@"DONE" forState:UIControlStateNormal];
       
//        txtFUserNAme.userInteractionEnabled=YES;
//        txtFCc_no.userInteractionEnabled=YES;
//        txtFCVV.userInteractionEnabled=YES;
        
//        btnOnCardType.enabled=YES;
//        btnOnExpiry.enabled=YES;
        
    }
    
    
    arrMonth=[[NSMutableArray alloc]initWithObjects:@"Jan", @"Feb", @"March", @"April",@"May", @"June", @"July", @"August" ,@"September", @"October", @"November", @"December",nil];
  
    NSDate *nowDate=[NSDate date];
    
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *theDate = [formater stringFromDate:nowDate];
    
    NSArray *arr=[theDate componentsSeparatedByString:@"-"];
    int year=[[arr objectAtIndex:0] intValue];
    
    for (int i=year; i<year+30; i++)
    {
        [arrYear addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    arrCardNames=[[NSArray alloc]initWithObjects:@"MasterCard",@"Discover",@"AmericanExpress",@"VISA",@"AmEx",@"Capital One",@"Chase",@"First PREMIER",@"Pentagon Federal", nil];
    
    viewaymentDetail.layer.cornerRadius=5.0f;
    viewaymentDetail.clipsToBounds=YES;
    
    
    viewCArd.layer.cornerRadius=5.0f;
    viewCArd.clipsToBounds=YES;
    
  //  btnSave.layer.cornerRadius=5.0f;
    
    if (IDIOM == IPAD){
        
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTitle.font           =   [UIFont fontWithName:FONT_TITLE size:22];
        btnDone.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        
        txtFCard.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFUserNAme.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFCc_no.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFExpiry.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFCVV.font        =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        
        txtFCardShowDetail.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFUserNAmeShowDetail.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFCc_noShowDetail.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFExpiryShowDetail.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFCVVShowDetail.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblCrdType.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblCrdName.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblCrdCc_no.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblCrdExpiry.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblCrdFccv.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblCrdTypeShowDetail.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblCrdNameShowDetail.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblCrdCc_noShowDetail.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblCrdExpiryShowDetail.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblCrdFccvShowDetail.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        btnSave.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblDetails.font         =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        txtFCard.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFCard.frame.origin.y, txtFCard.frame.size.width*2, txtFCard.frame.size.height);
        txtFUserNAme.frame  =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFUserNAme.frame.origin.y, txtFUserNAme.frame.size.width*2, txtFUserNAme.frame.size.height);
        txtFCc_no.frame     =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFCc_no.frame.origin.y, txtFCc_no.frame.size.width*2, txtFCc_no.frame.size.height);
        txtFExpiry.frame    =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFExpiry.frame.origin.y, txtFExpiry.frame.size.width*2, txtFExpiry.frame.size.height);
        txtFCVV.frame       =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFCVV.frame.origin.y, txtFCVV.frame.size.width*2, txtFCVV.frame.size.height);
        
        
        txtFCardShowDetail.frame        =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFCardShowDetail.frame.origin.y, txtFCardShowDetail.frame.size.width*2, txtFCardShowDetail.frame.size.height);
        txtFUserNAmeShowDetail.frame    =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFUserNAmeShowDetail.frame.origin.y, txtFUserNAmeShowDetail.frame.size.width*2, txtFUserNAmeShowDetail.frame.size.height);
        txtFCc_noShowDetail.frame       =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFCc_noShowDetail.frame.origin.y, txtFCc_noShowDetail.frame.size.width*2, txtFCc_noShowDetail.frame.size.height);
        txtFExpiryShowDetail.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFExpiryShowDetail.frame.origin.y, txtFExpiryShowDetail.frame.size.width*2, txtFExpiryShowDetail.frame.size.height);
        txtFCVVShowDetail.frame         =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, txtFCVVShowDetail.frame.origin.y, txtFCVVShowDetail.frame.size.width*2, txtFCVVShowDetail.frame.size.height);
        
//        btnOnCardType.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, btnOnCardType.frame.origin.y, btnOnCardType.frame.size.width*2, btnOnCardType.frame.size.height);
//        btnOnExpiry.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*3.2, btnOnExpiry.frame.origin.y, btnOnExpiry.frame.size.width*2, btnOnExpiry.frame.size.height);
        
//        btnOnCardType.backgroundColor  =   [UIColor redColor];

    }else{
        
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblTitle.font           =   [UIFont fontWithName:FONT_TITLE size:14];
        btnDone.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        
        txtFCard.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFUserNAme.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFCc_no.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFExpiry.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFCVV.font        =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        
        txtFCardShowDetail.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFUserNAmeShowDetail.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFCc_noShowDetail.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFExpiryShowDetail.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFCVVShowDetail.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblCrdType.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblCrdName.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblCrdCc_no.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblCrdExpiry.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblCrdFccv.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblCrdTypeShowDetail.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblCrdNameShowDetail.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblCrdCc_noShowDetail.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblCrdExpiryShowDetail.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblCrdFccvShowDetail.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        btnSave.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblDetails.font         =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        txtFCard.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFCard.frame.origin.y, txtFCard.frame.size.width, txtFCard.frame.size.height);
        txtFUserNAme.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFUserNAme.frame.origin.y, txtFUserNAme.frame.size.width, txtFUserNAme.frame.size.height);
        txtFCc_no.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFCc_no.frame.origin.y, txtFCc_no.frame.size.width, txtFCc_no.frame.size.height);
        txtFExpiry.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFExpiry.frame.origin.y, txtFExpiry.frame.size.width, txtFExpiry.frame.size.height);
        txtFCVV.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFCVV.frame.origin.y, txtFCVV.frame.size.width, txtFCVV.frame.size.height);
        
        
        txtFCardShowDetail.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFCardShowDetail.frame.origin.y, txtFCardShowDetail.frame.size.width, txtFCardShowDetail.frame.size.height);
        txtFUserNAmeShowDetail.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFUserNAmeShowDetail.frame.origin.y, txtFUserNAmeShowDetail.frame.size.width, txtFUserNAmeShowDetail.frame.size.height);
        txtFCc_noShowDetail.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFCc_noShowDetail.frame.origin.y, txtFCc_noShowDetail.frame.size.width, txtFCc_noShowDetail.frame.size.height);
        txtFExpiryShowDetail.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFExpiryShowDetail.frame.origin.y, txtFExpiryShowDetail.frame.size.width, txtFExpiryShowDetail.frame.size.height);
        txtFCVVShowDetail.frame      =   CGRectMake(lblCrdType.frame.origin.x+lblCrdType.frame.size.width*1.5, txtFCVVShowDetail.frame.origin.y, txtFCVVShowDetail.frame.size.width, txtFCVVShowDetail.frame.size.height);
    }
    

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtFCard resignFirstResponder];
    [txtFCc_no resignFirstResponder];
    [txtFCVV resignFirstResponder];
    [txtFUserNAme resignFirstResponder];
    [txtFExpiry resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag==20)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        
        const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        if (isBackSpace == -8)
        {
            NSLog(@"Backspace was pressed");
        }
        else
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            return (newLength > 16) ? NO : YES;
        }
        
        
    }
    if (textField.tag==30)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 3) ? NO : YES;
    }

    // Prevent crashing undo bug – see note below.
    
    return YES;
}


-(void)showDetailOfCard
{
   
    
    int n=[[diccardDetailData objectForKey:@"cc_expiration_month"] intValue];
    NSString *strMonth1;
    
    
    if (n==1)
    {
        strMonth1=@"Jan";
    }
    else if (n==2)
    {
        strMonth1=@"Feb";
    }
    else if (n==3)
    {
        strMonth1=@"March";
    }
    else if (n==4)
    {
        strMonth1=@"April";
    } else if (n==5)
    {
        strMonth1=@"May";
    }
    else if (n==6)
    {
        strMonth1=@"June";
    }
    else if (n==7)
    {
        strMonth1=@"July";
    }
    else if (n==8)
    {
        strMonth1=@"August";
    }
    else if (n==9)
    {
        strMonth1=@"September";
    }
    else if (n==10)
    {
        strMonth1=@"October";
    }
    else if (n==11)
    {
        strMonth1=@"November";
    }
    else if (n==12)
    {
        strMonth1=@"December";
    }
    
   
    
   // NSString *strDate=[NSString stringWithFormat:@"%@",[diccardDetailData objectForKey:@"cc_expiration_year"]];
    
    NSString *str=[NSString stringWithFormat:@"%@",[diccardDetailData objectForKey:@"cc_number"]];
    NSString *code = [str substringFromIndex: [str length] -4];
    
    txtFCard.text=[diccardDetailData objectForKey:@"cc_type"];
    txtFUserNAme.text=[diccardDetailData objectForKey:@"cc_name"];
  //  txtFCc_no.text=[NSString stringWithFormat:@"XXXXXXXXXXXX%@",code];
    txtFCc_no.text=[diccardDetailData objectForKey:@"cc_number"];
    txtFExpiry.text=[NSString stringWithFormat:@"%@/%@",[diccardDetailData objectForKey:@"cc_expiration_year"],[diccardDetailData objectForKey:@"cc_expiration_month"]];
    txtFCVV.text=[diccardDetailData objectForKey:@"cc_cvv"];
    
    
    txtFCardShowDetail.text=[diccardDetailData objectForKey:@"cc_type"];
    txtFUserNAmeShowDetail.text=[diccardDetailData objectForKey:@"cc_name"];
//    txtFCc_noShowDetail.text=[NSString stringWithFormat:@"XXXXXXXXXXXX%@",code];
    txtFCc_noShowDetail.text=[diccardDetailData objectForKey:@"cc_number"];
    txtFExpiryShowDetail.text=[NSString stringWithFormat:@"%@/%@",[diccardDetailData objectForKey:@"cc_expiration_year"],[diccardDetailData objectForKey:@"cc_expiration_month"]];
    txtFCVVShowDetail.text=[diccardDetailData objectForKey:@"cc_cvv"];
    
    
}


#pragma mark- ASIHTTP request handler

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    
    NSString *responseString = [request responseString];
    
    NSLog(@"LoginResponse=>%@",[responseString JSONValue]);
    
    NSLog(@"responseString==>%@",responseString);
    
    NSData *responseData = [request responseData];
    
    if(![[responseString JSONValue] isKindOfClass:[SBJSON class]])
    {
        NSLog(@"Nakul%@",[request JSONRepresentation]);
    }
    
    NSError *e=nil;
    
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&e];
    
    if (!jsonArray)
    {
        if (responseString.length>0 && responseString.length<5)
        {
            if ([strType isEqualToString:@"addCard"])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Card detail successfully added." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
              
            }
            else if ([strType isEqualToString:@"updateUserCard"])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Card updated successfully!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                
            }
            
              [self.navigationController popViewControllerAnimated:YES ];
        }
        else
        {
            
            NSLog(@"errorNkl==%@ [e localizedDescription]=%@",e,[e localizedDescription]);
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"server error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }

      
    }
    else
    {
       
        
        
        if ([strType isEqualToString:@"addCard"])
        {
            if (responseString.length==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Error to get response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            if ([responseString isEqualToString:@"{\"error\":\"Card expiration month cannot be blank must have range from 1 to 12.\"}" ])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Card expiration month cannot be blank must have range from 1 to 12." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:data forKey:@"userdataKey"];
                
                
                
            }

        }
        else if ([strType isEqualToString:@"updateUserCard"])
        {
            if (responseString.length==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Error to get response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            if ([responseString isEqualToString:@"{\"error\":\"Bad Request!\"}" ])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Card expiration month cannot be blank must have range from 1 to 12." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                
              //  NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
                
               
                
                
                
            }

        }
        
        
        
        
    }
  
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSError *error = [request error];
    
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}



#pragma mark- TableView Datasource and delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrCardNames count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text=[arrCardNames objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:FONT_NAME_MAIN size:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    txtFCard.text=[arrCardNames objectAtIndex:indexPath.row];

    [modal hide];
}


#pragma mark - Picker View Data source

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// Return row count for each of the components
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [arrYear count];
    }
    else
    {
        return [arrMonth count];
    }
}


// The data to return for the row and component (column) that's being passed in
// Populate the rows of the Picker
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    // Component 0 should load the array1 values, Component 1 will have the array2 values
    if (component == 0)
    {
        return [arrYear objectAtIndex:row];
    }
    else if (component == 1)
    {
        return [arrMonth objectAtIndex:row];
    }
    return nil;
}



#pragma mark- Picker View Delegate

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if (component==0)
//    {
//        strYear=[arrYear objectAtIndex:row];
//    }
//    if (component==1)
//    {
//        strMonth=[arrMonth objectAtIndex:row];
//    }
    
    
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
}




#pragma mark- IB_Action

-(IBAction)btn_cardTypeDidClicked:(id)sender
{
    [txtFCard resignFirstResponder];
    [txtFCc_no resignFirstResponder];
    [txtFCVV resignFirstResponder];
    [txtFUserNAme resignFirstResponder];
    [txtFExpiry resignFirstResponder];
    
    
#warning Change this to see a custom view
    BOOL useCustomView = NO;
    
    
    if (useCustomView)
    {
        UITableView *tblview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 400)];
         tblview.separatorColor=[UIColor clearColor];
        
        //tblview.backgroundColor = [UIColor redColor];
        tblview.layer.cornerRadius = 2.f;
        // tblview.layer.borderColor = [UIColor blackColor].CGColor;
        tblview.layer.borderWidth = 0.5f;
        
        tblview.delegate=self;
        tblview.dataSource=self;
        
        modal = [[RNBlurModalView alloc] initWithView:tblview];
       
        

    }
    else {
        
        UITableView *tblview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 400)];
        tblview.separatorColor=[UIColor clearColor];
       // tblview.backgroundColor = [UIColor redColor];
        tblview.layer.cornerRadius = 2.f;
       // tblview.layer.borderColor = [UIColor blackColor].CGColor;
        tblview.layer.borderWidth = 0.5f;
        
        tblview.delegate=self;
        tblview.dataSource=self;
        
        modal = [[RNBlurModalView alloc] initWithView:tblview];
        
        modal.defaultHideBlock = ^{
            NSLog(@"Code called after the modal view is hidden");
        };
    }
    //    modal.dismissButtonRight = YES;
    [modal show];
}


-(IBAction)btn_ExpirationDidClicked:(id)sender
{
    [txtFCard resignFirstResponder];
    [txtFCc_no resignFirstResponder];
    [txtFCVV resignFirstResponder];
    [txtFUserNAme resignFirstResponder];
    [txtFExpiry resignFirstResponder];

    
   [self addPickerView];
}


-(void)done:(id)sender
{
    strYear=[arrYear objectAtIndex:[myPickerView selectedRowInComponent:0]];
    strMonth=[arrMonth objectAtIndex:[myPickerView selectedRowInComponent:1]];
    
    
    
    NSString *month;
    
    for (int i=0;i<12;i++)
    {
        if ([[arrMonth objectAtIndex:i] isEqualToString:strMonth])
        {
            
            month=[NSString stringWithFormat:@"%d",i+1];
            
        }
    }
    
   // NSDate *currentDate=[NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger currentmonth2 = [components month];
    NSInteger currentyear = [components year];
    
    if ([strYear intValue]==currentyear)
    {
        if ([month intValue]<currentmonth2)
        {
            txtFExpiry.text=nil;
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Date can't be in past." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];

        }
        else
        {
            txtFExpiry.text=[NSString stringWithFormat:@"%@/%@",strYear,month];
        }
        
    }
    else
    {
        txtFExpiry.text=[NSString stringWithFormat:@"%@/%@",strYear,month];
    }
    
    
    [modal hide];
}

-(void)addPickerView
{
 
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 202)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 2.f;
       // view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.borderWidth = 0.5f;
    
        myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 250, 162)];
        myPickerView.backgroundColor=[UIColor whiteColor];
        myPickerView.dataSource = self;
        myPickerView.delegate = self;
    
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                       target:self action:@selector(done:)];
        
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
        
        toolBar.backgroundColor=[UIColor whiteColor];
        [toolBar setBarStyle:UIBarStyleBlackOpaque];
    
        NSArray *toolbarItems = [NSArray arrayWithObjects:flexibleSpace,doneButton,flexibleSpace, nil];
    
        [toolBar setItems:toolbarItems];
        
        [view addSubview:toolBar];
        [view addSubview:myPickerView];
       // [self.view bringSubviewToFront:myPickerView];
    
        modal = [[RNBlurModalView alloc] initWithView:view];
        
        modal.defaultHideBlock = ^{
            NSLog(@"Code called after the modal view is hidden");
        };
    
    //    modal.dismissButtonRight = YES;
    [modal show];
    
    
    
    
}

-(void)upDateUseerCArd
{
    NSString *strCardNo;
    if (txtFCc_no.text.length<16)
    {
        
    }
    else
    {
        strCardNo=[txtFCc_no.text substringWithRange:NSMakeRange(0,12)];

    }
   
    if([[txtFCard.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFCard.text==nil)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please select card type." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        
    }
    else if([[txtFUserNAme.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFUserNAme.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter name on card" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFUserNAme becomeFirstResponder];
        
    }
    else if([[txtFCc_no.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFCc_no.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter card number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFCc_no becomeFirstResponder];
        
    }
//    else if ([strCardNo isEqualToString:@"XXXXXXXXXXXX"])
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter correct card number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    else if (txtFCc_no.text.length<16)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter proper card number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFCc_no becomeFirstResponder];
        
    }
    else if([[txtFExpiry.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFExpiry.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please choose card expiry date." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        
    }
     else if (txtFCVV.text.length<3)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter correct CVV number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFCVV becomeFirstResponder];
        
    }
    else
    {

    
        if([QAUtils IsNetConnected])
        {
            
            
            strType=@"updateUserCard";
            
            
            [DSBezelActivityView  newActivityViewForView:self.view];
            //[self CallLoginMethodForWebservice:info];
            
            NSLog(@"%@",txtFExpiry.text);
            NSLog(@"year=%@ month=%@",strYear,strMonth);
            
            //              arrMonth=[[NSMutableArray alloc]initWithObjects:@"Jan", @"Feb", @"March", @"April",@"May", @"June", @"July", @"August" ,@"September", @"October", @"November", @"December"  ,nil];
            
            NSArray *arrMonthYear=[txtFExpiry.text componentsSeparatedByString:@"/"];
            
            NSString *month;
            
            
       /*     for (int i=0;i<12;i++)
            {
                if ([[arrMonth objectAtIndex:i] isEqualToString:[arrMonthYear objectAtIndex:1]])
                {
                    
                    month=[NSString stringWithFormat:@"%d",i+1];
                    
                }
            }
            
            */
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [defaults objectForKey:@"userdataKey"];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSLog(@"%d",[[diccardDetailData objectForKey:@"is_default"] intValue]);
            NSDictionary *urlParam=[NSDictionary dictionaryWithObjectsAndKeys:[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"],@"user_id",
                                    [diccardDetailData objectForKey:@"id"],@"card_id",
                                    txtFCard.text,@"cc_type",
                                    txtFUserNAme.text,@"cc_name",
                                    txtFCc_no.text,@"cc_number",
                                    txtFCVV.text,@"cc_cvv",
                                    [arrMonthYear objectAtIndex:1],@"cc_expiration_month",
                                    [arrMonthYear objectAtIndex:0],@"cc_expiration_year",
                                    [diccardDetailData objectForKey:@"is_default"],@"is_default",nil];
            
            
            //  {"user_id":"3","card_id":"6","cc_type":"disc","cc_name":"ss12","cc_number":"7894567891235654","cc_expiration_month":"12","cc_expiration_year":"2015","is_default":"1"}
            
            NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/updateusercards"];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            
            [request addRequestHeader:@"Content-type" value:@"application/json"];
            [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
            
            [request setRequestMethod:@"PUT"];
            request.delegate=self;
            request.allowCompressedResponse = NO;
            request.useCookiePersistence = NO;
            request.shouldCompressRequestBody = NO;
            
            NSString *jsonRequest = [urlParam JSONRepresentation];
            
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

}


-(IBAction)btnDoneClicked:(id)sender
{
    
    if ([strCradType isEqualToString:@"SeeDetail"])
    {
        if ([btnDone.titleLabel.text isEqualToString:@"EDIT"])
        {
            [btnDone setTitle:@"DONE" forState:UIControlStateNormal];

            
//            btnOnCardType.enabled=YES;
//            btnOnExpiry.enabled=YES;
//            txtFUserNAme.userInteractionEnabled=YES;
//            txtFCc_no.userInteractionEnabled=YES;
//            txtFCVV.userInteractionEnabled=YES;
          //  btnSave.hidden=NO;
            
            viewaymentDetail.hidden=YES;
            viewCArd.hidden=NO;
            
            
        }
        else if ([btnDone.titleLabel.text isEqualToString:@"DONE"])
        {
            [btnDone setTitle:@"EDIT" forState:UIControlStateNormal];
            
//            txtFCard.userInteractionEnabled=NO;
//            txtFUserNAme.userInteractionEnabled=NO;
//            txtFCc_no.userInteractionEnabled=NO;
//            txtFExpiry.userInteractionEnabled=NO;
//            txtFCVV.userInteractionEnabled=NO;
//            
//            btnOnCardType.enabled=NO;
//            btnOnExpiry.enabled=NO;
            
            [self.navigationController popViewControllerAnimated:YES ];
            
            
        }
        
        
        
    }
    else if([strCradType isEqualToString:@"addCard"])
    {
        
          [self.navigationController popViewControllerAnimated:YES ];
       // [self btnSaveClicked:nil];
    }
    
    
    
}

-(IBAction)btnSaveClicked:(id)sender
{
    
    if ([strCradType isEqualToString:@"SeeDetail"])
    {
        
        [self upDateUseerCArd];
        
        
    }
    else if([strCradType isEqualToString:@"addCard"])
    {
        
        
        if([[txtFCard.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFCard.text==nil)
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please select card type." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        else if([[txtFUserNAme.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFUserNAme.text==nil)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter name on card" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFUserNAme becomeFirstResponder];
            
        }
        else if([[txtFCc_no.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFCc_no.text==nil)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter card number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFCc_no becomeFirstResponder];
            
        }
        else if (txtFCc_no.text.length<16)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter proper card number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFCc_no becomeFirstResponder];
            
        }
        else if([[txtFExpiry.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFExpiry.text==nil)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please choose card expiry date." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        else if (txtFCVV.text.length<3)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter correct CVV number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFCVV becomeFirstResponder];
            
        }
        else
        {
            
            if([QAUtils IsNetConnected])
            {
                
                strType=@"addCard";
                
                
                [DSBezelActivityView  newActivityViewForView:self.view];
                //[self CallLoginMethodForWebservice:info];
                
                NSLog(@"%@",txtFExpiry.text);
                NSLog(@"year=%@ month=%@",strYear,strMonth);
                
                //              arrMonth=[[NSMutableArray alloc]initWithObjects:@"Jan", @"Feb", @"March", @"April",@"May", @"June", @"July", @"August" ,@"September", @"October", @"November", @"December"  ,nil];
                
                NSString *month;
                
                for (int i=0;i<12;i++)
                {
                    if ([[arrMonth objectAtIndex:i] isEqualToString:strMonth])
                    {
                        
                        month=[NSString stringWithFormat:@"%d",i+1];
                        
                    }
                }
                
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [defaults objectForKey:@"userdataKey"];
                NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                NSString *strIscardDefalut;
                if ([strIsFirstCard isEqualToString:@"yes"])
                {
                    strIscardDefalut=@"1";
                }
                else
                {
                    strIscardDefalut=@"0";
                }
                NSDictionary *urlParam=[NSDictionary dictionaryWithObjectsAndKeys:[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"],@"user_id",
                                        txtFCVV.text,@"cc_cvv",
                                        txtFCard.text,@"cc_type",
                                        txtFUserNAme.text,@"cc_name",
                                        txtFCc_no.text,@"cc_number",
                                        month,@"cc_expiration_month",
                                        strYear,@"cc_expiration_year",
                                        strIscardDefalut,@"is_default",nil];
                
                
                //  {"user_id":"1","cc_type":"Visa", "cc_name":"NameOnCard", "cc_number":"1234-4567-7895-4567", "cc_expiration_month":"12", "cc_expiration_year":"2015", "cc_cvv":"123", "is_default":"0"}
                
                NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/user/addusercards"];
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                
                [request addRequestHeader:@"Content-type" value:@"application/json"];
                [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
                
                [request setRequestMethod:@"PUT"];
                request.delegate=self;
                request.allowCompressedResponse = NO;
                request.useCookiePersistence = NO;
                request.shouldCompressRequestBody = NO;
                
                NSString *jsonRequest = [urlParam JSONRepresentation];
                
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
        
    }

}


-(IBAction)btnBackDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
