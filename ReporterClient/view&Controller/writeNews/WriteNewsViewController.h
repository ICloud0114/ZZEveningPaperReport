//
//  WriteNewsViewController.h
//  ReporterClient
//
//  Created by easaa on 4/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditNewsView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface WriteNewsViewController : UIViewController
{
    UITextField *titleTextField;
    UITextView *contentTextView;
    UITableView *mediaTableView;
    EditNewsView *headView;
    
}
@property (nonatomic, strong)NSMutableArray *dataArray;

@property NSInteger stateTpye; //0 本地 1 采用
@property NSInteger selectIndex; //选中编辑的行数
@property NSInteger _sourceID;

-(id)initWithGetNSMutableArray:(NSMutableArray*)array StateType:(NSInteger)stateType;

@end
