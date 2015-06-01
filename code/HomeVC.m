//
//  HomeVC.m
//  kentApp
//
//  Created by N@kuL on 22/12/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import "HomeVC.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "DSActivityView.h"
#import "CreateReservationVC.h"

#import "RNBlurModalView.h"

//#import "NSData+Base64.h"


#import "login.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isProfileOpening    =   0;
    isProfileClosing    =   0;
    isCasualOpening     =   0;
    isFineOpening       =   0;
    isRecommendedOpening=   0;
    isCasualClosing     =   0;
    isRestroOpening     =   0;
    isRestroClosing     =   0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"userdataKey"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@",arr);
    isDirectReservation = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterReservationDirect) name:@"AfterReservation" object:nil];
    
    
    lblUserName.text=[NSString stringWithFormat:@"%@ %@ ",[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"first_name"],[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"last_name"]];
    
//    @"userdataKey"
    
    if ([[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"photo"] isKindOfClass:[NSNull class]])
    {
        
    }
    else
    {
        [self performSelector:@selector(getProfilePic:) withObject:data afterDelay:0.01];
    }
  
    
    locationManager=[[CLLocationManager alloc]init];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];
        }
        
        
        
    }
    
    dicSearchId=[[NSMutableDictionary alloc]init];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapONMap)];
    
    [mapView addGestureRecognizer:tap];


    
    mapView.showsUserLocation=TRUE;
    
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:NO];
    
    
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=100.0f;
    
    
    imgViewUserProfile.layer.cornerRadius=imgViewUserProfile.frame.size.width/2;
    imgViewUserProfile.layer.masksToBounds=YES;
    imgViewUserProfile.clipsToBounds=YES;
    
//    imgViewUserOnEDitProfile.frame  =   CGRectMake(imgViewUserOnEDitProfile.frame.origin.x, imgViewUserOnEDitProfile.frame.origin.y, imgViewUserOnEDitProfile.frame.size.width, imgViewUserOnEDitProfile.frame.size.width);
    imgViewUserOnEDitProfile.layer.cornerRadius=imgViewUserOnEDitProfile.frame.size.width/2;
    imgViewUserOnEDitProfile.layer.masksToBounds=YES;
    imgViewUserOnEDitProfile.clipsToBounds=YES;
    
    seeProfile.layer.cornerRadius=5.0f;
    seeProfile.clipsToBounds=YES;
    changeProfile.layer.cornerRadius=5.0f;
    changeProfile.clipsToBounds=YES;
    
     ViewDropdown.hidden = YES;
    viewRestauInfo.hidden=YES;
    viewPriceCFU.hidden=NO;
    
    
    ViewDropdown.layer.cornerRadius=5.0f;
    ViewDropdown.clipsToBounds=YES;
    
    viewBelowSearch.layer.cornerRadius=5.0f;
    viewBelowSearch.clipsToBounds=YES;
    
    btnReserveTable.layer.cornerRadius=12.0f;
    btnReserveTable.clipsToBounds=YES;
    
    btnReserve2Table2.layer.cornerRadius=12.0f;
    btnReserve2Table2.clipsToBounds=YES;
    
    tlbV.separatorColor=[UIColor clearColor];
    tblVUpscale.separatorColor=[UIColor clearColor];
    tblVUpscale.backgroundColor=[UIColor clearColor];
    tlbV.backgroundColor=[UIColor clearColor];
    
    lblReceiptNumbewr.layer.borderColor=[UIColor grayColor].CGColor;
    lblReceiptNumbewr.layer.borderWidth=2.0f;
    
    lblReceiptNumbewr.text=@"0";
    lblReceiptNumbewr.layer.cornerRadius=lblReceiptNumbewr.frame.size.width/2;
    lblReceiptNumbewr.clipsToBounds=YES;
    
    
    
    
    arrAfterSearch=[NSMutableArray new];
    arrDataOfAfterSearch=[NSMutableArray new];
    arrTemp=[NSMutableArray new];
    
//    [self getAllRestaurants];
    [self performSelector:@selector(getAllRestaurants) withObject:nil afterDelay:0.01];
    
    UISwipeGestureRecognizer *swipeUpForCasual;
    
    swipeUpForCasual = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeCasual:)];
    swipeUpForCasual.direction = UISwipeGestureRecognizerDirectionUp;
    [btnSwipeOnCasual addGestureRecognizer:swipeUpForCasual];
    
    UISwipeGestureRecognizer *swipeUpForFine;
    
    swipeUpForFine = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFine:)];
    swipeUpForFine.direction = UISwipeGestureRecognizerDirectionUp;
    [btnSwipeOnFine addGestureRecognizer:swipeUpForFine];
    
    
    UISwipeGestureRecognizer *swipeUpForRecomended;

    swipeUpForRecomended = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRecomended:)];
    swipeUpForRecomended.direction = UISwipeGestureRecognizerDirectionUp;
    [btnSwipeOnRecommended addGestureRecognizer:swipeUpForRecomended];
    
    //
  
    UISwipeGestureRecognizer *swipeUpForCasual2;
    
    swipeUpForCasual2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    swipeUpForCasual2.direction = UISwipeGestureRecognizerDirectionDown;
    [btnCasual2 addGestureRecognizer:swipeUpForCasual2];
    
    UISwipeGestureRecognizer *swipeUpForFine2;
    
    swipeUpForFine2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    swipeUpForFine2.direction = UISwipeGestureRecognizerDirectionDown;
    [btnFine2 addGestureRecognizer:swipeUpForFine2];
    
    
    UISwipeGestureRecognizer *swipeUpForRecomended2;
    
    swipeUpForRecomended2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    swipeUpForRecomended2.direction = UISwipeGestureRecognizerDirectionDown;
    [btnRecomended addGestureRecognizer:swipeUpForRecomended2];
    
//    btnCasual2.backgroundColor  =   [UIColor redColor];
//    btnFine2.backgroundColor  =   [UIColor greenColor];
//    btnRecomended.backgroundColor  =   [UIColor yellowColor];
    
    UISwipeGestureRecognizer *swipeUpForProfileCncl;
    
    swipeUpForProfileCncl = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpUserProfile:)];
    swipeUpForProfileCncl.direction = UISwipeGestureRecognizerDirectionUp;
    [btnProfileCncl addGestureRecognizer:swipeUpForProfileCncl];
    
    UISwipeGestureRecognizer *swipeDownForRestroReview;
    
    swipeDownForRestroReview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownForRestroReview:)];
    swipeDownForRestroReview.direction = UISwipeGestureRecognizerDirectionDown;
//    [viewRestroInfoWithReview addGestureRecognizer:swipeDownForRestroReview];
    
//    btnProfileCncl.backgroundColor  =   [UIColor redColor];
    
    if (IDIOM == IPAD) {
        btnCasual2.frame    =   CGRectMake(btnCasual2.frame.origin.x-btnCasual2.frame.size.width/2, btnCasual2.frame.origin.y-20, btnCasual2.frame.size.width*2, btnCasual2.frame.size.height+40);
        btnFine2.frame    =   CGRectMake(btnFine2.frame.origin.x-btnFine2.frame.size.width/2, btnFine2.frame.origin.y-20, btnFine2.frame.size.width*2, btnFine2.frame.size.height+40);
        btnRecomended.frame    =   CGRectMake(btnRecomended.frame.origin.x-btnRecomended.frame.size.width/2, btnRecomended.frame.origin.y-20, btnRecomended.frame.size.width*2, btnRecomended.frame.size.height+40);
        
        btnSwipeOnCasual.frame    =   CGRectMake(btnSwipeOnCasual.frame.origin.x-btnSwipeOnCasual.frame.size.width/2, btnSwipeOnCasual.frame.origin.y-7, btnSwipeOnCasual.frame.size.width*2, btnSwipeOnCasual.frame.size.height+14);
        btnSwipeOnFine.frame    =   CGRectMake(btnSwipeOnFine.frame.origin.x-btnSwipeOnFine.frame.size.width/2, btnSwipeOnFine.frame.origin.y-7, btnSwipeOnFine.frame.size.width*2, btnSwipeOnFine.frame.size.height+14);
        btnSwipeOnRecommended.frame    =   CGRectMake(btnSwipeOnRecommended.frame.origin.x-btnSwipeOnRecommended.frame.size.width*0.35, btnSwipeOnRecommended.frame.origin.y-7, btnSwipeOnRecommended.frame.size.width*2, btnSwipeOnRecommended.frame.size.height+14);
        
        btnProfileCncl.frame    =   CGRectMake(btnProfileCncl.frame.origin.x, btnProfileCncl.frame.origin.y-btnProfileCncl.frame.size.height*0.90, btnProfileCncl.frame.size.width, btnProfileCncl.frame.size.height*2.8);
        
        btnReviews.frame    =   CGRectMake(btnReviews.frame.origin.x-btnReviews.frame.size.width*0.40, btnReviews.frame.origin.y, btnReviews.frame.size.width*1.8, btnReviews.frame.size.height);
    }else{
        
        btnCasual2.frame    =   CGRectMake(btnCasual2.frame.origin.x-btnCasual2.frame.size.width, btnCasual2.frame.origin.y-20, btnCasual2.frame.size.width*3, btnCasual2.frame.size.height+40);
        btnFine2.frame    =   CGRectMake(btnFine2.frame.origin.x-btnFine2.frame.size.width, btnFine2.frame.origin.y-20, btnFine2.frame.size.width*3, btnFine2.frame.size.height+40);
        btnRecomended.frame    =   CGRectMake(btnRecomended.frame.origin.x-btnRecomended.frame.size.width, btnRecomended.frame.origin.y-20, btnRecomended.frame.size.width*3, btnRecomended.frame.size.height+40);
        
        btnSwipeOnCasual.frame    =   CGRectMake(btnSwipeOnCasual.frame.origin.x-btnSwipeOnCasual.frame.size.width/2, btnSwipeOnCasual.frame.origin.y-7, btnSwipeOnCasual.frame.size.width*2, btnSwipeOnCasual.frame.size.height+14);
        btnSwipeOnFine.frame    =   CGRectMake(btnSwipeOnFine.frame.origin.x-btnSwipeOnFine.frame.size.width/2, btnSwipeOnFine.frame.origin.y-7, btnSwipeOnFine.frame.size.width*2, btnSwipeOnFine.frame.size.height+14);
        btnSwipeOnRecommended.frame    =   CGRectMake(btnSwipeOnRecommended.frame.origin.x-btnSwipeOnRecommended.frame.size.width*0.25, btnSwipeOnRecommended.frame.origin.y-7, btnSwipeOnRecommended.frame.size.width*1.70, btnSwipeOnRecommended.frame.size.height+14);
        
        lblRecommended.frame    =   CGRectMake(lblRecommended.frame.origin.x+15, lblRecommended.frame.origin.y, lblRecommended.frame.size.width, lblRecommended.frame.size.height);
        
        btnProfileCncl.frame    =   CGRectMake(btnProfileCncl.frame.origin.x, btnProfileCncl.frame.origin.y-btnProfileCncl.frame.size.height*0.50, btnProfileCncl.frame.size.width, btnProfileCncl.frame.size.height*2);
        
        btnReviews.frame    =   CGRectMake(btnReviews.frame.origin.x-btnReviews.frame.size.width*0.40, btnReviews.frame.origin.y, btnReviews.frame.size.width*1.8, btnReviews.frame.size.height);
    }
    
    
    
    //
    
    UISwipeGestureRecognizer *swipeUpForReview;
    
    swipeUpForReview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeForREVIEWS:)];
    swipeUpForReview.direction = UISwipeGestureRecognizerDirectionUp;
    [btnReviews addGestureRecognizer:swipeUpForReview];
    
//    btnReviews.backgroundColor  =   [UIColor redColor];
    
    
    UISwipeGestureRecognizer *swipeDownForUser;
    
    swipeDownForUser = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeForBtnUSeR:)];
    swipeDownForUser.direction = UISwipeGestureRecognizerDirectionDown;
//    [btnUser addGestureRecognizer:swipeDownForUser];
 
    
//    Api_connect *api=[Api_connect serviceStart];
//    [api getFilterCategory:self action:@selector(getFilterCategoryHandlert:)];
    
//    tlbV.style  =   UITableViewStyleGrouped;
    
    NSMutableArray *imageNames  =   [[NSMutableArray alloc]initWithObjects:@"ic_direction_gray.png",@"ic_call_gray.png",@"browse_menu.png",@"ic_action_message.png",@"ic_action_overflow.png", nil];
    
    NSMutableArray *textArr  =   [[NSMutableArray alloc]initWithObjects:@"Directions",@"Call",@"Browse the Menu",@"Message the Business",@"More Info", nil];
    
    restroMenuOptionsViewArr    =   [[NSMutableArray alloc]init];
    
    // Redesign for iPad
    if ( IDIOM == IPAD ) {
        
        btnTitle.frame  =   CGRectMake(btnTitle.frame.origin.x-btnTitle.frame.size.width*0.10, btnTitle.frame.origin.y-btnTitle.frame.size.height*0.10, btnTitle.frame.size.width*1.2, btnTitle.frame.size.height*1.2);
        
        ViewDropdown.frame  =   CGRectMake(ViewDropdown.frame.origin.x, ViewDropdown.frame.origin.y-12.5, ViewDropdown.frame.size.width, ViewDropdown.frame.size.height);
        
        imgUserMenu.frame   =   CGRectMake(imgUserMenu.frame.origin.x, imgUserMenu.frame.origin.y-imgUserMenu.frame.size.height*0.25, imgUserMenu.frame.size.width*1.5, imgUserMenu.frame.size.height*1.5);
        
        imgProFindRestaurant.frame  =   CGRectMake(imgProFindRestaurant.frame.origin.x+5, imgProFindRestaurant.frame.origin.y-imgProPayWith.frame.size.height*0.25, imgProFindRestaurant.frame.size.width*1.5, imgProFindRestaurant.frame.size.height*1.5);
        imgProPayWith.frame  =   CGRectMake(imgProPayWith.frame.origin.x+5, imgProPayWith.frame.origin.y-imgProPayWith.frame.size.height*0.25, imgProPayWith.frame.size.width*1.5, imgProPayWith.frame.size.height*1.5);
        imgProPayment.frame  =   CGRectMake(imgProPayment.frame.origin.x+5, imgProPayment.frame.origin.y-imgProPayWith.frame.size.height*0.25, imgProPayment.frame.size.width*1.5, imgProPayment.frame.size.height*1.5);
        imgProReservation.frame  =   CGRectMake(imgProReservation.frame.origin.x+5, imgProReservation.frame.origin.y-imgProPayWith.frame.size.height*0.25, imgProReservation.frame.size.width*1.5, imgProReservation.frame.size.height*1.5);
        imgProReceipt.frame  =   CGRectMake(imgProReceipt.frame.origin.x+5, imgProReceipt.frame.origin.y-imgProPayWith.frame.size.height*0.25, imgProReceipt.frame.size.width*1.5, imgProReceipt.frame.size.height*1.5);
        imgProSupport.frame  =   CGRectMake(imgProSupport.frame.origin.x+5, imgProSupport.frame.origin.y-imgProPayWith.frame.size.height*0.25, imgProSupport.frame.size.width*1.5, imgProSupport.frame.size.height*1.5);
        imgProLogOut.frame  =   CGRectMake(imgProLogOut.frame.origin.x+5, imgProLogOut.frame.origin.y-imgProPayWith.frame.size.height*0.25, imgProLogOut.frame.size.width*1.5, imgProLogOut.frame.size.height*1.5);
        
        viewRestauInfo.frame    =   CGRectMake(viewRestauInfo.frame.origin.x, viewRestauInfo.frame.origin.y-58, viewRestauInfo.frame.size.width, viewRestauInfo.frame.size.height+60);
        
        btnCurrentLoc.frame     =   CGRectMake(btnCurrentLoc.frame.origin.x-btnCurrentLoc.frame.size.width, btnCurrentLoc.frame.origin.y, btnCurrentLoc.frame.size.width*2, btnCurrentLoc.frame.size.width*2);
        
        editProfile.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        editProfile.frame   =   CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        imgViewUserOnEDitProfile.frame                =   CGRectMake(imgViewUserOnEDitProfile.frame.origin.x-imgViewUserOnEDitProfile.frame.size.width/2, imgViewUserOnEDitProfile.frame.origin.y-15, imgViewUserOnEDitProfile.frame.size.width*2, imgViewUserOnEDitProfile.frame.size.width*2);
        imgViewUserOnEDitProfile.layer.cornerRadius     =   imgViewUserOnEDitProfile.frame.size.width/2;
        imgViewUserOnEDitProfile.layer.masksToBounds    =   YES;
        
        imgViewUserProfile.frame                =   CGRectMake(imgViewUserProfile.frame.origin.x-imgViewUserProfile.frame.size.width/2, imgViewUserProfile.frame.origin.y-15, imgViewUserProfile.frame.size.width*2, imgViewUserProfile.frame.size.width*2);
        imgViewUserProfile.layer.cornerRadius   =   imgViewUserProfile.frame.size.width/2;
        imgViewUserProfile.layer.masksToBounds  =   YES;
        
        seeProfile.frame    =   CGRectMake(seeProfile.frame.origin.x, seeProfile.frame.origin.y+30, seeProfile.frame.size.width, seeProfile.frame.size.height);
        changeProfile.frame    =   CGRectMake(changeProfile.frame.origin.x, changeProfile.frame.origin.y+30, changeProfile.frame.size.width, changeProfile.frame.size.height);
        
        btnReserveTable.frame   =   CGRectMake(btnReserveTable.frame.origin.x-btnReserveTable.frame.size.width*0.50, btnReserveTable.frame.origin.y-btnReserveTable.frame.size.height*0.25, btnReserveTable.frame.size.width*1.5, btnReserveTable.frame.size.height*1.5);
        btnReserveTable.layer.cornerRadius=btnReserveTable.frame.size.height/2;
        btnReserveTable.clipsToBounds=YES;
        btnReserveTable.layer.masksToBounds =   YES;
        
        btnReserve2Table2.frame   =   CGRectMake(btnReserve2Table2.frame.origin.x-btnReserve2Table2.frame.size.width*0.50, btnReserve2Table2.frame.origin.y-btnReserve2Table2.frame.size.height*0.25, btnReserve2Table2.frame.size.width*1.5, btnReserve2Table2.frame.size.height*1.5);
        btnReserve2Table2.layer.cornerRadius=btnReserve2Table2.frame.size.height/2;
        btnReserve2Table2.clipsToBounds=YES;
        btnReserve2Table2.layer.masksToBounds =   YES;
        
        txtFFirstnameH1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFMobileH1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFEmailH1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        txtFFirstname.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFEmail.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFMobile.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFPassword.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblFEditProfileDetail.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFEditProfileName.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFEditProfileName1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFEditProfileEmail.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFEditProfileEmail1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFEditProfileMob.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFEditProfileMob1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFEditProfilePass.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        btnFEditProfileSave.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFindRestaurant.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblPayWithKent.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblPayment.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblReservation.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblReceipt.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblSupport.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblLogout.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        btnProfileCncl.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        btnProfileViewAccount.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        lblUserName.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        txtFSearch.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblLocation.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:19];
        txtFLocation.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:19];
        lblPrizeCasual.font =   [UIFont fontWithName:FONT_NAME_MAIN size:19];
        txtFPrizeCasual.font=   [UIFont fontWithName:FONT_NAME_MAIN size:19];
        lblCatgory.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:19];
        txtFCatgory.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:19];
        btnDropDownSearch.titleLabel.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:25];
        lblReviews1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblMinWaitBtm.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblMinWait.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblReviews.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        btnReserveTable.titleLabel.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        btnReserve2Table2.titleLabel.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblRestauName.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:32];
        lblRestauName1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:32];
        lblPhoneNo.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblPhoneNo1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblGetDirection.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblGetDirection1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblTime.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:32];
        lblTime1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:32];
        
        // After animation
        lblCasual.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFine.font        =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblRecommended.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        // Default on screen
        lblCasualBtm.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblFineBtm.font        =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        lblRecommendedBtm.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        btnBackOnEditProfile.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:20];
        btnEditOnEditProfile.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:20];
        btnONWifi.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:20];
        lblEditProTitle.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        
        txtFFirstnameH1.frame   =   CGRectMake(lblFEditProfileName.frame.origin.x+lblFEditProfileName.frame.size.width*1.15, txtFFirstnameH1.frame.origin.y, txtFFirstnameH1.frame.size.width*2, txtFFirstnameH1.frame.size.height);
        txtFMobileH1.frame   =   CGRectMake(lblFEditProfileName.frame.origin.x+lblFEditProfileName.frame.size.width*1.15, txtFMobileH1.frame.origin.y, txtFMobileH1.frame.size.width*2, txtFMobileH1.frame.size.height);
        txtFEmailH1.frame   =   CGRectMake(lblFEditProfileName.frame.origin.x+lblFEditProfileName.frame.size.width*1.15, txtFEmailH1.frame.origin.y, txtFEmailH1.frame.size.width*2, txtFEmailH1.frame.size.height);
        txtFFirstname.frame   =   CGRectMake(lblFEditProfileName.frame.origin.x+lblFEditProfileName.frame.size.width*1.15, txtFFirstname.frame.origin.y, txtFFirstname.frame.size.width*2, txtFFirstname.frame.size.height);
        txtFEmail.frame   =   CGRectMake(lblFEditProfileName.frame.origin.x+lblFEditProfileName.frame.size.width*1.15, txtFEmail.frame.origin.y, txtFEmail.frame.size.width*2, txtFEmail.frame.size.height);
        txtFMobile.frame   =   CGRectMake(lblFEditProfileName.frame.origin.x+lblFEditProfileName.frame.size.width*1.15, txtFMobile.frame.origin.y, txtFMobile.frame.size.width*2, txtFMobile.frame.size.height);
        txtFPassword.frame   =   CGRectMake(lblFEditProfileName.frame.origin.x+lblFEditProfileName.frame.size.width*1.15, txtFPassword.frame.origin.y, txtFPassword.frame.size.width*2, txtFPassword.frame.size.height);
        
        
        
        lblFEditProfileDetail.frame =   CGRectMake(lblFEditProfileDetail.frame.origin.x, lblFEditProfileDetail.frame.origin.y+15, lblFEditProfileDetail.frame.size.width, lblFEditProfileDetail.frame.size.height);
        
//        imgViewWIfi.frame   =   CGRectMake(282, 20, 24, 24);
        imgViewWIfi.frame   =   CGRectMake(imgViewWIfi.frame.origin.x-imgViewWIfi.frame.size.width*0.50, imgViewWIfi.frame.origin.y-imgViewWIfi.frame.size.height*0.40, imgViewWIfi.frame.size.width*1.5, imgViewWIfi.frame.size.height*1.5);
        imgViewWIfi.image   =   [UIImage imageNamed:@"wifi@3x.png"];
