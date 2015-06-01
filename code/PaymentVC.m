//
//  PaymentVC.m
//  kentApp
//
//  Created by N@kuL on 08/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "PaymentVC.h"
#import "PaymentDetailVC.h"

#import "DSActivityView.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "QAUtils.h"

@interface PaymentVC ()

@end

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IDIOM == IPAD){
        viewForCArd.frame       =   CGRectMake(viewForCArd.frame.origin.x, viewForCArd.frame.origin.y+40, viewForCArd.frame.size.width, viewForCArd.frame.size.height);
        
        btnPayment.frame        =   CGRectMake(btnPayment.frame.origin.x, btnPayment.frame.origin.y, btnPayment.frame.size.width, btnPayment.frame.size.height*1.9);
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTitle.font           =   [UIFont fontWithName:FONT_TITLE size:22];
        lblMessage.font         =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        btnPayment.titleLabel.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
    }else{
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblTitle.font           =   [UIFont fontWithName:FONT_TITLE size:14];
        lblMessage.font         =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        btnPayment.titleLabel.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    tbleCard.hidden=YES;
    
//    tbleCard.layer.cornerRadius=5.0f;
//    btnPayment.layer.cornerRadius=5.0f;
    
    viewForCArd.layer.cornerRadius=5.0f;
    viewForCArd.clipsToBounds=YES;
    
    
    [self ckeckPayMentMode];
}



-(void)ckeckPayMentMode
{
    strType=@"check card";
    
    if([QAUtils IsNetConnected])
    {
        
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



#pragma mark- ASIHTTPRequest response methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSString *responseString = [request responseString];
   
    NSData *responseData = [request responseData];
    
    
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
         
         SBJSON *jsonParser=[[SBJSON alloc] init];
        id output=[jsonParser objectWithString:responseString error:nil];

         
         if ([strType isEqualToString:@"check card"])
         {
             
             if ([responseString isEqualToString:@"{\"error\":\"No card found!\"}"])
             {
                 strCradFound=@"yes";
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"No card found!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                 [alert show];
                 if (IDIOM == IPAD){
                     
                     [viewForCArd setFrame:CGRectMake(viewForCArd.frame.origin.x, viewForCArd.frame.origin.y, viewForCArd.frame.size.width,btnPayment.frame.size.height+30)];
                     
                     [btnPayment setFrame:CGRectMake(btnPayment.frame.origin.x, tbleCard.frame.origin.y+30, btnPayment.frame.size.width, btnPayment.frame.size.height)];
                     
                     
                     [lblMessage setFrame:CGRectMake(lblMessage.frame.origin.x, viewForCArd.frame.origin.y+viewForCArd.frame.size.height, lblMessage.frame.size.width, lblMessage.frame.size.height)];
                 }
             }
             else
             {
                 outputCard=output;
                 
                 if ([outputCard count]==0)
                 {
                     
                     tbleCard.hidden=YES;
                     
                     [tbleCard setFrame:CGRectMake(tbleCard.frame.origin.x, tbleCard.frame.origin.y, tbleCard.frame.size.width, 0)];
                     
                     
                 }
                 else
                 {
                     strCradFound=@"no";

                     tbleCard.hidden=NO;
                     
                     
//                     for(int j=0;j<[outputCard count];j++)
//                     {
//                         NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:[outputCard objectAtIndex:j ]];
//                         [dic setObject:@"hidemap" forKey:@"cellmap"];
//                         [[outputCard objectForKey:@"data"]replaceObjectAtIndex:j withObject:dic];
//                     }
//                     NSLog(@"%@",[outputCard objectForKey:@"data"]);
                     
                     if ([outputCard count]<8)
                     {
                         [tbleCard setFrame:CGRectMake(tbleCard.frame.origin.x, tbleCard.frame.origin.y, tbleCard.frame.size.width, 44*[outputCard count])];
                         
                         if (IDIOM == IPAD){
                             [viewForCArd setFrame:CGRectMake(viewForCArd.frame.origin.x, viewForCArd.frame.origin.y, viewForCArd.frame.size.width,btnPayment.frame.size.height/2+42+44*[outputCard count])];
                         }else{
                             [viewForCArd setFrame:CGRectMake(viewForCArd.frame.origin.x, viewForCArd.frame.origin.y, viewForCArd.frame.size.width,42+44*[outputCard count])];
                         }
                         
                         [btnPayment setFrame:CGRectMake(btnPayment.frame.origin.x, tbleCard.frame.origin.y+44*[outputCard count]+1, btnPayment.frame.size.width, btnPayment.frame.size.height)];
                         
                         
                         [lblMessage setFrame:CGRectMake(lblMessage.frame.origin.x, viewForCArd.frame.origin.y+viewForCArd.frame.size.height, lblMessage.frame.size.width, lblMessage.frame.size.height)];
                     }
                     else
                     {
                         [tbleCard setFrame:CGRectMake(tbleCard.frame.origin.x, tbleCard.frame.origin.y, tbleCard.frame.size.width, 44*8)];
                         
                         if (IDIOM == IPAD){
                             [viewForCArd setFrame:CGRectMake(viewForCArd.frame.origin.x, viewForCArd.frame.origin.y, viewForCArd.frame.size.width,btnPayment.frame.size.height/2+42+44*8)];
                         }else{
                             [viewForCArd setFrame:CGRectMake(viewForCArd.frame.origin.x, viewForCArd.frame.origin.y, viewForCArd.frame.size.width,42+44*8)];
                         }
                         
                         [btnPayment setFrame:CGRectMake(btnPayment.frame.origin.x, tbleCard.frame.origin.y+44*8+1, btnPayment.frame.size.width, btnPayment.frame.size.height)];
                         
                         
                         [lblMessage setFrame:CGRectMake(lblMessage.frame.origin.x, viewForCArd.frame.origin.y+viewForCArd.frame.size.height, lblMessage.frame.size.width, lblMessage.frame.size.height)];
                     }
                     
                    
                     
                     [tbleCard reloadData];
                     
                 }

             }
             
            
         }
         else  if ([strType isEqualToString:@"make default"])
         {
             
             if ([[output objectForKey:@"success"] isEqualToString:@"Marked as default!"])
             {
                 [tbleCard reloadData];
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Marked as default!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                 [alert show];
                 
                // [self ckeckPayMentMode];
             }
            
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

#pragma mark- UITableview delegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [outputCard count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"paymentCellIdentifier";
    
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CardCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0] ;
        
       

    } NSString *str=[NSString stringWithFormat:@"%@",[[outputCard objectAtIndex:indexPath.row]objectForKey:@"cc_number"]];
    
    NSString *code = [str substringFromIndex: [str length] -4];
    
    cell.lblCardNAme.text=[[outputCard objectAtIndex:indexPath.row]objectForKey:@"cc_type"];
    cell.lblCarsNumber.text=[NSString stringWithFormat:@"...%@",code];
    
    
    if ([[[outputCard objectAtIndex:indexPath.row]objectForKey:@"is_default"] isEqualToString:@"1"])
    {
        [cell.btnStar1 setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        cell.imgVCardIamge.image=[UIImage imageNamed:@"blackcard.png"];
        
        cell.lblCardNAme.textColor = [UIColor blackColor];
        cell.lblCarsNumber.textColor = [UIColor blackColor];
    }
    else
    {
        
        
        [cell.btnStar1 setImage:[UIImage imageNamed:@"greystar.png"] forState:UIControlStateNormal];
        cell.imgVCardIamge.image=[UIImage imageNamed:@"graycard.png"];
        
        cell.lblCardNAme.textColor = [UIColor grayColor];
        cell.lblCarsNumber.textColor = [UIColor grayColor];
        
    }
    
    if (IDIOM == IPAD){
        cell.lblCardNAme.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        cell.lblCarsNumber.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:18];

    }else{
        cell.lblCardNAme.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        cell.lblCarsNumber.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
    }
    
    
    
  
    cell.btnStar1.tag=indexPath.row;
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentDetailVC *paymentDetailob=[[PaymentDetailVC alloc]initWithNibName:@"PaymentDetailVC" bundle:nil];
    paymentDetailob.strCradType=@"SeeDetail";
    paymentDetailob.diccardDetailData=[outputCard objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:paymentDetailob animated:YES];
}

