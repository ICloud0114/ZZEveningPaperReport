//
//  LinkDetailCell.m
//  ReporterClient
//
//  Created by smile on 14-4-16.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "LinkDetailCell.h"

@implementation LinkDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        _linkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,20,15,15)];
        [self addSubview:_linkImageView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREENWIDTH - 40 - 36, 30)];
        [self addSubview:_titleLabel];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:WRITETITLECOLOR];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 2, 150, 15)];
        [self addSubview:_contentLabel];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setTextColor:TIMECOLOR];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:12]];
        [_contentLabel setNumberOfLines:0];
        
        
        _markImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 36 - 20, 17, 36, 20)];
        [self addSubview:_markImageView];
        
        _isImageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 150, 30, 21, 15)];
        [self addSubview:_isImageImageView];
        [_isImageImageView setImage:Nil];
        
        _isVideoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 120, 30, 21, 15)];
        [self addSubview:_isVideoImageView];
        [_isVideoImageView setImage:Nil];
        
        
        UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 53, SCREENWIDTH, 1)];
        [lineImageView setImage:[UIImage imageNamed:@"line"]];
        [self addSubview:lineImageView];
        
        [self setSelected_ZZ:NO];
    }
    return self;
}
-(void)setMarkInteger:(NSInteger)markInteger
{
    _markInteger = markInteger;
    switch (_markInteger)
    {
        case 0://
        {
            [_markImageView setImage:nil];
            
        }
            break;
        case 1://抢占
        {
            [_markImageView setImage:[UIImage imageNamed:@"grab_pic"]];

        }
            break;
        case 2://采用
        {
            [_markImageView setImage:[UIImage imageNamed:@"used_pic"]];
//            [_markImageView setImage:[UIImage imageNamed:@"shangchuan_icon@2x.png"]];
            
        }
        
            break;
        case 3://已上传
        {
            [_markImageView setImage:[UIImage imageNamed:@"upload_pic"]];
        }
            break;
        case 4:// 已审核
        {
            [_markImageView setImage:[UIImage imageNamed:@"approve_pic"]];
        }
            break;
        case 5://已发布
        {
            [_markImageView setImage:[UIImage imageNamed:@"publish_pic"]];
        }
            break;
        default:
        {
            [_markImageView setImage:nil];
        }
            break;
    }

}
-(void)setClueType:(NSInteger)markInteger
{
    switch (markInteger)
    {
        case 2://已上传
        {
            [_markImageView setImage:[UIImage imageNamed:@"upload_pic"]];
            
        }
            break;
        case 3://已审核
        {
            [_markImageView setImage:[UIImage imageNamed:@"approve_pic"]];
            
        }
            break;
        case 4://已发布
        {
            [_markImageView setImage:[UIImage imageNamed:@"publish_pic"]];
            
        }
            break;
            
        default:
        {
            [_markImageView setImage:nil];
        }
            break;
    }
}


- (void)isImageView:(BOOL)isImage
{
    if (isImage)
    {
        [_isImageImageView setImage:[UIImage imageNamed:@"pic_pic"]];
    }
    else
    {
        [_isImageImageView setImage:nil];
    }
}

- (void)isVideoView:(BOOL)isVideo
{
    if (isVideo)
    {
        [_isVideoImageView setImage:[UIImage imageNamed:@"video_pic"]];
    }
    else
    {
        [_isVideoImageView setImage:nil];
    }
}

//-(void)setMediaType:(NSInteger)markInteger
//{
//    _markInteger = markInteger;
//     switch (_markInteger)
//    {
//            
//        case 0://视频
//        {
//            [_isVideoImageView setImage:[UIImage imageNamed:@"video_icon@2x.png"]];
//            
//        }
//            break;
//        case 1://图片
//        {
//            [_isImageImageView setImage:[UIImage imageNamed:@"picture_icon@2x.png"]];
//            
//        }
//            break;
//       
//        default:
//        {
//            
//        }
//            break;
//    }
//}
//-(void)setIsReaded:(BOOL)isReaded
//{
//    _isReaded = isReaded;
//    if (_isReaded)
//    {
//        [_titleLabel setTextColor:LISTTITLECOLOR];
//        [_contentLabel setTextColor:LISTDATECOLOR];
//    }
//    else
//    {
//    }
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
