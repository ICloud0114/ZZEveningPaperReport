//
//  ReplyView.h
//  ReporterClient
//
//  Created by easaa on 4/16/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ReplayViewType)
{
    ZZReplayViewTypeDefault = 0,
    ZZReplayViewTypeNoShare = 1,
};
@interface ReplyView : UIView
{
    
}
@property (nonatomic, strong)UIImageView *backgroundImageView;
@property (nonatomic, strong)UIImageView *replyTextFieldBackgroundImageView;
@property (nonatomic, strong)UITextField *replyTextField;
@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, strong)UIButton *sendButton;

- (id)initWithFrame:(CGRect)frame withReplyType:(ReplayViewType )type;
@end
