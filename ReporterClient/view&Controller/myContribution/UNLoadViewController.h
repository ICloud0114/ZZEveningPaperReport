//
//  UNLoadViewController.h
//  ReporterClient
//
//  Created by smile on 14-4-24.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNLoadViewController : UIViewController
@property (nonatomic, strong)NSString *contents;
@property (nonatomic, strong)NSString *dateString;
@property (nonatomic, strong)NSString *newsTitle;
@property (nonatomic, strong)NSMutableArray *dataArray;
-(id)initWithGetNSDictionary:(NSDictionary*)Dictionary;
@end
