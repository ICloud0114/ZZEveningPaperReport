//
//  LinkMediaCell.h
//  ReporterClient
//
//  Created by smile on 14-4-16.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkMediaCell : UITableViewCell
{
    UIImageView *imgView;
   
}
@property (nonatomic, strong)UIButton *addVideoButton;
@property (nonatomic, strong)UIButton *addPhoteButton;
@property (nonatomic, copy) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *topLineImageView;
@property (nonatomic, strong) UIImageView *bottomLineImageView;
@end