//        viewRestaurentListAfterSearch.frame =   CGRectMake(viewRestaurentListAfterSearch.frame.origin.x, viewRestaurentListAfterSearch.frame.origin.y+40, viewRestaurentListAfterSearch.frame.size.width, viewRestaurentListAfterSearch.frame.size.height);
        tblVUpscale.frame   =   CGRectMake(tblVUpscale.frame.origin.x, tblVUpscale.frame.origin.y+50, tblVUpscale.frame.size.width, tblVUpscale.frame.size.height);
        
        lblFindRestaurant.frame =   CGRectMake(lblFindRestaurant.frame.origin.x+30, lblFindRestaurant.frame.origin.y, lblFindRestaurant.frame.size.width, lblFindRestaurant.frame.size.height);
        lblPayWithKent.frame =   CGRectMake(lblPayWithKent.frame.origin.x+30, lblPayWithKent.frame.origin.y, lblPayWithKent.frame.size.width, lblPayWithKent.frame.size.height);
        lblPayment.frame =   CGRectMake(lblPayment.frame.origin.x+30, lblPayment.frame.origin.y, lblPayment.frame.size.width, lblPayment.frame.size.height);
        lblReservation.frame =   CGRectMake(lblReservation.frame.origin.x+30, lblReservation.frame.origin.y, lblReservation.frame.size.width, lblReservation.frame.size.height);
        lblReceipt.frame =   CGRectMake(lblReceipt.frame.origin.x+30, lblReceipt.frame.origin.y, lblReceipt.frame.size.width, lblReceipt.frame.size.height);
        lblSupport.frame =   CGRectMake(lblSupport.frame.origin.x+30, lblSupport.frame.origin.y, lblSupport.frame.size.width, lblSupport.frame.size.height);
        lblLogout.frame =   CGRectMake(lblLogout.frame.origin.x+30, lblLogout.frame.origin.y, lblLogout.frame.size.width, lblLogout.frame.size.height);
        
        
        lblUserName.frame   =   CGRectMake(lblUserName.frame.origin.x, lblUserName.frame.origin.y-5, lblUserName.frame.size.width, lblUserName.frame.size.height+5);
        
        btnAdvncSearch.frame    =   CGRectMake(btnAdvncSearch.frame.origin.x+200, btnAdvncSearch.frame.origin.y, btnAdvncSearch.frame.size.width-200, btnAdvncSearch.frame.size.height);
        
//        btnAdvncSearch.backgroundColor  =   [UIColor cyanColor];
        imgViewLeftSearch.frame =   CGRectMake(imgViewLeftSearch.frame.origin.x, imgViewLeftSearch.frame.origin.y-7, imgViewLeftSearch.frame.size.width, imgViewLeftSearch.frame.size.height+14);
        txtFLocation.frame  =   CGRectMake(txtFLocation.frame.origin.x, txtFLocation.frame.origin.y+5, txtFLocation.frame.size.width, txtFLocation.frame.size.height);
//        txtFSearch.backgroundColor  =   [UIColor cyanColor];
        txtFSearch.frame    =   CGRectMake(txtFSearch.frame.origin.x+50, txtFSearch.frame.origin.y, txtFSearch.frame.size.width-50, txtFSearch.frame.size.height);
        
//        lblRecommended.frame    =   CGRectMake(lblRecommended.frame.origin.x+10, lblRecommended.frame.origin.y, lblRecommended.frame.size.width, lblRecommended.frame.size.height);
        lblRecommended.textAlignment    =   NSTextAlignmentCenter;
        lblMinWait.frame    =   CGRectMake(lblMinWait.frame.origin.x-25, lblMinWait.frame.origin.y, lblMinWait.frame.size.width, lblMinWait.frame.size.height);
        lblMinWaitBtm.frame    =   CGRectMake(lblMinWaitBtm.frame.origin.x+25, lblMinWaitBtm.frame.origin.y, lblMinWaitBtm.frame.size.width, lblMinWaitBtm.frame.size.height);
        lblReviews1.frame   =   CGRectMake(lblReviews1.frame.origin.x+45, lblReviews1.frame.origin.y-2, lblReviews1.frame.size.width, lblReviews1.frame.size.height);
        
        lblTime.frame   =   CGRectMake(lblTime.frame.origin.x-10, lblTime.frame.origin.y, lblTime.frame.size.width-10, lblTime.frame.size.height);
//        lblTime1.backgroundColor =   [UIColor cyanColor];
        lblTime1.frame   =   CGRectMake(lblTime1.frame.origin.x-10, lblTime1.frame.origin.y, lblTime1.frame.size.width-15, lblTime1.frame.size.height);
        
        lblRestauName.frame     =   CGRectMake(imgStar1.frame.origin.x+5, lblRestauName.frame.origin.y, lblRestauName.frame.size.width, lblRestauName.frame.size.height);
        lblRestauName1.frame     =   CGRectMake(imgStar11.frame.origin.x+5, lblRestauName1.frame.origin.y, lblRestauName1.frame.size.width, lblRestauName1.frame.size.height);
        
        
        imgStar11.frame =   CGRectMake(imgStar11.frame.origin.x+5, imgStar11.frame.origin.y, imgStar11.frame.size.width/2, imgStar11.frame.size.height/2);
        
        imgStar22.frame =   CGRectMake(imgStar11.frame.origin.x+imgStar11.frame.size.width+2, imgStar22.frame.origin.y, imgStar22.frame.size.width/2, imgStar22.frame.size.height/2);
        imgStar33.frame =   CGRectMake(imgStar22.frame.origin.x+imgStar22.frame.size.width+2, imgStar33.frame.origin.y, imgStar33.frame.size.width/2, imgStar33.frame.size.height/2);
        imgStar44.frame =   CGRectMake(imgStar33.frame.origin.x+imgStar33.frame.size.width+2, imgStar44.frame.origin.y, imgStar44.frame.size.width/2, imgStar44.frame.size.height/2);
        imgStar55.frame =   CGRectMake(imgStar44.frame.origin.x+imgStar44.frame.size.width+2, imgStar55.frame.origin.y, imgStar55.frame.size.width/2, imgStar55.frame.size.height/2);

        imgStar1.frame =   CGRectMake(imgStar1.frame.origin.x+5, imgStar1.frame.origin.y, imgStar1.frame.size.width/2, imgStar1.frame.size.height);
        imgStar2.frame =   CGRectMake(imgStar1.frame.origin.x+imgStar1.frame.size.width+2, imgStar2.frame.origin.y, imgStar2.frame.size.width/2, imgStar2.frame.size.height);
        imgStar3.frame =   CGRectMake(imgStar2.frame.origin.x+imgStar2.frame.size.width+2, imgStar3.frame.origin.y, imgStar3.frame.size.width/2, imgStar3.frame.size.height);
        imgStar4.frame =   CGRectMake(imgStar3.frame.origin.x+imgStar3.frame.size.width+2, imgStar4.frame.origin.y, imgStar4.frame.size.width/2, imgStar4.frame.size.height);
        imgStar5.frame =   CGRectMake(imgStar4.frame.origin.x+imgStar4.frame.size.width+2, imgStar5.frame.origin.y, imgStar5.frame.size.width/2, imgStar5.frame.size.height);
        lblReviews.frame    =   CGRectMake(lblReviews.frame.origin.x+45, lblReviews.frame.origin.y+2, lblReviews.frame.size.width, lblReviews.frame.size.height);
        
        imgStar11.contentMode   =   UIViewContentModeScaleAspectFill;
        imgStar22.contentMode   =   UIViewContentModeScaleAspectFill;
        imgStar33.contentMode   =   UIViewContentModeScaleAspectFill;
        imgStar44.contentMode   =   UIViewContentModeScaleAspectFill;
        imgStar55.contentMode   =   UIViewContentModeScaleAspectFill;
        imgStar1.contentMode   =   UIViewContentModeScaleAspectFill;
        imgStar2.contentMode   =   UIViewContentModeScaleAspectFill;
        imgStar3.contentMode   =   UIViewContentModeScaleAspectFill;
        imgStar4.contentMode   =   UIViewContentModeScaleAspectFill;
        imgStar5.contentMode   =   UIViewContentModeScaleAspectFill;
        
        imgPhoneImg1.frame  =   CGRectMake(imgPhoneImg1.frame.origin.x-120, imgPhoneImg1.frame.origin.y-2, imgPhoneImg1.frame.size.width*2, imgPhoneImg1.frame.size.height*2);
        imgMapImg1.frame  =   CGRectMake(imgMapImg1.frame.origin.x-120, imgMapImg1.frame.origin.y-10, imgMapImg1.frame.size.width*2, imgMapImg1.frame.size.height*2);
        imgPhoneImg.frame  =   CGRectMake(imgPhoneImg.frame.origin.x-10, imgPhoneImg.frame.origin.y, imgPhoneImg.frame.size.width*2, imgPhoneImg.frame.size.height*2);
        imgMapImg.frame  =   CGRectMake(imgMapImg.frame.origin.x-10, imgMapImg.frame.origin.y-7, imgMapImg.frame.size.width*2, imgMapImg.frame.size.height*2);
        
        
        lblGetDirection1.frame  =   CGRectMake(lblGetDirection1.frame.origin.x-100, lblGetDirection1.frame.origin.y, lblGetDirection1.frame.size.width+100, lblGetDirection1.frame.size.height);
        lblPhoneNo1.frame  =   CGRectMake(lblPhoneNo1.frame.origin.x-100, lblPhoneNo1.frame.origin.y, lblPhoneNo1.frame.size.width+100, lblPhoneNo1.frame.size.height);
        
        
        
        
        
        float topMargin =   viewReviewListBtm.frame.origin.y+viewReviewListBtm.frame.size.height;
        
        for (int i=0; i<5; i++) {
            
            UIView *bgView  =   [[UIView alloc]initWithFrame:CGRectMake(0, topMargin, screenWidth, screenHeight*0.08)];
            bgView.backgroundColor  =   [UIColor whiteColor];
            [viewRestaurentReview addSubview:bgView];
            
            UIImageView *iconImgView  =   [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth*0.02, screenHeight*0.02, screenHeight*0.04, screenHeight*0.04)];
            [iconImgView setImage:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
            [bgView addSubview:iconImgView];
            
            float height    =   screenHeight*0.08;
            if (i==0) {
                height    =   screenHeight*0.05;
            }
            
            UILabel *mainTextLbl           =   [[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.04+screenHeight*0.04, 0, screenWidth*0.80, height)];
            mainTextLbl.text               =   [textArr objectAtIndex:i];
            mainTextLbl.backgroundColor    =   [UIColor clearColor];
            mainTextLbl.textColor          =   [UIColor colorWithRed:24.0f/255.0f green:29.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
            mainTextLbl.textAlignment      =   NSTextAlignmentLeft;
            mainTextLbl.font               =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
            [bgView addSubview:mainTextLbl];
            
            if (i==0) {
                reviewDistanceLbl           =   [[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.04+screenHeight*0.04, screenHeight*0.05, screenWidth*0.80, screenHeight*0.03)];
                reviewDistanceLbl.text             =   @"4 mins walk";
                reviewDistanceLbl.backgroundColor  =   [UIColor clearColor];
                reviewDistanceLbl.textColor        =   [UIColor grayColor];
                reviewDistanceLbl.textAlignment    =   NSTextAlignmentLeft;
                reviewDistanceLbl.font             =   [UIFont fontWithName:FONT_NAME_MAIN size:16];
                [bgView addSubview:reviewDistanceLbl];
            }
            
            if (i==1){
                reviewCallNoLbl                     =   [[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.10+screenHeight*0.04, 0, screenWidth*0.80, height)];
                reviewCallNoLbl.text               =   @"(615 730 8552)";
                reviewCallNoLbl.backgroundColor    =   [UIColor clearColor];
                reviewCallNoLbl.textColor          =   [UIColor grayColor];
                reviewCallNoLbl.textAlignment      =   NSTextAlignmentLeft;
                reviewCallNoLbl.font               =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
                [bgView addSubview:reviewCallNoLbl];
            }
            
            UIImageView *arrowIconView  =   [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth*0.95, screenHeight*0.025, screenHeight*0.03, screenHeight*0.03)];
            [arrowIconView setImage:[UIImage imageNamed:@"ic_action_collapse.png"]];
            [bgView addSubview:arrowIconView];
            
            UIImageView *btmLine        =   [[UIImageView alloc]initWithFrame:CGRectMake(0, screenHeight*0.08-2, screenWidth, 2)];
            btmLine.backgroundColor     =   [UIColor colorWithRed:224.0f/255.0f green:228.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
            [bgView addSubview:btmLine];
            
            UIButton *btn   =   [[UIButton alloc]initWithFrame:CGRectMake(0,0,screenWidth,screenHeight*0.08)];
            [btn setBackgroundColor:[UIColor clearColor]];
            btn.tag         =   i+500;
            [btn addTarget:self action:@selector(reviewOptionClicked:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            
            [restroMenuOptionsViewArr addObject:bgView];
            
            topMargin   +=  screenHeight*0.08;
        }
        
//        topMargin   -=  screenHeight*0.088;
        
//        tlbV.frame  =   CGRectMake(tlbV.frame.origin.x, tlbV.frame.origin.y-20, tlbV.frame.size.width, tlbV.frame.size.height-70);
        tlbV.frame  =   CGRectMake(tlbV.frame.origin.x, tlbV.frame.origin.y+225, tlbV.frame.size.width, tlbV.frame.size.height-235);
    }else{

        imgViewUserOnEDitProfile.frame  =   CGRectMake(imgViewUserOnEDitProfile.frame.origin.x, imgViewUserOnEDitProfile.frame.origin.y, imgViewUserOnEDitProfile.frame.size.width, imgViewUserOnEDitProfile.frame.size.width);
        imgViewUserOnEDitProfile.layer.cornerRadius=imgViewUserOnEDitProfile.frame.size.width/2;
        imgViewUserOnEDitProfile.clipsToBounds=YES;
        imgViewUserOnEDitProfile.layer.masksToBounds    =   YES;
        
        imgViewUserProfile.frame                =   CGRectMake(imgViewUserProfile.frame.origin.x, imgViewUserProfile.frame.origin.y, imgViewUserProfile.frame.size.width, imgViewUserProfile.frame.size.width);
        imgViewUserProfile.layer.cornerRadius   =   imgViewUserProfile.frame.size.width/2;
        imgViewUserProfile.layer.masksToBounds  =   YES;
        
        lblReviews.frame    =   CGRectMake(lblReviews.frame.origin.x+20, lblReviews.frame.origin.y, lblReviews.frame.size.width, lblReviews.frame.size.height);
        
        lblReviews1.frame    =   CGRectMake(lblReviews1.frame.origin.x+20, lblReviews1.frame.origin.y, lblReviews1.frame.size.width, lblReviews1.frame.size.height);
        
        float topMargin =   viewReviewListBtm.frame.origin.y+viewReviewListBtm.frame.size.height;
        
        for (int i=0; i<5; i++) {
            
            UIView *bgView  =   [[UIView alloc]initWithFrame:CGRectMake(0, topMargin, screenWidth, screenHeight*0.08)];
            bgView.backgroundColor  =   [UIColor whiteColor];
            [viewRestaurentReview addSubview:bgView];
            
            UIImageView *iconImgView  =   [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth*0.025, screenHeight*0.028, screenHeight*0.024, screenHeight*0.024)];
            [iconImgView setImage:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
            [bgView addSubview:iconImgView];
            
            float height    =   screenHeight*0.08;
            if (i==0) {
                height    =   screenHeight*0.05;
            }
            
            UILabel *mainTextLbl           =   [[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.04+screenHeight*0.04, 0, screenWidth*0.80, height)];
            mainTextLbl.text               =   [textArr objectAtIndex:i];
            mainTextLbl.backgroundColor    =   [UIColor clearColor];
            mainTextLbl.textColor          =   [UIColor colorWithRed:24.0f/255.0f green:29.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
            mainTextLbl.textAlignment      =   NSTextAlignmentLeft;
            mainTextLbl.font               =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
            [bgView addSubview:mainTextLbl];
            
            if (i==0) {
                reviewDistanceLbl           =   [[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.04+screenHeight*0.04, screenHeight*0.05, screenWidth*0.80, screenHeight*0.03)];
                reviewDistanceLbl.text             =   @"4 mins walk";
                reviewDistanceLbl.backgroundColor  =   [UIColor clearColor];
                reviewDistanceLbl.textColor        =   [UIColor grayColor];
                reviewDistanceLbl.textAlignment    =   NSTextAlignmentLeft;
                reviewDistanceLbl.font             =   [UIFont fontWithName:FONT_NAME_MAIN size:10];
                [bgView addSubview:reviewDistanceLbl];
            }
            
            if (i==1){
                reviewCallNoLbl                     =   [[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.15+screenHeight*0.04, 0, screenWidth*0.80, height)];
                reviewCallNoLbl.text               =   @"(615 730 8552)";
                reviewCallNoLbl.backgroundColor    =   [UIColor clearColor];
                reviewCallNoLbl.textColor          =   [UIColor grayColor];
                reviewCallNoLbl.textAlignment      =   NSTextAlignmentLeft;
                reviewCallNoLbl.font               =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
                [bgView addSubview:reviewCallNoLbl];
            }
            
            UIImageView *arrowIconView  =   [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth*0.95, screenHeight*0.025, screenHeight*0.03, screenHeight*0.03)];
            [arrowIconView setImage:[UIImage imageNamed:@"ic_action_collapse.png"]];
            [bgView addSubview:arrowIconView];
            
            UIImageView *btmLine        =   [[UIImageView alloc]initWithFrame:CGRectMake(0, screenHeight*0.08-2, screenWidth, 1)];
            btmLine.backgroundColor     =   [UIColor colorWithRed:224.0f/255.0f green:228.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
            [bgView addSubview:btmLine];
            
            UIButton *btn   =   [[UIButton alloc]initWithFrame:CGRectMake(0,0,screenWidth,screenHeight*0.08)];
            [btn setBackgroundColor:[UIColor clearColor]];
            btn.tag         =   i+500;
            [btn addTarget:self action:@selector(reviewOptionClicked:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            
            [restroMenuOptionsViewArr addObject:bgView];
            
            topMargin   +=  screenHeight*0.08;
        }
        
        //        topMargin   -=  screenHeight*0.088;
        
        //        tlbV.frame  =   CGRectMake(tlbV.frame.origin.x, tlbV.frame.origin.y-20, tlbV.frame.size.width, tlbV.frame.size.height-70);
        tlbV.frame  =   CGRectMake(tlbV.frame.origin.x, tlbV.frame.origin.y+228, tlbV.frame.size.width, tlbV.frame.size.height-238);
        
        txtFFirstnameH1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFMobileH1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFEmailH1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        txtFFirstname.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFEmail.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFMobile.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFPassword.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblFEditProfileDetail.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFEditProfileName.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFEditProfileName1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFEditProfileEmail.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFEditProfileEmail1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFEditProfileMob.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFEditProfileMob1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFEditProfilePass.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        btnFEditProfileSave.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFindRestaurant.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblPayWithKent.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblPayment.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblReservation.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblReceipt.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblSupport.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblLogout.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        btnProfileCncl.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        btnProfileViewAccount.titleLabel.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        lblUserName.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        txtFSearch.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblLocation.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        txtFLocation.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblPrizeCasual.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        txtFPrizeCasual.font=   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblCatgory.font     =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        txtFCatgory.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        btnDropDownSearch.titleLabel.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblReviews1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblMinWaitBtm.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblMinWait.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblReviews.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        btnReserveTable.titleLabel.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        btnReserve2Table2.titleLabel.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblRestauName.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblRestauName1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblPhoneNo.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblPhoneNo1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblGetDirection.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblGetDirection1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblTime.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        lblTime1.font    =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
        
        // After animation
        lblCasual.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFine.font        =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblRecommended.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        // Default on screen
        lblCasualBtm.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblFineBtm.font        =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        lblRecommendedBtm.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
        btnBackOnEditProfile.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        btnEditOnEditProfile.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        btnONWifi.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        lblEditProTitle.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        
//        viewRestaurentListAfterSearch.frame =   CGRectMake(viewRestaurentListAfterSearch.frame.origin.x, viewPriceCFU.frame.origin.y, viewRestaurentListAfterSearch.frame.size.width, viewRestaurentListAfterSearch.frame.size.height);
    }
    

}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *strISHome=[[NSUserDefaults standardUserDefaults ]objectForKey:@"directHomeKey"];
    if ([ strISHome isEqualToString:@"yes"])
    {
        [[NSUserDefaults standardUserDefaults ] setObject:@"no" forKey:@"directHomeKey"];
        
        [self btnCancelDidClicked:nil];
        
         [self btn_GogleDidClicked:nil];
    }
    
}

-(void)setMenuOptionFrame{
    float topMargin =   viewReviewListBtm.frame.origin.y+viewReviewListBtm.frame.size.height;
//    if ( IDIOM == IPAD ) {
        for (int i=0; i<5; i++) {
            UIView *tempView    =   [restroMenuOptionsViewArr objectAtIndex:i];
            tempView.hidden     =   NO;
            tempView.frame      =   CGRectMake(0, topMargin, screenWidth, screenHeight*0.08);
            topMargin   +=  screenHeight*0.08;
        }
//    }else{
//        
//    }
}

-(void)getProfilePic:(NSData *)data{
    if (![[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"photo"] isEqualToString:@"0"]) {
        NSLog(@"PIC :: %@",[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"photo"]);
        //            NSMutableDictionary *Dict   =   [[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] mutableCopy];
        //            [Dict setObject:@"" forKey:@"photo"];
        
        NSData *Imgdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[NSKeyedUnarchiver unarchiveObjectWithData:data] objectAtIndex:0] objectForKey:@"photo"]]];
        
        imgViewUserProfile.image=[UIImage imageWithData:Imgdata];
        imgViewUserOnEDitProfile.image = [UIImage imageWithData:Imgdata];
    }
}

