//
//  ThanksForReviewVC.m
//  kentApp
//
//  Created by N@kuL on 12/01/15.
//  Copyright (c) 2015 pericent. All rights reserved.
//

#import "ThanksForReviewVC.h"

@interface ThanksForReviewVC ()

@end

@implementation ThanksForReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark- IB_Action
-(IBAction)btnBackDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)btnHomeDidClicked:(id)sender
{
    //HomeVC *home=[[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
    
    for (UIViewController *viw in [self.navigationController viewControllers])
    {
        if ([viw isKindOfClass:[HomeVC class]])
        {
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
