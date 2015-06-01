//
//  upScale.m
//  kentApp
//
//  Created by pericent on 12/24/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import "upScale.h"
#import "HomeVC.h"


#import "ASIHTTPRequest.h"
#import "DSActivityView.h"
#import "JSON.h"

@interface upScale ()

@end

@implementation upScale
@synthesize arrListOfRestaurent;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // [self getRestaurantCategories];//	Get Restaurant Categories
    
    [cell.btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [cell.btnStar2 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [cell.btnStar3 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [cell.btnStar4 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [cell.btnStar5 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    
}


#pragma mark- Table View delegates and Datasource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrListOfRestaurent count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identidier=@"customeCell";
    
    cell=(UpSacleCell*)[tableView dequeueReusableCellWithIdentifier:identidier];
    
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"UpSacleCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
    }
    
    cell.lblIndex.text=[NSString stringWithFormat:@"%d",indexPath.row];
    cell.lblRestauName.text=[[arrListOfRestaurent objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.lblTime.text=[NSString stringWithFormat:@"%@  min",[[arrListOfRestaurent objectAtIndex:indexPath.row] objectForKey:@"wait_time"]];
    
    
    int rating=[[[arrListOfRestaurent objectAtIndex:indexPath.row]objectForKey:@"rating"] intValue];
    
    
    if(rating==0)
    {
        [cell.btnStar1 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar2 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar3 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar4 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    
    if(rating==1)
    {
        [cell.btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar2 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar3 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar4 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==2)
    {
        [cell.btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar2 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar3 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar4 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==3)
    {
        [cell.btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar2 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar3 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar4 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [cell.btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==4)
    {
        [cell.btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar2 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar3 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar4 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==5)
    {
        [cell.btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar2 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar3 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar4 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [cell.btnStar5 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    }

    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeVC *home=[[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
    
    //[self.navigationController popToViewController:home animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
