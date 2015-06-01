//
//  MyAnnotation.h
//  SimpleMapView
//
//  Created by Mayur Birari.

//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation> {
	
	CLLocationCoordinate2D	coordinate;
	NSString*				title;
	NSString*				subtitle;
	NSString*               carStatus;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
//@property (nonatomic, assign)	image	coordinate;
@property (nonatomic, copy)		NSString*				title;
@property (nonatomic, copy)		NSString*				subtitle;

@end