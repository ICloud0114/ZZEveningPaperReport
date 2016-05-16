//
//  ReplyCell.h
//  ReporterClient
//
//  Created by easaa on 4/16/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *userlabel;
@property (nonatomic,strong)UILabel *positionsLabel;
@property(nonatomic,strong)UILabel *contentlabel;
@property(nonatomic,strong)UILabel *areaDatelabel;
//@property(nonatomic,retain)UILabel *floorlabel;
//@property(nonatomic,retain)UIButton *replyBtn;
-(CGFloat)setContentlabelText:(NSString *)text;
@end
