//
//  BottomMediaView.m
//  ReporterClient
//
//  Created by smile on 14-4-14.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "BottomMediaView.h"

@implementation BottomMediaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {   
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 2)];
        backgroundView.image = [UIImage imageNamed:@"line_a"];
        [self addSubview:backgroundView];
        
        
        self.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
        _grabButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
        
        _grapLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
        _grapLabel.backgroundColor = [UIColor clearColor];
        _grapLabel.text = @"抢占资源";
        [self addSubview:_grapLabel];
//        [_grabButton setTitle:@"抢占资源" forState:UIControlStateNormal];
//        [_grabButton setTitle:@"已抢占" forState:UIControlStateSelected];
        [_grabButton setTitleColor:LINKCLURCOLOR forState:UIControlStateNormal];
        [_grabButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self addSubview:_grabButton];
        
//        [_grabButton setBackgroundImage:[UIImage imageNamed:@"bm_icon_camera@2x.png"] forState:UIControlStateNormal];
//        [_grabButton setBackgroundImage:[UIImage imageNamed:@"bm_icon_camera_h@2x.png"] forState:UIControlStateHighlighted];
        _employLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 140, 10, 60, 30)];
        _employLabel.backgroundColor = [UIColor clearColor];
        _employLabel.text = @"采用";
        _employLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_employLabel];
        _employButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 140, 10, 60, 30)];
//        [_employButton setTitle:@"采用" forState:UIControlStateNormal];
//        [_employButton setTitle:@"已采用" forState:UIControlStateSelected];
        [_employButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_employButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self addSubview:_employButton];
        
        
//        [_employButton setBackgroundImage:[UIImage imageNamed:@"bm_icon_picture@2x.png"] forState:UIControlStateNormal];
//        [_employButton setBackgroundImage:[UIImage imageNamed:@"bm_icon_picture_h@2x.png"] forState:UIControlStateHighlighted];
//        
        _replyButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 70, 10, 60, 30)];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_replyButton];
//        [_replyButton setBackgroundImage:[UIImage imageNamed:@"bm_icon_camera@2x.png"] forState:UIControlStateNormal];
//        [_replyButton setBackgroundImage:[UIImage imageNamed:@"bm_icon_camera_h@2x.png"] forState:UIControlStateHighlighted];
        
    }
    return self;
}



@end
