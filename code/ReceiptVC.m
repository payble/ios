//
//  ReceiptVC.m
//  kentApp
//
//  Created by N@kuL on 08/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "ReceiptVC.h"
#import "QAUtils.h"
#import "ASIHTTPRequest.h"
#import "DSActivityView.h"
#import "SBJSON.h"

#import "ReceiptDetail.h"

@interface ReceiptVC ()

@end

@implementation ReceiptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    arrForPending=[NSMutableArray new];
    arrForProcessed=[NSMutableArray new];
    
    lblPending.hidden=YES;
    lblProcessed.hidden=YES;
    
    tblPending.hidden=YES;
    tblProcessed.hidden=YES;
    
    [self userReceipt];
    
   
    
    
    tblPending.layer.cornerRadius=5.0f;
    tblProcessed.layer.cornerRadius=5.0f;
    
    if (IDIOM == IPAD){
        lblPending.frame    =   CGRectMake(lblPending.frame.origin.x, lblPending.frame.origin.y+15, lblPending.frame.size.width, lblPending.frame.size.height);
        lblProcessed.frame    =   CGRectMake(lblProcessed.frame.origin.x, lblProcessed.frame.origin.y+15, lblProcessed.frame.size.width, lblProcessed.frame.size.height);
        tblPending.frame    =   CGRectMake(tblPending.frame.origin.x, tblPending.frame.origin.y+15, tblPending.frame.size.width, tblPending.frame.size.height);
        tblProcessed.frame  =   CGRectMake(tblProcessed.frame.origin.x, tblProcessed.frame.origin.y+15, tblProcessed.frame.size.width, tblProcessed.frame.size.height);
        
        
        lblTitle.frame          =   CGRectMake(lblTitle.frame.origin.x-50, lblTitle.frame.origin.y, lblTitle.frame.size.width+100, lblTitle.frame.size.height);
        
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTitle.font           =   [UIFont fontWithName:FONT_TITLE size:22];
        lblProcessed.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblPending.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFooter.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
    }else{
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblTitle.font           =   [UIFont fontWithName:FONT_TITLE size:14];
        lblProcessed.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblPending.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFooter.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    tblPending.separatorColor=[UIColor clearColor];
    tblPending.backgroundColor=[UIColor  clearColor];
    tblProcessed.separatorColor=[UIColor clearColor];
    tblProcessed.backgroundColor=[UIColor  clearColor];
    
}

