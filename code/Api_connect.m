//
//  CalendarDataService.m
//  calendar
//
//  Created by Mahmood1 on 1/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Api_connect.h"
#import "RESTAPIRequest.h"
#import "AppDelegate.h"
#import "JSON.h"
//#import "TaxibuddyAppDelegate.h"

@implementation Api_connect


+(Api_connect *)serviceStart
{
    
	return [Api_connect new];
    
}
-(RESTAPIRequest *)registers:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email password:(NSString *)password dob:(NSString *)dob  gender:(NSString *)gender type:(NSString*)type image:(NSData *)image imagename:(NSString *)imagename onTarget:(id)target action:(SEL)action
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@register",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:firstname,@"firstname",lastname,@"lastname",email,@"email",password,@"password",dob,@"dob",gender,@"gender",type,@"type",nil];
    
    NSString *jsonstring=[dict JSONRepresentation];
    NSLog(@"%@",jsonstring);
    [_request sendPostDataWithImage:jsonstring withdate:image withImageName:imagename];
    return _request;
  
}


-(RESTAPIRequest *)login:(NSString *)username password:(NSString *)password type:(NSString*)type onTarget:(id)target action:(SEL)action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@login",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:username,@"email",password,@"password",type,@"type",nil];
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [_request sendPostData:data];
    return _request;
}


-(RESTAPIRequest *)getuserbyemail:(NSString *)email onTarget:(id)target action:(SEL)action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@getuserbyemail",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:email,@"email",nil];
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [_request sendPostData:data];
    return _request;
}

#pragma mark- add Post comment ONLY  TEXt

-(RESTAPIRequest *)addcommentOnlyText:(NSString *)userid WithAnonymous:(NSString *)anonymous withMaplocation:(NSString *)maplocation  withLatitude:(NSString *)latitude  withLongitude:(NSString *)longitude  WithImgOrVdo:(NSString *)key withComment:(NSString *)text onTarget:(id)target action:(SEL)action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@addcomment",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",
                                                                anonymous,@"anonymous",
                                                                maplocation,@"maplocation",
                                                                key,@"key",
                                                                latitude,@"latitude",
                                                                longitude,@"longitude",
                                                                text,@"text",nil];
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",jsonstring);
     NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
  //  [_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;
    
}

#pragma mark- update user details
-(RESTAPIRequest *)updateuser:(NSString *)userid firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email   profilepic:(NSData*)photo onTarget:(id)target action:(SEL)action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@updateuser",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",
                                                                    firstname,@"firstname",
                                                                    lastname,@"lastname",
                                                                    email,@"email",
                                                                    nil];
    NSString *jsonstring=[dict JSONRepresentation];
    // NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",jsonstring);
    // NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [_request sendPostDataWithImage:jsonstring withdate:photo withImageName:@"img"];
    //[_request sendPostData:data];
    return _request;

    
}

#pragma mark- add Post comment with IMAGE

-(RESTAPIRequest *)addcomment:(NSString *)userid WithAnonymous:(NSString *)anonymous withMaplocation:(NSString *)maplocation  withLatitude:(NSString *)latitude  withLongitude:(NSString *)longitude  WithImgOrVdo:(NSString *)key withComment:(NSString *)text withPostImage:(NSData*)image onTarget:(id)target action:(SEL)action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@addcomment",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",
                                                                    anonymous,@"anonymous",
                                                                    maplocation,@"maplocation",
                                                                    key,@"key",
                                                                    latitude,@"latitude",
                                                                    longitude,@"longitude",
                                                                    text,@"text",nil];
    NSString *jsonstring=[dict JSONRepresentation];
   // NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",jsonstring);
   // NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    //[_request sendPostData:data];
    return _request;
    
}

#pragma mark- add Post comment with-VIDEO

-(RESTAPIRequest *)addcommentVideo:(NSString *)userid WithAnonymous:(NSString *)anonymous withMaplocation:(NSString *)maplocation  withLatitude:(NSString *)latitude  withLongitude:(NSString *)longitude  WithImgOrVdo:(NSString *)key withComment:(NSString *)text withPostVideo:(NSData*)video withThumbNail:(NSData*)thumnail withThumnailName:(NSString*)thumbnailName onTarget:(id)target action:(SEL)action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@addcomment",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",
                                                                    anonymous,@"anonymous",
                                                                    maplocation,@"maplocation",
                                                                    key,@"key",
                                                                    latitude,@"latitude",
                                                                    longitude,@"longitude",
                                                                    text,@"text",nil];
    NSString *jsonstring=[dict JSONRepresentation];
    // NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",jsonstring);
  //  [_request sendPostDataWithVideo:jsonstring withdate:video withVideoName:@"video"];
    [_request sendPostDataWithVideo:jsonstring withdate:video withVideoName:@"video" withImagrThumnail:thumnail withImageName:thumbnailName];
    return _request;
    
}

