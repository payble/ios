//
//  ReservationVC.m
//  kentApp
//
//  Created by N@kuL on 08/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "ReservationVC.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "QAUtils.h"
#import "DSActivityView.h"


@interface ReservationVC ()

@end

@implementation ReservationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tbleResrvation.separatorColor=[UIColor clearColor];
    tbleResrvation.hidden=YES;
    
    [self fetchUserReservation];
    
    if (IDIOM == IPAD){
        lblRestro.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblStart.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblEnd.font         =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblPartySize.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTitle.font       =   [UIFont fontWithName:FONT_TITLE size:22];
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        
        lblTitle.frame      =   CGRectMake(0, lblTitle.frame.origin.y, [UIScreen mainScreen].bounds.size.width, lblTitle.frame.size.height);
    }else{
        lblRestro.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblStart.font       =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblEnd.font         =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblPartySize.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTitle.font       =   [UIFont fontWithName:FONT_TITLE size:14];
        btnBack.titleLabel.font =   [UIFont fontWithName:FONT_TITLE size:12];
    }
    
}




-(void)fetchUserReservation
{
    if([QAUtils IsNetConnected])
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"userdataKey"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        // NSLog(@"%@",arr);
        
        //netleondev.com/kentapi/user/reservations/userid/{user_id}
        
        [DSBezelActivityView  newActivityViewForView:self.view];
        
        NSString *str=[NSString stringWithFormat:@"http://netleondev.com/kentapi/user/reservations/userid/%@",[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"id"]];
        
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
        
        if([responseString isEqualToString:@"{\"error\":\"No Reservation Found!\"}"])
        {
            
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[dic objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            SBJSON *jsonParser=[[SBJSON alloc] init];
            outputUserReservation=[jsonParser objectWithString:responseString error:nil];
            
            
            tbleResrvation.hidden=NO;

            
            [tbleResrvation reloadData];
            
            
            
            
            
            
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

#pragma mark- IB_Action

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [outputUserReservation count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    
    cell=(ReservationTableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ReservationTableCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    
    
    
    NSArray *arrstartDAte=[[[outputUserReservation objectAtIndex:[outputUserReservation count]-1-indexPath.row] objectForKey:@"start_date"] componentsSeparatedByString:@" "];
    
    NSArray *arrEndDAte=[[[outputUserReservation objectAtIndex:[outputUserReservation count]-1-indexPath.row] objectForKey:@"end_date"] componentsSeparatedByString:@" "];
    
    if (IDIOM == IPAD){
        cell.lblRestauName.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        cell.lblStardDate.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        cell.lblStardTime.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        cell.lblEndDate.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        cell.lblEndTime.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        cell.lblPartSize.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        cell.lblRestauName.frame    =   CGRectMake(cell.lblRestauName.frame.origin.x, cell.lblRestauName.frame.origin.y, cell.lblRestauName.frame.size.width+100, cell.lblRestauName.frame.size.height);
        cell.lblStardDate.frame    =   CGRectMake(cell.lblStardDate.frame.origin.x-20, cell.lblStardDate.frame.origin.y, cell.lblStardDate.frame.size.width, cell.lblStardDate.frame.size.height);
        cell.lblStardTime.frame    =   CGRectMake(cell.lblStardTime.frame.origin.x-20, cell.lblStardTime.frame.origin.y, cell.lblStardTime.frame.size.width, cell.lblStardTime.frame.size.height);
        cell.lblEndDate.frame    =   CGRectMake(cell.lblEndDate.frame.origin.x, cell.lblEndDate.frame.origin.y, cell.lblEndDate.frame.size.width, cell.lblEndDate.frame.size.height);
        cell.lblEndTime.frame    =   CGRectMake(cell.lblEndTime.frame.origin.x, cell.lblEndTime.frame.origin.y, cell.lblEndTime.frame.size.width, cell.lblEndTime.frame.size.height);
        cell.lblPartSize.frame    =   CGRectMake(cell.lblPartSize.frame.origin.x, cell.lblPartSize.frame.origin.y, cell.lblPartSize.frame.size.width, cell.lblPartSize.frame.size.height);
    }else{
        cell.lblRestauName.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        cell.lblStardDate.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        cell.lblStardTime.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        cell.lblEndDate.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        cell.lblEndTime.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        cell.lblPartSize.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
    }
    
    cell.lblRestauName.text=[[outputUserReservation objectAtIndex:[outputUserReservation count]-1-indexPath.row] objectForKey:@"restaurant_name"];
    cell.lblStardDate.text=[arrstartDAte objectAtIndex:0];
    cell.lblStardTime.text=[arrstartDAte objectAtIndex:1];
    cell.lblEndDate.text=[arrEndDAte objectAtIndex:0];
    cell.lblEndTime.text=[arrEndDAte objectAtIndex:1];
    cell.lblPartSize.text=[[outputUserReservation objectAtIndex:[outputUserReservation count]-1-indexPath.row] objectForKey:@"party_size"];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark- IB_Action
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
