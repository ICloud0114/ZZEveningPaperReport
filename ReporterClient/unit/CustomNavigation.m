//
//  CustomNavigation.m
//  ReporterClient
//
//  Created by smile on 14-4-14.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "CustomNavigation.h"

@implementation CustomNavigation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_backgroundImageView];
        [_backgroundImageView setImage:[UIImage imageNamed:@"top.png"]];
        _backgroundImageView.backgroundColor = [UIColor yellowColor];
        
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 26, 30, 30)];
        [self addSubview:_leftButton];
        _leftButton.hidden = YES;
        
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"back_btn_after"] forState:UIControlStateHighlighted];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_rightButton];
        _rightButton.hidden = YES;
        
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH - 100)/2, 26, 100, 30)];
        [self addSubview:_titleLabel];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
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
