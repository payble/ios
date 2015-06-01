//
//  LoadingView.h
//  ituneUniversity
//
//  Created by Balvinder on 5/9/12.
//  Copyright 2012 Pericent Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoadingView :UIView
{

}

+ (id)loadingViewInView:(UIView *)aSuperview withBGColor:(UIColor *)bgColor;
+ (id)loadingViewInView:(UIView *)aSuperview withBGColor:(UIColor *)bgColor withMessage:(NSString *)msg;
- (void)removeView;

@end
