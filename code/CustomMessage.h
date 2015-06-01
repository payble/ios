//
//  CustomMessage.h
//  campusc
//
//  Created by mac on 03/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CustomMessage : UIView {

	
}
-(void)show:(NSString *)msg inView:(UIView *) parentView delay:(int)loDelay lYAxis:(int)loY;
- (void)dismiss:(id)sender;
@end
