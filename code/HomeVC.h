//
//  HomeVC.h
//  kentApp
//
//  Created by N@kuL on 22/12/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "reviewCell.h"
#import "UpSacleCell.h"

#import "PaymentVC.h"
#import "ReceiptVC.h"
#import "ReservationVC.h"

#import "Api_connect.h"

#import "WebServiceConnection.h"
#import "URL.h"


#import "CustomMessage.h"

#import "RNBlurModalView.h"

#import "NSDate+NVTimeAgo.h"
#import "UploadImage.h"
#import "UploadClass.h"

@interface HomeVC : UIViewController<MKMapViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    
    
    IBOutlet UITextField *txtFFirstname;
    IBOutlet UITextField *txtFEmail;
    IBOutlet UITextField *txtFMobile;
    IBOutlet UITextField *txtFPassword;
    
    IBOutlet UITextField *txtFFirstnameH1;
    IBOutlet UITextField *txtFEmailH1;
    IBOutlet UITextField *txtFMobileH1;
    
    IBOutlet UITextField *txtFSearch;
    IBOutlet UITextField *txtFSortBy;
    IBOutlet UITextField *txtFLocation;
    IBOutlet UITextField *txtFType;
    IBOutlet UITextField *txtFPrizeCasual;
    IBOutlet UITextField *txtFCatgory;
    IBOutlet UITextField *txtFWaitTime10Min;
    
    //============

    IBOutlet UIImageView *imgStar1;
    IBOutlet UIImageView *imgStar2;
    IBOutlet UIImageView *imgStar3;
    IBOutlet UIImageView *imgStar4;
    IBOutlet UIImageView *imgStar5;
    
    IBOutlet UIImageView *imgStar11;
    IBOutlet UIImageView *imgStar22;
    IBOutlet UIImageView *imgStar33;
    IBOutlet UIImageView *imgStar44;
    IBOutlet UIImageView *imgStar55;
    
    IBOutlet UIImageView *imgViewUserProfile;
    IBOutlet UIImageView *imgViewLeftSearch;
    
    IBOutlet UIImageView *imgViewUserOnEDitProfile;
    IBOutlet UIImageView *imgViewWIfi;
    
    IBOutlet UIImageView *imgVAnimate;

    //============
    
    IBOutlet UIButton *btnReviews;
    IBOutlet UIButton *btnCurrentLoc;
    
    IBOutlet UIButton *btnCasual2;
    IBOutlet UIButton *btnRecomended;
    IBOutlet UIButton *btnFine2;
    IBOutlet UIButton *btnProfileCncl;
    IBOutlet UIButton *btnProfileViewAccount;
    //============
    
    
    IBOutlet reviewCell *cell;
   
    IBOutlet UpSacleCell *cellRestListAftrSrch;

    IBOutlet MKMapView *mapView;
    
    //============
    
    IBOutlet UIButton *btnOnLocation;
    IBOutlet UIButton *btnOnPrice;
    IBOutlet UIButton *btnOnCategory;
    IBOutlet UIButton *btnOnType;
    
    
    IBOutlet UIButton *btnSwipeOnCasual;
    IBOutlet UIButton *btnSwipeOnFine;
    IBOutlet UIButton *btnSwipeOnRecommended;

    
    IBOutlet UIButton *btnUser;
    IBOutlet UIButton *btnBackOnEditProfile;
    IBOutlet UIButton *btnEditOnEditProfile;
    IBOutlet UIButton *btnONWifi;
    
    IBOutlet UIButton *btnReserveTable;
    IBOutlet UIButton *btnReserve2Table2;
    
    IBOutlet UIButton *btnAdvncSearch;
    IBOutlet UIButton *btnDropDownSearch;
    
    //===========================================
    BOOL isDirectReservation;

    IBOutlet UILabel *lblVericalLine;
    IBOutlet UILabel *lblReceiptNumbewr;
    IBOutlet UILabel *lblRestauName;
    IBOutlet UILabel *lblReviews;
    IBOutlet UILabel *lblPhoneNo;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblRestauName1;
    IBOutlet UILabel *lblReviews1;
    IBOutlet UILabel *lblPhoneNo1;
    IBOutlet UILabel *lblTime1;
    IBOutlet UILabel *lblEditProTitle;
    
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblType;
    IBOutlet UILabel *lblPrizeCasual;
    IBOutlet UILabel *lblCatgory;
    
    IBOutlet UILabel *lblFindRestaurant;
    IBOutlet UILabel *lblPayWithKent;
    IBOutlet UILabel *lblPayment;
    IBOutlet UILabel *lblReservation;
    IBOutlet UILabel *lblReceipt;
    IBOutlet UILabel *lblSupport;
    IBOutlet UILabel *lblLogout;
    IBOutlet UILabel *lblRecommended;
    IBOutlet UILabel *lblMinWait;
    IBOutlet UILabel *lblMinWaitBtm;
    IBOutlet UILabel *lblCasual;
    IBOutlet UILabel *lblFine;
    IBOutlet UILabel *lblRecommendedBtm;
    IBOutlet UILabel *lblCasualBtm;
    IBOutlet UILabel *lblFineBtm;
    IBOutlet UILabel *lblFEditProfileDetail;
    IBOutlet UILabel *lblFEditProfileName;
    IBOutlet UILabel *lblFEditProfileName1;
    IBOutlet UILabel *lblFEditProfileEmail;
    IBOutlet UILabel *lblFEditProfileEmail1;
    IBOutlet UILabel *lblFEditProfileMob;
    IBOutlet UILabel *lblFEditProfileMob1;
    IBOutlet UILabel *lblFEditProfilePass;
    IBOutlet UIButton *btnFEditProfileSave;
    IBOutlet UIButton *btnTitle;
    

    IBOutlet UILabel *lblGetDirection;
    IBOutlet UILabel *lblGetDirection1;
    
    IBOutlet UIImageView *imgPhoneImg;
    IBOutlet UIImageView *imgMapImg;
    
    IBOutlet UIImageView *imgPhoneImg1;
    IBOutlet UIImageView *imgMapImg1;
    
    IBOutlet UIImageView *imgProFindRestaurant;
    IBOutlet UIImageView *imgProPayWith;
    IBOutlet UIImageView *imgProPayment;
    IBOutlet UIImageView *imgProReservation;
    IBOutlet UIImageView *imgProReceipt;
    IBOutlet UIImageView *imgProSupport;
    IBOutlet UIImageView *imgProLogOut;
    IBOutlet UIImageView *imgUserMenu;

    
    UITableView *tblePrice;
    UITableView *tbleCat;
    UITableView *tbleLocation;
    UITableView *tblType;
    IBOutlet UITableView *tlbV;
    IBOutlet UITableView *tblVUpscale;
    
    
    IBOutlet UIView *viewHome;
    IBOutlet UIView *viewInHeader;
    IBOutlet UIView *viewBelowSearch;
    IBOutlet UIView *viewRestaurentReview;
    IBOutlet UIView *viewRestaurentListAfterSearch;
    IBOutlet UIView  *ViewDropdown;
    IBOutlet UIView *profileView;
    IBOutlet UIView *editProfile;
    IBOutlet UIView *seeProfile;
    IBOutlet UIView *changeProfile;
    IBOutlet UIView *viewRestauInfo;
    IBOutlet UIView *viewPriceCFU;
    IBOutlet UIView *viewReviewListBtm;
    IBOutlet UIView *viewRestroInfoWithReview;
    IBOutlet UIView *viewProfileBtmView;
    IBOutlet UIView *viewRestroInfoGesture;
    
    
    BOOL isFisrtTime;
    BOOL isFisrtTimeForReceiptApi;
    BOOL isBackCicked;
    
    NSMutableArray *arrTemp;
    NSMutableArray *arrAfterSearch;
    NSMutableArray *arrDataOfAfterSearch;
    
    NSArray *outputReviewsList;
    
    id receiptData;
    id outputRastByCat;
    id outputAllRestaurents;
    id listAllRestaurents;
    
    NSString *strType;
    NSString *strFilterType;
    NSString *strSearchType;
    NSString *strMapDidClicked;

    NSMutableDictionary *dicSearchId;
    NSMutableDictionary *dicFilterKeys;
    
    NSDictionary *dicUserProfileInfoAfterUpdate;
   
    CLLocationManager *locationManager;
  
    CLLocationCoordinate2D selectedMApCo;
    
    MKPolyline *polyline;
    int index;
    
    RNBlurModalView *modal;
    
    UILabel *reviewDistanceLbl;
    UILabel *reviewCallNoLbl;
    
    NSMutableArray  *restroMenuOptionsViewArr;
    
    int     isProfileOpening;   // 1 = opening
    int     isProfileClosing;   // 1 = closing
    int     isCasualOpening;   // 1 = opening
    int     isFineOpening;   // 1 = opening
    int     isRecommendedOpening;   // 1 = opening
    int     isCasualClosing;   // 1 = Closing
    int     isRestroOpening;   // 1 = Closing
    int     isRestroClosing;   // 1 = Closing
   
}