-(void)ckeckPayMentMode
{
    
    
    if([QAUtils IsNetConnected])
    {
        
        strType=@"isCardAvailable";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"userdataKey"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        // NSLog(@"%@",arr);
        
        
        
        [DSBezelActivityView  newActivityViewForView:self.view];
        
        NSString *str=[NSString stringWithFormat:@"http://netleondev.com/kentapi/user/creditcards/userid/%@",[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"]];
        
        NSURL *url =[NSURL URLWithString:str];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request addRequestHeader:@"Content-type" value:@"application/json"];
        [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
        
        [request setRequestMethod:@"GET"];
        request.delegate=self;
        request.allowCompressedResponse = NO;
        request.useCookiePersistence = NO;
        request.shouldCompressRequestBody = NO;
        request.timeOutSeconds=30;
        
        [request startAsynchronous];
        
        
        
    }
    else
    {
        [DSBezelActivityView removeViewAnimated:YES];
        return;
    }
    
    
}



-(void)userReceipt
{
    if([QAUtils IsNetConnected])
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"userdataKey"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
       // NSLog(@"%@",arr);

        
        
        [DSBezelActivityView  newActivityViewForView:self.view];
        
        NSString *str=[NSString stringWithFormat:@"http://netleondev.com/kentapi/user/receipts/userid/%@",[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"]];
        
        NSURL *url =[NSURL URLWithString:str];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request addRequestHeader:@"Content-type" value:@"application/json"];
        [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
        
        [request setRequestMethod:@"GET"];
        request.delegate=self;
        request.allowCompressedResponse = NO;
        request.useCookiePersistence = NO;
        request.shouldCompressRequestBody = NO;
        request.timeOutSeconds=30;
        
        [request startAsynchronous];
        
//          NSError *error = [request error];
//         
//         if (!error)
//         {
//          NSString *response = [request responseString];
//             
//             NSLog(@"%@",response);
//         }
//         else
//        {
//            
//        }
        
        
        
    }
    else
    {
        [DSBezelActivityView removeViewAnimated:YES];
        return;
    }

    
}

#pragma mark- ASIHTTPRequest response methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSString *responseString = [request responseString];
    
     NSData *responseData = [request responseData];
     
    /* NSDictionary *dicAllRestaurents=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
     
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicAllRestaurents];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:data forKey:@"userdataKey"];
     
     */
    
    
    NSError *e=nil;
    
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&e];
    
    if (!jsonArray)
    {
        NSLog(@"errorNkl==%@ [e localizedDescription]=%@",e,[e localizedDescription]);
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"server error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ([strType isEqualToString:@"isCardAvailable"])
        {
            SBJSON *jsonParser=[[SBJSON alloc] init];
            id outputCard=[jsonParser objectWithString:responseString error:nil];
            NSLog(@"outputCard %@",outputCard);
//            if ([[outputCard valueForKey:@"error"] isEqualToString:@"No card found!"]){
            if ([outputCard isKindOfClass:[NSDictionary class]]){
                NSLog(@"HEre");
                strCheck=@"cardNOTAvailable";
            }
            else
            {
                strCheck=@"cardAvailable";
                arrForCardList=outputCard;

                for (int i=0;i<[outputCard count]; i++)
                {
                    if ([[[outputCard objectAtIndex:i]objectForKey:@"is_default"] isEqualToString:@"1"])
                    {
                      // arrForCardList=[outputCard objectAtIndex:i];
                        break;
                    }
                }
    
            }
            
            //            if ([outputCard count]==0)
            //            {
            //
            //                strCheck=@"cardNOTAvailable";
            ////                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please add you card detail in payment section." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            ////
            ////                [alert show];
            //            }
            

        }
        else
        {
            if([responseString isEqualToString:@"{\"error\":\"No receipt found!\"}"])
            {
                lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, 40, lblFooter.frame.size.width, lblFooter.frame.size.height);
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[dic objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                SBJSON *jsonParser=[[SBJSON alloc] init];
                id outputReceipt=[jsonParser objectWithString:responseString error:nil];
                
                
                for (int i=0;i<[outputReceipt count];i++)
                {
                    if ([[[outputReceipt objectAtIndex:i]objectForKey:@"status"] isEqualToString:@"Pending"])
                    {
                        [arrForPending addObject:[outputReceipt objectAtIndex:i]];
                    }
                    else
                    {
                        [arrForProcessed addObject:[outputReceipt objectAtIndex:i]];
                    }
                }
                
                NSLog(@"arrForPending=>%@",arrForPending);
                NSLog(@"arrForProcessed=>%@",arrForProcessed);
                
                [tblPending reloadData];
                [tblProcessed reloadData];
                
                if (arrForProcessed.count > 0 && arrForPending.count < 1){
                    tblProcessed.hidden=NO;
                    tblPending.hidden=YES;
                    lblProcessed.frame  =   lblPending.frame;
                    tblProcessed.frame= CGRectMake(tblPending.frame.origin.x, tblPending.frame.origin.y, tblPending.frame.size.width, arrForProcessed.count*44);
                    if (IDIOM == IPAD){
                        lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, arrForProcessed.count*44 +80, lblFooter.frame.size.width, lblFooter.frame.size.height);
                    }else{
                        lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, arrForProcessed.count*44 +40, lblFooter.frame.size.width, lblFooter.frame.size.height);
                    }
                    [scrollView setContentInset:UIEdgeInsetsMake(0, 0, tblProcessed.frame.origin.y+50, 0)];
                }else if (arrForProcessed.count <= 0 && arrForPending.count > 0){
                    tblPending.hidden=NO;
                    tblProcessed.hidden=YES;
                    tblPending.frame= CGRectMake(tblPending.frame.origin.x, tblPending.frame.origin.y, tblPending.frame.size.width, arrForPending.count*44);
                    if (IDIOM == IPAD){
                        lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, arrForPending.count*44 +80, lblFooter.frame.size.width, lblFooter.frame.size.height);
                    }else{
                        lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, arrForPending.count*44 +40, lblFooter.frame.size.width, lblFooter.frame.size.height);
                    }
                    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 44*arrForPending.count+50);
                }else if(arrForProcessed.count > 0 && arrForPending.count > 0){
                    tblPending.hidden=NO;
                    tblProcessed.hidden=NO;
                    
                    
                    
                    tblPending.frame= CGRectMake(tblPending.frame.origin.x, tblPending.frame.origin.y, tblPending.frame.size.width, arrForPending.count*44);
                    tblProcessed.frame= CGRectMake(tblProcessed.frame.origin.x, tblPending.frame.origin.y+44*arrForPending.count+40, tblProcessed.frame.size.width, arrForProcessed.count*44);
                    
                    lblProcessed.frame = CGRectMake(lblProcessed.frame.origin.x, tblPending.frame.origin.y+tblPending.frame.size.height, lblProcessed.frame.size.width, lblProcessed.frame.size.height);
                    if (IDIOM == IPAD){
                        
                        lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, arrForProcessed.count*44 + 44*arrForPending.count +120, lblFooter.frame.size.width, lblFooter.frame.size.height);
                    }else{
                        lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, arrForProcessed.count*44 + 44*arrForPending.count +80, lblFooter.frame.size.width, lblFooter.frame.size.height);
                    }
