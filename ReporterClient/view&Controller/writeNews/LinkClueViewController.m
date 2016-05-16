//
//  LinkClueViewController.m
//  ReporterClient
//
//  Created by easaa on 4/14/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "LinkClueViewController.h"
#import "ClueDetailViewController.h"
#import "SearchViewController.h"
#import "LinkDetailCell.h"
#import "MJRefresh.h"
//#import "MBProgressHUD.h"
@interface LinkClueViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@end

@implementation LinkClueViewController
{
    MJRefreshFooterView *footerView;
    MJRefreshHeaderView *headerView;
    
    CustomNavigation *myNavigation;
    UITableView *mediaTableView;
    UISearchBar *searchVeiw;
    NSMutableArray *linkNewsMutableArray;
    NSInteger pageSize;
    NSInteger pageIndex;
    
    NSMutableArray *dataArray;
    
    
    NSMutableDictionary *receiveDictionary;
    
    NSString *reporterId;
    
//    MBProgressHUD *HUD;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        pageIndex = 1;
        pageSize = 10;
        linkNewsMutableArray = [[NSMutableArray alloc] init];
        receiveDictionary = [[NSMutableDictionary alloc] init];
        dataArray = [[NSMutableArray alloc] init];
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        reporterId = [[userDefaultes objectForKey:USER_INFO_DICTIONARY] objectForKey:USERID];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
    myNavigation = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT + INCREMENT)];
    myNavigation.titleLabel.text = @"关联线索";
    [myNavigation.leftButton addTarget:self action:@selector(backLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [myNavigation.leftButton setHidden:NO];
    [self.view addSubview:myNavigation];

    
    mediaTableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0,
                                 myNavigation.frame.origin.y +
                                 myNavigation.frame.size.height,
                                 SCREENWIDTH,
                                 self.view.frame.size.height -
                                 myNavigation.frame.size.height-
                                 myNavigation.frame.origin.y)
                                 style:UITableViewStylePlain];
    
    mediaTableView.showsVerticalScrollIndicator = NO;
    [mediaTableView setDataSource:self];
    [mediaTableView setDelegate:self];
    [mediaTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mediaTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mediaTableView];

    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
    [lineImageView setImage:[UIImage imageNamed:@"line"]];
    [searchView addSubview:lineImageView];
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH - 290)/2, 4, 290, 31)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search_button_290"] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search_button_290"] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(showSearchView:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchButton];
    mediaTableView.tableHeaderView = searchView;
    
//    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
//                                           [NSNumber numberWithInt:pageSize],PAGESIZE,
//                                           [NSNumber numberWithInt:pageIndex],PAGEINDEX,
//                                                                                    nil];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//    
//        [receiveDictionary setDictionary:[EAHTTPRequest getSearchSourceList:sendDictionary]];
//       dispatch_async(dispatch_get_main_queue(), ^{
//           if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
//           {
//               [linkNewsMutableArray setArray:[receiveDictionary objectForKey:DATA]];
//           }
//           else
//           {
//               NSString *string  = @"服务器无响应，请稍后重试";
//               if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
//               {
//                   
//                   string = [receiveDictionary objectForKey:ERROR];
//                   
//                   
//               }
//               UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//               [alertView show];
//           }
//           
//           NSLog(@"返回数据--%@",receiveDictionary);
//       });
//    });
    
    
    headerView = [MJRefreshHeaderView header];
    headerView.scrollView = mediaTableView;
    headerView.delegate = self;
    
    
    footerView = [MJRefreshFooterView footer];
    footerView.scrollView = mediaTableView;
    footerView.delegate = self;
    
    [headerView beginRefreshing];
    
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = @"Loading";

}
- (void)dealloc
{
    [headerView free];
    [footerView free];
}
#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == headerView)
    {
//        [HUD show:YES];
        
        pageIndex = 1;
        NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                               [NSNumber numberWithInt:pageSize],PAGESIZE,
                                               [NSNumber numberWithInt:pageIndex],PAGEINDEX,
                                               reporterId,USERID,
                                               [NSNumber numberWithInt:0],@"SourceTime",
                                               nil];
        
        dispatch_async(dispatch_get_global_queue(0, 0),
            ^{
            
           [receiveDictionary setDictionary:[EAHTTPRequest getRelevancysourceList:sendDictionary]];
            
            dispatch_async(dispatch_get_main_queue(),
                    ^{
                
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    [linkNewsMutableArray  setArray: [receiveDictionary objectForKey:DATA]];
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
                
            });
        });

    }
    else
    {
        pageIndex++;
        NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                               [NSNumber numberWithInt:pageSize],PAGESIZE,
                                               [NSNumber numberWithInt:pageIndex],PAGEINDEX,
                                               reporterId,USERID,
                                               [NSNumber numberWithInt:0],@"SourceTime",
                                               nil];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
           [receiveDictionary setDictionary:[EAHTTPRequest getRelevancysourceList:sendDictionary]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    [linkNewsMutableArray addObjectsFromArray:[receiveDictionary objectForKey:DATA]];
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
                
            });
        });
        
        
    }
    
    [self performSelector:@selector(refersh) withObject:self afterDelay:0.5];
    
}
-(void)refersh
{
//    [HUD hide:YES];
    [headerView endRefreshing];
    [footerView endRefreshing];
    [mediaTableView reloadData];
}
- (void)showSearchView:(id)sender
{
    SearchViewController *searchView = [[SearchViewController alloc]init];
    searchView.searchType = 3;
    [self.navigationController pushViewController:searchView animated:YES];
}
-(void)backLastViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return linkNewsMutableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    LinkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell = [[LinkDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titleLabel.text = [[linkNewsMutableArray objectAtIndex:indexPath.row] objectForKey:TITLE];
    
    cell.contentLabel.text = [[linkNewsMutableArray objectAtIndex:indexPath.row] objectForKey:ADDTIME];
    
    [cell setMarkInteger:[[linkNewsMutableArray[indexPath.row] objectForKey:CONDITION] intValue]];
    NSLog(@"%d",[[linkNewsMutableArray[indexPath.row] objectForKey:CONDITION] intValue]);
    
    //判内容是什么类型

    if (![[linkNewsMutableArray[indexPath.row] objectForKey:VIDEO] isEqualToString:@""])
    {
        [cell isVideoView:YES];
    }
    else
    {
        [cell isVideoView:NO];
    }
    if(![[linkNewsMutableArray[indexPath.row] objectForKey:IMAGE] isEqualToString:@""])
    {
        [cell isImageView:YES];
    }
    else
    {
        [cell isImageView:NO];
    }

    
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //判内容是什么类型
    NSInteger makrType = 100;
    if (![[linkNewsMutableArray[indexPath.row] objectForKey:VIDEO] isEqualToString:@""])
    {
        makrType = 0;
    }
    
    else if(![[linkNewsMutableArray[indexPath.row] objectForKey:IMAGE] isEqualToString:@""])
    {
        makrType = 1;
    }
    
    ClueDetailViewController *clueDetail = [[ClueDetailViewController alloc] initWithType:0 State:[[linkNewsMutableArray[indexPath.row] objectForKey:CONDITION] intValue] Mark:makrType];
    clueDetail.titleString = [linkNewsMutableArray[indexPath.row] objectForKey:TITLE];
    clueDetail.dateString = [linkNewsMutableArray[indexPath.row] objectForKey:ADDTIME];
    clueDetail.sourceID = [[linkNewsMutableArray[indexPath.row] objectForKey:SOURCEID] integerValue];
    
    [self.navigationController pushViewController:clueDetail animated:YES];
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
