//
//  SearchViewController.m
//  ReporterClient
//
//  Created by easaa on 4/14/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "SearchViewController.h"
#import "ClueDetailViewController.h"
#import "ContributionDetailViewController.h"
#import "LinkContributionViewController.h"
#import "UNLoadViewController.h"
#import "MJRefresh.h"
#import "LinkDetailCell.h"
@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource,MJRefreshBaseViewDelegate,UIAlertViewDelegate>
{
    CustomNavigation *myNavigationBar;
    UITableView *resultTableView;
    NSMutableArray *resultMutableArray;
    MJRefreshFooterView *footerView;
    MJRefreshHeaderView *headerView;
    NSInteger pageIndex;
    NSInteger pageSize;
    
    UITapGestureRecognizer *tapGesture;
    
    NSInteger unLoadCount;//未上传 计数
    NSMutableDictionary *unloadDictionary;
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        unLoadCount = 0;
        unloadDictionary = [NSMutableDictionary dictionary];
        
        historyMutableArray = [[NSMutableArray alloc]init];
        searchLocalMutableArray = [[NSMutableArray alloc]init];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:HISTORYSEARCH] isKindOfClass:[NSArray class]])
        {
            [historyMutableArray setArray:[[NSUserDefaults standardUserDefaults] objectForKey:HISTORYSEARCH]];
        }
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
//    [searchTextField becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    resultMutableArray  = [NSMutableArray array];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:BGCOLOR];
//    UIView *mainView = [[UIView alloc]init];
//    mainView.backgroundColor = BGCOLOR;
//    mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
//    [self.view addSubview:mainView];
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT + INCREMENT)];
    myNavigationBar.titleLabel.text = @"搜索";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT, SCREENWIDTH, 40 )];
    [self.view addSubview:headView];
    
    searchBarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 4, SCREENWIDTH - 70, 31)];
    [headView addSubview:searchBarImageView];
    
    [searchBarImageView setImage:[UIImage imageNamed:@"search_input_s"]];
    
    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 4, SCREENWIDTH - 120, 32)];
    searchTextField.font = [UIFont systemFontOfSize:12];
    searchTextField.placeholder = @"请输入关键字";
    [headView addSubview:searchTextField];
    
    [searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [searchTextField setClearsOnBeginEditing:YES];
    [searchTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [searchTextField setReturnKeyType:UIReturnKeySearch];
    [searchTextField setDelegate:self];
    
    cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 30 - 15, 1, 30, 38)];
    [headView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:LINKCLURCOLOR forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [cancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT + 40, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - INCREMENT) style:UITableViewStylePlain];
    [self.view addSubview:historyTableView];
    
    [historyTableView setDataSource:self];
    [historyTableView setDelegate:self];
    [historyTableView setBackgroundView:nil];
    [historyTableView setBackgroundColor:[UIColor clearColor]];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"  最近搜索";
    historyTableView.tableHeaderView = titleLabel;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    historyTableView.tableFooterView = footView;
    UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(109, 29, 101, 31)];
    [footView addSubview:clearButton];
    [clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"qingchu_btn"] forState:UIControlStateNormal];
    [clearButton setTitleColor:GRAY_COLOR_ZZ forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - INCREMENT) style:UITableViewStylePlain];
    resultTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:resultTableView];
    
    [resultTableView setDataSource:self];
    [resultTableView setDelegate:self];
//    [resultTableView setBackgroundView:nil];
//    [resultTableView setBackgroundColor:[UIColor clearColor]];
    resultTableView.hidden = YES;
    
    headerView = [MJRefreshHeaderView header];
    headerView.scrollView = resultTableView;
    resultTableView.tag = 10000;
    headerView.delegate = self;
    
    footerView = [MJRefreshFooterView footer];
    footerView.scrollView = resultTableView;
    footerView.tag = 20000;
    footerView.delegate = self;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        
        historyTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginSearch
{
//    if ([searchTextField.text isEqualToString:@""] || searchTextField.text == nil)
//    {
//        
//        NSLog(@"提示要输入关键字");
//        return;
//    }
    //记录历史搜索关键字
    NSInteger localIndex = -1;
    for (int i = 0; i < historyMutableArray.count ; i++)
    {
        if ([[historyMutableArray objectAtIndex:i] isEqualToString:searchTextField.text])
        {
            localIndex = i;
        }
    }
    if (localIndex > -1)//存在的话移到第一个
    {
        if (localIndex != 0)
        {
            [historyMutableArray exchangeObjectAtIndex:localIndex withObjectAtIndex:0];
        }
    }
    else//不存在插入第一个
    {
        [historyMutableArray addObject:searchTextField.text];
    }
    [[NSUserDefaults standardUserDefaults] setObject:historyMutableArray forKey:HISTORYSEARCH];
    
    [historyTableView reloadData];
    [self showSearchResultTableview];
}
- (void)showSearchResultTableview
{
    
    [self refreshView:headerView];
    resultTableView.hidden = NO;
}



- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [resultTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark 下拉刷新
- (void)refreshView:(MJRefreshBaseView *)refreshView
{
    pageIndex = 1;
    pageSize = 10;
    
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
        [NSNumber numberWithInt:pageSize],PAGESIZE,
        [NSNumber numberWithInt:pageIndex],PAGEINDEX,
        searchTextField.text,TITLE,
                                           nil];
    if (_searchType == 0)// 查看线索
    {
        [sendDictionary setObject:[NSNumber numberWithInt:0] forKey:SOURCETIME];
        NSLog(@"search all clue");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableDictionary *receiveDictionary = [EAHTTPRequest getSearchSourceList:sendDictionary];
            NSLog(@"刷新数据:%@", receiveDictionary);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [resultMutableArray removeAllObjects];
                
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    if (![[receiveDictionary objectForKey:@"total"]intValue])
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有找到您要的内容！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView setTag:404];
                        [alertView show];
                    }
                    else
                    {
                        NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                        [resultMutableArray addObjectsFromArray:tempArray];
                    }
                    
                }
                else
                {
                    NSString *string  = @"服务器无响应，请稍后重试";
                    if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                    {
                        
                        string = [receiveDictionary objectForKey:ERROR];
                        
                    }
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
                
                [self performSelector:@selector(doneWithView:) withObject:refreshView];
            });
        });
        
        
        
    }
    else if (_searchType == 1)//我的线索
    {
        NSLog(@"search my clue");
        [sendDictionary setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID] forKey:USERID];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
            NSMutableDictionary *receiveDictionary = [EAHTTPRequest getMysourceList:sendDictionary];
            NSLog(@"刷新数据:%@", receiveDictionary);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [resultMutableArray removeAllObjects];
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    if (![[receiveDictionary objectForKey:@"total"]intValue])
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有找到您要的内容！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView setTag:404];
                        [alertView show];
                    }
                    else
                    {
                        NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                        [resultMutableArray addObjectsFromArray:tempArray];
                    }
                    
                }
                else
                {
                    NSString *string  = @"服务器无响应，请稍后重试";
                    if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                    {
                        
                        string = [receiveDictionary objectForKey:ERROR];
                        
                    }
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
                [self performSelector:@selector(doneWithView:) withObject:refreshView];
            });
        });
       
        

    }
    else if (_searchType == 2)//我的稿件
        {
/////////////////////////////////////////////搜索本地稿件/////////////////////////////////////////////////////////////////////////
            NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID ]];
            NSFileManager *fm = [NSFileManager defaultManager];
            //找到文件，判断是不是存在
            NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                                  stringByAppendingPathComponent:plistfile];
            
            if ([fm fileExistsAtPath:fileName] )
            {
                NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:fileName];
                NSArray *news = [dicplist objectForKey:@"News"];
//                NSArray *photos = [dicplist objectForKey:@"Photos"];
//                NSArray *videos = [dicplist objectForKey:@"Videos"];
//                
//                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//                [tempArray addObject:news];
//                [tempArray addObject:photos];
//                [tempArray addObject:videos];
//                unLoadCount = [news count];
                [resultMutableArray setArray:news];
            }
            
            [searchLocalMutableArray removeAllObjects];
            if ([searchTextField.text  isEqualToString:@""] || searchTextField.text == nil)
            {
                [searchLocalMutableArray setArray:resultMutableArray];
            }
            else
            {
                NSInteger temp = 0;
                unLoadCount = 0;
                for (NSDictionary *dictionary in resultMutableArray)
                {
                    NSString *title = [dictionary objectForKey:@"Title"];
                    NSRange range = [title rangeOfString:searchTextField.text];
                    if (range.length > 0)
                    {
                        [searchLocalMutableArray addObject:dictionary];
                        [unloadDictionary setObject:[NSNumber numberWithInt:temp] forKey:[NSString stringWithFormat:@"%d",unLoadCount]];
                        
                        NSLog(@"begin================");
                        NSLog(@"%d",unLoadCount);
                        NSLog(@"%d",temp);
                        NSLog(@"end==================");
                        
                        unLoadCount ++;
                    }
                    ++ temp;
                }
            }
            
