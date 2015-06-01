//
//  CalendarDataService.h
//  calendar
//
//  Created by Mahmood1 on 1/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTAPIRequest.h"
@interface Api_connect : UIViewController
{

    
}

+(Api_connect *)serviceStart;

-(RESTAPIRequest *)registers:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email password:(NSString *)password dob:(NSString *)dob  gender:(NSString *)gender type:(NSString*)type image:(NSData *)image imagename:(NSString *)imagename onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)login:(NSString *)username password:(NSString *)password type:(NSString*)type onTarget:(id)target action:(SEL)action;
-(RESTAPIRequest *)updateuser:(NSString *)userid firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email   profilepic:(NSData*)photo onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)getuserbyemail:(NSString *)email  onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)addcommentOnlyText:(NSString *)userid WithAnonymous:(NSString *)anonymous withMaplocation:(NSString *)maplocation  withLatitude:(NSString *)latitude  withLongitude:(NSString *)longitude  WithImgOrVdo:(NSString *)key withComment:(NSString *)text onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)addcomment:(NSString *)userid WithAnonymous:(NSString *)anonymous withMaplocation:(NSString *)maplocation  withLatitude:(NSString *)latitude  withLongitude:(NSString *)longitude  WithImgOrVdo:(NSString *)key withComment:(NSString *)text withPostImage:(NSData*)image onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)addcommentVideo:(NSString *)userid WithAnonymous:(NSString *)anonymous withMaplocation:(NSString *)maplocation  withLatitude:(NSString *)latitude  withLongitude:(NSString *)longitude  WithImgOrVdo:(NSString *)key withComment:(NSString *)text withPostVideo:(NSData*)video withThumbNail:(NSData*)thumnail withThumnailName:(NSString*)thumbnailName onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)getcommentbyuserid:(NSString *)userid  onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)updateLocation:(NSString *)userid  withLatitude:(NSString *)latitude  withLongitude:(NSString *)longitude  withUdid:(NSString *)udid  onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)getallcomment:(NSString *)userid  onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)addCommentLikeDislke:(NSString *)userid withPostId:(NSString *)postId witPost_userid:(NSString *)post_userid withpost_comment:(NSString *)post_comment withstatus:(NSString *)status onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)getOwnAllPost:(NSString *)userid userType:(NSString*)TYPE onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)addlike:(NSString *)userid commentid:(NSString*)commentid postid:(NSString*)post_userid likeStatus:(NSString*)status post_comment:(NSString*)post_comment onTarget:(id)target action:(SEL)action;

-(RESTAPIRequest *)addfollower:(NSString*)follower withfollowing:(NSString*)following  withtype:(NSString *)type  onTarget:(id)target  action:(SEL)action;

-(RESTAPIRequest *)getappuser:(NSString*)userid  onTarget:(id)target  action:(SEL)action;

-(RESTAPIRequest *)getfollows:(NSString*)userid  onTarget:(id)target  action:(SEL)action;

-(RESTAPIRequest *)getFilterCategory:(id)target  action:(SEL)action;

@end