-(void)makeCardDefault:(NSInteger)indexNo
{
    
    if([QAUtils IsNetConnected])
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"userdataKey"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        // NSLog(@"%@",arr);
        
        
        
        [DSBezelActivityView  newActivityViewForView:self.view];
        
        NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"],@"user_id",
                            [[outputCard objectAtIndex:indexNo ] objectForKey:@"id"],@"user_card_id",nil];
        
        
        
        NSString *str=[NSString stringWithFormat:@"http://netleondev.com/kentapi/user/markcardasdefault"];
        
        NSURL *url =[NSURL URLWithString:str];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request addRequestHeader:@"Content-type" value:@"application/json"];
        [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
        
        [request setRequestMethod:@"POST"];
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


#pragma mark- IB_Action


-(IBAction)btn_StarDidClicked:(UIButton*)sender
{
    NSLog(@"%d",sender.tag);
    
    
    
    NSString *strIsDefault= [[outputCard  objectAtIndex:sender.tag]objectForKey:@"is_default"];
    
    
    if([strIsDefault isEqualToString:@"0"])
    {
        for (int i=0; i<[outputCard count]; i++)
        {
            NSMutableDictionary *dic=[[outputCard objectAtIndex:i] mutableCopy];
            [dic setObject:@"0" forKey:@"is_default"];
            
            [outputCard replaceObjectAtIndex:i withObject:dic];
            
        }
        
        NSMutableDictionary *dic=[[outputCard objectAtIndex:sender.tag] mutableCopy];
        [dic setObject:@"1" forKey:@"is_default"];
        // NSMutableArray *dic2= [outputCard mutableCopy];
        [outputCard replaceObjectAtIndex:sender.tag withObject:dic];
        
        //  outputCard=dic2;
        
        
        
        
        strType=@"make default";
        
        [self makeCardDefault:sender.tag];
    }
    
    
//    [tbleCard reloadData];
}




-(IBAction)btnAddPaymentDidClicked:(id)sender
{
    PaymentDetailVC *paymentDetailob=[[PaymentDetailVC alloc]initWithNibName:@"PaymentDetailVC" bundle:nil];
    paymentDetailob.strCradType=@"addCard";
    paymentDetailob.strIsFirstCard=strCradFound;
    
    [self.navigationController pushViewController:paymentDetailob animated:YES];
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