//////////////////////////////////////////////////////搜索本地稿件///////////////////////////////////////////////////////////////
            [sendDictionary setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID] forKey:@"uid"];
            [sendDictionary setObject:[NSNumber numberWithInt:0] forKey:STATE];
            NSLog(@"search my contribution");
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                
                NSMutableDictionary *receiveDictionary = [EAHTTPRequest getMaymanuscriptList:sendDictionary];
                NSLog(@"刷新数据:%@", receiveDictionary);
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
//                    [resultMutableArray removeAllObjects];
                    if ([[receiveDictionary objectForKey:DATA]isKindOfClass:[NSArray class]])
                    {
                        if (![[receiveDictionary objectForKey:@"total"]intValue])
                        {
                            if (!searchLocalMutableArray.count)
                            {
                                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有找到您要的内容！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                [alertView setTag:404];
                                [alertView show];
                            }
                            
                        }
                        else
                        {
                            NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
//                            [resultMutableArray addObjectsFromArray:tempArray];
                            if ([tempArray isKindOfClass:[NSArray class]])
                            {
                                [searchLocalMutableArray addObjectsFromArray:tempArray];
                                
                            }
                        }
                        
                    }
                    else
                    {
                        NSString *string  = @"服务器无响应，请稍后重试";
                        if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                        {
                            
                            string = [receiveDictionary objectForKey:ERROR];
                            
                        }
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView show];
                    }
                    [self performSelector:@selector(doneWithView:) withObject:refreshView];
                });
            });
           
            
            
        }
    else if (_searchType == 3)
    {
        [sendDictionary setObject:[NSNumber numberWithInt:0] forKey:SOURCETIME];
        [sendDictionary setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID] forKey:USERID];
        NSLog(@"search link clue");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableDictionary *receiveDictionary = [EAHTTPRequest getRelevancysourceList:sendDictionary];
            NSLog(@"刷新数据:%@", receiveDictionary);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [resultMutableArray removeAllObjects];
                
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    if (![[receiveDictionary objectForKey:@"total"]intValue])
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有找到您要的内容！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView setTag:404];
                        [alertView show];
                    }
                    else
                    {
                        NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                        [resultMutableArray addObjectsFromArray:tempArray];
                    }
                    
                }
                else
                {
                    NSString *string  = @"服务器无响应，请稍后重试";
                    if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                    {
                        
                        string = [receiveDictionary objectForKey:ERROR];
                        
                    }
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
                
                [self performSelector:@selector(doneWithView:) withObject:refreshView];
            });
        });

    }
}
#pragma mark 上拉加载
- (void)reLoadView:(MJRefreshBaseView *)refreshView
{
    pageIndex ++;
    
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:pageSize],PAGESIZE,
        [NSNumber numberWithInt:pageIndex],PAGEINDEX,
        searchTextField.text,TITLE,
                                           nil];
    if (_searchType == 0 )//查看线索
    {
        [sendDictionary setObject:[NSNumber numberWithInt:0] forKey:SOURCETIME];
        NSLog(@"search all clue");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableDictionary *receiveDictionary = [EAHTTPRequest getSearchSourceList:sendDictionary];
            NSLog(@"刷新数据:%@", receiveDictionary);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                    [resultMutableArray addObjectsFromArray:tempArray];
                    if (![[receiveDictionary objectForKey:@"total"]intValue])
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有更多内容了！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView show];
                    }
                    
                }
                else
                {
                    NSString *string  = @"服务器无响应，请稍后重试";
                    if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                    {
                        
                        string = [receiveDictionary objectForKey:ERROR];
                        
                    }
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
 
                [self performSelector:@selector(doneWithView:) withObject:refreshView];
            });
        });
        
        
        
    }
    else if (_searchType == 1)//我的线索
    {
        NSLog(@"search my clue");
        [sendDictionary setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID] forKey:USERID];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
            NSMutableDictionary *receiveDictionary = [EAHTTPRequest getMysourceList:sendDictionary];
            NSLog(@"刷新数据:%@", receiveDictionary);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                    [resultMutableArray addObjectsFromArray:tempArray];
                    if (![[receiveDictionary objectForKey:@"total"]intValue])
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有更多内容了！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView show];
                    }
                    
                }
                else
                {
                    NSString *string  = @"服务器无响应，请稍后重试";
                    if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                    {
                        
                        string = [receiveDictionary objectForKey:ERROR];
                        
                    }
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
                [self performSelector:@selector(doneWithView:) withObject:refreshView];
            });
        });
        
        
    }
    else if (_searchType == 2)//我的稿件
        {
            
            
            
            [sendDictionary setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID] forKey:@"uid"];
            [sendDictionary setObject:[NSNumber numberWithInt:0] forKey:STATE];
            NSLog(@"search my contribution");
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSMutableDictionary *receiveDictionary = [EAHTTPRequest getMaymanuscriptList:sendDictionary];
                NSLog(@"刷新数据:%@", receiveDictionary);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                    {
                        NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                        [searchLocalMutableArray addObjectsFromArray:tempArray];
                        if (![[receiveDictionary objectForKey:@"total"]intValue])
                        {
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有更多内容了！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alertView show];
                        }
                        
                    }
                    else
                    {
                        NSString *string  = @"服务器无响应，请稍后重试";
                        if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                        {
                            
                            string = [receiveDictionary objectForKey:ERROR];
                            
                        }
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView show];
                    }
                    [self performSelector:@selector(doneWithView:) withObject:refreshView];
                });
            });
            
            
        }
       else if (_searchType == 3)//关联列表、
       {
           [sendDictionary setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID] forKey:USERID];
           [sendDictionary setObject:[NSNumber numberWithInt:0] forKey:SOURCETIME];
           NSLog(@"search all clue");
           
           dispatch_async(dispatch_get_global_queue(0, 0), ^{
               
               NSMutableDictionary *receiveDictionary = [EAHTTPRequest getRelevancysourceList:sendDictionary];
               NSLog(@"刷新数据:%@", receiveDictionary);
               
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   
                   if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                   {
                       NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                       [resultMutableArray addObjectsFromArray:tempArray];
                       if (![[receiveDictionary objectForKey:@"total"]intValue])
                       {
                           UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有更多内容了！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                           [alertView show];
                       }
                       
                   }
                   else
                   {
                       NSString *string  = @"服务器无响应，请稍后重试";
                       if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                       {
                           
                           string = [receiveDictionary objectForKey:ERROR];
                           
                       }
                       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alertView show];
                   }
                   
                   [self performSelector:@selector(doneWithView:) withObject:refreshView];
               });
           });
       }

    
}
#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]])
    {
        
        [self refreshView:refreshView];
        
        
    }
    else if([refreshView isKindOfClass:[MJRefreshFooterView class]])
    {
        
        [self reLoadView:refreshView];
    }
    
}

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    [headerView free];
    [footerView free];
    
}
-(void)clearHistory
{
    [historyMutableArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:historyMutableArray forKey:HISTORYSEARCH];
    [historyTableView reloadData];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == historyTableView)
    {
        return historyMutableArray.count;
    }
    else if(tableView == resultTableView)
    {
        if (_searchType == 2)
        {
            
            NSLog(@"begin================");
            NSLog(@"searchLocal ====== %d", searchLocalMutableArray.count);
            NSLog(@"end==================");
            return searchLocalMutableArray.count;
        }
        else
        {
            return resultMutableArray.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == historyTableView)
    {
        static NSString *identify = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] ;
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            [cell.textLabel setTextColor:GRAY_COLOR_ZZ];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }

        cell.textLabel.text = [historyMutableArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    else if(tableView == resultTableView)
    {
        static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
        LinkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[LinkDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        if (_searchType == 0 || _searchType == 1 || _searchType == 3) {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            cell.titleLabel.text = [[resultMutableArray objectAtIndex:indexPath.row]objectForKey:TITLE];
            cell.contentLabel.text = [[resultMutableArray objectAtIndex:indexPath.row]objectForKey:ADDTIME];
            [ cell setMarkInteger:[resultMutableArray[indexPath.row][CONDITION] intValue]];
            
            
            //判内容是什么类型
            
            //图片1  视频0

            if (![[[resultMutableArray objectAtIndex:indexPath.row]objectForKey:VIDEO] isEqualToString:@""])
            {
                [cell isVideoView:YES];
            }
            if(![[[resultMutableArray objectAtIndex:indexPath.row]objectForKey:IMAGE] isEqualToString:@""])
            {
                [cell isImageView:YES];
            }

        }
       else if (_searchType == 2)
       {
           
           
           if (indexPath.row < unLoadCount)
           {
               cell.titleLabel.text = [[searchLocalMutableArray objectAtIndex:indexPath.row]objectForKey:@"Title"];
               cell.contentLabel.text = [[searchLocalMutableArray objectAtIndex:indexPath.row]objectForKey:@"dateString"];
               [ cell setClueType:0];
           }
           else
           {
               cell.titleLabel.text = [[searchLocalMutableArray objectAtIndex:indexPath.row]objectForKey:@"Title"];
               
               cell.contentLabel.text = [[searchLocalMutableArray objectAtIndex:indexPath.row]objectForKey:@"uploadingTime"];
               NSString *str = searchLocalMutableArray[indexPath.row][STATE];
               [ cell setClueType:[str intValue]];

               if ([[[searchLocalMutableArray objectAtIndex:indexPath.row]objectForKey:@"isvideo"] intValue] == 1)
               {
                   [cell isVideoView:YES];
               }
               if([[[ searchLocalMutableArray objectAtIndex:indexPath.row]objectForKey:@"isvideo"] intValue] == 1)
               {
                   [cell isImageView:YES];
               }

           }
           
       }
        
        return cell;
    }
    return 0;
}

#pragma mark UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (tableView == historyTableView)
    {
        if (!historyMutableArray.count)
        {
            tableView.tableFooterView.hidden = YES;
        }
        else
        {
            tableView.tableFooterView.hidden = NO;
        }

    }
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == historyTableView)
    {
        return 36;
    }
    else if(tableView == resultTableView)
    {
        return 55;
    }

    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == historyTableView)
    {
        searchTextField.text = [historyMutableArray objectAtIndex:indexPath.row];
        [self beginSearch];
    }
    else if(tableView == resultTableView)
    {
        if (_searchType == 0 )//所有线索
        {
            NSInteger makrType = 100;
            if (![[[resultMutableArray objectAtIndex:indexPath.row]objectForKey:VIDEO] isEqualToString:@""])
            {
                makrType = 0;
            }
            else if(![[[resultMutableArray objectAtIndex:indexPath.row]objectForKey:IMAGE] isEqualToString:@""])
            {
                makrType = 1;
            }
            
            NSInteger stateId = [resultMutableArray [indexPath.row][CONDITION] integerValue];
            //状态(0未采用，1抢占，2采用)
            ClueDetailViewController *clueDetail = [[ClueDetailViewController alloc]initWithType:1 State:stateId Mark:makrType];
            
            clueDetail.titleString = [[resultMutableArray objectAtIndex:indexPath.row]objectForKey:TITLE];
            clueDetail.dateString = [[resultMutableArray objectAtIndex:indexPath.row]objectForKey:ADDTIME];
            
            
            
            NSLog(@"%d",clueDetail.linkID);
            
            clueDetail.sourceID = [resultMutableArray[indexPath.row][SOURCEID] intValue];
            
            [self.navigationController pushViewController:clueDetail animated:YES];
        }
        else if(_searchType == 1)//我的线索
        {
            //图片1  视频0
            NSInteger makrType = 100;
            if (![[[resultMutableArray objectAtIndex:indexPath.row]objectForKey:VIDEO] isEqualToString:@""])
            {
                makrType = 0;
            }
            else if(![[[resultMutableArray objectAtIndex:indexPath.row]objectForKey:IMAGE] isEqualToString:@""])
            {
                makrType = 1;
            }
            NSInteger stateId = [resultMutableArray [indexPath.row][CONDITION] integerValue];
            //状态(0未采用，1抢占，2采用)
            if (stateId == 2)
            {
                LinkContributionViewController *linkContributionList = [[LinkContributionViewController alloc]init];
                linkContributionList.clueID = [resultMutableArray[indexPath.row][SOURCEID] intValue];
                [self.navigationController pushViewController:linkContributionList animated:YES];
            }
            else
            {
                ClueDetailViewController *clueDetail = [[ClueDetailViewController alloc]initWithType:2 State:stateId Mark:makrType];
                
                clueDetail.titleString = [[resultMutableArray objectAtIndex:indexPath.row]objectForKey:TITLE];
                clueDetail.dateString = [[resultMutableArray objectAtIndex:indexPath.row]objectForKey:ADDTIME];
                
                
                
                NSLog(@"%d",clueDetail.linkID);
                
                clueDetail.sourceID = [resultMutableArray[indexPath.row][SOURCEID] intValue];
                
                [self.navigationController pushViewController:clueDetail animated:YES];
            }
        }
        else if(_searchType == 2)//我的稿件详情
        {
            
            if (indexPath.row < unLoadCount)//未上传的稿件
            {
                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                //存到plist文件
                
                NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID]];
                NSFileManager *fm = [NSFileManager defaultManager];
                //找到文件，判断是不是存在
                NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                                      stringByAppendingPathComponent:plistfile];
                NSInteger whichOne = [[unloadDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]intValue];
                if ([fm fileExistsAtPath:fileName] )
                {
                    NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:fileName];
                    [dataArray addObject:[dicplist objectForKey:@"News"][whichOne]];
                    [dataArray addObject:[dicplist objectForKey:@"Photos"][whichOne]];
                    [dataArray addObject:[dicplist objectForKey:@"Videos"][whichOne]];
                }
                
                
                NSLog(@"%d",whichOne);
                NSLog(@"begin================");
                NSLog(@"%@", [unloadDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]);
                NSLog(@"end==================");
                NSDictionary *dataDictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 dataArray, @"data",
                                                 [NSString stringWithFormat:@"%d",whichOne],@"index",
                                                 nil];
                
                UNLoadViewController *unLoad = [[UNLoadViewController alloc] initWithGetNSDictionary:dataDictionary1];
                
                [self.navigationController pushViewController:unLoad animated:YES];
            }
            else//已上传，已审核，已发布
            {
                NSInteger markType = 100;
                if ([[[searchLocalMutableArray objectAtIndex:indexPath.row]objectForKey:@"isvideo"] intValue] == 1)
                {
                    markType = 1;
                }
                else if([[[searchLocalMutableArray objectAtIndex:indexPath.row]objectForKey:@"isimg"] intValue] == 1)
                {
                    markType = 0;
                }
                else
                {
                    markType = 100;
                }
                
                ContributionDetailViewController *contributionDetail = [[ContributionDetailViewController alloc]init];
                contributionDetail.manuscriptID = [searchLocalMutableArray[indexPath.row][@"manuscriptid"] intValue];
                NSInteger stateId = [searchLocalMutableArray[indexPath.row][STATE] integerValue];
                contributionDetail.stateID = stateId;
                contributionDetail.markID = markType;
                [self.navigationController pushViewController:contributionDetail animated:YES];
                
                
                NSLog(@"show contribution Detail");
            }
            
        }
        else if(_searchType == 3)//去关联线索详情
        {
            //判内容是什么类型
            NSInteger makrType = 100;
            if (![[resultMutableArray[indexPath.row] objectForKey:VIDEO] isEqualToString:@""])
            {
                makrType = 0;
            }
            
            else if(![[resultMutableArray[indexPath.row] objectForKey:IMAGE] isEqualToString:@""])
            {
                makrType = 1;
            }
            
            ClueDetailViewController *clueDetail = [[ClueDetailViewController alloc] initWithType:0 State:[[resultMutableArray[indexPath.row] objectForKey:CONDITION] intValue] Mark:makrType];
            clueDetail.titleString = [resultMutableArray[indexPath.row] objectForKey:TITLE];
            clueDetail.dateString = [resultMutableArray[indexPath.row] objectForKey:ADDTIME];
            clueDetail.sourceID = [[resultMutableArray[indexPath.row] objectForKey:SOURCEID] integerValue];
            
            [self.navigationController pushViewController:clueDetail animated:YES];
        }
        
    }
}


- (void)hiddenKeyboard
{
    [self.view endEditing:YES];
}
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    resultTableView.hidden = YES;
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.view removeGestureRecognizer:tapGesture];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self beginSearch];
    return YES;
}
#pragma mark alertDelegate
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag)
    {
        case 404:
        {
            if (buttonIndex == 0)
            {
                [searchTextField becomeFirstResponder];
            }
            else
            {
               
            }
            
        }
            break;
            
        default:
            break;
    }
    
}
@end
