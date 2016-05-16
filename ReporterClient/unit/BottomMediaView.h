//
//  BottomMediaView.h
//  ReporterClient
//
//  Created by smile on 14-4-14.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomMediaView : UIView
{
    UIImageView *backgroundImageView;
}
@property (nonatomic, strong)UIButton *grabButton;//抢占资源/已抢占
@property (nonatomic, strong)UIButton *employButton;//采用/已采用
@property (nonatomic, strong)UIButton *replyButton;//回复

@property (nonatomic, strong)UILabel *grapLabel;
@property (nonatomic, strong)UILabel *employLabel;

@end
