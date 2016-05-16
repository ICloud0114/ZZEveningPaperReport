//
//  SearchViewController.h
//  ReporterClient
//
//  Created by easaa on 4/14/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SearchResultViewController.h"
@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIImageView *searchBackgroundImageView;
    UIImageView *searchBarImageView;
    UITextField *searchTextField;
    UIButton *cancelButton;
    UIButton *historyButton;
    UIImageView *searchTypeImageView;
    
    
    UITableView *historyTableView;
    NSMutableArray *historyMutableArray;
    UIView *showContentView;
    
    UIButton *backButton;
    NSMutableArray *searchLocalMutableArray;
    
}

//@property (nonatomic,strong)UINavigationController *navigationController_ZZ;
//@property (nonatomic,strong)SearchResultViewController *searchResultViewController;

@property (nonatomic, assign)NSInteger searchType; //0 搜索全部线索， 1 搜索我的线索 2 搜索我的稿件, 3 从关联线索里面搜索
@end
