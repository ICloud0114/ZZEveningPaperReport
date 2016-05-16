//
//  LinkDetailCell.h
//  ReporterClient
//
//  Created by smile on 14-4-16.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkDetailCell : UITableViewCell
{
//    UIImageView *markImageView;
    NSString *photoType;
    NSString *videoType;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, assign) NSInteger markInteger; // 0 采用, 1 抢占 2 已上传 4 已审核 5 已发布
@property (nonatomic, assign) BOOL selected_ZZ;
//@property (nonatomic, assign) NSInteger mediaType;
@property (nonatomic, strong) UIImageView *linkImageView;
//@property (nonatomic, strong) UIImageView *mediaTypeImageView;
@property (nonatomic, strong)  UIImageView *isImageImageView;//是否有图片
@property (nonatomic, strong) UIImageView *isVideoImageView;//是否有视频

@property (nonatomic, strong) UIImageView *markImageView;//显示状态

//-(void)setMediaType:(NSInteger)markInteger;

-(void)isImageView:(BOOL)isImage;
-(void)isVideoView:(BOOL)isVideo;

-(void)setClueType:(NSInteger)markInteger;
@end