-(IBAction)btnUserDidClicked:(id)sender;
-(IBAction)btnViewAccountDidClicked:(id)sender;
-(IBAction)btnBackEditProfileDidClicked:(id)sender;
-(IBAction)btnEditONEditProfileDidClicked:(id)sender;
-(IBAction)btn_GogleDidClicked:(id)sender;
-(IBAction)btnThreeFilter:(id)sender;

-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)btn_GogleDidClicked:(id)sender;
-(IBAction)btn_CurrentLocation:(id)sender;

//============search via check boxes view
-(IBAction)btnLocationDidClicked:(id)sender;
-(IBAction)btnPriceDidClicked:(id)sender;
-(IBAction)btnCategoryhDidClicked:(id)sender;
-(IBAction)btnTypeDidClicked:(id)sender;
-(IBAction)btnSearchDidClicked:(id)sender;
-(IBAction)btnCheckBoxDidClicked:(id)sender;

//============

-(IBAction)btnSearchViaTextField:(id)sender;
-(IBAction)btnWifiDidClicked:(id)sender;
-(IBAction)btnONUserProfileDidClicked:(UIButton*)sender;
-(IBAction)btnTouchDownONUserProfile:(UIButton*)sender;
-(IBAction)btnSaveClicked:(id)sender;
-(IBAction)btn_UploadProPic:(id)sender;


//============Restaurant info view
-(IBAction)btnReservTableDidClicked:(id)sender;
-(IBAction)btnReviewDidClicked:(id)sender;
-(IBAction)btnGetDirectionDidClicked:(id)sender;
-(IBAction)btnPhoneNumberDidClicked:(id)sender;




@end
