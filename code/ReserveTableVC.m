//
//  ReserveTableVC.m
//  kentApp
//
//  Created by N@kuL on 26/12/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import "ReserveTableVC.h"

@interface ReserveTableVC ()

@end

@implementation ReserveTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IDIOM == IPAD){
        lblMinWait.frame    =   CGRectMake(lblMinWait.frame.origin.x+20, lblMinWait.frame.origin.y, lblMinWait.frame.size.width, lblMinWait.frame.size.height);
    }
}


#pragma mark- tableview deleagte and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"customeCell";
    cell=(ReserveTableVCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ReserveTableVCell" owner:self options:nil];
        
        cell=[nib objectAtIndex:0];
    }
    cell.imgVProPick.layer.cornerRadius=cell.imgVProPick.frame.size.width/2;
    cell.imgVProPick.clipsToBounds=YES;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}


#pragma mark- IB_Action

-(IBAction)btnBackDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnReservTableDidClicked:(id)sender
{
//    ReserveTableVC *reservTable=[[ReserveTableVC alloc]initWithNibName:@"ReserveTableVC" bundle:nil];
//    [self.navigationController pushViewController:reservTable animated:YES];
    
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
