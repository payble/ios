//
//  CustomMessage.m
//  campusc
//
//  Created by mac on 03/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomMessage.h"
@implementation CustomMessage

-(void)show:(NSString *)msg inView:(UIView *) parentView delay:(int)loDelay lYAxis:(int)loY{
	
	CGSize loSize=[msg sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f] constrainedToSize:CGSizeMake(250,80)];
    //CGSize loSize=
	float start=( [[UIScreen mainScreen]bounds].size.width-loSize.width)/2;
	NSLog(@"%f",loSize.width);
	NSLog(@"%f",loSize.height);
	
	self.frame=CGRectMake(start,loY,loSize.width+6, loSize.height+6);
		// Create a view. Put a label, set the msg
		UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(2,2,loSize.width,loSize.height)];
		lblTitle.numberOfLines=0;
		//lblTitle.lineBreakMode=UILineBreakModeWordWrap;
		lblTitle.font = [UIFont fontWithName:@"Arial" size:16.0f];
		lblTitle.textColor = [UIColor whiteColor];
		//lblTitle.textAlignment = UITextAlignmentCenter;
		lblTitle.text = msg;
		lblTitle.backgroundColor = [UIColor clearColor];
		[self addSubview:lblTitle];
		CALayer *layer = self.layer;
		layer.cornerRadius = 8.0f;
		self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0f];
		[parentView addSubview:self];
		[self performSelector:@selector(dismiss:) withObject:nil afterDelay:loDelay];
		[self setAutoresizesSubviews:FALSE];

}

- (void)dismiss:(id)sender
{
    // Fade out the message and destroy self
    [UIView animateWithDuration:0.5 
					 animations:^  { self.alpha = 0; }
					 completion:^ (BOOL finished) { [self removeFromSuperview]; }];
}

@end
