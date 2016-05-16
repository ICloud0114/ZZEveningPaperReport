//
//  MyClueViewController.m
//  ReporterClient
//
//  Created by easaa on 4/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "MyClueViewController.h"
#import "LinkDetailCell.h"
#import "SearchViewController.h"
#import "MJRefresh.h"
#import "ClueDetailViewController.h"
#import "LinkContributionViewController.h"
//#import "MBProgressHUD.h"
@interface MyClueViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    CustomNavigation *myNavigationBar;
    UITableView *myTableView;
    
    NSInteger pageIndex;
    NSInteger pageSize;
    NSMutableArray *listMutableArray;
    
    MJRefreshFooterView *footerView;
    MJRefreshHeaderView *headerView;
    
//    MBProgressHUD *HUD;
    dispatch_queue_t _serialQueue;
}
@end

@implementation MyClueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        listMutableArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMyTableView) name:@"reloadMyClueData" object:nil];
        _serialQueue = dispatch_queue_create("com.MyClueViewController.zz", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"MJCollectionViewController--dealloc---");
    /**
     为了保证内部不泄露，在dealloc中释放占用的内存
     */
    [headerView free];
    [footerView free];
}

- (void)reloadMyTableView
{
    [self refreshView:headerView];

}

-(void)viewWillAppear:(BOOL)animated
{
    

}

- (void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:BGCOLOR];
//    UIView *mainView = [[UIView alloc]init];
//    mainView.backgroundColor = BGCOLOR;
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
//        mainView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height -20);
//    }
//    else
//    {
//        mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
//    }
//    [self.view addSubview:mainView];
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT + INCREMENT)];
    myNavigationBar.titleLabel.text = @"我的线索";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT, SCREENWIDTH  ,SCREENHEIGHT - INCREMENT - NAVHEIGHT)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundView = nil;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    [self.view addSubview:myTableView];
    
    headerView = [MJRefreshHeaderView header];
    headerView.scrollView = myTableView;
    headerView.delegate = self;
    footerView = [MJRefreshFooterView footer];
    footerView.scrollView = myTableView;
    footerView.delegate = self;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
    [lineImageView setImage:[UIImage imageNamed:@"line"]];
    [searchView addSubview:lineImageView];
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH - 290)/2, 4, 290, 31)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search_button_290"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(showSearchView:) forControlEvents:UIControlEventTouchUpInside];
    
    [searchView addSubview:searchButton];
    
    myTableView.tableHeaderView = searchView;
    

//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = @"Loading";
    [headerView beginRefreshing];
//    [self refreshView:headerView];
//    [myTableView reloadData];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSearchView:(id)sender
{
    SearchViewController *searchView = [[SearchViewController alloc]init];
    searchView.searchType = 1;
    [self.navigationController pushViewController:searchView animated:YES];
}


- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    

//    [HUD hide:YES];
    // 刷新表格
    [myTableView reloadData];
    
//    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark 下拉刷新
- (void)refreshView:(MJRefreshBaseView *)refreshView
{
   // @synchronized(myTableView)
  //  {
    
    //    [HUD show:YES];
        
        
        dispatch_async(_serialQueue, ^{
            pageIndex = 1;
            pageSize = 10;
            NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                   [NSNumber numberWithInt:pageSize],PAGESIZE,
                                                   [NSNumber numberWithInt:pageIndex],PAGEINDEX,
                                                   [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID],USERID,
                                                   nil];

    NSMutableDictionary *receiveDictionary = [EAHTTPRequest getMysourceList:sendDictionary];
    NSLog(@"刷新数据10000:%@", receiveDictionary);

            dispatch_async(dispatch_get_main_queue(), ^{
                [listMutableArray removeAllObjects];
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    if ([[receiveDictionary objectForKey:TOTAL] intValue] > 0)
                    {
                        
                        NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                        [listMutableArray addObjectsFromArray:tempArray];
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
                [self doneWithView:refreshView];
            });
        });
    
       // [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
//    }
}
#pragma mark 上拉加载
- (void)reLoadView:(MJRefreshBaseView *)refreshView
{
   // @synchronized(myTableView)
   // {
        dispatch_async(_serialQueue, ^{
            ++ pageIndex;
            
            NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                   [NSNumber numberWithInt:pageSize],PAGESIZE,
                                                   [NSNumber numberWithInt:pageIndex],PAGEINDEX,
                                                   [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID],USERID,
                                                   nil];
            NSMutableDictionary *receiveDictionary = [EAHTTPRequest getMysourceList:sendDictionary];
            NSLog(@"刷新数据20000:%@", receiveDictionary);
            
           
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    if ([[receiveDictionary objectForKey:TOTAL] intValue] > 0)
                    {
                        NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                        [listMutableArray addObjectsFromArray:tempArray];
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
                [self doneWithView:refreshView];
            });

        });
        
        
      //  [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
  //  }
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

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{

    NSLog(@"%@----刷新完毕", refreshView.class);
}

#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateNormal:
            NSLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
}


#pragma mark UITableViewDelegate,UITableViewDataSource
//有多少段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//每段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!listMutableArray.count)
    {
        return 0;   

    }
    else
    {
        return listMutableArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    LinkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[LinkDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:TITLE];
    cell.contentLabel.text = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:ADDTIME];
    //状态
     [ cell setMarkInteger:[listMutableArray[indexPath.row][CONDITION] intValue]];
    //判内容是什么类型
    
    //图片1  视频0

    if (![[[listMutableArray objectAtIndex:indexPath.row]objectForKey:VIDEO] isEqualToString:@""])
    {
        [cell isVideoView:YES];
    }
    else
    {
        [cell isVideoView:NO];
    }
    if(![[[listMutableArray objectAtIndex:indexPath.row]objectForKey:IMAGE] isEqualToString:@""])
    {
        [cell isImageView:YES];
    }
    else
    {
        [cell isImageView:NO];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //图片1  视频0
    NSInteger makrType = 100;
    if (![[[listMutableArray objectAtIndex:indexPath.row]objectForKey:VIDEO] isEqualToString:@""])
    {
        makrType = 0;
    }
    else if(![[[listMutableArray objectAtIndex:indexPath.row]objectForKey:IMAGE] isEqualToString:@""])
    {
        makrType = 1;
    }
    NSInteger stateId = [listMutableArray [indexPath.row][CONDITION] integerValue];
    //状态(0未采用，1抢占，2采用)
    
    if (stateId == 2)
    {
        LinkContributionViewController *linkContributionList = [[LinkContributionViewController alloc]init];
        linkContributionList.clueID = [listMutableArray[indexPath.row][SOURCEID] intValue];
        [self.navigationController pushViewController:linkContributionList animated:YES];
    }
    else
    {
        ClueDetailViewController *clueDetail = [[ClueDetailViewController alloc]initWithType:2 State:stateId Mark:makrType];
        
        clueDetail.titleString = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:TITLE];
        clueDetail.dateString = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:ADDTIME];
        
        
        
        NSLog(@"%d",clueDetail.linkID);
        
        clueDetail.sourceID = [listMutableArray[indexPath.row][SOURCEID] intValue];
        
        [self.navigationController pushViewController:clueDetail animated:YES];
    }
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