#pragma mark- get all Post and comment
-(RESTAPIRequest *)getcommentbyuserid:(NSString *)userid  onTarget:(id)target action:(SEL)action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@getcommentbyuserid",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",nil];
    NSString *jsonstring=[dict JSONRepresentation];
     NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
     NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;
    
}
#pragma mark- update Location

-(RESTAPIRequest *)updateLocation:(NSString *)userid  withLatitude:(NSString *)latitude  withLongitude:(NSString *)longitude  withUdid:(NSString *)udid  onTarget:(id)target action:(SEL)action
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@updateLocation",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",
                                                                    latitude,@"latitude",
                                                                    longitude,@"longitude",
                                                                    udid,@"udid",
                                                                    @"",@"gcm_regid",
                                                                    nil];
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;
    
}

#pragma mark- get All comments
-(RESTAPIRequest *)getallcomment:(NSString *)userid  onTarget:(id)target action:(SEL)action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@getallcomment",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",nil];
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;
}

#pragma mark- add comments like or dislike
-(RESTAPIRequest *)addCommentLikeDislke:(NSString *)userid withPostId:(NSString *)postId witPost_userid:(NSString *)post_userid withpost_comment:(NSString *)post_comment withstatus:(NSString *)status onTarget:(id)target action:(SEL)action
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@addlike",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",
                                                                    postId,@"commentid",
                                                                    post_userid,@"post_userid",
                                                                    post_comment,@"post_comment",
                                                                    status,@"status",
                                                                    nil];
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;
    
}


#pragma mark- get users(own) all post
-(RESTAPIRequest *)getOwnAllPost:(NSString *)userid userType:(NSString*)TYPE onTarget:(id)target action:(SEL)action
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@getfollowcomment",appDelegate.urlString];
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",TYPE,@"type",  nil];
    
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;
    
}

#pragma mark- get users(own) all post

-(RESTAPIRequest *)addlike:(NSString *)userid commentid:(NSString*)commentid postid:(NSString*)post_userid likeStatus:(NSString*)status post_comment:(NSString*)post_comment onTarget:(id)target action:(SEL)action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlstring=[NSString stringWithFormat:@"%@addlike",appDelegate.urlString];
    
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlstring];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",
                                                                    commentid,@"commentid",
                                                                    post_userid,@"post_userid",
                                                                    status,@"status",
                                                                    post_comment,@"post_comment",nil];
  
    
    
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;

    
    
}

#pragma mark- add follower

-(RESTAPIRequest *)addfollower:(NSString*)follower withfollowing:(NSString*)following  withtype:(NSString *)type  onTarget:(id)target  action:(SEL)action
{
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *urlString=[NSString stringWithFormat:@"%@addfollower",appDelegate.urlString];
    
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlString];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:follower,@"fallower",
                                                                    following,@"following",
                                                                    type,@"type", nil];
    
    
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;
    
}

#pragma mark- get followers
-(RESTAPIRequest *)getfollows:(NSString*)userid  onTarget:(id)target  action:(SEL)action
{
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *urlString=[NSString stringWithFormat:@"%@getfollows",appDelegate.urlString];
    
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlString];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid",nil];
    
    
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;

}

#pragma mark- get all app user for search section
-(RESTAPIRequest *)getappuser:(NSString*)userid   onTarget:(id)target  action:(SEL)action
{
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *urlString=[NSString stringWithFormat:@"%@getappuser",appDelegate.urlString];
    
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlString];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid", nil];
    
    
    NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =[NSString stringWithFormat:@"request=%@",jsonstring];
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;
}

-(RESTAPIRequest *)getFilterCategory:(id)target  action:(SEL)action
{
    
    //AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *urlString=@"http://netleondev.com/kentapi/restaurant/category";
    
    RESTAPIRequest *_request=[RESTAPIRequest createRequest:target action:action urlString:urlString];
 //   NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"userid", nil];
    
    
  //  NSString *jsonstring=[dict JSONRepresentation];
    NSString *post =nil;
    NSLog(@"post ra%@",post);
    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //[_request sendPostDataWithImage:jsonstring withdate:image withImageName:@"img"];
    [_request sendPostData:data];
    return _request;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
