//
//  MapPointDetailVC.m
//  kentApp
//
//  Created by N@kuL on 26/12/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import "MapPointDetailVC.h"
#import "ReserveTableVC.h"


@interface MapPointDetailVC ()

@end

@implementation MapPointDetailVC
@synthesize dicRstauDetail,loccordRestau;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    MKCoordinateRegion region1;
    region1.center=loccordRestau;
    region1.span.longitudeDelta=1 ;
    region1.span.latitudeDelta=1;
    [mapView1 setRegion:region1 animated:YES];
    
    MKPointAnnotation *point=[[MKPointAnnotation alloc]init];
    point.coordinate=loccordRestau;
    point.title=[dicRstauDetail objectForKey:@"title"];
    point.subtitle=[dicRstauDetail objectForKey:@"address"];
    [mapView1 addAnnotation:point];

    
    lblCity.text=[dicRstauDetail objectForKey:@"name"];
    lblReviews.text=[NSString stringWithFormat:@"%@ review",[dicRstauDetail objectForKey:@"review_count"]];
    lblPhoneNo.text=[dicRstauDetail objectForKey:@"phone_number"];
    lblTime.text=[dicRstauDetail objectForKey:@"wait_time"];
    
    int rating=[[dicRstauDetail objectForKey:@"rating"] intValue];
    
    
    if(rating==0)
    {
        [btnStar1 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar2 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar3 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar4 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    
    if(rating==1)
    {
        [btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar2 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar3 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar4 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==2)
    {
        [btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar2 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar3 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar4 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==3)
    {
        [btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar2 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar3 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar4 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        [btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==4)
    {
        [btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar2 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar3 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar4 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar5 setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==5)
    {
        [btnStar1 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar2 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar3 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar4 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [btnStar5 setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    }

    
  
    
}





-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKAnnotationView *pinView=(MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"custom"];
        
        if (!pinView)
        {
            pinView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"custom"];
            pinView.canShowCallout=YES;
            pinView.image=[UIImage imageNamed:@"mapicon.png"];
            pinView.calloutOffset=CGPointMake(0,32);
            
        }
        else
        {
            pinView.annotation=annotation;
        }
        return pinView;
    }
    return nil;
}




#pragma mark- IB_Action

-(IBAction)btnBackDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)btnReservTableDidClicked:(id)sender
{
    ReserveTableVC *reservTable=[[ReserveTableVC alloc]initWithNibName:@"ReserveTableVC" bundle:nil];
    [self.navigationController pushViewController:reservTable animated:YES];
    
}

-(IBAction)btnReviewDidClicked:(id)sender
{
//    ReviewVC *reviewOb=[[ReviewVC alloc]initWithNibName:@"ReviewVC" bundle:nil];
//    reviewOb.dicRestaurentDetail=dicRstauDetail;
//    [self.navigationController pushViewController:reviewOb animated:YES];
}


-(IBAction)btnGetDirectionDidClicked:(id)sender
{
    
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
