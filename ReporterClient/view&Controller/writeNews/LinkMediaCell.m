//
//  LinkMediaCell.m
//  ReporterClient
//
//  Created by smile on 14-4-16.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "LinkMediaCell.h"

@implementation LinkMediaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _topLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, SCREENWIDTH - 10, 1)];
        [_topLineImageView setImage:[UIImage imageNamed:@"line"]];
        [self addSubview:_topLineImageView];

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTheme:(UITapGestureRecognizer*)tap
{
    NSLog(@"-----");
}
@end