-(void)reviewOptionClicked:(UIButton *)sender{
    if (sender.tag == 500) {
        // Direction
        
        
        //[viewRestaurentReview removeFromSuperview];
        [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:1500];
        
        [self getDirections];
        [btnONWifi setTitle:@"BACK" forState:UIControlStateNormal];
        imgViewWIfi.hidden=YES;
        viewRestauInfo.hidden=NO;
    }else if (sender.tag == 501){
        // Call
        NSString *phoneNumberString=[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:index] objectForKey:@"phone_number"]];
        
        if ([phoneNumberString length]>0)
        {
            phoneNumberString = [[phoneNumberString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString: @""];
            NSString *phoneDecender = @"tel:";
            NSString *totalPhoneNumberString = [phoneDecender stringByAppendingString:phoneNumberString];
            NSURL *aPhoneNumberURL = [NSURL URLWithString:totalPhoneNumberString];
            
            if ([[UIApplication sharedApplication] canOpenURL:aPhoneNumberURL])
            {
                [[UIApplication sharedApplication] openURL:aPhoneNumberURL];
            }
            
        }
    }else if (sender.tag == 502){
        // Browse
        if (![[[arrAfterSearch objectAtIndex:index] objectForKey:@"browse_the_menu"] isEqualToString:@""]){
            NSString *strUrl    =   [[arrAfterSearch objectAtIndex:index] objectForKey:@"browse_the_menu"];
            if ([strUrl rangeOfString:@"http://"].location == NSNotFound && [strUrl rangeOfString:@"https://"].location == NSNotFound) {
                strUrl    =   [NSString stringWithFormat:@"http://%@",[[arrAfterSearch objectAtIndex:index] objectForKey:@"browse_the_menu"]];
            }else{
                strUrl    =   [[arrAfterSearch objectAtIndex:index] objectForKey:@"browse_the_menu"];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strUrl]];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Sorry, no data." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alert show];
        }
        
    }else if (sender.tag == 503){
        // Message
        if (![[[arrAfterSearch objectAtIndex:index] objectForKey:@"message_the_business"] isEqualToString:@""]){
            NSString *strUrl    =   [[arrAfterSearch objectAtIndex:index] objectForKey:@"message_the_business"];
            if ([strUrl rangeOfString:@"http://"].location == NSNotFound && [strUrl rangeOfString:@"https://"].location == NSNotFound) {
                strUrl    =   [NSString stringWithFormat:@"http://%@",[[arrAfterSearch objectAtIndex:index] objectForKey:@"message_the_business"]];
            }else{
                strUrl    =   [[arrAfterSearch objectAtIndex:index] objectForKey:@"message_the_business"];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strUrl]];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Sorry, no data." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alert show];
        }
    }else if (sender.tag == 504){
        // more
        NSString *strInfo   =   [[arrAfterSearch objectAtIndex:index] objectForKey:@"more_info"];
//        if ([strInfo isEqualToString:@""]){
//            strInfo =   @"Sorry, no data.";
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strInfo delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//        [alert show];
        
        UIView *popupV  =   [[UIView alloc]initWithFrame:CGRectMake(screenWidth*0.10, screenHeight*0.40, screenWidth*0.80, screenHeight*0.20)];
        popupV.backgroundColor  =   [UIColor whiteColor];
        popupV.layer.cornerRadius   =   5;
        popupV.layer.borderWidth    =   1;
        popupV.layer.borderColor    =   [UIColor blackColor].CGColor;
        popupV.layer.masksToBounds  =   YES;
        [self.view addSubview:popupV];
        
        UITextView *infoTxt =   [[UITextView alloc]initWithFrame:CGRectMake(screenWidth*0.02, screenHeight*0.01, screenWidth*0.76, screenHeight*0.12)];
        infoTxt.text        =   strInfo;
        infoTxt.textAlignment   =   NSTextAlignmentCenter;
        infoTxt.editable    =   NO;
        infoTxt.font        =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        [popupV addSubview:infoTxt];
        
        
        if (IDIOM == IPAD) {
            infoTxt.font                =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        }
        
        modal = [[RNBlurModalView alloc] initWithView:popupV];
        
        modal.defaultHideBlock = ^{
            NSLog(@"Code called after the modal view is hidden");
        };
        
        //    modal.dismissButtonRight = YES;
        [modal show];
        
        
        [tblePrice reloadData];
    }
}

-(void)hidePopup{
    [modal hide];
}