//                    NSLog(@"%f %lu",scrollView.frame.size.width, arrForProcessed.count*44+44*arrForPending.count+40);
                    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, arrForProcessed.count*44+44*arrForPending.count+130);
                }
                
                
                
//                if (arrForPending.count==0 && arrForProcessed.count>0)
//                {
//                    lblPending.text=@"Processed";
//                    lblPending.hidden=NO;
//                    lblProcessed.hidden=YES;
//                    
//                    tblPending.hidden=NO;
//                    tblProcessed.hidden=YES;
//                    tblPending.frame= CGRectMake(tblPending.frame.origin.x, tblPending.frame.origin.y, tblPending.frame.size.width, arrForProcessed.count*44);
//                    lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, arrForProcessed.count*44 +40, lblFooter.frame.size.width, lblFooter.frame.size.height);
//                    [scrollView setContentInset:UIEdgeInsetsMake(0, 0, tblPending.frame.origin.y+50, 0)];
//                    [tblPending reloadData];
//                }
//                else if(arrForPending.count==0 && arrForPending.count>0)
//                {
//                    lblPending.text=@"Pending";
//                    lblPending.hidden=NO;
//                    lblProcessed.hidden=YES;
//                    
//                    tblPending.hidden=NO;
//                    tblProcessed.hidden=YES;
//                    tblPending.frame= CGRectMake(tblPending.frame.origin.x, tblPending.frame.origin.y, tblPending.frame.size.width, arrForPending.count*44);
//                    lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, arrForPending.count*44 +40, lblFooter.frame.size.width, lblFooter.frame.size.height);
//                    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 44*arrForPending.count+50);
//                    [tblPending reloadData];
//                    
//                }
//                else if(arrForPending.count>0 && arrForPending.count>0)
//                {
//                    lblPending.text=@"Pending";
//                    lblProcessed.text=@"Processed";
//                    lblProcessed.frame = CGRectMake(lblProcessed.frame.origin.x, tblPending.frame.size.height-50, lblProcessed.frame.size.width, lblProcessed.frame.size.height);
//                    
//                    lblPending.hidden=NO;
//                    lblProcessed.hidden=NO;
//                    
//                    tblPending.hidden=NO;
//                    tblProcessed.hidden=NO;
//                    tblPending.frame= CGRectMake(tblPending.frame.origin.x, tblPending.frame.origin.y, tblPending.frame.size.width, arrForPending.count*44);
//                    tblProcessed.frame= CGRectMake(tblProcessed.frame.origin.x, tblPending.frame.origin.y+44*arrForPending.count+40, tblProcessed.frame.size.width, arrForProcessed.count*44);
//                    
//                    lblFooter.frame = CGRectMake(lblFooter.frame.origin.x, arrForProcessed.count*44 + 44*arrForPending.count +80, lblFooter.frame.size.width, lblFooter.frame.size.height);
//                    
//                    NSLog(@"%f %lu",scrollView.frame.size.width, arrForProcessed.count*44+44*arrForPending.count+40);
//                    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, arrForProcessed.count*44+44*arrForPending.count+130);
//                    
//
//                    [tblPending reloadData];
//                    [tblProcessed reloadData];
//                }
                
                 [self ckeckPayMentMode];

        }
        
        
            
            
            
            /*
            NSArray *arr=[output1 allKeys];
            int flag=0;
            
            for (NSString *strKey in arr)
            {
                if ([strKey isEqualToString:@"success"])
                {
                    flag=1;
                    break;
                }
            }
            
            
            if (flag==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:[output1 objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:[output1 objectForKey:@"success"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                //  [btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
                
                
                
            }
               */
        }
        
    }
}



- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSError *error = [request error];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}



#pragma mark- UITableview datasource and delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"PENDING %lu Processed %lu",(unsigned long)arrForPending.count,(unsigned long)arrForProcessed.count);
    
    if (tableView == tblPending){
        return arrForPending.count;
    }else{
        return arrForProcessed.count;
    }
//    if (arrForPending.count==0 && arrForProcessed.count>0)
//    {
//        if (tableView.tag==10)
//        {
//            return [arrForProcessed count];
//        }
//       
//    }
//    else if(arrForProcessed.count==0 && arrForPending.count>0)
//    {
//         if(tableView.tag==10)
//        {
//            return [arrForPending count];
//        }
//
//    }
//    else if(arrForPending.count>0 && arrForProcessed.count>0)
//    {
//        if (tableView.tag==10)
//        {
//            return [arrForPending count];
//        }
//        else if(tableView.tag==20)
//        {
//            return [arrForProcessed count];
//        }
//
//    }
//    else if(arrForPending.count==0 && arrForPending.count==0)
//    {
//        return 0;
//    }
//
    
    
    
//    if (tableView.tag==10)
//    {
//        return [arrForPending count];
//    }
//    else if(tableView.tag==20)
//    {
//        return [arrForPending count];
//    }
    return 1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"customCell";
    
    cell=(ReceiptCustomeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ReceiptCustomeCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (IDIOM == IPAD){
        
        cell.lblDate.font           =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        cell.lblRestaurentName.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        cell.lblPrice.font          =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        cell.lblDecimalPoint.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:20];
        
        cell.lblDate.frame  =   CGRectMake(cell.lblDate.frame.origin.x, cell.lblDate.frame.origin.y, cell.lblDate.frame.size.width, cell.lblDate.frame.size.height);
        cell.lblRestaurentName.frame  =   CGRectMake(cell.lblRestaurentName.frame.origin.x+2, cell.lblRestaurentName.frame.origin.y, cell.lblRestaurentName.frame.size.width, cell.lblRestaurentName.frame.size.height);
        cell.lblPrice.frame  =   CGRectMake(cell.lblPrice.frame.origin.x, cell.lblPrice.frame.origin.y, cell.lblPrice.frame.size.width, cell.lblPrice.frame.size.height);
        cell.lblDecimalPoint.frame  =   CGRectMake(cell.lblDecimalPoint.frame.origin.x, cell.lblDecimalPoint.frame.origin.y, cell.lblDecimalPoint.frame.size.width, cell.lblDecimalPoint.frame.size.height);
    }else{
        cell.lblDate.font           =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        cell.lblRestaurentName.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        cell.lblPrice.font          =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        cell.lblDecimalPoint.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
    }
    
    if (tableView == tblPending) {
        
        lblPending.text=@"Pending";
        lblPending.hidden=NO;
        
        NSString *strDate=[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"updated_at"];
        NSString *strDateWithoutTime =[[strDate componentsSeparatedByString:@" "] objectAtIndex:0];
        NSArray *YrMnthDay=[strDateWithoutTime componentsSeparatedByString:@"-"] ;
        
        NSLog(@"strDate %@",strDate);

        
        // NSString *strDate=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
        
        cell.lblDate.text=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
        
        
        NSArray *arrinvoicePrice=[[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"invoice_amount"] componentsSeparatedByString:@"."];
        if (arrinvoicePrice.count==2)
        {
            cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
            cell.lblDecimalPoint.text=[NSString stringWithFormat:@"%@",[arrinvoicePrice objectAtIndex:1]];
        }
        else
        {
            cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
            cell.lblDecimalPoint.text=@"00";
        }
        
        // cell.lblRestaurentName.text=[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"restaurant_name"];
        cell.lblRestaurentName.text=[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"first_name"];
        return cell;
    }else{
        lblProcessed.text=@"Processed";
        lblProcessed.hidden=NO;
        
        NSString *strDate=[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"updated_at"];
        NSString *strDateWithoutTime =[[strDate componentsSeparatedByString:@" "] objectAtIndex:0];
        NSArray *YrMnthDay=[strDateWithoutTime componentsSeparatedByString:@"-"] ;
        
        cell.lblDate.text=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
        
        
        NSArray *arrinvoicePrice=[[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"invoice_amount"] componentsSeparatedByString:@"."];
        if (arrinvoicePrice.count==2)
        {
            cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
            cell.lblDecimalPoint.text=[NSString stringWithFormat:@"%@",[arrinvoicePrice objectAtIndex:1]];
        }
        else
        {
            cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
            cell.lblDecimalPoint.text=@"00";
        }
        
        
        
        //            cell.lblRestaurentName.text=[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"restaurant_name"];
        cell.lblRestaurentName.text=[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"first_name"];
        return cell;
    }

    
