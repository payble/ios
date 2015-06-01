//
//  MapPointDetailVC.h
//  kentApp
//
//  Created by N@kuL on 26/12/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapPointDetailVC : UIViewController<MKMapViewDelegate>
{
    IBOutlet MKMapView *mapView1;
    
    IBOutlet UIButton *btnStar1;
    IBOutlet UIButton *btnStar2;
    IBOutlet UIButton *btnStar3;
    IBOutlet UIButton *btnStar4;
    IBOutlet UIButton *btnStar5;
    IBOutlet UIButton *btnReserveTable;


    
    IBOutlet UILabel *lblCity;
    IBOutlet UILabel *lblReviews;
    IBOutlet UILabel *lblPhoneNo;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblWaitTime;
    
}

@property(assign) CLLocationCoordinate2D loccordRestau;
@property(nonatomic,weak) NSDictionary *dicRstauDetail;

-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnReservTableDidClicked:(id)sender;
-(IBAction)btnReviewDidClicked:(id)sender;
-(IBAction)btnGetDirectionDidClicked:(id)sender;

@end
