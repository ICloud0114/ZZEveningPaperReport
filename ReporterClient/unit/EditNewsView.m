//
//  EditNewsView.m
//  ReporterClient
//
//  Created by smile on 14-4-15.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "EditNewsView.h"
#import "Definition.h"

@implementation EditNewsView
{
    BOOL flag;
    UIImageView *inputTitle;
    UIImageView *backgroudView;
    
//    UIImageView *lineImageView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.backgroundColor = [UIColor clearColor];
        inputTitle = [[UIImageView alloc] initWithFrame:CGRectMake(15,5,SCREENWIDTH - 30,40)];
        [inputTitle setImage:[UIImage imageNamed:@"input_title"]];
        inputTitle.userInteractionEnabled = YES;
        [self addSubview:inputTitle];
        
        _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,5,SCREENWIDTH - 30 - 30 ,30)];
        _titleTextView.backgroundColor = [UIColor clearColor];
        _titleTextView.tag = 1010;
        _titleTextView.showsVerticalScrollIndicator = NO;
        [_titleTextView setTextColor:WRITETITLECOLOR];
        [_titleTextView setDelegate:self];
        [_titleTextView setFont:[UIFont systemFontOfSize:14]];
        [inputTitle addSubview:_titleTextView];
        
        
        
        _textLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
        [_textLable setBackgroundColor:[UIColor clearColor]];
        [_textLable setFont:_titleTextView.font];
        [_textLable setTextColor:REMMINDERTEXTCLOLOR];
        [_textLable setText:@"标题名称"];
        [_titleTextView addSubview:_textLable];
        
        
//        lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 40, self.frame.size.width-4, 3)];
//        [lineImageView setImage:[UIImage imageNamed:@"line.png"]];
//        [self addSubview:lineImageView];
        
        _audioButton1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, 5, 30, 30)];
        [_audioButton1 setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [_audioButton1 setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateHighlighted];
        _audioButton1.tag = 100;
        [_audioButton1 addTarget:self action:@selector(startListenning:) forControlEvents:UIControlEventTouchUpInside];
        [inputTitle addSubview:_audioButton1];
        
        
        
        backgroudView = [[UIImageView alloc] initWithFrame:CGRectMake(15,inputTitle.frame.origin.y +
                                                                                   inputTitle.frame.size.height + 10,
                                                                                   
                                                                                   SCREENWIDTH - 30,
                                                                                   
                                                                                   self.frame.size.height -
                                                                                   inputTitle.frame.size.height -
                                                                                   inputTitle.frame.origin.y - 20)];
        [backgroudView setImage:[UIImage imageNamed:@"input_box"]];
        backgroudView.userInteractionEnabled = YES;
        [self addSubview:backgroudView];

        _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0,0,SCREENWIDTH - 30,self.frame.size.height -inputTitle.frame.size.height -inputTitle.frame.origin.y - 10 - 30)];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.tag = 1011;
        [_contentTextView.layer setCornerRadius:2];
        [_contentTextView setTextColor:WRITETITLECOLOR];
        [_contentTextView setFont:[UIFont systemFontOfSize:14]];
        [_contentTextView setDelegate:self];
        [backgroudView addSubview:_contentTextView];
        
        _audioButton2 = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 30 - 30, backgroudView.frame.size.height-35, 30, 30)];
        [_audioButton2 setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [_audioButton2 setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateHighlighted];
        _audioButton2.tag = 101;
        [_audioButton2 addTarget:self action:@selector(startListenning:) forControlEvents:UIControlEventTouchUpInside];
        [backgroudView addSubview:_audioButton2];
        
        
        _textViewPlaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(_contentTextView.font.pointSize/2-2,
                                                                             _contentTextView.font.pointSize/2,
                                                                             _contentTextView.frame.size.width,
                                                                             _contentTextView.font.pointSize + 2)];
        [_contentTextView addSubview:_textViewPlaceholderLabel];
        [_textViewPlaceholderLabel setBackgroundColor:[UIColor clearColor]];
        [_textViewPlaceholderLabel setFont:_contentTextView.font];
        [_textViewPlaceholderLabel setTextColor:REMMINDERTEXTCLOLOR];
        [_textViewPlaceholderLabel setText:@"请输入稿件内容"];
        
        _popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
        _popView.ParentView = self;
        
        //初始化语音识别控件
        NSString *initString = [NSString stringWithFormat:@"appid=%@",APPID];
        CGPoint point = CGPointMake(SCREENWIDTH / 2, 240);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            point = CGPointMake(SCREENWIDTH / 2, 260);
        }
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:point initParam:initString];
        _iflyRecognizerView.delegate = self;
        
        [_iflyRecognizerView setParameter:@"domain" value:@"iat"];
        [_iflyRecognizerView setParameter:@"asr_audio_path" value:@"asrview.pcm"];
        //    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];   当你再不需要保存音频时，请在必要的地方加上这行。
        
        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        