-(void)handleSwipeFine:(UISwipeGestureRecognizer *)recognizer
{
     NSString *strId;
    
  
    
    if ([outputRastByCat count]==0)
    {
        
    }
    else
    {
        if ([outputAllRestaurents count]==0)
        {
            
        }
        else
        {
           
            
            //strSearchType=@"searchInAllRestarents";
            
            if (btnSwipeOnFine.tag==30) //Fine
            {
                strFilterType=@"Fine";
                
                [btnCasual2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                [btnRecomended setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                [btnFine2 setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
                
                for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
                {
                    if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Fine"])
                    {
                        strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                        break;
                    }
                    
                }
                
                
            }
            
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"SELF contains[cd] %@",strId];
            
            
            
            
            if ([strSearchType isEqualToString:@"searchInAllRestarents"])
            {
                NSMutableArray *arrBottomSearch=[NSMutableArray new];
                
                [ arrBottomSearch addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                
                [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
                
                // NSLog(@"dicSearchId=%@",dicSearchId);
                NSLog(@"arrAfterSearch =%@",arrBottomSearch);
                
                [arrAfterSearch removeAllObjects];
                // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<arrBottomSearch.count; i++)
                {
                    if ([[arrBottomSearch objectAtIndex:i] count]>0)
                    {
                        for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                        {
                            // if()
                            for (int j=0; j< [outputAllRestaurents count]; j++)
                            {
                                if ([arrCat isEqualToArray:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"categories"]])
                                {
                                    [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                }
                            }
                            
                            
                        }
                    }
                }
                
                
            }
            else
            {
                
                NSMutableArray *arrBottomSearch=[NSMutableArray new];
                
                
                if (isBackCicked==NO)
                {
                    [arrTemp removeAllObjects];
                    [arrTemp addObjectsFromArray:arrAfterSearch];
                }
                
                [arrTemp setArray:[[NSSet setWithArray:arrTemp] allObjects]];
                
                
                
                
                [ arrBottomSearch addObject:[[arrTemp  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                
                [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
                
                // NSLog(@"dicSearchId=%@",dicSearchId);
                NSLog(@"arrAfterSearch =%@",arrBottomSearch);
                
                [arrAfterSearch removeAllObjects];
                // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<arrBottomSearch.count; i++)
                {
                    if ([[arrBottomSearch objectAtIndex:i] count]>0)
                    {
                        for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                        {
                            // if()
                            for (int j=0; j< [arrTemp count]; j++)
                            {
                                if ([arrCat isEqualToArray:[[arrTemp objectAtIndex:j] objectForKey:@"categories"]])
                                {
                                    [arrAfterSearch addObject:[arrTemp objectAtIndex:j]];
                                }
                            }
                            
                            
                        }
                    }
                }
                
                
            }
            
            
            [self performSelector:@selector(hideViews) withObject:self afterDelay:.5];
            imgViewWIfi.hidden=YES;
            [btnONWifi setTitle:@"BACK" forState:UIControlStateNormal];
            
            tblVUpscale.delegate=self;
            tblVUpscale.dataSource=self;
            [tblVUpscale reloadData];
            
            
            // [self.view addSubview:viewRestaurentListAfterSearch];
            
//            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:viewInHeader.frame.size.height];
            
            //  NSTimer *timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(hideViews) userInfo:nil repeats:NO];
            
            
            
        }
        
    }
    

    

}

-(void)handleSwipeRecomended:(UISwipeGestureRecognizer *)recognizer
{
     NSString *strId;
    
    if ([outputRastByCat count]==0)
    {
        
    }
    else
    {
        if ([outputAllRestaurents count]==0)
        {
            
        }
        else
        {
            
            
            
            //strSearchType=@"searchInAllRestarents";
            
            if(btnSwipeOnRecommended.tag==20)  //Recommended
            {
                strFilterType=@"Recommended ";
                
                
                
                [btnCasual2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                [btnRecomended setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
                [btnFine2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                
                
                
                for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
                {
                    if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Recommended "])
                    {
                        strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                        break;
                    }
                    
                }
                
                
                
            }
            
            
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"SELF contains[cd] %@",strId];
            
            
            
            
            if ([strSearchType isEqualToString:@"searchInAllRestarents"])
            {
                NSMutableArray *arrBottomSearch=[NSMutableArray new];
                
                [ arrBottomSearch addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                
                [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
                
                // NSLog(@"dicSearchId=%@",dicSearchId);
                NSLog(@"arrAfterSearch =%@",arrBottomSearch);
                
                [arrAfterSearch removeAllObjects];
                // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<arrBottomSearch.count; i++)
                {
                    if ([[arrBottomSearch objectAtIndex:i] count]>0)
                    {
                        for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                        {
                            // if()
                            for (int j=0; j< [outputAllRestaurents count]; j++)
                            {
                                if ([arrCat isEqualToArray:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"categories"]])
                                {
                                    [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                }
                            }
                            
                            
                        }
                    }
                }
                
                
            }
            else
            {
                
                NSMutableArray *arrBottomSearch=[NSMutableArray new];
                
                
                if (isBackCicked==NO)
                {
                    [arrTemp removeAllObjects];
                    [arrTemp addObjectsFromArray:arrAfterSearch];
                }
                
                [arrTemp setArray:[[NSSet setWithArray:arrTemp] allObjects]];
                
                
                
                
                [ arrBottomSearch addObject:[[arrTemp  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                
                [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
                
                // NSLog(@"dicSearchId=%@",dicSearchId);
                NSLog(@"arrAfterSearch =%@",arrBottomSearch);
                
                [arrAfterSearch removeAllObjects];
                // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<arrBottomSearch.count; i++)
                {
                    if ([[arrBottomSearch objectAtIndex:i] count]>0)
                    {
                        for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                        {
                            // if()
                            for (int j=0; j< [arrTemp count]; j++)
                            {
                                if ([arrCat isEqualToArray:[[arrTemp objectAtIndex:j] objectForKey:@"categories"]])
                                {
                                    [arrAfterSearch addObject:[arrTemp objectAtIndex:j]];
                                }
                            }
                            
                            
                        }
                    }
                }
                
                
            }
            
            
            
            
            [self performSelector:@selector(hideViews) withObject:self afterDelay:.5];
            imgViewWIfi.hidden=YES;
            [btnONWifi setTitle:@"BACK" forState:UIControlStateNormal];
            
            tblVUpscale.delegate=self;
            tblVUpscale.dataSource=self;
            [tblVUpscale reloadData];
            
            
            // [self.view addSubview:viewRestaurentListAfterSearch];
            
//            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:viewInHeader.frame.size.height];
            
            
        }
        
    }


    
}

-(void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer{
    [self btnWifiDidClicked:btnONWifi];
}

-(void)handleSwipeUpUserProfile:(UISwipeGestureRecognizer *)recognizer{
    [self btnCancelDidClicked:btnProfileCncl];
}

-(void)handleSwipeDownForRestroReview:(UISwipeGestureRecognizer *)recognizer{
    [self btnWifiDidClicked:btnONWifi];
}


-(void)handleSwipeCasual:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"Swipe handleSwipeCasual.");
    

    
    NSString *strId;
    
    if ([outputRastByCat count]==0)
    {
        
    }
    else
    {
        if ([outputAllRestaurents count]==0)
        {
            
        }
        else
        {
            
            
            
            //strSearchType=@"searchInAllRestarents";
            
            if (btnSwipeOnCasual.tag==10)  //Casual
            {
                strFilterType=@"Casual";
                
                
                
                [btnCasual2 setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
                [btnRecomended setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                [btnFine2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                
                
                
                for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
                {
                    if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Casual"])
                    {
                        strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                        break;
                    }
                    
                }
                
                
            }
            
            
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"SELF contains[cd] %@",strId];
            
            
            
            
            if ([strSearchType isEqualToString:@"searchInAllRestarents"])
            {
                NSMutableArray *arrBottomSearch=[NSMutableArray new];
                
                [ arrBottomSearch addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                
                [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
                
                // NSLog(@"dicSearchId=%@",dicSearchId);
                NSLog(@"arrAfterSearch =%@",arrBottomSearch);
                
                [arrAfterSearch removeAllObjects];
                // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<arrBottomSearch.count; i++)
                {
                    if ([[arrBottomSearch objectAtIndex:i] count]>0)
                    {
                        for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                        {
                            // if()
                            for (int j=0; j< [outputAllRestaurents count]; j++)
                            {
                                if ([arrCat isEqualToArray:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"categories"]])
                                {
                                    [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                }
                            }
                            
                            
                        }
                    }
                }
                
                
            }
            else
            {
                
                NSMutableArray *arrBottomSearch=[NSMutableArray new];
                
                
                if (isBackCicked==NO)
                {
                    [arrTemp removeAllObjects];
                    [arrTemp addObjectsFromArray:arrAfterSearch];
                }
                
                [arrTemp setArray:[[NSSet setWithArray:arrTemp] allObjects]];
                
                
                
                
                [ arrBottomSearch addObject:[[arrTemp  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                
                [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
                
                // NSLog(@"dicSearchId=%@",dicSearchId);
                NSLog(@"arrAfterSearch =%@",arrBottomSearch);
                
                [arrAfterSearch removeAllObjects];
                // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<arrBottomSearch.count; i++)
                {
                    if ([[arrBottomSearch objectAtIndex:i] count]>0)
                    {
                        for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                        {
                            // if()
                            for (int j=0; j< [arrTemp count]; j++)
                            {
                                if ([arrCat isEqualToArray:[[arrTemp objectAtIndex:j] objectForKey:@"categories"]])
                                {
                                    [arrAfterSearch addObject:[arrTemp objectAtIndex:j]];
                                }
                            }
                            
                            
                        }
                    }
                }
                
                
            }
            
            
            
            
            [self performSelector:@selector(hideViews) withObject:self afterDelay:.5];
            imgViewWIfi.hidden=YES;
            [btnONWifi setTitle:@"BACK" forState:UIControlStateNormal];
            
            tblVUpscale.delegate=self;
            tblVUpscale.dataSource=self;
            [tblVUpscale reloadData];
            
            
            // [self.view addSubview:viewRestaurentListAfterSearch];
            
//            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:viewInHeader.frame.size.height];
            
            //  NSTimer *timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(hideViews) userInfo:nil repeats:NO];
            
          
            
            
        }
        
    }

    
}

-(void)handleSwipeForBtnUSeR:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"Swipe handleSwipeForBtnUSeR.");
    
    [self btnUserDidClicked:nil];
    
    
}


-(void)handleSwipeForREVIEWS:(UISwipeGestureRecognizer *)recognizer
{
     NSLog(@"Swipe handleSwipeForREVIEWS.");
    
    [self btnReviewDidClicked:nil];
    
    
}


-(void)getFilterCategoryHandlert:(id)sender
{
   // [self checkLoadingView];
    NSLog(@"sender :%@",sender);
    if([sender isKindOfClass:[NSError class]])
    {
        
        NSLog(@"Error occur=>%@",[sender localizedDescription]);
      //  CustomMessage *cav=[[CustomMessage alloc] init];
       // [cav show:[sender localizedDescription] inView:self.view delay:2 lYAxis:100];
    }
    else
    {
        if([sender isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please check network connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if([sender isEqualToString:@"[]"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *jsonString=[NSString stringWithString:sender];
            SBJSON *jsonParser=[[SBJSON alloc] init];
            id output1=[jsonParser objectWithString:jsonString error:nil];
            if([[output1 valueForKey:@"message"]isEqualToString:@"REGISTRATION SUCCESSFULLY"])
            {
                
                id output2=[output1 valueForKey:@"data"];
                
               
            }
            else if([[output1 valueForKey:@"message"]isEqualToString:@"USERNAME ALREADY REGISTERED"])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"username already registered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            
        }
    }

    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self keyboardShow];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self keyboardHide];
 
    return YES;
}



#pragma mark-keyboard show and hide

-(void)keyboardShow
{
    UIView *view=editProfile;
    
    [UIView animateWithDuration:.5
                          delay:.1
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         CGRect frame = view.frame;
                         frame.origin.y = -70;
                         frame.origin.x = (0);
                         view.frame = frame;
                     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];

}

-(void)keyboardHide
{
    UIView *view=editProfile;
    
    [UIView animateWithDuration:.5
                          delay:.1
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         CGRect frame = view.frame;
                         frame.origin.y = (0);
                         frame.origin.x = (0);
                         view.frame = frame;
                     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
}


-(void)tapONMap
{
    ViewDropdown.hidden=YES;
}


-(void)getRestaurantByCategories
{
    
    [DSBezelActivityView  newActivityViewForView:self.view];
    
    strType=@"getRestaurantCategories";
    
    NSURL *url=[NSURL URLWithString:@"http://netleondev.com/kentapi/restaurant/category"];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:url];
    
    [request addRequestHeader:@"Content-type" value:@"application/json"];
    [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
    
    [request setRequestMethod:@"GET"];
    request.delegate=self;
    request.allowCompressedResponse=NO;
    request.shouldCompressRequestBody=NO;
    request.useCookiePersistence=NO;
    request.timeOutSeconds=60;
   // [request performSelector:@selector(getRestaurantCategories:)];
    [request startAsynchronous];
    
      NSError *error = [request error];
     
     if (!error)
     {
     NSString *response = [request responseString];
     }
     
     

}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  /*  CLLocation *loccrd=[locationManager location];
    
    MKCoordinateRegion region;
    region.center.latitude=loccrd.coordinate.latitude;
    region.center.longitude=loccrd.coordinate.longitude;
    
    region.span.latitudeDelta=.10;
    region.span.longitudeDelta=.10;
    
    [mapView setRegion:region animated:YES];
    
    */
    
    

   
    
}

-(void)getAllRestaurants
{
    
    if([QAUtils IsNetConnected])
    {
        strType=@"getAllRestaurants";
        
        [DSBezelActivityView  newActivityViewForView:self.view];
        
        NSURL *url =[NSURL URLWithString:@"http://netleondev.com/kentapi/restaurant/all"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request addRequestHeader:@"Content-type" value:@"application/json"];
        [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
        
        [request setRequestMethod:@"GET"];
        request.delegate=self;
        request.allowCompressedResponse = NO;
        request.useCookiePersistence = NO;
        request.shouldCompressRequestBody = NO;
        request.timeOutSeconds=60;
        
        [request startAsynchronous];
        /*  NSError *error = [request error];
         
         if (!error)
         {
         NSString *response = [request responseString];
         }
         
         */

    }
    else
    {
        [DSBezelActivityView removeViewAnimated:YES];
        return;
    }
}

#pragma mark- ASIHttp request response

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    
    [DSBezelActivityView removeViewAnimated:YES];

    NSString *responseString = [request responseString];
    
     NSData *responseData = [request responseData];
    /*
     NSDictionary *dicAllRestaurents=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
     
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
        if ( [strType isEqualToString:@"getRestaurantCategories"])
        {
            
            NSString *strReponspeString=[request responseString ];
            
            SBJSON *jsonString=[[SBJSON alloc]init];
            
            outputRastByCat=[jsonString objectWithString:strReponspeString];
            
            NSLog(@"getRestaurantCategories=>%@",outputRastByCat);
            
            
            [mapView removeOverlay:polyline];
            mapView.showsUserLocation=TRUE;
            
            MKUserLocation *userLocation = mapView.userLocation;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
            [mapView setRegion:region animated:NO];
            
        }
        else  if ( [strType isEqualToString:@"getAllRestaurants"])
        {
            NSString *jsonString=[NSString stringWithString:responseString];
            SBJSON *jsonParser=[[SBJSON alloc] init];
            outputAllRestaurents=[jsonParser objectWithString:jsonString error:nil];
            listAllRestaurents  =   [jsonParser objectWithString:jsonString error:nil];
            strSearchType=@"searchInAllRestarents";
            
            NSLog(@"%@",outputAllRestaurents);
            
            [self setPointOnMap];
            
//            if (isFisrtTime==NO)
//            {
                [self getRestaurantByCategories];
                isFisrtTime=YES;
//            }
            
        }
        else if( [strType isEqualToString:@"editProfile"])
        {
            SBJSON *jsonParser=[[SBJSON alloc] init];
            id output1=[jsonParser objectWithString:responseString error:nil];
            
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
                [btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:[output1 objectForKey:@"success"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                //  [btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
                
                
                [btnBackOnEditProfile setTitle:@"BACK" forState:UIControlStateNormal];
                [btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
            }
            
            
        }
        else if( [strType isEqualToString:@"saveProfile"])
        {
            SBJSON *jsonParser=[[SBJSON alloc] init];
            id output1=[jsonParser objectWithString:responseString error:nil];
            
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
                [btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
            }
            else
            {
                
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:[output1 objectForKey:@"success"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                //  [btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
                
                
                //[btnBackOnEditProfile setTitle:@"BACK" forState:UIControlStateNormal];
                //[btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
            }
            
            
        }
        else if ( [strType isEqualToString:@"restaurentReviews"])
        {
            NSData *responseData = [request responseData];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
            
            
            if ([responseString isEqualToString:@"{\"error\":\"Couldn't find any restaurent reviews!\"}"])
            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"Couldn't find any restaurent reviews!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//                [alert show];
            }
            else
            {
                
                outputReviewsList=dic;
                
                [tlbV reloadData];
            }
            
            
           //propicUpload
            
        }
        else if ( [strType isEqualToString:@"propicUpload"])
        {
            NSData *responseData = [request responseData];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
            
            
            if ([responseString isEqualToString:@"{\"error\":\"Couldn't find any restaurent reviews!\"}"])
            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"Couldn't find any restaurent reviews!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//                [alert show];
            }
            else
            {
                outputReviewsList=dic;
                
                [tlbV reloadData];
            }
            
            
            
            
        }
        else if ([strType isEqualToString:@"userReceipt"])
        {
             if([responseString isEqualToString:@"{\"error\":\"No receipt found!\"}"])
            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"No receipt found!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                [alert show];
                
                lblReceiptNumbewr.text=@"0";
                
            }
         
            else
            {
                
                receiptData=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil ];
                
                lblReceiptNumbewr.text=[NSString stringWithFormat:@"%d",[receiptData count]];
                
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setObject:data forKey:@"userdataKey"];
                
                
                
            }
            
        }
        

        }
        

    }
    
  
    



- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DSBezelActivityView removeViewAnimated:YES];
    
    NSError *error = [request error];
    
    
    //Error Domain=ASIHTTPRequestErrorDomain Code=2 "The request timed out" UserInfo=0x15eb2030 {NSLocalizedDescription=The request timed out}
    
    
   // NSString *strTimeOut=@"The request timed out";
    
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}



#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
//    imgViewUserOnEDitProfile.image = image;
    [self dismissModalViewControllerAnimated:YES];
    
    if([QAUtils IsNetConnected])
    {
        strType=@"propicUpload";
        
      [DSBezelActivityView  newActivityViewForView:self.view];
        
//        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//        NSString *imageEncodedString = [imageData base64EncodedStringWithOptions:0];
//        NSData *imageData = UIImagePNGRepresentation(image);
//        NSString *imageEncodedString =  [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
        NSString *imageEncodedString =  [self encodeToBase64String:image];
        
        NSString *base64String = [imageData base64EncodedStringWithOptions:kNilOptions];
        NSString *encodedString2 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL,  (CFStringRef)base64String,    NULL,   CFSTR("!*'();:@&=+$,/?%#[]\" "),   kCFStringEncodingUTF8));
        
        WebServiceConnection * connection;
        connection = [WebServiceConnection connectinManager];
        
        NSString *urlString=[NSString stringWithFormat:imageURL];
        NSDictionary *urlParam =@{base64KEY:encodedString2,userIDKEY:[[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userdataKey"]] objectAtIndex:0] objectForKey:@"id"],imageNameKEY:@"image.png"};
        
        [connection startConectionWithString:urlString HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData)
         {
            [DSBezelActivityView removeViewAnimated:YES];
             
            NSLog(@"receivedData=>%@",receivedData);
             
             if ([[receivedData objectForKey:@"success"] isEqualToString:@"User Image changed"]) {
                 imgViewUserProfile.image = image;
                 imgViewUserOnEDitProfile.image =   image;
//                 imgViewUserProfile.image   =   [self decodeBase64ToImage:encodedString2];
//                 imgViewUserProfile.image   =   [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] options:NSDataBase64DecodingIgnoreUnknownCharacters]];
                 
             }
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[receivedData objectForKey:@"success"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
             
             [alert show];
             
             
        }];

        
   
    }
    else
    {
        [DSBezelActivityView removeViewAnimated:YES];
        return;
    }

    
    
}

- (NSString *)encodeToBase64String:(UIImage *)image {
//    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}



#pragma mark- tableview datasource and delegate



#pragma mark- tableview deleagte and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) //price
    {
        return [[outputRastByCat objectAtIndex:2] count];
    }
    else if(tableView.tag==2) //category
    {
        return [[outputRastByCat objectAtIndex:3] count];
    }
    else if(tableView.tag==3) //location
    {
        return [[outputRastByCat objectAtIndex:1] count];
    }
    else if(tableView.tag==4) //type
    {
        return [[outputRastByCat objectAtIndex:4] count];
    }
    else if(tableView.tag==100) //Review table
    {
        return [outputReviewsList count];
    }
    else if (tableView.tag==200) //list of restaurent after search
    {
        
        if (arrAfterSearch.count==0)
        {
//            CustomMessage *cav=[[CustomMessage alloc] init];
//            [cav show:[NSString stringWithFormat:@"%lu Restaurants found",(unsigned long)arrAfterSearch.count] inView:self.view delay:.9 lYAxis:200];
        }
        else
        {
             return [arrAfterSearch count];
        }
        
       
    }
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == tlbV){
        return 64;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView  =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lineLbl  =   [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 2, 64)];
    lineLbl.backgroundColor =   [UIColor lightGrayColor];
    [headerView addSubview:lineLbl];
    
    UILabel *reviewLbl  =   [[UILabel alloc]initWithFrame:CGRectMake(74, 0, screenWidth*0.85, 64)];
    reviewLbl.text      =   @"Reviews";
    reviewLbl.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
    if(IDIOM == IPAD){
        reviewLbl.font      =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
    }
    [headerView addSubview:reviewLbl];
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView.tag==100) //review table
    {
        
        NSString *identifier=@"customeCell";
        cell=(reviewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell==nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"reviewCell" owner:self options:nil];
            
            cell=[nib objectAtIndex:0];
        }
        
        if (IDIOM == IPAD) {
            cell.txtVReviews.frame  =   CGRectMake(cell.txtVReviews.frame.origin.x, cell.txtVReviews.frame.origin.y, cell.txtVReviews.frame.size.width*2.3, cell.txtVReviews.frame.size.height);
            cell.txtVReviews.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
            cell.lblTimeAgo.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:18];
//            cell.imgVProPick.frame  =   CGRectMake(cell.imgVProPick.frame.origin.x-5, cell.imgVProPick.frame.origin.y, cell.imgVProPick.frame.size.width+10, cell.imgVProPick.frame.size.height+10);

        }else{
            cell.txtVReviews.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
            cell.lblTimeAgo.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:12];
        }
        cell.txtVReviews.textColor  =   [UIColor colorWithRed:148/255.0f green:148/255.0f blue:148/255.0f alpha:1.0f];
        cell.lblTimeAgo.textColor   =   [UIColor colorWithRed:196/255.0f green:196/255.0f blue:196/255.0f alpha:1.0f];
//
        cell.imgVProPick.layer.cornerRadius=cell.imgVProPick.frame.size.width/2;
        cell.imgVProPick.clipsToBounds=YES;
        
        [cell.contentView bringSubviewToFront:cell.imgVProPick];
        
        cell.txtVReviews.text=[[outputReviewsList objectAtIndex:[outputReviewsList count] -1-indexPath.row]objectForKey:@"comment"];
        cell.txtVReviews.textColor  =   [UIColor grayColor];
//        NSString *strDt= [self HourCalculation:[[outputReviewsList objectAtIndex:[outputReviewsList count] -1-indexPath.row]objectForKey:@"review_date"]];
        
        NSString *strDt=[NSDate mysqlDatetimeFormattedAsTimeAgo:[[outputReviewsList objectAtIndex:[outputReviewsList count] -1-indexPath.row]objectForKey:@"review_date"]];
        
        
        cell.lblTimeAgo.text=strDt;
        
        int rating=[[[outputReviewsList objectAtIndex:[outputReviewsList count] -1-indexPath.row]objectForKey:@"rating"] intValue];
        
       // int rating=[[[outputReviewsList objectAtIndex:indexPath.row]objectForKey:@"rating"] floatValue]/20.0;
       
        
        if(rating==0)
        {
            
            cell.imgStar1.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar2.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar5.image=[UIImage imageNamed:@"gray-star.png"];


        }
        
        if(rating==1)
        {
            cell.imgStar1.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar2.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
            

        }
        if(rating==2)
        {
            cell.imgStar1.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar2.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
            

        }
        if(rating==3)
        {
            
            cell.imgStar1.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar2.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar3.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
            cell.imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
            

        }
        if(rating==4)
        {
            
            cell.imgStar1.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar2.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar3.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar4.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
            

        }
        if(rating==5)
        {
            
            cell.imgStar1.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar2.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar3.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar4.image=[UIImage imageNamed:@"start.png"];
            cell.imgStar5.image=[UIImage imageNamed:@"start.png"];
            

        }
        
        return cell;
        
    }
    else if (tableView.tag==200) //restaurent list after search
    {
        
        
        static NSString *identidier=@"upscaleIdentifier";
        
        cellRestListAftrSrch=(UpSacleCell*)[tableView dequeueReusableCellWithIdentifier:identidier];
        
        
        if (cellRestListAftrSrch==nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"UpSacleCell" owner:self options:nil];
            cellRestListAftrSrch=[nib objectAtIndex:0];
            
        }
        
        
        if (IDIOM == IPAD){
            cellRestListAftrSrch.lblIndex.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
            cellRestListAftrSrch.lblRestauName.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
            cellRestListAftrSrch.lblTime.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
            
        }else{
            cellRestListAftrSrch.lblIndex.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
            cellRestListAftrSrch.lblRestauName.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
            cellRestListAftrSrch.lblTime.font  =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        }
        
        
//        if ([strSearchType isEqualToString:@"searchInAllRestarents"])
//        {
            cellRestListAftrSrch.lblIndex.text=[NSString stringWithFormat:@"%d",indexPath.row+1];
            cellRestListAftrSrch.lblRestauName.text=[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"name"];
            cellRestListAftrSrch.lblTime.text=[NSString stringWithFormat:@"%@  min",[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"wait_time"]];
            
            
        int rating11=[[[arrAfterSearch objectAtIndex:indexPath.row]objectForKey:@"rating"] intValue]/20;
         int rating=[[[arrAfterSearch objectAtIndex:indexPath.row]objectForKey:@"rating"] intValue]/20.0;
        
          NSLog(@"%d rating=>%d",indexPath.row,rating11);
        NSLog(@"%d rating=>%d",indexPath.row,rating);

        
            if(rating==0)
            {
                [cellRestListAftrSrch.btnStar1 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar2 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar3 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar4 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar5 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
            }
            
            if(rating==1)
            {
                [cellRestListAftrSrch.btnStar1 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar2 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar3 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar4 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar5 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
            }
            if(rating==2)
            {
                [cellRestListAftrSrch.btnStar1 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar2 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar3 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar4 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar5 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
            }
            if(rating==3)
            {
                [cellRestListAftrSrch.btnStar1 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar2 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar3 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar4 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar5 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
            }
            if(rating==4)
            {
                [cellRestListAftrSrch.btnStar1 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar2 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar3 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar4 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar5 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
            }
            if(rating==5)
            {
                [cellRestListAftrSrch.btnStar1 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar2 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar3 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar4 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
                [cellRestListAftrSrch.btnStar5 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
            }
            

//        }
//        else if ([strSearchType isEqualToString:@"searchInParicularRestaurents"])
//        {
//            
//            
//        }
//        
        
        
        
        return cellRestListAftrSrch;
        
        
        
    }
    else
    {
        
        
        static NSString *identifier=@"Cell";
        
        UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        
        if (cell1==nil)
        {
            cell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        
        
        if (tableView.tag==1) //price
        {
            cell1.textLabel.text=[[[outputRastByCat objectAtIndex:2]objectAtIndex:indexPath.row]objectForKey:@"name"];
        }
        else  if (tableView.tag==2) //category
        {
            // NSLog(@"%@",[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"]);
            cell1.textLabel.text=[[[outputRastByCat objectAtIndex:3]objectAtIndex:indexPath.row]objectForKey:@"name"];
            // cell.textLabel.text=@"cat";
        }
        else  if (tableView.tag==3) //location
        {
            NSLog(@"%@",[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"]);
            cell1.textLabel.text=[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"];
            //cell.textLabel.text=@"loc";
        }
        else if(tableView.tag==4) //type
        {
            NSLog(@"%@",[[[outputRastByCat objectAtIndex:4]objectAtIndex:indexPath.row]objectForKey:@"name"]);
            cell1.textLabel.text=[[[outputRastByCat objectAtIndex:4]objectAtIndex:indexPath.row]objectForKey:@"name"];
        }
       // cell1.textLabel.textAlignment=NSTextAlignmentCenter;
        

        return cell1;
        
    }
    
    
    return cell;
}






-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==200)
    {
       // [viewRestaurentListAfterSearch removeFromSuperview];
        
        [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
        
        viewRestauInfo.hidden=YES;
        viewPriceCFU.hidden=NO;
        
        imgViewWIfi.hidden=NO;
        [btnONWifi setTitle:nil forState:UIControlStateNormal];
        
        index=indexPath.row ;
        
        CLLocationCoordinate2D coord;
        
        coord.latitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"latitude"]] floatValue];
        coord.longitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"longitude"]] floatValue];
        
        
        MKPointAnnotation *point=[[MKPointAnnotation alloc]init];
        point.coordinate=coord;
        
//        point.title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"name"]]];
//        point.subtitle=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"address"]]];
        NSString *mins  =   @"Minute wait";
        if ([[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"wait_time"] integerValue] > 1){
            mins  =   @"Minutes wait";
        }
        point.title =   [NSString stringWithFormat:@"%@ %@",[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"wait_time"],mins];
        
        [mapView addAnnotation:point];

        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (coord, 50, 50);
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        
        
        
        
       // [mapView setRegion:region animated:YES];
        
       // NSDictionary *dicSelectedRestau=[arrAfterSearch objectAtIndex:indexPath.row];
        
       // [self getDirections];
        
         strMapDidClicked=@"Reset";
       // strMapDidClicked=@"yes";
        imgViewWIfi.hidden=YES;
        [btnONWifi setTitle:@"BACK" forState:UIControlStateNormal];
        
        imgStar1.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar2.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
        
        
        
        viewRestauInfo.hidden=NO;
        viewPriceCFU.hidden=YES;
 
 
        
        if (arrAfterSearch.count!=0)
        {
            if ([[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"review_count"] intValue]==0)
            {
//                btnReviews.enabled=NO;
                btnReviews.enabled=YES;
                tlbV.hidden =   YES;
            }
            else
            {
                btnReviews.enabled=YES;
                tlbV.hidden =   NO;
            }
            
            
            
            lblRestauName.text=[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"name"];
            lblReviews.text=[NSString stringWithFormat:@"%@ review",[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"review_count"]];
            lblPhoneNo.text=[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"phone_number"];
            lblTime.text=[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"wait_time"];
            
            
            float rat1=[[[arrAfterSearch objectAtIndex:indexPath.row] objectForKey:@"rating"] floatValue];
            float result=rat1/20.0;
            
            int rating=ceilf(result);
            
            
            // int rating=[[[arrAfterSearch objectAtIndex:flag] objectForKey:@"rating"] intValue]/20;
            
            NSLog(@"rating=%d",rating);
            
            if(rating==0)
            {
                
                
                imgStar1.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar2.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                
                
            }
            
            if(rating==1)
            {
                
                
                imgStar1.image=[UIImage imageNamed:@"start.png"];
                imgStar2.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                
                
                
            }
            if(rating==2)
            {
                
                
                imgStar1.image=[UIImage imageNamed:@"start.png"];
                imgStar2.image=[UIImage imageNamed:@"start.png"];
                imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                
                
            }
            if(rating==3)
            {
                
                imgStar1.image=[UIImage imageNamed:@"start.png"];
                imgStar2.image=[UIImage imageNamed:@"start.png"];
                imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
                imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                
                
                
            }
            if(rating==4)
            {
                
                imgStar1.image=[UIImage imageNamed:@"start.png"];
                imgStar2.image=[UIImage imageNamed:@"start.png"];
                imgStar3.image=[UIImage imageNamed:@"start.png"];
                imgStar4.image=[UIImage imageNamed:@"start.png"];
                imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                
                
            }
            if(rating==5)
            {
                
                imgStar1.image=[UIImage imageNamed:@"start.png"];
                imgStar2.image=[UIImage imageNamed:@"start.png"];
                imgStar3.image=[UIImage imageNamed:@"start.png"];
                imgStar4.image=[UIImage imageNamed:@"start.png"];
                imgStar5.image=[UIImage imageNamed:@"start.png"];
                
                
            }
        }
        
       
        
    }
    else if (tableView.tag==1) //price
    {
        txtFPrizeCasual.text=[[[outputRastByCat objectAtIndex:2]objectAtIndex:indexPath.row]objectForKey:@"name"];
        [ dicSearchId setObject:[[[outputRastByCat objectAtIndex:2]objectAtIndex:indexPath.row]objectForKey:@"name"] forKey:@"priceNameKey"];
        [ dicSearchId setObject:[[[outputRastByCat objectAtIndex:2]objectAtIndex:indexPath.row]objectForKey:@"id"] forKey:@"priceIdKey"];
        
        //tblePrice.hidden=YES;
        [tblePrice removeFromSuperview];
        [modal hide];
        
        
    }
    else  if (tableView.tag==2) //category
    {
        //NSLog(@"%@",[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"]);
        //cell.textLabel.text=[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"];
        txtFCatgory.text=[[[outputRastByCat objectAtIndex:3]objectAtIndex:indexPath.row]objectForKey:@"name"];
        
        [ dicSearchId setObject:[[[outputRastByCat objectAtIndex:3]objectAtIndex:indexPath.row]objectForKey:@"name"] forKey:@"categoryNameKey"];
        [ dicSearchId setObject:[[[outputRastByCat objectAtIndex:3]objectAtIndex:indexPath.row]objectForKey:@"id"] forKey:@"categoryIdKey"];
        
     //   tbleCat.hidden=YES;
        [tbleCat removeFromSuperview];
        [modal hide];
        
    }
    else  if (tableView.tag==3) //location
    {
        // NSLog(@"%@",[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"]);
        txtFLocation.text=[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"];
        
        [ dicSearchId setObject:[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"] forKey:@"locationNameKey"];
        [ dicSearchId setObject:[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"id"] forKey:@"locationIdKey"];
        //  txtFLocation.text=@"loc";
      //  tbleLocation.hidden=YES;
        [tbleLocation removeFromSuperview];
        [modal hide];
        
        
    }
    else  if (tableView.tag==4) //type
    {
        // NSLog(@"%@",[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"]);
        txtFType.text=[[[outputRastByCat objectAtIndex:4]objectAtIndex:indexPath.row]objectForKey:@"name"];
        
        [ dicSearchId setObject:[[[outputRastByCat objectAtIndex:4]objectAtIndex:indexPath.row]objectForKey:@"name"] forKey:@"typeNameKey"];
        [ dicSearchId setObject:[[[outputRastByCat objectAtIndex:4]objectAtIndex:indexPath.row]objectForKey:@"id"] forKey:@"typeIdKey"];
        //  txtFLocation.text=@"loc";
        tblType.hidden=YES;
        [tblType removeFromSuperview];
     
        
    }

    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==100)
    {
//        if (IDIOM == IPAD){
//            return 150;
//        }
        return 113;
        
    }
    else if (tableView.tag==200)
    {
        
         return 55;
    }
    else
    {
        return 44;
    }
    
}

#pragma mark- CALCULATE like  "1 sec ago" or if it is of "1 min ago" or "1 year ago
-(NSString*)HourCalculation:(NSString*)PostDate

{
    //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mma"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormat setTimeZone:gmt];
    NSDate *ExpDate = [dateFormat dateFromString:PostDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSDayCalendarUnit|NSWeekCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:ExpDate toDate:[NSDate date] options:0];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:ExpDate toDate:[NSDate date] options:0];
    
    NSString *time;
    if(components.year!=0)
    {
        if(components.year==1)
        {
            time=[NSString stringWithFormat:@"%ld year",(long)components.year];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld years",(long)components.year];
        }
    }
    else if(components.month!=0)
    {
        if(components.month==1)
        {
            time=[NSString stringWithFormat:@"%ld month",(long)components.month];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld months",(long)components.month];
        }
    }
    else if(components.weekOfMonth<5)
    {
        if(components.weekOfMonth==1)
        {
            time=[NSString stringWithFormat:@"%ld week",(long)components.weekOfMonth];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld weeks",(long)components.weekOfMonth];
        }
    }
    else if(components.day!=0)
    {
        if(components.day==1)
        {
            time=[NSString stringWithFormat:@"%ld day",(long)components.day];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld days",(long)components.day];
        }
    }
    else if(components.hour!=0)
    {
        if(components.hour==1)
        {
            time=[NSString stringWithFormat:@"%ld hour",(long)components.hour];
        }
        else if(components.hour>1)
        {
            time=[NSString stringWithFormat:@"%ld hours",(long)components.hour];
        }else if(components.hour<0)
        {
            time=[NSString stringWithFormat:@"Just now"];
        }
    }
    else if(components.minute!=0)
    {
        if(components.minute==1)
        {
            time=[NSString stringWithFormat:@"%ld min",(long)components.minute];
        }else if(components.minute<0)
        {
            time=[NSString stringWithFormat:@"Just now"];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld mins",(long)components.minute];
        }
    }
    else if(components.second>=0)
    {
        if(components.second==0)
        {
            time=[NSString stringWithFormat:@"1 sec"];
        }
        else if(components.second<0)
        {
            time=[NSString stringWithFormat:@"Just now"];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld secs",(long)components.second];
        }
    }
    return [NSString stringWithFormat:@"%@ ago",time];
}




/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    if (tableView.tag==1) //price
    {
         return [[outputRastByCat objectAtIndex:2] count];
    }
    else if(tableView.tag==2) //category
    {
        return [[outputRastByCat objectAtIndex:3] count];
    }
    else if(tableView.tag==3) //location
    {
        return [[outputRastByCat objectAtIndex:1] count];
    }
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"Cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    

    if (tableView.tag==1) //price
    {
          cell.textLabel.text=[[[outputRastByCat objectAtIndex:2]objectAtIndex:indexPath.row]objectForKey:@"name"];
    }
    else  if (tableView.tag==2) //category
    {
       // NSLog(@"%@",[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"]);
        cell.textLabel.text=[[[outputRastByCat objectAtIndex:3]objectAtIndex:indexPath.row]objectForKey:@"name"];
       // cell.textLabel.text=@"cat";
    }
    else  if (tableView.tag==3) //location
    {
        NSLog(@"%@",[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"]);
        cell.textLabel.text=[[[outputRastByCat objectAtIndex:1]objectAtIndex:indexPath.row]objectForKey:@"name"];
        //cell.textLabel.text=@"loc";
    }
 
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    
    
    return cell;
}



*/
#pragma mark- IB_Action

-(IBAction)btn_CurrentLocation:(id)sender
{
    isBackCicked=NO;
    [arrAfterSearch removeAllObjects];
    
    [mapView removeOverlay:polyline]; 
    mapView.showsUserLocation=TRUE;
    
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:NO];
    
    
//    locationManager.delegate=self;
//    [locationManager startUpdatingLocation];
//    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//    locationManager.distanceFilter=100.0f;
    
}

-(IBAction)btn_GogleDidClicked:(id)sender
{
    viewRestauInfo.hidden=YES;
    viewPriceCFU.hidden=NO;
    
    imgViewLeftSearch.image=[UIImage imageNamed:@"downarrow.png"];
    ViewDropdown.hidden = YES;
    
    tbleLocation.hidden=YES;
    tbleCat.hidden=YES;
    tblePrice.hidden=YES;
    
    imgViewWIfi.hidden=NO;
    [btnONWifi setTitle:nil forState:UIControlStateNormal];
   // [viewRestaurentReview removeFromSuperview];
   // [viewRestaurentListAfterSearch removeFromSuperview];
    
    [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:1500];
    [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
    
    txtFSearch.text=nil;
    [txtFSearch resignFirstResponder];
    
    
    [mapView removeOverlay:polyline]; 
    
    NSArray *existingpoints = mapView.annotations;
    if ([existingpoints count] > 0)
    {
        [mapView removeAnnotations:existingpoints];
    }

    
    
    [self getAllRestaurants];
    
}


-(IBAction)btnViewAccountDidClicked:(id)sender
{
    profileView.hidden=YES;
    
  
    seeProfile.hidden=NO;
    changeProfile.hidden=YES;
    
//#define IS_IPHONE_6_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 667.0f)
    
    //[defaults objectForKey:@"userdataKey"]
    imgViewUserOnEDitProfile.frame  =   CGRectMake(imgViewUserOnEDitProfile.frame.origin.x, imgViewUserOnEDitProfile.frame.origin.y, imgViewUserOnEDitProfile.frame.size.width, imgViewUserOnEDitProfile.frame.size.width);
    imgViewUserOnEDitProfile.layer.cornerRadius=imgViewUserOnEDitProfile.frame.size.width/2;
    imgViewUserOnEDitProfile.clipsToBounds=YES;
    
    if (dicUserProfileInfoAfterUpdate.count==0)
    {
        
        
        txtFFirstnameH1.text=[NSString stringWithFormat:@"%@ ",[[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userdataKey"]] objectAtIndex:0] objectForKey:@"first_name"]];
        
        txtFEmailH1.text=[NSString stringWithFormat:@"%@ ",[[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userdataKey"]] objectAtIndex:0] objectForKey:@"email"]];
        
        txtFMobileH1.text=[NSString stringWithFormat:@"%@ ",[[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userdataKey"]] objectAtIndex:0] objectForKey:@"phone_number"]];
        
        
        txtFFirstname.text=[NSString stringWithFormat:@"%@ ",[[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userdataKey"]] objectAtIndex:0] objectForKey:@"first_name"]];
        
        txtFEmail.text=[NSString stringWithFormat:@"%@ ",[[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userdataKey"]] objectAtIndex:0] objectForKey:@"email"]];
        
        txtFMobile.text=[NSString stringWithFormat:@"%@ ",[[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userdataKey"]] objectAtIndex:0] objectForKey:@"phone_number"]];
    }
    else
    {
        txtFFirstnameH1.text    =   [dicUserProfileInfoAfterUpdate objectForKey:@"first_name"];
        txtFMobileH1.text       =   [dicUserProfileInfoAfterUpdate objectForKey:@"phone_number"];
        txtFEmailH1.text        =   [dicUserProfileInfoAfterUpdate objectForKey:@"email"];
        lblUserName.text        =   txtFFirstnameH1.text;
        
    }
    
    
    

    
    if ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale] == 667.0f)
    {
        [editProfile setFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height )];
    }
    else
    {
        
    }
  
    
    [self.view addSubview:editProfile];
    
    
}




-(IBAction)btn_UploadProPic:(id)sender
{
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    
    imgPicker.delegate=self;
    
    [self presentViewController:imgPicker animated:YES completion:nil];
    
    
    
}

-(IBAction)btnSaveClicked:(id)sender
{
    txtFFirstname.text=[txtFFirstname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    txtFEmail.text=[txtFEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    txtFMobile.text=[txtFMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    txtFPassword.text=[txtFPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if([[txtFFirstname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFFirstname.text==nil)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter first name." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFFirstname becomeFirstResponder];
    }
    else if([[txtFEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFEmail.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter email." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFEmail becomeFirstResponder];
        
    }
    else if(![self NSStringIsValidEmail:txtFEmail.text])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter valid email." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFEmail becomeFirstResponder];
        
    }
    else if([[txtFMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFMobile.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter mobile number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFMobile becomeFirstResponder];
        
    }
    else if (txtFMobile.text.length<10)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter proper mobile number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFMobile becomeFirstResponder];
        
    }
    else if([[txtFPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFPassword.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter password." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFPassword becomeFirstResponder];
        
    }
    else if (txtFPassword.text.length<5)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter min 5 characters in password." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtFPassword becomeFirstResponder];
        
    }
    else
    {
        
        
        if([QAUtils IsNetConnected])
        {
            strType=@"saveProfile";
            
            [btnBackOnEditProfile setTitle:@"BACK" forState:UIControlStateNormal];
            [btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
            
            NSString *strUserId=[[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userdataKey"]] objectAtIndex:0] objectForKey:@"id"];
            
            NSDictionary *dicInfo=[[NSDictionary alloc]initWithObjectsAndKeys:txtFFirstname.text,@"first_name",
                                   txtFEmail.text,@"email",
                                   txtFMobile.text,@"phone_number",
                                   txtFPassword.text,@"password",
                                   strUserId,@"user_id",nil];
            
            dicUserProfileInfoAfterUpdate=dicInfo;
            
            //{"email":"ravi1@netleon.com","password":"shane", "first_name":"Ravis", "phone_number":"1234567890", "user_id":"6"}
            
            [DSBezelActivityView  newActivityViewForView:self.view];
            
            NSURL *url=[NSURL URLWithString:@"http://netleondev.com/kentapi/user/update"];
            
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            
            [request addRequestHeader:@"Content-type" value:@"application/json"];
            [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
            
            [request setRequestMethod:@"POST"];
            request.delegate=self;
            request.allowCompressedResponse = NO;
            request.useCookiePersistence = NO;
            request.shouldCompressRequestBody = NO;
            request.timeOutSeconds=60;
            
            NSString *jsonRequest = [dicInfo JSONRepresentation];
            
            NSLog(@"jsonRequest is %@", jsonRequest);
            
            
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

-(IBAction)btnBackEditProfileDidClicked:(id)sender
{
   
    
    
    if ([btnBackOnEditProfile.titleLabel.text isEqualToString:@"BACK"])
    {
        if (dicUserProfileInfoAfterUpdate.count==0)
        {
            
        }
        else
        {
            txtFFirstnameH1.text=[dicUserProfileInfoAfterUpdate objectForKey:@"first_name"];
            txtFMobileH1.text=[dicUserProfileInfoAfterUpdate objectForKey:@"phone_number"];
            txtFEmailH1.text=[dicUserProfileInfoAfterUpdate objectForKey:@"email"];
            lblUserName.text=txtFFirstnameH1.text;

        }
        
        profileView.hidden=NO;
         [editProfile removeFromSuperview];
    }
    else if([btnBackOnEditProfile.titleLabel.text isEqualToString:@"CANCEL"])
    {
        [btnBackOnEditProfile setTitle:@"BACK" forState:UIControlStateNormal];
        [btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
        
        
        if (dicUserProfileInfoAfterUpdate.count==0)
        {
            
        }
        else
        {
            txtFFirstnameH1.text=[dicUserProfileInfoAfterUpdate objectForKey:@"first_name"];
            txtFMobileH1.text=[dicUserProfileInfoAfterUpdate objectForKey:@"phone_number"];
            txtFEmailH1.text=[dicUserProfileInfoAfterUpdate objectForKey:@"email"];
            lblUserName.text=txtFEmailH1.text;
            
        }
        
        
  
        
        seeProfile.hidden=NO;
        changeProfile.hidden=YES;
    }
}

-(IBAction)btnEditONEditProfileDidClicked:(id)sender
{
    seeProfile.hidden=YES;
    changeProfile.hidden=NO;
    viewRestauInfo.hidden=YES;
    viewPriceCFU.hidden=NO;
    
    if ([btnEditOnEditProfile.titleLabel.text isEqualToString:@"EDIT"])
    {
        
        
        
        
        [btnBackOnEditProfile setTitle:@"CANCEL" forState:UIControlStateNormal];
        [btnEditOnEditProfile setTitle:@"DONE" forState:UIControlStateNormal];
    }
    else if([btnEditOnEditProfile.titleLabel.text isEqualToString:@"DONE"])
    {
        txtFFirstname.text=[txtFFirstname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        txtFEmail.text=[txtFEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         txtFMobile.text=[txtFMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         txtFPassword.text=[txtFPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        if([[txtFFirstname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFFirstname.text==nil)
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter first name." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFFirstname becomeFirstResponder];
        }
        else if([[txtFEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFEmail.text==nil)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter email." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFEmail becomeFirstResponder];
            
        }
        else if(![self NSStringIsValidEmail:txtFEmail.text])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter valid email." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFEmail becomeFirstResponder];
            
        }
        else if([[txtFMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFMobile.text==nil)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter mobile number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFMobile becomeFirstResponder];
            
        }
        else if (txtFMobile.text.length<10)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter proper mobile number." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFMobile becomeFirstResponder];
            
        }
        else if([[txtFPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]|| txtFPassword.text==nil)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter password." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFPassword becomeFirstResponder];
            
        }
        else if (txtFPassword.text.length<5)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter min 5 characters in password." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtFPassword becomeFirstResponder];
            
        }
        else
        {
          
            if([QAUtils IsNetConnected])
            {
                strType=@"editProfile";
                
                [btnBackOnEditProfile setTitle:@"BACK" forState:UIControlStateNormal];
                [btnEditOnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
                
                NSString *strUserId=[[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userdataKey"]] objectAtIndex:0] objectForKey:@"id"];
                
                NSDictionary *dicInfo=[[NSDictionary alloc]initWithObjectsAndKeys:txtFFirstname.text,@"first_name",
                                       txtFEmail.text,@"email",
                                       txtFMobile.text,@"phone_number",
                                       txtFPassword.text,@"password",
                                       strUserId,@"user_id",nil];
                
                dicUserProfileInfoAfterUpdate=dicInfo;
                //{"email":"ravi1@netleon.com","password":"shane", "first_name":"Ravis", "phone_number":"1234567890", "user_id":"6"}
                
                [DSBezelActivityView  newActivityViewForView:self.view];
                
                NSURL *url=[NSURL URLWithString:@"http://netleondev.com/kentapi/user/update"];
                
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                
                [request addRequestHeader:@"Content-type" value:@"application/json"];
                [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
                
                [request setRequestMethod:@"POST"];
                request.delegate=self;
                request.allowCompressedResponse = NO;
                request.useCookiePersistence = NO;
                request.shouldCompressRequestBody = NO;
                
                NSString *jsonRequest = [dicInfo JSONRepresentation];
                
                NSLog(@"jsonRequest is %@", jsonRequest);
                
                
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


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


-(IBAction)btnUserDidClicked:(id)sender
{
    if (isFisrtTimeForReceiptApi==NO)
    {
//        strType=@"userReceipt";
//        
//        isFisrtTimeForReceiptApi=YES;
//         [self userReceipt];
    }
    
    if (ViewDropdown.hidden==NO){
        txtFSearch .userInteractionEnabled=YES;
        
        imgViewLeftSearch.image=[UIImage imageNamed:@"downarrow.png"];
        
        ViewDropdown.hidden = YES;
        
        tbleLocation.hidden=YES;
        tbleCat.hidden=YES;
        tblePrice.hidden=YES;
    }
    
    strType=@"userReceipt";
    [self userReceipt];
   
    
    
    //[viewRestaurentListAfterSearch removeFromSuperview];
   // [viewRestaurentReview removeFromSuperview];
    
    [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:1500];
    [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
    
    if (sender) {
        UIView *view=profileView;
        
        
        
        [UIView animateWithDuration:.5
                              delay:.1
                            options:UIViewAnimationCurveEaseOut
                         animations:^ {
                             CGRect frame = view.frame;
                             frame.origin.y = 0;
                             frame.origin.x = (0);
                             view.frame = frame;
                         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
    }
    
    
    

    

    
}


-(void)userReceipt
{
    if([QAUtils IsNetConnected])
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"userdataKey"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"%@",arr);
        
        
        
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
        request.timeOutSeconds=60;
        
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




-(IBAction)btnCancelDidClicked:(id)sender
{
    
    UIView *view=profileView;
    
    [UIView animateWithDuration:.5
                          delay:.1
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         CGRect frame = view.frame;
                         frame.origin.y = -1200;
                         frame.origin.x = (0);
                         view.frame = frame;
                     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];

}


-(IBAction)btnONUserProfileDidClicked:(UIButton*)sender
{
    if (sender.tag==10) //find a restaurant
    {
        [sender setBackgroundColor:[UIColor clearColor]];
        
        
        
        [self btnCancelDidClicked:nil];
        
        [self btn_GogleDidClicked:nil];
        
        //[self getAllRestaurants];
        
    }
    else if (sender.tag==20) //Pay With Kent
    {
        [sender setBackgroundColor:[UIColor clearColor]];
        
        
        
    }
    else if (sender.tag==30) //Payments
    {
        [sender setBackgroundColor:[UIColor clearColor]];
        
        PaymentVC *paymentOb = [[PaymentVC alloc]initWithNibName:@"PaymentVC" bundle:nil];
        [self.navigationController pushViewController:paymentOb animated:YES];

        
    }
    else if (sender.tag==40) //Reservation
    {
        [sender setBackgroundColor:[UIColor clearColor]];
        
        ReservationVC *reservationOb = [[ReservationVC alloc]initWithNibName:@"ReservationVC" bundle:nil];
        [self.navigationController pushViewController:reservationOb animated:YES];
        
    }
    else if (sender.tag==50) //Receipta
    {
        [sender setBackgroundColor:[UIColor clearColor]];
        
        ReceiptVC *receiptOb = [[ReceiptVC alloc]initWithNibName:@"ReceiptVC" bundle:nil];
        
        [self.navigationController pushViewController:receiptOb animated:YES];
        
    }
    else if (sender.tag==60) //Supports
    {
        [sender setBackgroundColor:[UIColor clearColor]];
        
    }
    else if (sender.tag==70) //Logout
    {
        [sender setBackgroundColor:[UIColor clearColor]];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"Do you want to logout?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert show];
        
        
    }
    
    [sender setBackgroundColor:[UIColor clearColor]];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) //yes
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userdataKey"];
        
        [NSUserDefaults resetStandardUserDefaults];
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonIndex==1) //no
    {
        
    }
    
    
   
}




-(IBAction)btnTouchDownONUserProfile:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:84.0/255.0 green:134.0/255.0 blue:182.0/255.0 alpha:1]];
}


- (IBAction)BtnDropDownSerch:(id)sender
{
    UIButton *btn=sender;
 /*    
    btnOnLocation.enabled=NO;
    btnOnCategory.enabled=NO;
    btnOnPrice.enabled=NO;
    btnOnType.enabled=NO;
    

    
   [btnCheckBoxLocation setImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
    lblLocation.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    txtFLocation.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    
    [btnCheckBoxPrice setImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
    lblPrizeCasual.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    txtFPrizeCasual.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    
    [btnCheckBoxCategory setImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
    lblCatgory.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    txtFCatgory.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    
    [btnCheckBoxType setImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
    lblType.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    txtFType.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    
    */
    
    
    

    if (ViewDropdown.hidden==YES)
    {
        
        txtFSearch .userInteractionEnabled=NO;
        txtFSearch.text=@"";

        
        imgViewLeftSearch.image=[UIImage imageNamed:@"uparrow.png"];
//        if (isFisrtTime==NO)
//        {
//            
//            
//            
//            [self getRestaurantByCategories];
//            isFisrtTime=YES;
//        }
       
         ViewDropdown.hidden = NO;
        
        
//        NSMutableArray *arrMut=[NSMutableArray new];
//        
//        for (int i=0; i<[[outputRastByCat objectAtIndex:1]count]; i++)
//        {
//            [arrMut addObject:[[[outputRastByCat objectAtIndex:1]objectAtIndex:i] objectForKey:@"name" ]  ] ;
//        }
        
    }
    else
    {
        
        txtFSearch .userInteractionEnabled=YES;
        
        imgViewLeftSearch.image=[UIImage imageNamed:@"downarrow.png"];
              
        ViewDropdown.hidden = YES;
        
        tbleLocation.hidden=YES;
        tbleCat.hidden=YES;
        tblePrice.hidden=YES;
    
    }
    
}


-(IBAction)BtnUpscale:(id)sender
{
    UIButton *btn=sender;
        
    
        NSString *strId;
    
    if ([outputRastByCat count]==0)
    {
        
    }
    else
    {
        if ([outputAllRestaurents count]==0)
        {
            
        }
        else
        {
            
           
            
                //strSearchType=@"searchInAllRestarents";
            
                if (btn.tag==10)  //Casual
                {
                    strFilterType=@"Casual";
                    
                    
                    
                    [btnCasual2 setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
                    [btnRecomended setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                    [btnFine2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                    
                    
                    
                    for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
                    {
                        if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Casual"])
                        {
                            strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                            break;
                        }
                        
                    }
                    
                    
                }
                else if(btn.tag==20)  //Recommended
                {
                    strFilterType=@"Recommended ";
                    
                    
                    
                    [btnCasual2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                    [btnRecomended setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
                    [btnFine2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                    
                    
                    
                    for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
                    {
                        if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Recommended "])
                        {
                            strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                            break;
                        }
                        
                    }
                    
                    
                    
                }
                else if (btn.tag==30) //Fine
                {
                    strFilterType=@"Fine";
                    
                    [btnCasual2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                    [btnRecomended setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
                    [btnFine2 setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
                    
                    for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
                    {
                        if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Fine"])
                        {
                            strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                            break;
                        }
                        
                    }
                    
                
                }
                
                
                NSPredicate *resultPredicate = [NSPredicate
                                                predicateWithFormat:@"SELF contains[cd] %@",strId];
            
            
            
            
            if ([strSearchType isEqualToString:@"searchInAllRestarents"])
            {
                NSMutableArray *arrBottomSearch=[NSMutableArray new];
                
                [ arrBottomSearch addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                
                [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
                
                // NSLog(@"dicSearchId=%@",dicSearchId);
                NSLog(@"arrAfterSearch =%@",arrBottomSearch);
                
                [arrAfterSearch removeAllObjects];
                // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<arrBottomSearch.count; i++)
                {
                    if ([[arrBottomSearch objectAtIndex:i] count]>0)
                    {
                        for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                        {
                            // if()
                            for (int j=0; j< [outputAllRestaurents count]; j++)
                            {
                                if ([arrCat isEqualToArray:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"categories"]])
                                {
                                    [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                }
                            }
                            
                            
                        }
                    }
                }
                

            }
            else
            {
                
                NSMutableArray *arrBottomSearch=[NSMutableArray new];
                
                
                if (isBackCicked==NO)
                {
                    [arrTemp removeAllObjects];
                    [arrTemp addObjectsFromArray:arrAfterSearch];
                }
                
                [arrTemp setArray:[[NSSet setWithArray:arrTemp] allObjects]];

                
               
                
                [ arrBottomSearch addObject:[[arrTemp  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                
                [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
                
                // NSLog(@"dicSearchId=%@",dicSearchId);
                NSLog(@"arrAfterSearch =%@",arrBottomSearch);
                
                [arrAfterSearch removeAllObjects];
                // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<arrBottomSearch.count; i++)
                {
                    if ([[arrBottomSearch objectAtIndex:i] count]>0)
                    {
                        for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                        {
                            // if()
                            for (int j=0; j< [arrTemp count]; j++)
                            {
                                if ([arrCat isEqualToArray:[[arrTemp objectAtIndex:j] objectForKey:@"categories"]])
                                {
                                    [arrAfterSearch addObject:[arrTemp objectAtIndex:j]];
                                }
                            }
                            
                            
                        }
                    }
                }

                
            }

            
            
           
            [self performSelector:@selector(hideViews) withObject:self afterDelay:.5];
            imgViewWIfi.hidden=YES;
            [btnONWifi setTitle:@"BACK" forState:UIControlStateNormal];
           
            tblVUpscale.delegate=self;
            tblVUpscale.dataSource=self;
            [tblVUpscale reloadData];
            
            
           // [self.view addSubview:viewRestaurentListAfterSearch];
            
            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:viewInHeader.frame.size.height];
            
          //  NSTimer *timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(hideViews) userInfo:nil repeats:NO];
            
           
            

            
            

        }
        
    }
        
    
    
    
    
       // upScale *upscale = [[upScale alloc]init];
       // upscale.arrListOfRestaurent=arrAfterSearch;
        
        //[self.navigationController pushViewController:upscale animated:YES];
    
    

}

-(void)hideViews
{
    viewRestauInfo.hidden=YES;
//    viewPriceCFU.hidden=YES;
    [UIView animateWithDuration:.5
                          delay:.1
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         viewPriceCFU.alpha =   0;
                         
                     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         viewPriceCFU.hidden=YES;
         viewPriceCFU.alpha =   1;
     }];
}

-(void)showHideviewWithAnimation:(UIView*)newView withXAxis:(int)xAxis withYAxis:(int)yAxis
{
    
    UIView *view=newView;
    
    [UIView animateWithDuration:.5
                          delay:.1
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         CGRect frame = view.frame;
                         frame.origin.x = xAxis;
                         frame.origin.y = yAxis;
                         view.frame = frame;
                     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
    
    
}


-(IBAction)btnThreeFilter:(id)sender
{
    UIButton *btn=sender;
    
    viewRestauInfo.hidden=YES;
    viewPriceCFU.hidden=YES;
   

    
    NSString *strId;
    
    
    if ([strSearchType isEqualToString:@""])
    {
        
    }
    else
    {
        
    }
    

        if (btn.tag==10)  //Casual
        {
            strFilterType=@"Casual";
            
            
            int xPoint=0,yPoint=0;
            
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if (result.height < 500) // iPhone 4S / 4th Gen iPod Touch or earlier
                {
                    xPoint=58;
                    yPoint=31;
                }
                else if (result.height == 568) // iPhone 4S / 4th Gen iPod Touch or earlier
                {
                    xPoint=58;
                    yPoint=31;
                }
                else if (result.height == 667) // iPhone 6
                {
                    xPoint=69;
                    yPoint=31;
                }
                else if (result.height == 736) // iPhone 6+
                {
                    xPoint=79;
                    yPoint=31;
                }
                
            }
            

            
            
            UIView *view=imgVAnimate;
            
            [UIView animateWithDuration:.3
                                  delay:.1
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 CGRect frame = view.frame;
                                 frame.origin.x = xPoint;
                                 frame.origin.y = yPoint;
                                 view.frame = frame;
                             }
                             completion:^(BOOL finished)
             {
                 NSLog(@"Completed");
                 
             }];

            
            
            [btnCasual2 setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
            [btnRecomended setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
            [btnFine2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
            
            
            for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
            {
                if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Casual"])
                {
                    strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                    break;
                }
                
            }
            
            
        }
        else if(btn.tag==20)  //Fine
        {
            
            strFilterType=@"Fine";
            
            
            int xPoint=0,yPoint=0;
            
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if (result.height < 500) // iPhone 4S / 4th Gen iPod Touch or earlier
                {
                    xPoint=38;
                    yPoint=31;
                }
                else if (result.height == 568) // iPhone 4S / 4th Gen iPod Touch or earlier
                {
                    xPoint=144;
                    yPoint=31;
                }
                else if (result.height == 667) // iPhone 6
                {
                    xPoint=170;
                    yPoint=31;
                }
                else if (result.height == 736) // iPhone 6+
                {
                    xPoint=189;
                    yPoint=31;
                }
                
            }

            
            UIView *view=imgVAnimate;
            
            [UIView animateWithDuration:.3
                                  delay:.1
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 CGRect frame = view.frame;
                                 frame.origin.x = xPoint;
                                 frame.origin.y = yPoint;
                                 view.frame = frame;
                             }
                             completion:^(BOOL finished)
             {
                 NSLog(@"Completed");
                 
             }];
            
            
            [btnCasual2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
            [btnRecomended setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
            [btnFine2 setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
            
            
            for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
            {
                if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Fine"])
                {
                    strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                    break;
                }
                
            }
            
            
            
            
        }
        else if (btn.tag==30) //Recommended
        {
            
            strFilterType=@"Recommended ";
            
            
            int xPoint=0,yPoint=0;
            
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if (result.height < 500) // iPhone 4S / 4th Gen iPod Touch or earlier
                {
                    xPoint=38;
                    yPoint=31;
                }
                else if (result.height == 568) // iPhone 4S / 4th Gen iPod Touch or earlier
                {
                    xPoint=238;
                    yPoint=31;
                }
                else if (result.height == 667) // iPhone 6
                {
                    xPoint=280;
                    yPoint=31;
                }
                else if (result.height == 736) // iPhone 6+
                {
                    xPoint=311;
                    yPoint=31;
                }
                
            }

            
            
            UIView *view=imgVAnimate;
            
            [UIView animateWithDuration:.3
                                  delay:.1
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 CGRect frame = view.frame;
                                 frame.origin.x = xPoint;
                                 frame.origin.y = yPoint;
                                 view.frame = frame;
                             }
                             completion:^(BOOL finished)
             {
                 NSLog(@"Completed");
                 
             }];
            
            [btnCasual2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
            [btnRecomended setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
            [btnFine2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
            
            
            for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
            {
                if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Recommended "])
                {
                    strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                    break;
                }
                
            }
            
        }
        
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF contains[cd] %@",strId];
        
        
    
   
 
    
    if ([strSearchType isEqualToString:@"searchInAllRestarents"])
    {
         NSMutableArray *arrBottomSearch=[NSMutableArray new];
        
        [ arrBottomSearch addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
        
        [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
        
        // NSLog(@"dicSearchId=%@",dicSearchId);
        NSLog(@"arrAfterSearch =%@",arrBottomSearch);
        
        
        [arrAfterSearch removeAllObjects];
        //arrAfterSearch=[NSMutableArray new];
        
        for (int i=0;i<arrBottomSearch.count; i++)
        {
            if ([[arrBottomSearch objectAtIndex:i] count]>0)
            {
                for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                {
                    // if()
                    for (int j=0; j< [outputAllRestaurents count]; j++)
                    {
                        if ([arrCat isEqualToArray:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"categories"]])
                        {
                            [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                        }
                    }
                    
                    
                }
            }
        }

        
    }
    else
    {
        
        NSMutableArray *arrBottomSearch=[NSMutableArray new];
//        arrTemp=[NSMutableArray new];
//        
//        [arrTemp addObjectsFromArray:arrAfterSearch];
        
        [ arrBottomSearch addObject:[[arrTemp  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
        
        [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
        
        // NSLog(@"dicSearchId=%@",dicSearchId);
        NSLog(@"arrAfterSearch =%@",arrBottomSearch);
        
        [arrAfterSearch removeAllObjects];
        // arrAfterSearch=[NSMutableArray new];
        
        for (int i=0;i<arrBottomSearch.count; i++)
        {
            if ([[arrBottomSearch objectAtIndex:i] count]>0)
            {
                for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
                {
                    // if()
                    for (int j=0; j< [arrTemp count]; j++)
                    {
                        if ([arrCat isEqualToArray:[[arrTemp objectAtIndex:j] objectForKey:@"categories"]])
                        {
                            [arrAfterSearch addObject:[arrTemp objectAtIndex:j]];
                        }
                    }
                    
                    
                }
            }
        }
        
        
    }
    
    
    
    
    /*
    if (btn.tag==10)  //Casual
    {
        strFilterType=@"Casual";
     
     
        [btnCasual2 setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
        [btnRecomended setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
        [btnFine2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
        
        
        for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
        {
            if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Casual"])
            {
                strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                break;
            }
            
        }
        
        
    }
    else if(btn.tag==20)  //Fine
    {
        
        strFilterType=@"Fine";
        
        
        [btnCasual2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
        [btnRecomended setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
        [btnFine2 setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
        
        
        for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
        {
            if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Fine"])
            {
                strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                break;
            }
            
        }

        
        
        
    }
    else if (btn.tag==30) //Recommended
    {
        
        strFilterType=@"Recommended ";
        
        
        [btnCasual2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
        [btnRecomended setImage:[UIImage imageNamed:@"white_circle.png"] forState:UIControlStateNormal];
        [btnFine2 setImage:[UIImage imageNamed:@"black_circle.png"] forState:UIControlStateNormal];
        
        
        for (int i=0; i<[[outputRastByCat objectAtIndex:2]count]; i++)
        {
            if ([[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"name"] isEqualToString:@"Recommended "])
            {
                strId=[[[outputRastByCat objectAtIndex:2] objectAtIndex:i] objectForKey:@"id"];
                break;
            }
            
        }
        
    }
    
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",strId];
    
    
    [ arrBottomSearch addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
    
    [arrBottomSearch setArray:[[NSSet setWithArray:arrBottomSearch] allObjects]];
    
    // NSLog(@"dicSearchId=%@",dicSearchId);
    NSLog(@"arrAfterSearch =%@",arrBottomSearch);
    
    arrAfterSearch=[NSMutableArray new];
    
    for (int i=0;i<arrBottomSearch.count; i++)
    {
        if ([[arrBottomSearch objectAtIndex:i] count]>0)
        {
            for (NSArray *arrCat in [arrBottomSearch objectAtIndex:i]  )
            {
                // if()
                for (int j=0; j< [outputAllRestaurents count]; j++)
                {
                    if ([arrCat isEqualToArray:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"categories"]])
                    {
                        [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                    }
                }
                
                
            }
        }
    }
    
    */
    
    
    

    
    tblVUpscale.delegate=self;
    tblVUpscale.dataSource=self;
    [tblVUpscale reloadData];
}


-(void)afterReservationDirect{
    if (isDirectReservation == YES) {
        
        NSLog(@"HELLO KIYA");
        [btnONWifi sendActionsForControlEvents: UIControlEventTouchUpInside];
        isDirectReservation = NO;
        
    }else{
        NSLog(@"Direct Data");
    }
}

-(IBAction)btnWifiDidClicked:(id)sender
{
    
    
    if ([btnONWifi.titleLabel.text isEqualToString:@"BACK"])
    {   
        isDirectReservation = NO;
        
        if ([strMapDidClicked isEqualToString:@"yes"])
        {
             strMapDidClicked=@"Reset";
            viewRestauInfo.hidden=NO;
            viewPriceCFU.hidden=YES;
            
           
           // [viewRestaurentReview removeFromSuperview];
           // [viewRestaurentListAfterSearch removeFromSuperview];
            
            [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:1500];
             [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
        }
        else if ([strMapDidClicked isEqualToString:@"Reset"])
        {
            strMapDidClicked=@"";
            imgViewWIfi.hidden=NO;
            [btnONWifi setTitle:nil forState:UIControlStateNormal];
            
            
            
            
            CLLocationCoordinate2D coord;
            
            coord.latitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:index] objectForKey:@"latitude"]] floatValue];
            coord.longitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:index] objectForKey:@"longitude"]] floatValue];
            

            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (coord, 1000000, 1000000);
            
            region = [mapView regionThatFits:region];
            [mapView setRegion:region animated:YES];
            
            
            
            isBackCicked=YES;
            viewRestauInfo.hidden=YES;
            viewPriceCFU.hidden=NO;
            
            imgViewWIfi.hidden=NO;
            [btnONWifi setTitle:nil forState:UIControlStateNormal];
           // [viewRestaurentReview removeFromSuperview];
            //[viewRestaurentListAfterSearch removeFromSuperview];
            [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:1500];

            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
            
            
        }else if ([strMapDidClicked isEqualToString:@"Restro"])
        {
            strMapDidClicked=@"Reset";
            isBackCicked=YES;
            viewRestauInfo.hidden=NO;
            viewPriceCFU.hidden=YES;
            
            [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:1500];
            
            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
        }
        else
        {
            isBackCicked=YES;
            viewRestauInfo.hidden=YES;
            viewPriceCFU.hidden=NO;
            
            imgViewWIfi.hidden=NO;
            [btnONWifi setTitle:nil forState:UIControlStateNormal];
           // [viewRestaurentReview removeFromSuperview];
           // [viewRestaurentListAfterSearch removeFromSuperview];
            
            [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:1500];

            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
            
           // strSearchType=@"";
            
        }
        
        
    }
    else
    {
       // [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
//    mapView.showsUserLocation=TRUE;
//    
//    MKUserLocation *userLocation = mapView.userLocation;
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
//    [mapView setRegion:region animated:NO];

}



-(IBAction)btnLocationDidClicked:(id)sender
{
    UIButton *btn=sender;
    [txtFSearch resignFirstResponder];

    if ([[outputRastByCat objectAtIndex:1] count]>0)
    {
        
//            tbleLocation=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewDropdown.frame.size.width, ViewDropdown.frame.size.height)];
            
            tbleLocation=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 250,400)];
            [tbleLocation setBackgroundColor:[UIColor clearColor]];
            tbleLocation.separatorColor=[UIColor clearColor];
            tbleLocation.layer.cornerRadius = 2.f;
            tbleLocation.layer.borderWidth = 0.5f;
            tbleLocation.tag=3;
            tbleLocation.delegate=self;
            tbleLocation.dataSource=self;
           // [ViewDropdown addSubview:tbleLocation];
            
            [tbleLocation reloadData];
            
            
            modal = [[RNBlurModalView alloc] initWithView:tbleLocation];
            
            modal.defaultHideBlock = ^{
                NSLog(@"Code called after the modal view is hidden");
            };
            
            //    modal.dismissButtonRight = YES;
            [modal show];

            
       
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"No Location avialble in the list." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
}
-(IBAction)btnPriceDidClicked:(id)sender
{
   // tbleView1.hidden=NO;
    UIButton *btn=sender;
    
    [txtFSearch resignFirstResponder];

    
    
    
    if ([[outputRastByCat objectAtIndex:2] count]>0)
    {
//        if (btn.tag==20)
//        {
//            btn.tag=15;
        
            //tblePrice=[[UITableView alloc]initWithFrame:CGRectMake(125, 136, 174, 120)];
            tblePrice=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 250,132)];
            [tblePrice setBackgroundColor:[UIColor clearColor]];
            tblePrice.layer.cornerRadius = 2.f;
            tblePrice.layer.borderWidth = 0.5f;

            tblePrice.tag=1;
            tblePrice.delegate=self;
            tblePrice.dataSource=self;
            tblePrice.separatorColor=[UIColor clearColor];
           // [ViewDropdown addSubview:tblePrice];
        
        modal = [[RNBlurModalView alloc] initWithView:tblePrice];
        
        modal.defaultHideBlock = ^{
            NSLog(@"Code called after the modal view is hidden");
        };
        
        //    modal.dismissButtonRight = YES;
        [modal show];

        
            [tblePrice reloadData];
            
//        }
//        else
//        {
//            btn.tag=20;
//            tblePrice.hidden=YES;
//        }
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"No Price avialble in the list." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
    //[tbleView1 setFrame:CGRectMake(tbleView1.frame.origin.x, tbleView1.frame.origin.y+75, tbleView1.frame.size.width, tbleView1.frame.size.height)];
}
-(IBAction)btnCategoryhDidClicked:(id)sender
{
    
    UIButton *btn=sender;
    
    [txtFSearch resignFirstResponder];

    
    if ([[outputRastByCat objectAtIndex:3] count]>0)
    {
//        if (btn.tag==10)
//        {
//            btn.tag=5;
        
            tbleCat=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 250,400)];
            [tbleCat setBackgroundColor:[UIColor clearColor]];
            tbleCat.separatorColor=[UIColor clearColor];
            tbleCat.layer.cornerRadius = 2.f;
            tbleCat.layer.borderWidth = 0.5f;
            tbleCat.tag=2;
            tbleCat.delegate=self;
            tbleCat.dataSource=self;
           // [ViewDropdown addSubview:tbleCat];
        
        
            [tbleCat reloadData];
        
        modal = [[RNBlurModalView alloc] initWithView:tbleCat];
        
        modal.defaultHideBlock = ^{
            NSLog(@"Code called after the modal view is hidden");
        };
        
        //    modal.dismissButtonRight = YES;
        [modal show];
        
        
        [tblePrice reloadData];

            
            
//        }
//        else
//        {
//            btn.tag=10;
//            tblePrice.hidden=YES;
//        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"No Category avialble in the list." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
    

    
    
   }

-(IBAction)btnTypeDidClicked:(id)sender
{
    
    
    UIButton *btn=sender;
    
    
    
    
    if ([[outputRastByCat objectAtIndex:4] count]>0)
    {
        if (btn.tag==30)
        {
            btn.tag=35;
            
            //tblePrice=[[UITableView alloc]initWithFrame:CGRectMake(125, 136, 174, 120)];
            tblType=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewDropdown.frame.size.width, ViewDropdown.frame.size.height)];
            [tblType setBackgroundColor:[UIColor clearColor]];
            tblType.separatorColor=[UIColor clearColor];
            tblType.tag=4;
            tblType.delegate=self;
            tblType.dataSource=self;
            [ViewDropdown addSubview:tblType];
            
            [tblType reloadData];
            
        }
        else
        {
            btn.tag=30;
            tblePrice.hidden=YES;
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"No Type avialble in the list." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
    
}


-(IBAction)btnCheckBoxDidClicked:(id)sender
{
   /* UIButton *btn=sender;
    
    if (btn.tag==10) //location
    {
        btn.tag=-10;
        btnOnLocation.enabled=YES;
        [btn setImage:[UIImage imageNamed:@"checkboxFilled.png"] forState:UIControlStateNormal];
        lblLocation.textColor=[UIColor blackColor];
        txtFLocation.textColor=[UIColor blackColor];
        
        
        
    }
    else  if (btn.tag==-10)
    {
        btn.tag=10;
        btnOnLocation.enabled=NO;
        [btn setImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
        lblLocation.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
        txtFLocation.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    }
    
    if (btn.tag==20)  //price
    {
        btn.tag=-20;
        btnOnPrice.enabled=YES;
        [btn setImage:[UIImage imageNamed:@"checkboxFilled.png"] forState:UIControlStateNormal];
        lblPrizeCasual.textColor=[UIColor blackColor];
        txtFPrizeCasual.textColor=[UIColor blackColor];
        

        
    }
    else  if (btn.tag==-20)
    {
        btn.tag=20;
        btnOnPrice.enabled=NO;
        [btn setImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
        lblPrizeCasual.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
        txtFPrizeCasual.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
     
        
    }
    
    if (btn.tag==30) //category
    {
        btn.tag=-30;
        btnOnCategory.enabled=YES;
        
        [btn setImage:[UIImage imageNamed:@"checkboxFilled.png"] forState:UIControlStateNormal];
        lblCatgory.textColor=[UIColor blackColor];
        txtFCatgory.textColor=[UIColor blackColor];
        

        
    }
    else  if (btn.tag==-30)
    {
        btn.tag=30;
        btnOnCategory.enabled=NO;
        [btn setImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
        lblCatgory.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
        txtFCatgory.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];

        
    }
    
    
    if (btn.tag==40) //type
    {
        btn.tag=-40;
        btnOnType.enabled=YES;
        [btn setImage:[UIImage imageNamed:@"checkboxFilled.png"] forState:UIControlStateNormal];
        lblType.textColor=[UIColor blackColor];
        txtFType.textColor=[UIColor blackColor];

        
    }
    else if (btn.tag==-40)
    {
        btn.tag=40;
        btnOnType.enabled=NO;
        [btn setImage:[UIImage imageNamed:@"checkboxEmpty.png"] forState:UIControlStateNormal];
        lblType.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
        txtFType.textColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
        
    }
    */
}

-(IBAction)btnSearchDidClicked:(id)sender
{
    
    

    if ([txtFLocation.text isEqualToString:@"Select"]&&[txtFPrizeCasual.text isEqualToString:@"Select"]&&[txtFCatgory.text isEqualToString:@"Select"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"Please choose any filter." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ([outputAllRestaurents count]==0)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"No restaurent availavle" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            
            [alert show];
            
        }
        else
        {
            
            
                txtFSearch .userInteractionEnabled=YES;
                imgViewLeftSearch.image=[UIImage imageNamed:@"downarrow.png"];
                
                ViewDropdown.hidden = YES;
                tbleLocation.hidden=YES;
                tbleCat.hidden=YES;
                tblePrice.hidden=YES;
            
                viewRestauInfo.hidden=YES;
                viewPriceCFU.hidden=NO;
                    
                
                NSMutableArray *arrFilterKeys=[NSMutableArray new];
                
                
                if (btnOnLocation.enabled==YES)
                {
                    [arrFilterKeys addObject:txtFLocation.text];
                    
                }
                if (btnOnPrice.enabled==YES)
                {
                    [arrFilterKeys addObject:txtFPrizeCasual.text];
                    
                }
                if (btnOnCategory.enabled==YES)
                {
                    
                    [arrFilterKeys addObject:txtFCatgory.text];
                    
                }
                if (btnOnType.enabled==YES)
                {
                    [arrFilterKeys addObject:txtFType.text];
                    
                }
            
             [arrFilterKeys setArray:[[NSSet setWithArray:arrFilterKeys] allObjects]];
            
            
                //        NSPredicate *resultPredicate = [NSPredicate
                //                                        predicateWithFormat:@"SELF contains[cd] %@",
                //                                        [dicSearchId objectForKey:@"locationIdKey"]];
            
                
                NSArray *arrFilterId=[dicSearchId allKeys];
                
                
                NSMutableArray *arrNakul=[NSMutableArray new];
            
                
                for (NSString *strKey in arrFilterId)
                {
                    if ([strKey isEqualToString:@"priceIdKey"])
                    {
                        
                        NSPredicate *resultPredicate = [NSPredicate
                                                        predicateWithFormat:@"SELF contains[cd] %@",[dicSearchId objectForKey:strKey]];
                        
                        
                        [ arrNakul addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                        
                        
                    }
                    if ([strKey isEqualToString:@"categoryIdKey"])
                    {
                        NSPredicate *resultPredicate = [NSPredicate
                                                        predicateWithFormat:@"SELF contains[cd] %@",[dicSearchId objectForKey:strKey]];
                        
                        
                        [ arrNakul addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                    }
                    if ([strKey isEqualToString:@"locationIdKey"])
                    {
                        NSPredicate *resultPredicate = [NSPredicate
                                                        predicateWithFormat:@"SELF contains[cd] %@",[dicSearchId objectForKey:strKey]];
                        
                        
                        [ arrNakul addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                    }
                    if ([strKey isEqualToString:@"typeIdKey"])
                    {
                        NSPredicate *resultPredicate = [NSPredicate
                                                        predicateWithFormat:@"SELF contains[cd] %@",[dicSearchId objectForKey:strKey]];
                        
                        
                        [ arrNakul addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
                    }
                }
                
                
                [arrNakul setArray:[[NSSet setWithArray:arrNakul] allObjects]];
                
                NSLog(@"dicSearchId=%@",dicSearchId);
                NSLog(@"arrAfterSearch =%@",arrNakul);
                
                [dicSearchId removeAllObjects];
                [arrAfterSearch removeAllObjects];
                
               // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<arrNakul.count; i++)
                {
                    if ([[arrNakul objectAtIndex:i] count]>0)
                    {
                        for (NSArray *arrCat in [arrNakul objectAtIndex:i]  )
                        {
                            // if()
                            for (int j=0; j< [outputAllRestaurents count]; j++)
                            {
                                if ([arrCat isEqualToArray:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"categories"]])
                                {
                                    [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                }
                            }
                            
                            
                        }
                    }
                }
                
            
            [arrAfterSearch setArray:[[NSSet setWithArray:arrAfterSearch] allObjects]];

            
            CustomMessage *cav=[[CustomMessage alloc] init];
            [cav show:[NSString stringWithFormat:@"%lu Restaurants found",(unsigned long)arrAfterSearch.count] inView:self.view delay:2 lYAxis:viewRestauInfo.frame.origin.y-20];
                
            
            strSearchType=@"";
            isBackCicked=NO;

            
                float minLat=0;
                float minLong=0;
                
                float maxLat=0;
                float maxLong=0;
                
                
                
                
                if (arrAfterSearch.count>0)
                {
                    minLat=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"latitude"] floatValue];
                    minLong=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"longitude"] floatValue];
                    
                    maxLat=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"latitude"] floatValue];
                    maxLong=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"longitude"] floatValue];
                    
                    for (int i=0; i<[arrAfterSearch count]; i++)
                    {
                        if (minLat>[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue])
                        {
                            minLat=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue];
                        }
                        if (minLong>[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue])
                        {
                            minLong=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue];
                        }
                        
                        if (maxLat<[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue])
                        {
                            maxLat=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue];
                        }
                        if (maxLong<[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue])
                        {
                            maxLong=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue];
                        }
                    }
                    
                }
                
                
                NSArray *existingpoints = mapView.annotations;
                if ([existingpoints count] > 0)
                    [mapView removeAnnotations:existingpoints];
                
                
                for ( int i=0; i<[arrAfterSearch count]; i++)
                {
                    CLLocationCoordinate2D coord;
                    
                    coord.latitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"latitude"]] floatValue];
                    coord.longitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"longitude"]] floatValue];
                    
                    //        MKCoordinateRegion region1;
                    //        region1.center=coord;
                    //        region1.span.longitudeDelta=1 ;
                    //        region1.span.latitudeDelta=1;
                    //        [mapView setRegion:region1 animated:YES];
                    
                    MKPointAnnotation *point=[[MKPointAnnotation alloc]init];
                    point.coordinate=coord;
                    
//                    point.title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"name"]]];
//                    point.subtitle=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"address"]]];
                    
                    NSString *mins  =   @"Minute wait";
                    if ([[[arrAfterSearch objectAtIndex:i] objectForKey:@"wait_time"] integerValue] > 1){
                        mins  =   @"Minutes wait";
                    }
                    
                    point.title =   [NSString stringWithFormat:@"%@ %@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"wait_time"],mins];
                    
                    [mapView addAnnotation:point];
                    
                }
            
//            MKUserLocation *userLocation = mapView.userLocation;
//           // MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
//            
//            double miles = 5.0;
//            double scalingFactor = ABS( (cos(2 * M_PI * userLocation.location.coordinate.latitude / 360.0) ));
//            
//            MKCoordinateSpan span;
//            
//            span.latitudeDelta = miles/69.0;
//            span.longitudeDelta = miles/(scalingFactor * 69.0);
//            
//            MKCoordinateRegion region;
//            region.span = span;
//            region.center = userLocation.location.coordinate;
//            
//            [mapView setRegion:region animated:YES];
            
            
            
                CLLocation *location1 = [[CLLocation alloc] initWithLatitude:minLat longitude:minLong];
                CLLocation *location2 = [[CLLocation alloc] initWithLatitude:maxLat longitude:maxLong];
                NSLog(@"Distance i meters: %f", [location1 distanceFromLocation:location2]);
                
                MKCoordinateRegion region;
                region.center.latitude = (minLat+ maxLat) / 2.0;
                region.center.longitude = (minLong + maxLong) / 2.0;
                if ( (region.center.latitude >= -90) && (region.center.latitude <= 90) && (region.center.longitude >= -180) && (region.center.longitude <= 180))
                {
                    region.span.latitudeDelta = fabs(minLat - maxLat) * 1.1;
                    region.span.longitudeDelta = fabs(minLong - maxLong) * 1.1;;

                    region = [mapView regionThatFits:region];
                    [mapView setRegion:region animated:YES];
                }
            
            
        }
        
      /*  imgViewLeftSearch.image=[UIImage imageNamed:@"downarrow.png"];
        
        ViewDropdown.hidden = YES;
        tbleLocation.hidden=YES;
        tbleCat.hidden=YES;
        tblePrice.hidden=YES;

        
        NSMutableArray *arrFilterKeys=[NSMutableArray new];
        
        
        if (btnOnLocation.enabled==YES)
        {
           [arrFilterKeys addObject:txtFLocation.text];
            
        }
        if (btnOnPrice.enabled==YES)
        {
           [arrFilterKeys addObject:txtFPrizeCasual.text];
            
        }
        if (btnOnCategory.enabled==YES)
        {
            
            [arrFilterKeys addObject:txtFCatgory.text];
            
        }
        if (btnOnType.enabled==YES)
        {
            [arrFilterKeys addObject:txtFType.text];

        }
        
        
//        NSPredicate *resultPredicate = [NSPredicate
//                                        predicateWithFormat:@"SELF contains[cd] %@",
//                                        [dicSearchId objectForKey:@"locationIdKey"]];

       
        
        
        NSArray *arrFilterId=[dicSearchId allKeys];
        
        
        NSMutableArray *arrNakul=[NSMutableArray new];
        
        
        
        for (NSString *strKey in arrFilterId)
        {
            if ([strKey isEqualToString:@"priceIdKey"])
            {
                
                NSPredicate *resultPredicate = [NSPredicate
                                                predicateWithFormat:@"SELF contains[cd] %@",[dicSearchId objectForKey:strKey]];
                
                
                 [ arrNakul addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;

                
            }
            if ([strKey isEqualToString:@"categoryIdKey"])
            {
                NSPredicate *resultPredicate = [NSPredicate
                                                predicateWithFormat:@"SELF contains[cd] %@",[dicSearchId objectForKey:strKey]];
                
                
                [ arrNakul addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
            }
            if ([strKey isEqualToString:@"locationIdKey"])
            {
                NSPredicate *resultPredicate = [NSPredicate
                                                predicateWithFormat:@"SELF contains[cd] %@",[dicSearchId objectForKey:strKey]];
                
                
                [ arrNakul addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
            }
            if ([strKey isEqualToString:@"typeIdKey"])
            {
                NSPredicate *resultPredicate = [NSPredicate
                                                predicateWithFormat:@"SELF contains[cd] %@",[dicSearchId objectForKey:strKey]];
                
                
                [ arrNakul addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]] ;
            }
        }
        
        
        [arrNakul setArray:[[NSSet setWithArray:arrNakul] allObjects]];
        
        NSLog(@"dicSearchId=%@",dicSearchId);
        NSLog(@"arrAfterSearch =%@",arrNakul);
        
        
        [arrAfterSearch removeAllObjects];
        
       // arrAfterSearch=[NSMutableArray new];
        
        for (int i=0;i<arrNakul.count; i++)
        {
            if ([[arrNakul objectAtIndex:i] count]>0)
            {
                for (NSArray *arrCat in [arrNakul objectAtIndex:i]  )
                {
                    // if()
                    for (int j=0; j< [outputAllRestaurents count]; j++)
                    {
                        if ([arrCat isEqualToArray:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"categories"]])
                        {
                            [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                        }
                    }
                    
                    
                }
            }
        }
        
        
        
       
        float minLat=0;
        float minLong=0;
        
        float maxLat=0;
        float maxLong=0;
        
        
        
        
        if (arrAfterSearch.count>0)
        {
            minLat=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"latitude"] floatValue];
            minLong=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"longitude"] floatValue];
            
            maxLat=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"latitude"] floatValue];
            maxLong=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"longitude"] floatValue];
            
            for (int i=0; i<[arrAfterSearch count]; i++)
            {
                if (minLat>[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue])
                {
                    minLat=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue];
                }
                if (minLong>[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue])
                {
                    minLong=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue];
                }
                
                if (maxLat<[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue])
                {
                    maxLat=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue];
                }
                if (maxLong<[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue])
                {
                    maxLong=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue];
                }
            }
            
        }
        
        
        NSArray *existingpoints = mapView.annotations;
        if ([existingpoints count] > 0)
            [mapView removeAnnotations:existingpoints];
        
        
        for ( int i=0; i<[arrAfterSearch count]; i++)
        {
            CLLocationCoordinate2D coord;
            
            coord.latitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"latitude"]] floatValue];
            coord.longitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"longitude"]] floatValue];
            
            //        MKCoordinateRegion region1;
            //        region1.center=coord;
            //        region1.span.longitudeDelta=1 ;
            //        region1.span.latitudeDelta=1;
            //        [mapView setRegion:region1 animated:YES];
            
            MKPointAnnotation *point=[[MKPointAnnotation alloc]init];
            point.coordinate=coord;
            
            point.title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"name"]]];
            point.subtitle=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"address"]]];
            
            [mapView addAnnotation:point];
            
        }
        
        
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:minLat longitude:minLong];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:maxLat longitude:maxLong];
        NSLog(@"Distance i meters: %f", [location1 distanceFromLocation:location2]);
        
        MKCoordinateRegion region;
        region.center.latitude = (minLat+ maxLat) / 2.0;
        region.center.longitude = (minLong + maxLong) / 2.0;
        region.span.latitudeDelta = fabs(minLat - maxLat) * 1.1;
        region.span.longitudeDelta = fabs(minLong - maxLong) * 1.1;;
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];

        */
        
        txtFLocation.text=@"Select";
        txtFPrizeCasual.text=@"Select";
        txtFCatgory.text=@"Select";
    }
    

}


-(IBAction)btnSearchViaTextField:(id)sender
{
    ViewDropdown.hidden=YES;
   // [viewRestauInfo removeFromSuperview];
    viewRestauInfo.hidden=YES;
    viewPriceCFU.hidden=NO;

    
    [txtFSearch resignFirstResponder];
    
    txtFSearch.userInteractionEnabled=YES;
    [mapView removeOverlay:polyline];
    
    
    NSString *strGetSearchText=[txtFSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if (strGetSearchText.length!=0)
    {
        
        if ([outputAllRestaurents count]==0)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"No restaurent availavle" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            
            [alert show];
            
        }
        else
        {
            
            
            
            NSLog(@"str serch string==%@",strGetSearchText);
            
            NSArray *arrSearchText=[strGetSearchText componentsSeparatedByString:@" "];
                       
            
            NSArray *arrSearchResult=[[NSArray alloc]init];
            arrSearchResult=[outputAllRestaurents  valueForKey:@"categories"];
            
            NSArray *arrSearchR=[[NSArray alloc]init];
            NSMutableDictionary *dicSearch=[[NSMutableDictionary alloc]init];
            
            NSPredicate *resultPredicate;
            
            
            NSMutableArray *arrCat=[NSMutableArray new];
            NSMutableArray *arrAdd=[NSMutableArray new];
            NSMutableArray *arrCity=[NSMutableArray new];
            NSMutableArray *arrName=[NSMutableArray new];
            NSMutableArray *arrTitle=[NSMutableArray new];
            NSMutableArray *arrDesc=[NSMutableArray new];
            
            
            if (arrSearchText.count>0)
            {
                
                for (int i=0; i<arrSearchText.count; i++)
                {
                    resultPredicate = [NSPredicate  predicateWithFormat:@"SELF contains[cd] %@",[arrSearchText objectAtIndex:i]];
                    
                    arrSearchR= [arrSearchResult filteredArrayUsingPredicate:resultPredicate];
                    
                    [arrCat addObject:[[outputAllRestaurents  valueForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate]];
                    [arrAdd addObject:[[outputAllRestaurents  valueForKey:@"address"] filteredArrayUsingPredicate:resultPredicate]];
                    [arrCity addObject:[[outputAllRestaurents  valueForKey:@"city"] filteredArrayUsingPredicate:resultPredicate]];
                    [arrName addObject:[[outputAllRestaurents  valueForKey:@"name"] filteredArrayUsingPredicate:resultPredicate]];
                    [arrTitle addObject:[[outputAllRestaurents  valueForKey:@"title"] filteredArrayUsingPredicate:resultPredicate]];
                    [arrDesc addObject:[[outputAllRestaurents  valueForKey:@"description"] filteredArrayUsingPredicate:resultPredicate]];
                    
                    
                    
                }
            }
            
            
            
            [ dicSearch setObject:arrCat forKey:@"categories"];
            
            [ dicSearch setObject:arrAdd forKey:@"address"];
            
            [ dicSearch setObject:arrCity forKey:@"city"];
            
            [ dicSearch setObject:arrName forKey:@"name"];
            
            [ dicSearch setObject:arrTitle forKey:@"title"];
            
            [ dicSearch setObject:arrDesc forKey:@"description"];
            
            
            
            if ([outputAllRestaurents count]!=0)
            {
                [arrAfterSearch removeAllObjects];
                // arrAfterSearch=[NSMutableArray new];
                
                for (int i=0;i<dicSearch.count; i++)
                {
                    
                    for (int n=0; n<[[dicSearch  objectForKey:@"categories"] count]; n++)
                    {
                        
                        if ([[[dicSearch objectForKey:@"categories"] objectAtIndex:n]count]>0)
                        {
                            for (NSString *strTitle in [[dicSearch objectForKey:@"categories"] objectAtIndex:n] )
                            {
                                // if()
                                for (int j=0; j< [outputAllRestaurents count]; j++)
                                {
                                    if ([strTitle isEqualToString:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"categories"]])
                                    {
                                        [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                    }
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    for (int n=0; n<[[dicSearch  objectForKey:@"address"] count]; n++)
                    {
                        
                        if ([[[dicSearch objectForKey:@"address"] objectAtIndex:n]count]>0)
                        {
                            for (NSString *strTitle in [[dicSearch objectForKey:@"address"] objectAtIndex:n] )
                            {
                                // if()
                                for (int j=0; j< [outputAllRestaurents count]; j++)
                                {
                                    if ([strTitle isEqualToString:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"address"]])
                                    {
                                        [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                    }
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    for (int n=0; n<[[dicSearch  objectForKey:@"city"] count]; n++)
                    {
                        
                        if ([[[dicSearch objectForKey:@"city"]  objectAtIndex:n]count]>0)
                        {
                            for (NSString *strTitle in [[dicSearch objectForKey:@"city"]  objectAtIndex:n])
                            {
                                // if()
                                for (int j=0; j< [outputAllRestaurents count]; j++)
                                {
                                    if ([strTitle isEqualToString:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"city"]])
                                    {
                                        [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                    }
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                    
                    
                    for (int n=0; n<[[dicSearch  objectForKey:@"name"] count]; n++)
                    {
                        
                        if ([[[dicSearch objectForKey:@"name"] objectAtIndex:n]count]>0)
                        {
                            for (NSString *strTitle in [[dicSearch objectForKey:@"name"] objectAtIndex:n] )
                            {
                                // if()
                                for (int j=0; j< [outputAllRestaurents count]; j++)
                                {
                                    if ([strTitle isEqualToString:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"name"]])
                                    {
                                        [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                    }
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                    
                    
                    for (int n=0; n<[[dicSearch  objectForKey:@"title"] count]; n++)
                    {
                        
                        if ([[[dicSearch objectForKey:@"title"] objectAtIndex:n]count]>0)
                        {
                            
                            
                            for (NSString *strTitle in [[dicSearch objectForKey:@"title"]objectAtIndex:n] )
                            {
                                // if()
                                for (int j=0; j< [outputAllRestaurents count]; j++)
                                {
                                    if ([strTitle isEqualToString:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"title"]])
                                    {
                                        [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                    }
                                }
                                
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    for (int n=0; n<[[dicSearch  objectForKey:@"description"] count]; n++)
                    {
                        if ([[[dicSearch objectForKey:@"description"] objectAtIndex:n] count]>0)
                        {
                            for (NSString *strTitle in [[dicSearch objectForKey:@"description"] objectAtIndex:n] )
                            {
                                // if()
                                for (int j=0; j< [outputAllRestaurents count]; j++)
                                {
                                    if ([strTitle isEqualToString:[[outputAllRestaurents objectAtIndex:j] objectForKey:@"description"]])
                                    {
                                        [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
                                    }
                                }
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                //  NSMutableArray *values=[NSMutableArray new];
                
                [arrAfterSearch setArray:[[NSSet setWithArray:arrAfterSearch] allObjects]];
                
                NSLog(@"%@",dicSearch);
                NSLog(@"arrAfterSearch %@",arrAfterSearch);
                
                
                
                float minLat=0;
                float minLong=0;
                
                float maxLat=0;
                float maxLong=0;
                
                CustomMessage *cav=[[CustomMessage alloc] init];
                [cav show:[NSString stringWithFormat:@"%lu Restaurants found",(unsigned long)arrAfterSearch.count] inView:self.view delay:2 lYAxis:viewRestauInfo.frame.origin.y-20];
                
                
                strSearchType=@"";
                isBackCicked=NO;
                
                if (arrAfterSearch.count>0)
                {
                    minLat=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"latitude"] floatValue];
                    minLong=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"longitude"] floatValue];
                    
                    maxLat=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"latitude"] floatValue];
                    maxLong=[[[arrAfterSearch objectAtIndex:0]objectForKey:@"longitude"] floatValue];
                    
                    for (int i=0; i<[arrAfterSearch count]; i++)
                    {
                        if (minLat>[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue])
                        {
                            minLat=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue];
                        }
                        if (minLong>[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue])
                        {
                            minLong=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue];
                        }
                        
                        if (maxLat<[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue])
                        {
                            maxLat=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"latitude"] floatValue];
                        }
                        if (maxLong<[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue])
                        {
                            maxLong=[[[arrAfterSearch objectAtIndex:i]objectForKey:@"longitude"] floatValue];
                        }
                    }
                    
                }
                
                
                NSArray *existingpoints = mapView.annotations;
                if ([existingpoints count] > 0)
                    [mapView removeAnnotations:existingpoints];
                
                
                for ( int i=0; i<[arrAfterSearch count]; i++)
                {
                    CLLocationCoordinate2D coord;
                    
                    coord.latitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"latitude"]] floatValue];
                    coord.longitude=[[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"longitude"]] floatValue];
                    
                    //        MKCoordinateRegion region1;
                    //        region1.center=coord;
                    //        region1.span.longitudeDelta=1 ;
                    //        region1.span.latitudeDelta=1;
                    //        [mapView setRegion:region1 animated:YES];
                    
                    MKPointAnnotation *point=[[MKPointAnnotation alloc]init];
                    point.coordinate=coord;
                    
//                    point.title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"name"]]];
//                    point.subtitle=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"address"]]];
                    
                    NSString *mins  =   @"Minute wait";
                    if ([[[arrAfterSearch objectAtIndex:i] objectForKey:@"wait_time"] integerValue] > 1){
                        mins  =   @"Minutes wait";
                    }
                    
                    point.title =   [NSString stringWithFormat:@"%@ %@",[[arrAfterSearch objectAtIndex:i] objectForKey:@"wait_time"],mins];
                    
                    [mapView addAnnotation:point];
                    
                }
                
                
                CLLocation *location1 = [[CLLocation alloc] initWithLatitude:minLat longitude:minLong];
                CLLocation *location2 = [[CLLocation alloc] initWithLatitude:maxLat longitude:maxLong];
                NSLog(@"Distance i meters: %f", [location1 distanceFromLocation:location2]);
                
                MKCoordinateRegion region;
                region.center.latitude = (minLat+ maxLat) / 2.0;
                region.center.longitude = (minLong + maxLong) / 2.0;
                region.span.latitudeDelta = fabs(minLat - maxLat) * 1.1;
                region.span.longitudeDelta = fabs(minLong - maxLong) * 1.1;;
                
                region = [mapView regionThatFits:region];
                [mapView setRegion:region animated:YES];
                
                
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Payble" message:@"No restaurent availavle" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                
                [alert show];
            }
            
            

            
        }
        
      
        
    }
    
    else{
//        outputAllRestaurents    =   listAllRestaurents;
//        NSLog(@"listAllRestaurents %@",listAllRestaurents);
        [self getAllRestaurants];
        
    }
    
    
    
    
    
//    MKCoordinateRegion region;
//    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
//    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
//    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
//    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
//    
//    region = [mapView regionThatFits:region];
//    [mapView setRegion:region animated:YES];

    
}






-(void)setPointOnMap
{
 
    //The latitude must be a number between -90 and 90 and the longitude between -180 and 180.
    
    
    if ([outputAllRestaurents count]==0)
    {
        
    }
    else
    {
        
        for ( int i=0; i<[outputAllRestaurents count]; i++)
        {
            
            float lati=[[NSString stringWithFormat:@"%@",[[outputAllRestaurents objectAtIndex:i] objectForKey:@"latitude"]] floatValue];
            float longi=[[NSString stringWithFormat:@"%@",[[outputAllRestaurents objectAtIndex:i] objectForKey:@"latitude"]] floatValue];
            
            if ( lati<90 && lati >-90)
            {
                if (longi<180 && longi>-180)
                {
                    CLLocationCoordinate2D coord;
                    
                    coord.latitude=[[NSString stringWithFormat:@"%@",[[outputAllRestaurents objectAtIndex:i] objectForKey:@"latitude"]] floatValue];
                    coord.longitude=[[NSString stringWithFormat:@"%@",[[outputAllRestaurents objectAtIndex:i] objectForKey:@"longitude"]] floatValue];
                    MKCoordinateRegion region1;
                    region1.center=coord;
                    region1.span.longitudeDelta=20 ;
                    region1.span.latitudeDelta=20;
                    [mapView setRegion:region1 animated:YES];
                    
                    MKPointAnnotation *point=[[MKPointAnnotation alloc]init];
                    point.coordinate=coord;
//                    point.title=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[outputAllRestaurents objectAtIndex:i] objectForKey:@"name"]]];
//                    point.subtitle=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[outputAllRestaurents objectAtIndex:i] objectForKey:@"address"]]];
                    NSString *mins  =   @"Minute wait";
                    if ([[[outputAllRestaurents objectAtIndex:i] objectForKey:@"wait_time"] integerValue] > 1){
                        mins  =   @"Minutes wait";
                    }
                    
                    point.title =   [NSString stringWithFormat:@"%@ %@",[[outputAllRestaurents objectAtIndex:i] objectForKey:@"wait_time"],mins];
                    [mapView addAnnotation:point];

                }
                
            }
           
            
            
            
        }

    }
   
    
    
  
    
    mapView.showsUserLocation=TRUE;
    
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:NO];

    
}


//============Restaurant info view


-(IBAction)btnReviewDidClicked:(id)sender
{
    imgViewWIfi.hidden=YES;
    [btnONWifi setTitle:@"BACK" forState:UIControlStateNormal];
    
    viewRestauInfo.hidden=YES;
    viewPriceCFU.hidden=YES;
    isDirectReservation = YES;
    
    lblRestauName1.text=[[arrAfterSearch objectAtIndex:index] objectForKey:@"name"];
    lblReviews1.text=[NSString stringWithFormat:@"%@ review",[[arrAfterSearch objectAtIndex:index] objectForKey:@"review_count"]];
    lblPhoneNo1.text=[[arrAfterSearch objectAtIndex:index] objectForKey:@"phone_number"];
    reviewCallNoLbl.text    =   [NSString stringWithFormat:@"(%@)",[[arrAfterSearch objectAtIndex:index] objectForKey:@"phone_number"]];
    lblTime1.text=[[arrAfterSearch objectAtIndex:index] objectForKey:@"wait_time"];
    reviewDistanceLbl.text=[NSString stringWithFormat:@"%@ minutes walk",[[arrAfterSearch objectAtIndex:index] objectForKey:@"wait_time"]];
    
    float upShiftFactor =   0;
//    float cellHeight    =   
//    if (IDIOM == IPAD) {
//        
//    }
    
    [self setWalkingDistance];
    
    [self setMenuOptionFrame];
    
    UIView *tempView    =   [restroMenuOptionsViewArr objectAtIndex:4];
    
    
    tlbV.frame  =   CGRectMake(tlbV.frame.origin.x, tempView.frame.origin.y+tempView.frame.size.height, tlbV.frame.size.width, tlbV.frame.size.height+upShiftFactor);
    
    if ([[[arrAfterSearch objectAtIndex:index] objectForKey:@"browse_the_menu"] isEqualToString:@""]){
        UIView *menuView    =   [restroMenuOptionsViewArr objectAtIndex:2];
        menuView.hidden     =   true;
        UIView *msgView     =   [restroMenuOptionsViewArr objectAtIndex:3];
        msgView.frame       =   CGRectMake(msgView.frame.origin.x, msgView.frame.origin.y-screenHeight*0.08, msgView.frame.size.width, msgView.frame.size.height);
        UIView *infoView     =   [restroMenuOptionsViewArr objectAtIndex:4];
        infoView.frame       =   CGRectMake(infoView.frame.origin.x, infoView.frame.origin.y-screenHeight*0.08, infoView.frame.size.width, infoView.frame.size.height);
        upShiftFactor   +=  screenHeight*0.08;
    }
    
    if ([[[arrAfterSearch objectAtIndex:index] objectForKey:@"message_the_business"] isEqualToString:@""]) {
        UIView *menuView    =   [restroMenuOptionsViewArr objectAtIndex:3];
        menuView.hidden =   true;
        UIView *infoView     =   [restroMenuOptionsViewArr objectAtIndex:4];
        infoView.frame       =   CGRectMake(infoView.frame.origin.x, infoView.frame.origin.y-screenHeight*0.08, infoView.frame.size.width, infoView.frame.size.height);
        upShiftFactor   +=  screenHeight*0.08;
    }
    
    if ([[[arrAfterSearch objectAtIndex:index] objectForKey:@"more_info"] isEqualToString:@""]) {
        UIView *menuView    =   [restroMenuOptionsViewArr objectAtIndex:4];
        menuView.hidden =   true;
        upShiftFactor   +=  screenHeight*0.08;
    }
    
    tlbV.frame  =   CGRectMake(tlbV.frame.origin.x, tlbV.frame.origin.y-upShiftFactor, tlbV.frame.size.width, tlbV.frame.size.height+upShiftFactor);
    
    int rating=[[[arrAfterSearch objectAtIndex:index] objectForKey:@"rating"] intValue]/20;
    
    NSLog(@"rating=%d",rating);
    
    if(rating==0)
    {
        
        
        imgStar11.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar22.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar33.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar44.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar55.image=[UIImage imageNamed:@"gray-star.png"];

        
//        [btnStar11 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar22 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar33 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar44 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar55 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    
    if(rating==1)
    {
        
        imgStar11.image=[UIImage imageNamed:@"start.png"];
        imgStar22.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar33.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar44.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar55.image=[UIImage imageNamed:@"gray-star.png"];
        
//        [btnStar11 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar22 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar33 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar44 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar55 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==2)
    {
        imgStar11.image=[UIImage imageNamed:@"start.png"];
        imgStar22.image=[UIImage imageNamed:@"start.png"];
        imgStar33.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar44.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar55.image=[UIImage imageNamed:@"gray-star.png"];
        
//        [btnStar11 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar22 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar33 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar44 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar55 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==3)
    {
        imgStar11.image=[UIImage imageNamed:@"start.png"];
        imgStar22.image=[UIImage imageNamed:@"start.png"];
        imgStar33.image=[UIImage imageNamed:@"start.png"];
        imgStar44.image=[UIImage imageNamed:@"gray-star.png"];
        imgStar55.image=[UIImage imageNamed:@"gray-star.png"];
        
//        [btnStar11 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar22 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar33 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar44 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
//        [btnStar55 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==4)
    {
        imgStar11.image=[UIImage imageNamed:@"start.png"];
        imgStar22.image=[UIImage imageNamed:@"start.png"];
        imgStar33.image=[UIImage imageNamed:@"start.png"];
        imgStar44.image=[UIImage imageNamed:@"start.png"];
        imgStar55.image=[UIImage imageNamed:@"gray-star.png"];
        
//        [btnStar11 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar22 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar33 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar44 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar55 setImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
    }
    if(rating==5)
    {
        
        imgStar11.image=[UIImage imageNamed:@"start.png"];
        imgStar22.image=[UIImage imageNamed:@"start.png"];
        imgStar33.image=[UIImage imageNamed:@"start.png"];
        imgStar44.image=[UIImage imageNamed:@"start.png"];
        imgStar55.image=[UIImage imageNamed:@"start.png"];
        
//        [btnStar11 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar22 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar33 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar44 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//        [btnStar55 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    }
    

    
    
    //[viewRestaurentListAfterSearch setFrame:CGRectMake(0, viewInHeader.frame.size.height+20, self.view.frame.size.width, viewRestaurentListAfterSearch.frame.size.height)];
    
    
    
    
//    outputReviewsList=nil;
    viewRestaurentReview.hidden =   NO;
   // [viewRestaurentReview setFrame:CGRectMake(0, viewInHeader.frame.size.height+20, self.view.frame.size.width, viewRestaurentReview.frame.size.height)];
    
    
//    [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:viewInHeader.frame.size.height];

    
    //[self.view addSubview:viewRestaurentReview];
    
    
    if([QAUtils IsNetConnected])
    {
        
        strType=@"restaurentReviews";
        [DSBezelActivityView  newActivityViewForView:self.view];
        
        
        //  NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://netleondev.com/kentapi/restaurant/reviews/restaurant_id/%@",[dicRestaurentDetail objectForKey:@"id"]]];
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://netleondev.com/kentapi/restaurant/reviews/restaurant_id/%@",[[arrAfterSearch objectAtIndex:index] objectForKey:@"id"]]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request addRequestHeader:@"Content-type" value:@"application/json"];
        [request addRequestHeader:@"Authorization" value:@"aDRF@F#JG_a34-n3d"];
        
        [request setRequestMethod:@"GET"];
        request.delegate=self;
        request.allowCompressedResponse = NO;
        request.useCookiePersistence = NO;
        request.shouldCompressRequestBody = NO;
        
        request.timeOutSeconds =60;
        
        // NSString *jsonRequest = [dicInfo JSONRepresentation];
        
        //  NSLog(@"jsonRequest is %@", jsonRequest);
        
        
        //   NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
        
        //[request setPostBody:[requestData mutableCopy]];
        
        [request startAsynchronous];
        
        
    }
    else
    {
        [DSBezelActivityView removeViewAnimated:YES];
        return;
    }
    
    
    /*
    ReviewVC *reviewOb=[[ReviewVC alloc]initWithNibName:@"ReviewVC" bundle:nil];
    reviewOb.dicRestaurentDetail=[arrAfterSearch objectAtIndex:index];
    [self.navigationController pushViewController:reviewOb animated:YES];
     
     */
}

-(IBAction)btnPhoneNumberDidClicked:(id)sender
{
   
    NSLog(@"%@",[NSString stringWithFormat:@"tel:%@",[[arrAfterSearch objectAtIndex:index] objectForKey:@"phone_number"]]);
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[arrAfterSearch objectAtIndex:index] objectForKey:@"phone_number"]]]];
    
    
    NSString *phoneNumberString=[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:index] objectForKey:@"phone_number"]];
    
    if ([phoneNumberString length]>0)
    {
        phoneNumberString = [[phoneNumberString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString: @""];
        NSString *phoneDecender = @"tel:";
        NSString *totalPhoneNumberString = [phoneDecender stringByAppendingString:phoneNumberString];
        NSURL *aPhoneNumberURL = [NSURL URLWithString:totalPhoneNumberString];
        
        if ([[UIApplication sharedApplication] canOpenURL:aPhoneNumberURL])
        {
            [[UIApplication sharedApplication] openURL:aPhoneNumberURL];
        }
        
    }
    

    
}

-(IBAction)btnReservTableDidClicked:(id)sender
{
    
    if (arrAfterSearch.count == 0) {
        
    }else{
        CreateReservationVC *createTbl=[[CreateReservationVC alloc]initWithNibName:@"CreateReservationVC" bundle:nil];
        createTbl.dicRest5=[arrAfterSearch objectAtIndex:index];
        [self.navigationController pushViewController:createTbl animated:YES];
    }
   
    
    
}

-(void)btnGetDirectionDidClicked:(id)sender
{
//    [btnONWifi setTitle:nil forState:UIControlStateNormal];
//    imgViewWIfi.hidden=NO;
   //[viewRestaurentReview removeFromSuperview];
    [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:1500];
    
    [self getDirections];
    [btnONWifi setTitle:@"BACK" forState:UIControlStateNormal];
    imgViewWIfi.hidden=YES;
    viewRestauInfo.hidden=NO;
    
}



#pragma mark- map annotation

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
            //pinView.calloutOffset=CGPointMake(0,32);
            
        }
        else
        {
            pinView.annotation=annotation;
        }
        return pinView;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
  //  [viewRestauInfo removeFromSuperview];
    
    

    
//    if ([view isKindOfClass:[MKUserLocation class]])
//    {
//        NSLog(@"user loaction");
//    }
    
//    if([[view.annotation title] isEqualToString:@"Current Location"])
//    {
//         NSLog(@"user loaction");
//    }
//    else
//    {
    
            strMapDidClicked=@"Reset";
            imgViewWIfi.hidden=YES;
            [btnONWifi setTitle:@"BACK" forState:UIControlStateNormal];
            
            imgStar1.image=[UIImage imageNamed:@"gray-star.png"];
            imgStar2.image=[UIImage imageNamed:@"gray-star.png"];
            imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
            imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
            imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
            

            
            viewRestauInfo.hidden=NO;
            viewPriceCFU.hidden=YES;
            
            // Annotation is your custom class that holds information about the annotation
            CLLocationCoordinate2D loccord= [[view annotation] coordinate];
            NSString *strTitle=[[view annotation] title];
            NSString *strSubTitle =[[view annotation] subtitle];
            
            
            // MKMapPoint annotationPoint = MKMapPointForCoordinate(loccord);
            // MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (loccord, 50, 50);
            
            [mapView setRegion:region animated:YES];
            
            
            int flag=0;
            
            for (int j=0; j< [arrAfterSearch count]; j++)
            {
                
                float lati=[[[arrAfterSearch objectAtIndex:j]objectForKey:@"latitude"]floatValue];
                float longitude=[[[arrAfterSearch objectAtIndex:j]objectForKey:@"longitude"]floatValue];
                
                CLLocation *keyPlace = [[CLLocation alloc] initWithLatitude:lati longitude:longitude];
                MKPointAnnotation *endannotation = [[MKPointAnnotation alloc] init];
                
                if (keyPlace.coordinate.latitude == loccord.latitude && keyPlace.coordinate.longitude == loccord.longitude){
                    NSLog(@"here %@",[[arrAfterSearch objectAtIndex:j] objectForKey:@"name"]);
                    flag=j;
                    break;
                }
                
//                if ([strTitle isEqualToString:[[arrAfterSearch objectAtIndex:j] objectForKey:@"name"]])
//                {
//                    // [arrAfterSearch addObject:[outputAllRestaurents objectAtIndex:j]];
//                    flag=j;
//                    break;
//                }
            }
            
            index=flag;
            
            
            if (arrAfterSearch.count!=0)
            {
                if ([[[arrAfterSearch objectAtIndex:flag] objectForKey:@"review_count"] intValue]==0)
                {
//                    btnReviews.enabled=NO;
                    btnReviews.enabled=YES;
                    tlbV.hidden =   YES;
                }
                else
                {
                    btnReviews.enabled=YES;
                    tlbV.hidden =   NO;
                }
                
                
                
                lblRestauName.text=[[arrAfterSearch objectAtIndex:flag] objectForKey:@"name"];
                lblReviews.text=[NSString stringWithFormat:@"%@ review",[[arrAfterSearch objectAtIndex:flag] objectForKey:@"review_count"]];
                lblPhoneNo.text=[[arrAfterSearch objectAtIndex:flag] objectForKey:@"phone_number"];
                lblTime.text=[[arrAfterSearch objectAtIndex:flag] objectForKey:@"wait_time"];
                
                
                float rat1=[[[arrAfterSearch objectAtIndex:flag] objectForKey:@"rating"] floatValue];
                float result=rat1/20.0;
                
                int rating=ceilf(result);
                
                
                // int rating=[[[arrAfterSearch objectAtIndex:flag] objectForKey:@"rating"] intValue]/20;
                
                NSLog(@"rating=%d",rating);
                
                if(rating==0)
                {
                    
                    
                    imgStar1.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar2.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                    
         
                }
                
                if(rating==1)
                {
                    
                    
                    imgStar1.image=[UIImage imageNamed:@"start.png"];
                    imgStar2.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                    
                    
             
                }
                if(rating==2)
                {
                    
                    
                    imgStar1.image=[UIImage imageNamed:@"start.png"];
                    imgStar2.image=[UIImage imageNamed:@"start.png"];
                    imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                    
            
                }
                if(rating==3)
                {
                    
                    imgStar1.image=[UIImage imageNamed:@"start.png"];
                    imgStar2.image=[UIImage imageNamed:@"start.png"];
                    imgStar3.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar4.image=[UIImage imageNamed:@"gray-star.png"];
                    imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                    
                    
                 
                }
                if(rating==4)
                {
                    
                    imgStar1.image=[UIImage imageNamed:@"start.png"];
                    imgStar2.image=[UIImage imageNamed:@"start.png"];
                    imgStar3.image=[UIImage imageNamed:@"start.png"];
                    imgStar4.image=[UIImage imageNamed:@"start.png"];
                    imgStar5.image=[UIImage imageNamed:@"gray-star.png"];
                    
                
                }
                if(rating==5)
                {
                    
                    imgStar1.image=[UIImage imageNamed:@"start.png"];
                    imgStar2.image=[UIImage imageNamed:@"start.png"];
                    imgStar3.image=[UIImage imageNamed:@"start.png"];
                    imgStar4.image=[UIImage imageNamed:@"start.png"];
                    imgStar5.image=[UIImage imageNamed:@"start.png"];
                    
         
                }
//            }
                
    }
    
    
    
    
    /*
    
    MapPointDetailVC *mapdetail=[[MapPointDetailVC alloc]initWithNibName:@"MapPointDetailVC" bundle:nil];
   // mapdetail.dicRstauDetail=[NSDictionary dictionaryWithObjectsAndKeys:strTitle,@"title",strSubTitle,@"subtitle",nil];
    mapdetail.dicRstauDetail=[arrAfterSearch objectAtIndex:flag];
    mapdetail.loccordRestau=loccord;
    [self.navigationController pushViewController:mapdetail animated:YES];
     
     */
}

-(void)setWalkingDistance{
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    
    float lati=[[[arrAfterSearch objectAtIndex:index]objectForKey:@"latitude"]floatValue];
    float longitude=[[[arrAfterSearch objectAtIndex:index]objectForKey:@"longitude"]floatValue];
    
    CLLocation *keyPlace = [[CLLocation alloc] initWithLatitude:lati longitude:longitude];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=walking", newLocation.coordinate.latitude, newLocation.coordinate.longitude, keyPlace.coordinate.latitude, keyPlace.coordinate.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!error)
    {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        if ([[responseDict valueForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
        {
//            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not route path from your current location" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            return;
        }
        
        int points_count = 0;
        NSString *walkTime = @"";
        if ([[responseDict objectForKey:@"routes"] count]){
            points_count = [[[[[[responseDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"] count];
            walkTime    = [[[[[[responseDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"duration"] valueForKey:@"text"];
        }
        reviewDistanceLbl.text  =   [NSString stringWithFormat:@"%@ walk",walkTime];;
        
        if (!points_count)
        {
//            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not route path from your current location" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            return;
        }
    }
}


#pragma mark-getDirection via Polyline

- (void)getDirections
{
    
    NSArray *existingpoints = mapView.annotations;
    if ([existingpoints count] > 0)
    {
        [mapView removeAnnotations:existingpoints];
    }
    
   // mapView.userLocation.location.coordinate.latitude
    
    NSLog(@"%@", [NSString stringWithFormat:@"latitude: %f longitude: %f", mapView.userLocation.location.coordinate.latitude, mapView.userLocation.location.coordinate.longitude]);

    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    annotation.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//    annotation.title = @"current locaton";
  //  annotation.subtitle=dataHolder.strPickUpAddressLater;
    
   // [mapView addAnnotation:annotation];
    
    float lati=[[[arrAfterSearch objectAtIndex:index]objectForKey:@"latitude"]floatValue];
    float longitude=[[[arrAfterSearch objectAtIndex:index]objectForKey:@"longitude"]floatValue];
    
    CLLocation *keyPlace = [[CLLocation alloc] initWithLatitude:lati longitude:longitude];
    MKPointAnnotation *endannotation = [[MKPointAnnotation alloc] init];
    endannotation.coordinate = CLLocationCoordinate2DMake(keyPlace.coordinate.latitude, keyPlace.coordinate.longitude);
    endannotation.title = [NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:index]objectForKey:@"name"]];
    endannotation.subtitle=[NSString stringWithFormat:@"%@",[[arrAfterSearch objectAtIndex:index]objectForKey:@"address"]];
    [mapView addAnnotation:endannotation];
    // NSArray *a=[[NSArray alloc]initWithObjects:annotation,endannotation, nil];
    // [routeMapView showAnnotations:a animated:YES];
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [mapView setVisibleMapRect:zoomRect animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=driving", newLocation.coordinate.latitude, newLocation.coordinate.longitude, keyPlace.coordinate.latitude, keyPlace.coordinate.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!error)
    {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        if ([[responseDict valueForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
        {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Could not route path from your current location"
                                       delegate:nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil, nil] show];
            return;
        }
        
        int points_count = 0;
        if ([[responseDict objectForKey:@"routes"] count])
            points_count = [[[[[[responseDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"] count];
        
        
        if (!points_count)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Could not route path from your current location"
                                       delegate:nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil, nil] show];
            return;
        }
        //   CLLocationCoordinate2D points[points_count];
        
        //   NSLog(@"routes %@", [[[[responseDict objectForKey:@"routes"] objectAtIndex:0]objectForKey:@"overview_polyline"] objectForKey:@"points"]);
        
        [mapView removeOverlay:polyline]; // removing polyine
        
        polyline = [self polylineWithEncodedString:[[[[responseDict objectForKey:@"routes"] objectAtIndex:0]objectForKey:@"overview_polyline"] objectForKey:@"points"]];
        
        [mapView addOverlay:polyline];  //adding polyline
        // int j = 0;
        //NSArray *steps = nil;
        //        if (points_count && [[[[responseDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] count])
        //            steps = [[[[[responseDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
        //        for (int i = 0; i < points_count; i++) {
        //
        //            double st_lat = [[[[steps objectAtIndex:i] objectForKey:@"start_location"] valueForKey:@"lat"] doubleValue];
        //            double st_lon = [[[[steps objectAtIndex:i] objectForKey:@"start_location"] valueForKey:@"lng"] doubleValue];
        //            //NSLog(@"lat lon: %f %f", st_lat, st_lon);
        //            if (st_lat > 0.0f && st_lon > 0.0f) {
        //                points[j] = CLLocationCoordinate2DMake(st_lat, st_lon);
        //                j++;
        //            }
        //
        //            double end_lat = [[[[steps objectAtIndex:i] objectForKey:@"end_location"] valueForKey:@"lat"] doubleValue];
        //            double end_lon = [[[[steps objectAtIndex:i] objectForKey:@"end_location"] valueForKey:@"lng"] doubleValue];
        //
        //            //NSLog(@"lat %f lng %f",end_lat,end_lon);
        //          if (end_lat > 0.0f && end_lon > 0.0f)
        //            {
        //
        //                points[j] = CLLocationCoordinate2DMake(end_lat, end_lon);
        //                endCoordinate = CLLocationCoordinate2DMake(end_lat, end_lon);
        //                j++;
        //
        //
        //
        //           }
        //        }
        //  NSLog(@"points Count %d",points_count);
        //        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:points count:points_count];
        //        [self.mapView addOverlay:polyline];
        // [self centerMapForCoordinateArray:points andCount:points_count];
    }
}

#pragma mark - MapKit
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
//    MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
//    annView.canShowCallout = YES;
//    annView.animatesDrop = YES;
//    return annView;
//}

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay {
    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];
    
    overlayView.lineWidth = 5;
    overlayView.strokeColor = [UIColor purpleColor];
    overlayView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5f];
    return overlayView;
}

-(void) centerMapForCoordinateArray:(CLLocationCoordinate2D *)routes andCount:(int)count{
    MKCoordinateRegion region;
    
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    for(int idx = 0; idx <count; idx++)
    {
        CLLocationCoordinate2D currentLocation = routes[idx];
        if(currentLocation.latitude > maxLat)
            maxLat = currentLocation.latitude;
        if(currentLocation.latitude < minLat)
            minLat = currentLocation.latitude;
        if(currentLocation.longitude > maxLon)
            maxLon = currentLocation.longitude;
        if(currentLocation.longitude < minLon)
            minLon = currentLocation.longitude;
    }
    
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  = maxLat - minLat;
    region.span.longitudeDelta = maxLon - minLon;
    
    [mapView setRegion:region animated:YES];
}


- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString
{
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length)
    {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do
        {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline1 = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline1;
}

#pragma mark - Touch delegate methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtFSearch resignFirstResponder];
    [txtFFirstname resignFirstResponder];
    [txtFEmail resignFirstResponder];
    [txtFMobile resignFirstResponder];
    [txtFPassword resignFirstResponder];
    // [txtFFirstname resignFirstResponder];
    
    
    [self keyboardHide];
    
    UITouch *touch              =   [[event allTouches] anyObject];
    CGPoint location            =   [touch locationInView:viewInHeader];
    CGPoint location2           =   [touch locationInView:profileView];
    CGPoint locationCFU         =   [touch locationInView:viewPriceCFU];
    CGPoint locationCFUDown     =   [touch locationInView:viewRestaurentListAfterSearch];
    CGPoint locationRestro      =   [touch locationInView:viewRestroInfoGesture];
    CGPoint locationRestro2     =   [touch locationInView:viewRestroInfoWithReview];
    
    if(CGRectContainsPoint(viewInHeader.frame, location) && isProfileOpening == 0)
    {
        NSLog(@"IF##");
        isProfileOpening    =   1;
        [self btnUserDidClicked:nil];
    }else if(CGRectContainsPoint(viewProfileBtmView.frame, location2) ){

        isProfileClosing    =   1;
    }else if(CGRectContainsPoint(btnSwipeOnCasual.frame, locationCFU) && viewPriceCFU.hidden == NO){
        isCasualOpening    =   1;
        UIView *view=viewRestaurentListAfterSearch;
        
        CGRect frame = view.frame;
        frame.origin.y = viewPriceCFU.frame.origin.y;
        view.frame = frame;
        [self handleSwipeCasual:nil];
    }else if(CGRectContainsPoint(btnSwipeOnFine.frame, locationCFU) && viewPriceCFU.hidden == NO){
        isFineOpening    =   1;
        
        UIView *view=viewRestaurentListAfterSearch;
        
        CGRect frame = view.frame;
        frame.origin.y = viewPriceCFU.frame.origin.y;
        view.frame = frame;
        
        [self handleSwipeFine:nil];
    }else if(CGRectContainsPoint(btnSwipeOnRecommended.frame, locationCFU) && viewPriceCFU.hidden == NO){
        isRecommendedOpening    =   1;
        
        UIView *view=viewRestaurentListAfterSearch;
        
        CGRect frame = view.frame;
        frame.origin.y = viewPriceCFU.frame.origin.y;
        view.frame = frame;
        
        [self handleSwipeRecomended:nil];
    }else if(CGRectContainsPoint(btnCasual2.frame, locationCFUDown) || CGRectContainsPoint(btnFine2.frame, locationCFUDown) || CGRectContainsPoint(btnRecomended.frame, locationCFUDown)){
        isCasualClosing    =   1;
    }else if(CGRectContainsPoint(viewRestroInfoGesture.frame, locationRestro) ){
        
        isRestroOpening    =   1;
        [self btnReviewDidClicked:nil];
    }else if(CGRectContainsPoint(viewRestroInfoWithReview.frame, locationRestro2) ){
        
        isRestroClosing    =   1;
//        [self handleSwipeRecomended:nil];
    }else{
//        [self btnReviewDidClicked:nil];
        NSLog(@"ELSE##");
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if (isProfileOpening == 1) {

        UIView *view=profileView;
        
        CGRect frame = view.frame;
        frame.origin.y = location.y-view.frame.size.height;
        view.frame = frame;
    }else if(isProfileClosing == 1){
        UIView *view=profileView;
        
        CGRect frame = view.frame;
        frame.origin.y = location.y-view.frame.size.height;
        view.frame = frame;
    }else if (isCasualOpening == 1){
        UIView *view=viewRestaurentListAfterSearch;
        
        CGRect frame = view.frame;
        frame.origin.y = location.y-35;
        view.frame = frame;
    }else if (isFineOpening == 1){
        UIView *view=viewRestaurentListAfterSearch;
        
        CGRect frame = view.frame;
        frame.origin.y = location.y-35;
        view.frame = frame;
    }else if (isRecommendedOpening == 1){
        UIView *view=viewRestaurentListAfterSearch;
        
        CGRect frame = view.frame;
        frame.origin.y = location.y-35;
        view.frame = frame;
    }else if (isCasualClosing == 1){
        UIView *view=viewRestaurentListAfterSearch;
        
        CGRect frame = view.frame;
        frame.origin.y = location.y;
        view.frame = frame;
    }else if (isRestroOpening == 1){
        UIView *view=viewRestaurentReview;
        
        CGRect frame = view.frame;
        frame.origin.y = location.y;
        view.frame = frame;
    }else if (isRestroClosing == 1){
        UIView *view=viewRestaurentReview;
        
        CGRect frame = view.frame;
        frame.origin.y = location.y;
        view.frame = frame;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if (isProfileOpening == 1) {
        if (location.y < screenHeight*0.30) {
            [self btnCancelDidClicked:nil];
        }else{
            UIView *view=profileView;
            
            [UIView animateWithDuration:.5
                                  delay:.1
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 CGRect frame = view.frame;
                                 frame.origin.y = 0;
                                 frame.origin.x = (0);
                                 view.frame = frame;
                             }
                             completion:^(BOOL finished)
             {
                 NSLog(@"Completed");
                 [self btnWifiDidClicked:nil];
             }];
        }
        isProfileOpening    =   0;
        [DSBezelActivityView removeViewAnimated:YES];
        
        
    }else if(isProfileClosing == 1){
        isProfileClosing    =   0;
        if (location.y < screenHeight*0.70) {
            [self btnCancelDidClicked:nil];
        }else{
            UIView *view=profileView;
            
            [UIView animateWithDuration:.5
                                  delay:.1
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 CGRect frame = view.frame;
                                 frame.origin.y = 0;
                                 frame.origin.x = (0);
                                 view.frame = frame;
                             }
                             completion:^(BOOL finished)
             {
                 NSLog(@"Completed");
                 
             }];
        }
        [DSBezelActivityView removeViewAnimated:YES];
        
    }else if (isCasualOpening == 1){
        
        if (location.y < screenHeight*0.60) {
        
            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:viewInHeader.frame.size.height];
        }else{
            isBackCicked=YES;
            viewRestauInfo.hidden=YES;
            viewPriceCFU.hidden=NO;
            
            imgViewWIfi.hidden=NO;
            [btnONWifi setTitle:nil forState:UIControlStateNormal];
            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
        }
        isCasualOpening =   0;
    }else if (isFineOpening == 1){
        isFineOpening   =   0;
        if (location.y < screenHeight*0.60) {
            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:viewInHeader.frame.size.height];
        }else{
            isBackCicked=YES;
            viewRestauInfo.hidden=YES;
            viewPriceCFU.hidden=NO;
            
            imgViewWIfi.hidden=NO;
            [btnONWifi setTitle:nil forState:UIControlStateNormal];
            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
        }
    }else if (isRecommendedOpening == 1){
        if (location.y < screenHeight*0.60) {
            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:viewInHeader.frame.size.height];
        }else{
            isBackCicked=YES;
            viewRestauInfo.hidden=YES;
            viewPriceCFU.hidden=NO;
            
            imgViewWIfi.hidden=NO;
            [btnONWifi setTitle:nil forState:UIControlStateNormal];
            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
        }
        
        isRecommendedOpening   =   0;
    }else if (isCasualClosing == 1){
        if (location.y > screenHeight*0.35) {
            isBackCicked=YES;
            viewRestauInfo.hidden=YES;
            viewPriceCFU.hidden=NO;
            
            imgViewWIfi.hidden=NO;
            [btnONWifi setTitle:nil forState:UIControlStateNormal];
            [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:1500];
        }else{
             [self showHideviewWithAnimation:viewRestaurentListAfterSearch withXAxis:0 withYAxis:viewInHeader.frame.size.height];
        }
        isCasualClosing =   0;
    }else if (isRestroOpening == 1){
//        if (location.y < screenHeight*0.65) {
            strMapDidClicked    =   @"Restro";
            [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:viewInHeader.frame.size.height];
//        }else{
//            viewRestauInfo.hidden=NO;
//            [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:1500];
//        }
        isRestroOpening = 0;
    }else if (isRestroClosing == 1){
//        [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:viewInHeader.frame.size.height];
        if (location.y > screenHeight*0.30) {
            [self btnWifiDidClicked:nil];
        }else{
            strMapDidClicked    =   @"Restro";
            [self showHideviewWithAnimation:viewRestaurentReview withXAxis:0 withYAxis:viewInHeader.frame.size.height];
        }
        isRestroClosing = 0;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
