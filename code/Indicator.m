//
//  Indicator.m
//  //

//

#import "Indicator.h"

@implementation Indicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       // self.backgroundColor = [UIColor lightTextColor];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        [_indicatorView setCenter: self.center];
        _indicatorView.color = [UIColor whiteColor];
        _indicatorView.layer.cornerRadius = 5.0;
        _indicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];//UIColorFromRGB(0x3366cc);
        [_indicatorView startAnimating];
        [self addSubview:_indicatorView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 100, 20)];
        label.text = @"Loading...";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor
                           ];
        [_indicatorView addSubview:label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
