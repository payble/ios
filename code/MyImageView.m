//
//  MyImageView.m
//  iMixtapes
//
//  Created by Vipin Jain on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyImageView.h"
#define TMP NSTemporaryDirectory()

@implementation MyImageView


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code.
        //self.image=[UIImage imageNamed:@"noimage.png"];
//        [self.layer setBorderColor: [[UIColor whiteColor] CGColor]];
//        [self.layer setBorderWidth: 4.0];
//        [self.layer setShadowOffset:CGSizeMake(-0.1, -0.1)];
//        [self.layer setShadowOpacity:0.4];
//        //[imgView.layer setShadowRadius:0.0];
//        [self.layer setShadowColor:[UIColor grayColor].CGColor];
    }
    return self;
}
-(void) addImageFrom:(NSString*) URL isRound:(BOOL)value isActivityIndicator:(BOOL)activ
{
    value = NO;
    
    NSString *imgPath = [self getUniquePath:URL];
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath])
    {
        
        NSData *data = [NSData dataWithContentsOfFile:imgPath];
        img=[UIImage imageWithData:data];
        if(img.size.width>330 && img.size.height>500)
        {
        [self setImage:[self imageWithImage:[UIImage imageWithData:data] andWidth:330 andHeight:500]];
        }
        else
        {
            [self setImage:[UIImage imageWithData:data]];
        }
        
    }
    
	else 
	{
        if (activ) 
        {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            
            activityIndicator.tag = 786;
            
            [activityIndicator startAnimating];
            
            [activityIndicator setHidesWhenStopped:YES];
            
            CGRect myRect = self.frame;
            
            NSLog(@"Class name %@",[self class]);
            
            CGRect newRect = CGRectMake(myRect.size.width/2 -12.5f,myRect.size.height/2 - 12.5f, 25, 25);
            
            [activityIndicator setFrame:newRect];
            
            [self addSubview:activityIndicator];
        }
        
		[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:URL];
	}
}
-(void) addImageFrom:(NSString*) URL isRound:(BOOL)value
{
	[self addImageFrom:URL isRound:value isActivityIndicator:YES];
}

-(void) fetchImage:(NSString*) str
{
	NSURL *url = [NSURL URLWithString:str];
    
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *tmpImage = [UIImage imageWithData:data];
	NSString *imgPath = [self getUniquePath:str];
	[data writeToFile:imgPath atomically:YES];
    
    
    NSLog(@"fetch image");
    
    [self performSelectorOnMainThread:@selector(setImageToImageView:) withObject:tmpImage waitUntilDone:YES];

}
-(UIImage*)imageWithImage:(UIImage*)image andWidth:(CGFloat)widths andHeight:(CGFloat)height
{
    UIGraphicsBeginImageContext( CGSizeMake(widths, height));
    [image drawInRect:CGRectMake(0,0,widths,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(void)setImageToImageView:(UIImage *)tmpImage
{
    if(tmpImage.size.width>330 && tmpImage.size.height>500)
    {
        [self setImage:[self imageWithImage:tmpImage andWidth:330 andHeight:500]];
    }
    else
    {
        [self setImage:tmpImage];
    }

    [self setImage:tmpImage];
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView*)[self viewWithTag:786];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}


-(NSString*)  getUniquePath:(NSString*)  urlStr
{
	NSLog(@"path : %@",urlStr);
    if ([urlStr length] > 7)
    {
        
    NSMutableString *tempImgUrlStr = [NSMutableString stringWithString:[urlStr substringFromIndex:7]];
        [tempImgUrlStr replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
    
    // Generate a unique path to a resource representing the image you want
    NSString    *filename = [NSString stringWithFormat:@"%@",tempImgUrlStr] ;//[ImageURLString substringFromIndex:7];   // [[something unique, perhaps the image name]];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    return uniquePath;
    }
return nil;
}
						   
- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *testImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}


//-(UIImage*)rescaleImage:(UIImage*)image{
//    UIImage* scaledImage = image;
//    CALayer* layer = self.layer;
//    CGFloat borderWidth = 4;//layer.borderWidth;
//    
//    //if border is defined
//    if (borderWidth > 0)
//    {
//        //rectangle in which we want to draw the image.
//        CGRect imageRect = CGRectMake(0.0, 0.0, self.bounds.size.width - 2 * borderWidth,self.bounds.size.height - 2 * borderWidth);
//        //Only draw image if its size is bigger than the image rect size.
//        if (image.size.width > imageRect.size.width || image.size.height > imageRect.size.height)
//        {
//            UIGraphicsBeginImageContext(imageRect.size);
//            [image drawInRect:imageRect];
//            scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//        }       
//    }
//    return scaledImage;
//}


@end
