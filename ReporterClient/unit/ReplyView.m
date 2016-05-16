//
//  ReplyView.m
//  ReporterClient
//
//  Created by easaa on 4/16/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "ReplyView.h"

@implementation ReplyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREENWIDTH, 49)];
        
//        self.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,2)];
        _backgroundImageView.image = [UIImage imageNamed:@"line_a"];
        [self addSubview:_backgroundImageView];
        _replyTextFieldBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 49)];
        [_replyTextFieldBackgroundImageView setImage:[UIImage imageNamed:@"comment_bg"]];
        [self addSubview:_replyTextFieldBackgroundImageView];

        
        _replyTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, SCREENWIDTH - 20 - 10 - 60, 30)];
        
        _replyTextField.background = [UIImage imageNamed:@"input_box_290"];
        [self addSubview:_replyTextField];
        [_replyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_replyTextField setFont:[UIFont systemFontOfSize:12]];
        [_replyTextField setPlaceholder:@"我来说说……"];
        [_replyTextField setReturnKeyType:UIReturnKeyDone];
        _replyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //底下的竖线
//        UIImageView * bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(258, 8, 2, 38)];
//        bottomLine.image = [UIImage imageNamed:@"top_bg_line"];
//        [self addSubview:bottomLine];

//        _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 44, 40)];
//        [self addSubview:_shareButton];
//
//        [_shareButton setBackgroundImage:[UIImage imageNamed:@"face_btn"] forState:UIControlStateNormal];
//        [_shareButton setBackgroundImage:[UIImage imageNamed:@"face_btn"] forState:UIControlStateHighlighted];
        
        _sendButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 58, 10, 58, 30)];
        [self addSubview:_sendButton];

        [_sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn"] forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_h"] forState:UIControlStateHighlighted];
        _sendButton.hidden = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withReplyType:(ReplayViewType )type
{
    self = [self initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        switch (type)
        {
            case 1:
            {
                [_shareButton setHidden:NO];
                [_sendButton setHidden:NO];
                [_replyTextFieldBackgroundImageView setFrame:CGRectMake(40, 5, 205, 31)];
                [_replyTextField setFrame:CGRectMake(45, 5, 252, 30)];
            }
                break;
                
            default:
                break;
        }
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
