//
//  ReplyCell.m
//  ReporterClient
//
//  Created by easaa on 4/16/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "ReplyCell.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:CGSizeMake((maxSize.width), (maxSize.height)) options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define EA_MULTILINE_TEXTSIZE(text, font, maxSize,mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode: mode] : CGSizeZero;
#endif

@implementation ReplyCell


//@synthesize replyBtn;
//@synthesize floorlabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //头像
        _headImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        _headImage.layer.cornerRadius = 5;
        _headImage.layer.masksToBounds = YES;
        _headImage.backgroundColor=[UIColor clearColor];
        [self addSubview:_headImage];
        //用户名
        _userlabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 73, 20)];
        _userlabel.textColor=[UIColor colorwithHexString:@"#c27575"];
        _userlabel.backgroundColor=[UIColor clearColor];
        _userlabel.font=[UIFont systemFontOfSize:14];

        [self addSubview:_userlabel];
        //职务
        _positionsLabel=[[UILabel alloc]initWithFrame:CGRectMake(123, 10, 34, 20)];
        _positionsLabel.textColor=[UIColor colorwithHexString:@"#c27575"];
        _positionsLabel.backgroundColor=[UIColor clearColor];
        _positionsLabel.font=[UIFont systemFontOfSize:14];
        [self addSubview:_positionsLabel];
//        //楼层
//        floorlabel=[[UILabel alloc]initWithFrame:CGRectMake(270, 10, 40, 15)];
//        floorlabel.textColor=[UIColor blackColor];
//        floorlabel.backgroundColor=[UIColor clearColor];
//        floorlabel.font=[UIFont systemFontOfSize:14];
//        floorlabel.textAlignment=NSTextAlignmentRight;
//        //        floorlabel.text=@"1楼";
//        [self addSubview:floorlabel];
        //内容
        _contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 45, SCREENWIDTH - 25, 25)];
        _contentlabel.textColor=[UIColor blackColor];
        _contentlabel.backgroundColor=[UIColor clearColor];
        _contentlabel.font=[UIFont systemFontOfSize:14];
        _contentlabel.numberOfLines=0;
        _contentlabel.lineBreakMode=NSLineBreakByWordWrapping;
        [self addSubview:_contentlabel];
        //地区时间
        _areaDatelabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 140, 15, 140, 10)];
        _areaDatelabel.textColor=[UIColor colorwithHexString:@"#595757"];
        _areaDatelabel.backgroundColor=[UIColor clearColor];
        _areaDatelabel.font=[UIFont systemFontOfSize:11];
        //        areaDatelabel.text=@"杭州 2013-05-02 14：39";
        [self addSubview:_areaDatelabel];
//        replyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        replyBtn.frame=CGRectMake(270, 65, 44, 30);
//        [replyBtn setBackgroundImage:[UIImage imageNamed:@"reply_btn"] forState:UIControlStateNormal];
//        [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
//        replyBtn.titleLabel.font=[UIFont systemFontOfSize:13];
//        [replyBtn setBackgroundImage:[UIImage imageNamed:@"reply_btn_h"] forState:UIControlStateHighlighted];
//        [self addSubview:replyBtn];
    }
    return self;
}
-(CGFloat)setContentlabelText:(NSString *)text
{
//    CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(230, MAXFLOAT)];
//    _contentlabel.frame=CGRectMake(55, 30, size.width,size.height);
//    _contentlabel.text=text;
//    _areaDatelabel.frame=CGRectMake(55, 40+size.height, 230, 10);
//    replyBtn.frame=CGRectMake(270, 30+size.height, 44, 30);
    
    CGSize contentSize = EA_MULTILINE_TEXTSIZE(text, _contentlabel.font, CGSizeMake(_contentlabel.frame.size.width, CGFLOAT_MAX), _contentlabel.lineBreakMode);
    
    _contentlabel.frame=CGRectMake(15, 45, contentSize.width,contentSize.height);
    _contentlabel.text=text;
    return ((contentSize.height + 50) >70 ?(contentSize.height + 50):70);
    
}
- (void)setContentlabel:(UILabel *)contentlabel
{
    CGSize contentSize = EA_MULTILINE_TEXTSIZE(contentlabel.text, contentlabel.font, CGSizeMake(contentlabel.frame.size.width, CGFLOAT_MAX), contentlabel.lineBreakMode);
    
    _contentlabel.frame=CGRectMake(15, 45, contentSize.width,contentSize.height + 5);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height-1, rect.size.width , 1));
}
@end
