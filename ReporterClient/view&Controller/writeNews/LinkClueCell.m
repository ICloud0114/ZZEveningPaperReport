//
//  LinkClueCell.m
//  ReporterClient
//
//  Created by smile on 14-4-15.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "LinkClueCell.h"

@implementation LinkClueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor];
        
//        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 281, 32)];
//        [self addSubview:_backgroundImageView];
//        [_backgroundImageView setImage:[UIImage imageNamed:@"xiansuo_box@2x.png"]];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, SCREENWIDTH - 30 - 25, 20)];
        [self addSubview:_nameLabel];

        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 10, 12, 20, 20)];
        [self addSubview:_deleteButton];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"pic_del_btn"] forState:UIControlStateNormal];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"pic_del_btn_after"] forState:UIControlStateHighlighted];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
