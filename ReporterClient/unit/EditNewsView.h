//
//  EditNewsView.h
//  ReporterClient
//
//  Created by smile on 14-4-15.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "PopupView.h"
@interface EditNewsView : UIView<UITextFieldDelegate,UITextViewDelegate,IFlyRecognizerViewDelegate>
{
    IFlyRecognizerView      *_iflyRecognizerView;
//    UITextView *_contentTextView;
    PopupView               *_popView;
}
@property (nonatomic, strong) UITextView *titleTextView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *audioButton1;
@property (nonatomic, strong) UIButton *audioButton2;
@property (nonatomic, strong) UILabel *textViewPlaceholderLabel;
@property (nonatomic, strong) UILabel *textLable;

@end