//        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
        
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyBoard)];
        
        
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
        
        [topView setItems:buttonsArray];
        [_contentTextView setInputAccessoryView:topView];

    }
    return self;
}
-(void)dismissKeyBoard
{
    [_contentTextView resignFirstResponder];
}
#pragma mark -UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 1011)
    {
        if ([textView.text isEqualToString:@""] || textView.text == nil)
        {
            [_textViewPlaceholderLabel setHidden:NO];
        }
        else
        {
            [_textViewPlaceholderLabel setHidden:YES];
        }

    }
    else if(textView.tag == 1010)
    {
        if ([textView.text isEqualToString:@""] || textView.text == nil)
        {
            [_textLable setHidden:NO];
        }
        else
        {
            [_textLable setHidden:YES];
        }

        
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    if (textView.tag == 1011)
    {
        _titleTextView.hidden = YES;
        _audioButton1.hidden = YES;
//        lineImageView.hidden = YES;
        
        [UIView animateWithDuration:0.2 animations:
         ^{
//             [_contentTextView setFrame:CGRectMake(5, 0, self.frame.size.width-10, 230-40)];
             CGRect rect = backgroudView.frame;
             rect.origin.y -= 50;
             rect.size.height += 50;
             [backgroudView setFrame:rect];
             [_audioButton2 setFrame:CGRectMake(SCREENWIDTH - 30 - 30, backgroudView.frame.size.height-35, 30, 30)];
         }];
        
    }
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 1011)
    {
        
        [UIView animateWithDuration:0.2 animations:
         ^{
             CGRect rect = backgroudView.frame;
             rect.origin.y += 50;
             rect.size.height -= 50;
             [backgroudView setFrame:rect];
             [_audioButton2 setFrame:CGRectMake(SCREENWIDTH - 30 - 30, backgroudView.frame.size.height-35, 30, 30)];
         }];
        _titleTextView.hidden = NO;
        _audioButton1.hidden = NO;
//        lineImageView.hidden = NO;
    }
    
}



- (void)startListenning:(UIButton*)sender
{
    [self endEditing:YES];
    if (sender.tag == 100)
    {
        flag = YES;
    }
    else if (sender.tag == 101)
    {
        flag = NO;
    }
    [_iflyRecognizerView start];
    NSLog(@"start listenning...");
}

#pragma mark delegate
- (void)onResult:(IFlyRecognizerView *)iFlyRecognizerView theResult:(NSArray *)resultArray
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic)
    {
        [result appendFormat:@"%@",key];
    }
    if (!flag)
    {
        [_textViewPlaceholderLabel setHidden:YES];
        _contentTextView.text = [NSString stringWithFormat:@"%@%@",_contentTextView.text,result];
    }
    else
    {
        [_textLable setHidden:YES];
         _titleTextView.text = [NSString stringWithFormat:@"%@%@",_titleTextView.text,result];
    }
    
}

- (void)onEnd:(IFlyRecognizerView *)iFlyRecognizerView theError:(IFlySpeechError *)error
{
    [self addSubview:_popView];
    [_popView setText:[NSString stringWithFormat:@"识别结束,错误码:%d",[error errorCode]]];
    NSLog(@"errorCode:%d",[error errorCode]);
}

@end
