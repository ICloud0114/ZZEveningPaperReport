//
//  LinkClueCell.h
//  ReporterClient
//
//  Created by smile on 14-4-15.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkClueCell : UITableViewCell
{
    UIImageView *mediaTypeIconImageView;
    
}
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIButton *deleteButton;
@property (nonatomic, strong)UIImageView *backgroundImageView;
@end
