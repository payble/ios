//
//  LoadingView.m
//  ituneUniversity
//
//  Created by Balvinder on 5/7/12.
//  Copyright 2012 Pericent Softwares. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

//
// NewPathWithRoundRect
//
// Creates a CGPathRect with a round rect of the given radius.
//
CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height - cornerRadius);

	// Top left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		cornerRadius);

	// Top right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y,
		cornerRadius);

	// Close the path at the rounded rect
	CGPathCloseSubpath(path);
	
	return path;
}

@implementation LoadingView

//
// loadingViewInView:
//
// Constructor for this view. Creates and adds a loading view for covering the
// provided aSuperview.
//
// Parameters:
//    aSuperview - the superview that will be covered by the loading view
//
// returns the constructed view, already added as a subview of the aSuperview
//	(and hence retained by the superview)
//
+ (id)loadingViewInView:(UIView *)aSuperview withBGColor:(UIColor *)bgColor{
	
	return [LoadingView loadingViewInView:aSuperview withBGColor:bgColor withMessage:nil];
}




+ (id)loadingViewInView:(UIView *)aSuperview withBGColor:(UIColor *)bgColor withMessage:(NSString *)msg
{
	
	LoadingView *loadingView =
		[[[LoadingView alloc] initWithFrame:[aSuperview bounds]] autorelease];
	if (!loadingView)
	{
		return nil;
	}
	loadingView.userInteractionEnabled=NO;
	
	loadingView.opaque = NO;
	loadingView.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.2f];
	loadingView.autoresizingMask =
		UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[aSuperview addSubview:loadingView];
	
	const CGFloat DEFAULT_LABEL_WIDTH = 150.0;
	const CGFloat DEFAULT_LABEL_HEIGHT = 30.0;
	UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT)];
	
	if (bgColor!=nil)
    {
		backView.backgroundColor=[UIColor colorWithRed:46.0f/255.0f green:77.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
	}
    else
    {
		backView.backgroundColor=[UIColor colorWithRed:46.0f/255.0f green:77.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
	}

	backView.userInteractionEnabled=NO;
	backView.layer.cornerRadius=10.0f;
	//backView.layer.shadowColor=[UIColor blackColor].CGColor;
//	backView.layer.shadowOffset=CGSizeMake(0.0f,3.0f);
//	backView.layer.shadowRadius=5.0f;
//	backView.layer.shadowOpacity=0.8f;
	backView.layer.borderWidth=2.0f;
	backView.layer.borderColor=[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.7f].CGColor;
	
	[loadingView addSubview:backView];
	backView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin |
	UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin |
	UIViewAutoresizingFlexibleBottomMargin;
	
	
	CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
	UILabel *loadingLabel =
		[[[UILabel alloc]
			initWithFrame:labelFrame]
		autorelease];
	if (msg==nil) {
		loadingLabel.text = NSLocalizedString(@"Loading...", nil);
	}else {
		loadingLabel.text = NSLocalizedString(msg, nil);
        
	}
    loadingLabel.textAlignment=NSTextAlignmentCenter;
	loadingLabel.userInteractionEnabled=NO;
	loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	//loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	loadingLabel.autoresizingMask =
		UIViewAutoresizingFlexibleLeftMargin |
		UIViewAutoresizingFlexibleRightMargin |
		UIViewAutoresizingFlexibleTopMargin |
		UIViewAutoresizingFlexibleBottomMargin;
	
	[loadingView addSubview:loadingLabel];
	UIActivityIndicatorView *activityIndicatorView =
		[[[UIActivityIndicatorView alloc]
			initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]
		autorelease];
	activityIndicatorView.userInteractionEnabled=NO;
	[loadingView addSubview:activityIndicatorView];
	
	activityIndicatorView.autoresizingMask =
		UIViewAutoresizingFlexibleLeftMargin |
		UIViewAutoresizingFlexibleRightMargin |
		UIViewAutoresizingFlexibleTopMargin |
		UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
	
	CGFloat totalHeight =
		loadingLabel.frame.size.height +
		activityIndicatorView.frame.size.height;
	labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
	labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - totalHeight));
	loadingLabel.frame = labelFrame;

	backView.frame=CGRectMake(labelFrame.origin.x, labelFrame.origin.y,labelFrame.size.width, totalHeight); 
	
	
	[backView release];

	
	CGRect activityIndicatorRect = activityIndicatorView.frame;
	activityIndicatorRect.origin.x =
		0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y =
		loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
	activityIndicatorView.frame = activityIndicatorRect;
	
	// Set up the fade-in animation
//	CATransition *animation = [CATransition animation];
//	[animation setType:kCATransitionFade];
//	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
	
	return loadingView;
}

//
// removeView
- (void)removeView
{
	//UIView *aSuperview = [self superview];
	super.userInteractionEnabled=YES;
	[super removeFromSuperview];
	

	
}

// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
	rect.size.height -= 1;
	rect.size.width -= 1;
	
	const CGFloat RECT_PADDING = 8.0;
	rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
	
	const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
	CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	const CGFloat BACKGROUND_OPACITY = 0.0f;
	CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextFillPath(context);

	const CGFloat STROKE_OPACITY = 0.25;
	CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextStrokePath(context);
	
	CGPathRelease(roundRectPath);
}

//
// dealloc
//
// Release instance memory.
//
- (void)dealloc
{
    [super dealloc];
}

@end