//     if (arrForPending.count==0 && arrForProcessed.count>0)
//    {
//        if (tableView.tag==10) //only processed table
//        {
//            
//            NSString *strDate=[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"updated_at"];
//            NSString *strDateWithoutTime =[[strDate componentsSeparatedByString:@" "] objectAtIndex:0];
//            NSArray *YrMnthDay=[strDateWithoutTime componentsSeparatedByString:@"-"] ;
//            
//            cell.lblDate.text=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
//            
//            
//            NSArray *arrinvoicePrice=[[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"invoice_amount"] componentsSeparatedByString:@"."];
//            if (arrinvoicePrice.count==2)
//            {
//                cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
//                cell.lblDecimalPoint.text=[NSString stringWithFormat:@"%@",[arrinvoicePrice objectAtIndex:1]];
//            }
//            else
//            {
//                cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
//                 cell.lblDecimalPoint.text=@"00";
//            }
//            
//           
//            
////            cell.lblRestaurentName.text=[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"restaurant_name"];
//            cell.lblRestaurentName.text=[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"first_name"];
//            return cell;
//            
//        }
//        
//    }
//    else if(arrForProcessed.count==0 && arrForPending.count>0)
//    {
//         if(tableView.tag==10) //only pending table
//        {
//            NSString *strDate=[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"updated_at"];
//            NSString *strDateWithoutTime =[[strDate componentsSeparatedByString:@" "] objectAtIndex:0];
//            NSArray *YrMnthDay=[strDateWithoutTime componentsSeparatedByString:@"-"] ;
//            
//           // NSString *strDate=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
//            
//           cell.lblDate.text=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
//          
//            
//            NSArray *arrinvoicePrice=[[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"invoice_amount"] componentsSeparatedByString:@"."];
//            if (arrinvoicePrice.count==2)
//            {
//                cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
//                cell.lblDecimalPoint.text=[NSString stringWithFormat:@"%@",[arrinvoicePrice objectAtIndex:1]];
//            }
//            else
//            {
//                cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
//                cell.lblDecimalPoint.text=@"00";
//            }
//            
//           // cell.lblRestaurentName.text=[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"restaurant_name"];
//             cell.lblRestaurentName.text=[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"first_name"];
//            return cell;
//            
//        }
//
//        
//    }
//    else  if(arrForPending.count>0 && arrForPending.count>0)
//    {
//        
//        if (tableView.tag==10) //pending table
//        {
//            NSString *strDate=[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"updated_at"];
//            NSString *strDateWithoutTime =[[strDate componentsSeparatedByString:@" "] objectAtIndex:0];
//            NSArray *YrMnthDay=[strDateWithoutTime componentsSeparatedByString:@"-"] ;
//            
//         //   NSString *strDate=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
//            
//            
//            cell.lblDate.text=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
//           
//            
//            NSArray *arrinvoicePrice=[[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"invoice_amount"] componentsSeparatedByString:@"."];
//            if (arrinvoicePrice.count==2)
//            {
//                cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
//                cell.lblDecimalPoint.text=[NSString stringWithFormat:@"%@",[arrinvoicePrice objectAtIndex:1]];
//            }
//            else
//            {
//                cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
//                cell.lblDecimalPoint.text=@"00";
//            }
//
//            
//           // cell.lblRestaurentName.text=[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"restaurant_name"];
//             cell.lblRestaurentName.text=[[arrForPending objectAtIndex:indexPath.row] objectForKey:@"first_name"];
//            return cell;
//            
//        }
//        else if(tableView.tag==20) //processesd table
//        {
//            NSString *strDate=[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"updated_at"];
//            NSString *strDateWithoutTime =[[strDate componentsSeparatedByString:@" "] objectAtIndex:0];
//            NSArray *YrMnthDay=[strDateWithoutTime componentsSeparatedByString:@"-"] ;
//            
//            
//          //  NSString *strDateCorrectFormate=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
//            
//            cell.lblDate.text=[NSString stringWithFormat:@"%@/%@",[YrMnthDay objectAtIndex:1],[YrMnthDay objectAtIndex:2]];
//           
//            
//            NSArray *arrinvoicePrice=[[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"invoice_amount"] componentsSeparatedByString:@"."];
//            if (arrinvoicePrice.count==2)
//            {
//                cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
//                cell.lblDecimalPoint.text=[NSString stringWithFormat:@"%@",[arrinvoicePrice objectAtIndex:1]];
//            }
//            else
//            {
//                cell.lblPrice.text=[NSString stringWithFormat:@"$ %@",[arrinvoicePrice objectAtIndex:0]];
//                cell.lblDecimalPoint.text=@"00";
//            }
//
//            
//           // cell.lblRestaurentName.text=[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"restaurant_name"];
//             cell.lblRestaurentName.text=[[arrForProcessed objectAtIndex:indexPath.row] objectForKey:@"first_name"];
//            return cell;
//            
//        }
//    }

    
  
    
    
     return cell;
    
       
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([strCheck isEqualToString:@"cardAvailable"])
    {
        ReceiptDetail *receiptDetaill=[[ReceiptDetail alloc]initWithNibName:@"ReceiptDetail" bundle:nil];
        
        if (tableView == tblPending){
            receiptDetaill.dicRestaurentDetail2 =[arrForPending objectAtIndex:indexPath.row];
        }else{
            receiptDetaill.dicRestaurentDetail2 =[arrForProcessed objectAtIndex:indexPath.row];
        }
        receiptDetaill.arrForCArdList=arrForCardList;
        
        [self.navigationController pushViewController:receiptDetaill animated:YES];
        
//        if (arrForPending.count==0 && arrForProcessed.count>0) //only processed
//        {
//            ReceiptDetail *receiptDetaill=[[ReceiptDetail alloc]initWithNibName:@"ReceiptDetail" bundle:nil];
//            receiptDetaill.dicRestaurentDetail2 =[arrForProcessed objectAtIndex:indexPath.row];
//            receiptDetaill.arrForCArdList=arrForCardList;
//
//            [self.navigationController pushViewController:receiptDetaill animated:YES];
//        }
//        else if(arrForProcessed.count==0 && arrForPending.count>0) //only pending
//        {
//            ReceiptDetail *receiptDetaill=[[ReceiptDetail alloc]initWithNibName:@"ReceiptDetail" bundle:nil];
//            receiptDetaill.dicRestaurentDetail2 =[arrForPending objectAtIndex:indexPath.row];
//            receiptDetaill.arrForCArdList=arrForCardList;
//            [self.navigationController pushViewController:receiptDetaill animated:YES];
//            
//            
//        }
//        else if(arrForPending.count>0 && arrForProcessed.count>0)  //both
//        {
//            if (tableView.tag==10) //pending
//            {
//                ReceiptDetail *receiptDetaill=[[ReceiptDetail alloc]initWithNibName:@"ReceiptDetail" bundle:nil];
//                receiptDetaill.dicRestaurentDetail2 =[arrForPending objectAtIndex:indexPath.row];
//                receiptDetaill.arrForCArdList=arrForCardList;
//                [self.navigationController pushViewController:receiptDetaill animated:YES];
//                
//            }
//            else if(tableView.tag==20) //processed
//            {
//                ReceiptDetail *receiptDetaill=[[ReceiptDetail alloc]initWithNibName:@"ReceiptDetail" bundle:nil];
//                receiptDetaill.dicRestaurentDetail2 =[arrForProcessed objectAtIndex:indexPath.row];
//                receiptDetaill.arrForCArdList=arrForCardList;
//                [self.navigationController pushViewController:receiptDetaill animated:YES];
//                
//            }
//            
//        }
        

    }
    else if ([strCheck isEqualToString:@"cardNOTAvailable"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please add you card detail in payment section." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        
        [alert show];

        
        

    }
    
    
    
 
}

#pragma mark- IB_Action
-(IBAction)btnReciptDetailDidClicked:(id)sender
{
    
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
