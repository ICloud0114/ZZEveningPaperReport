//
//  MediaFootView.m
//  ReporterClient
//
//  Created by smile on 14-4-14.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "MediaFootView.h"

@implementation MediaFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
         UIImageView *_topLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, 1)];
        [_topLineImageView setImage:[UIImage imageNamed:@"line"]];
        [self addSubview:_topLineImageView];

        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 90 - 20, 20, 90, 40)];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"save_btn"] forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"save_btn_after"] forState:UIControlStateHighlighted];
        [self addSubview:_saveButton];
        
        _upLoadButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 20, 20, 90, 40)];
        [_upLoadButton setTitle:@"上传" forState:UIControlStateNormal];
        [_upLoadButton setBackgroundImage:[UIImage imageNamed:@"submit_btn"] forState:UIControlStateNormal];
        [_upLoadButton setBackgroundImage:[UIImage imageNamed:@"submit_btn_after"] forState:UIControlStateHighlighted];
        [self addSubview:_upLoadButton];
        
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
