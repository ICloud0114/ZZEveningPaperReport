//
//  ClueDetailViewController.h
//  ReporterClient
//
//  Created by easaa on 4/14/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClueDetailViewController : UIViewController

@property (nonatomic, strong)NSString *titleString;
@property (nonatomic, strong)NSString *dateString;
@property (nonatomic, strong)NSString *ContentString;
@property NSInteger stateID;    // 0 采用 1 抢占
@property NSInteger type;       //0 关联线索 1 查看线索 2 搜索线索
@property NSString *detail;     //判断是不是查看线索
@property NSInteger sourceID;
@property NSInteger markID;     // 0 视频 1 图片
@property NSInteger linkID;     // 0 已采用 1 已抢占
-(id)initWithType:(NSInteger)type State:(NSInteger)state Mark:(NSInteger)mark;
//-(id)initWithDetail:(NSInteger)type State:(NSInteger)state Mark:(NSInteger)link;
//@property (nonatomic, strong)UILabel *titleLabel;
//@property (nonatomic, strong)UILabel *dateLabel;
//@property (nonatomic, strong)UITextView *contentView;
-(void)setBackImage:(NSInteger)index;
@end
