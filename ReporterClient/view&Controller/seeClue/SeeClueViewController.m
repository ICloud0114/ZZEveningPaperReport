//
//  SeeClueViewController.m
//  ReporterClient
//
//  Created by easaa on 4/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "SeeClueViewController.h"
#import "LinkDetailCell.h"
#import "ClueDetailViewController.h"
#import "SearchViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
//#import "MBProgressHUD.h"
@interface SeeClueViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MJRefreshBaseViewDelegate>
{
    CustomNavigation *myNavigationBar;
    UITableView *myTableView;
    UIScrollView *myScrollView;
    UIButton *selectButton;
    NSMutableArray *buttonArray;
    NSInteger pageIndex;
    NSInteger pageSize;
    NSMutableArray *tableViewArray;
    NSMutableArray *headerViewArray;
    NSMutableArray *footerViewArray;
    MJRefreshFooterView *footerView;
    MJRefreshHeaderView *headerView;
    NSMutableDictionary *dataDictionary;
    
    NSMutableArray *listMutableArray;
    
    NSMutableDictionary *tempDictionary;//用来存headView的tag
//    MBProgressHUD *HUD;
    
    NSInteger myTableViewTag;
}
@end

@implementation SeeClueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        pageIndex = 1;
        pageSize = 10;
        listMutableArray  = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMyTableView) name:@"reloadSeeClueData" object:nil];
    }
    return self;
}

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    for (MJRefreshHeaderView *header in headerViewArray)
    {
        [header free];
    }
    for (MJRefreshFooterView *footer in footerViewArray)
    {
        [footer free];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)reloadMyTableView
{
    [self refreshView:headerView AndTag:myTableView.tag];
//    [headerViewArray[2] beginRefreshing];//刷新全部线索
    if (myTableViewTag- 1000 != myTableView.tag - 10000)
    {
        [self refreshView:headerViewArray[myTableViewTag - 1000] AndTag:myTableViewTag + 9000];
//        [headerViewArray[myTableViewTag - 1000] beginRefreshing];//刷新对应线索

    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    buttonArray = [NSMutableArray array];
    tableViewArray = [NSMutableArray array];
    headerViewArray = [NSMutableArray array];
    footerViewArray = [NSMutableArray array];
    dataDictionary = [NSMutableDictionary dictionary];
    tempDictionary = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:BGCOLOR];
//    UIView *mainView = [[UIView alloc]init];
//    mainView.backgroundColor = BGCOLOR;
//
//    
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
//    {
//        mainView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height -20);
//    }
//    else
//    {
//        mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
//    }
//    [self.view addSubview:mainView];
    
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    myNavigationBar.titleLabel.text = @"查看线索";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];

    NSArray *textArray=@[@"今日线索",@"昨日线索",@"全部线索"];

   
    for (int i = 0; i < 3 ; i ++)
    {
        if (i < 2)
        {
            UIImageView *singleLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
            [singleLine setFrame:CGRectMake(SCREENWIDTH /3 * (i + 1) + i, myNavigationBar.frame.size.height, 1, 38)];
            [self.view addSubview:singleLine];
        }
        selectButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH /3 + 1) * i, myNavigationBar.frame.size.height, SCREENWIDTH /3, 38)];
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [selectButton setBackgroundImage:[UIImage imageNamed:@"top_bg"] forState:UIControlStateNormal];
        [selectButton setBackgroundImage:[UIImage imageNamed:@"top_btn_after"] forState:UIControlStateSelected];
        selectButton.tag = i;
        [selectButton setTitle:textArray[i] forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchDown];
        if (i == 0)
        {
            selectButton.selected = YES;
        }
        [self.view addSubview:selectButton];
        [buttonArray addObject:selectButton];

    }
    

    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT + 38, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - INCREMENT - 38)] ;
//    myScrollView.backgroundColor = [UIColor redColor];
    myScrollView.clipsToBounds = YES;
    myScrollView.pagingEnabled = YES;
    myScrollView.bounces = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    for (int count = 0 ; count < 3; ++count)
    {
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(myScrollView.frame.size.width * count, 0, myScrollView.frame.size.width  ,myScrollView.frame.size.height) style:UITableViewStylePlain];
        myTableView.tag = count + 1000;
        
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.backgroundColor = [UIColor clearColor];
        [myScrollView addSubview:myTableView];
        if (count == 2)
        {
            UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
            
            UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
            [lineImageView setImage:[UIImage imageNamed:@"line"]];
            [searchView addSubview:lineImageView];
            UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH - 290)/2, 4, 290, 31)];
            [searchButton setBackgroundImage:[UIImage imageNamed:@"search_button_290"] forState:UIControlStateNormal];
            [searchButton addTarget:self action:@selector(showSearchView:) forControlEvents:UIControlEventTouchUpInside];
            [searchView addSubview:searchButton];
            myTableView.tableHeaderView = searchView;
        }
        [tableViewArray addObject:myTableView];
        
        headerView = [MJRefreshHeaderView header];
        headerView.scrollView = myTableView;
        headerView.tag = 10000 + count;
        headerView.delegate = self;
        [headerViewArray addObject:headerView];
        
        footerView = [MJRefreshFooterView footer];
        footerView.scrollView = myTableView;
        footerView.tag = 20000  + count;
        footerView.delegate = self;
        [footerViewArray addObject:footerView];
        
        [tempDictionary setObject:@"1" forKey:[NSString stringWithFormat:@"%d",count]];
        [tempDictionary removeObjectForKey:@"0"];
    }
    myScrollView.contentSize = CGSizeMake(SCREENWIDTH * 3, 0);
    //第一次刷新
    
    [headerViewArray[0] beginRefreshing];
    
//    [self refreshViewBeginRefreshing:headerViewArray[0]];
    
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = @"Loading";
}


- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    
//    [HUD hide:YES];
    // 刷新表格
    for (UITableView *tb in tableViewArray) {
        if (tb.tag - 1000 == refreshView.tag - 10000  ||tb.tag - 1000 == refreshView.tag - 20000)
        {
//            [(UITableView*)tableViewArray[tb.tag - 1000] reloadData];
            [tb reloadData];
            NSLog(@"刷新tableView ");
            NSLog(@"%d",tb.tag);
        }
    }
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark 下拉刷新
- (void)refreshView:(MJRefreshBaseView *)refreshView AndTag:(NSInteger)tag
{
//    [HUD show:YES];
    pageIndex = 1;
    int temp = tag - 9999 ;
    if (temp == 3)
    {
        temp = 0;
    }
    NSString *keyNumber = [NSString stringWithFormat:@"%d",temp];
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:pageSize],PAGESIZE,
        [NSNumber numberWithInt:pageIndex],PAGEINDEX,
        [NSNumber numberWithInt:temp],SOURCETIME,
                                    nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        NSMutableDictionary *receiveDictionary = [EAHTTPRequest getSearchSourceList:sendDictionary];
        NSLog(@"刷新数据:%@", receiveDictionary);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
            {
                if ([[receiveDictionary objectForKey:TOTAL] intValue] > 0)
                {
                    NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                    [listMutableArray removeAllObjects];
                    [listMutableArray addObjectsFromArray:tempArray];
                    
                    [dataDictionary removeObjectForKey:keyNumber];
                    [dataDictionary setObject:tempArray forKey:keyNumber];
                }
                //        else
                //        {
                //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"暂时没有数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                //            [alertView show];
                //        }
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
#pragma mark 上拉加载
- (void)reLoadView:(MJRefreshBaseView *)refreshView AndTag:(NSInteger)tag
{
    ++ pageIndex;
    int temp = tag - 19999;
    if (temp == 3)
    {
        temp = 0;
    }
    NSString *keyNumber = [NSString stringWithFormat:@"%d",temp];
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:pageSize],PAGESIZE,
         [NSNumber numberWithInt:pageIndex],PAGEINDEX,
         [NSNumber numberWithInt:temp],SOURCETIME,
                                           nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableDictionary *receiveDictionary = [EAHTTPRequest getSearchSourceList:sendDictionary];
        NSLog(@"刷新数据:%@", receiveDictionary);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
            {
                if ([[receiveDictionary objectForKey:TOTAL] intValue] > 0)
                {
                    NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                    [listMutableArray addObjectsFromArray:tempArray];
                    [dataDictionary setObject:listMutableArray forKey:keyNumber];
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
#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{

        if ([refreshView isKindOfClass:[MJRefreshHeaderView class]])
        {

            [self refreshView:refreshView AndTag:refreshView.tag];


        }
        else if([refreshView isKindOfClass:[MJRefreshFooterView class]])
        {

            [self reLoadView:refreshView AndTag:refreshView.tag];
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

- (void)showSearchView:(id)sender
{
    SearchViewController *searchView = [[SearchViewController alloc]init];
    searchView.searchType = 0;
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)onButtonClicked:(UIButton *)sender
{
    for (int i=0; i<3; i++)
    {
        if(i == sender.tag)
        {
            [buttonArray[i] setSelected:YES];
            if ([tempDictionary objectForKey:[NSString stringWithFormat:@"%d",i]])
            {
                [tempDictionary removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
//                [self refreshViewBeginRefreshing:headerViewArray[i]];
                [headerViewArray[i] beginRefreshing];
            }
            [myScrollView setContentOffset:CGPointMake(SCREENWIDTH * i, 0) animated:NO];
        }
        else
        {
            [buttonArray[i] setSelected:NO];
        }
    }
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSString *keyNumber = [NSString stringWithFormat:@"%d",tableView.tag - 999];
    if (tableView.tag - 999 == 3)
    {
        keyNumber = @"0";
    }
    
    NSArray *tempArray = [dataDictionary objectForKey:keyNumber];
            
    return tempArray.count;

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
    static NSString *SimpleTableIdentifier = @"firstTableView";
    LinkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[LinkDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    NSString *keyNumber = [NSString stringWithFormat:@"%d",tableView.tag - 999];
    if (tableView.tag - 999 == 3)
    {
        keyNumber = @"0";
    }
    cell.titleLabel.text = [[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:TITLE];
    cell.contentLabel.text = [[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:ADDTIME];
    if ([[dataDictionary objectForKey:keyNumber][indexPath.row][CONDITION] intValue] == 1 ||
        [[dataDictionary objectForKey:keyNumber][indexPath.row][CONDITION] intValue] == 2)
    {
        [ cell setMarkInteger:[[dataDictionary objectForKey:keyNumber][indexPath.row][CONDITION] intValue]];
    }
    else
    {
        [cell setMarkInteger:0];
    }
    //判内容是什么类型
    
    NSLog(@"begin================");
    NSLog(@"video = %@",[[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:VIDEO] );
    NSLog(@"image = %@",[[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:IMAGE] );
    NSLog(@"end==================");
    //图片1  视频0
 
    if ([[[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:VIDEO] isEqualToString:@""])
    {
        [cell isVideoView:NO];
    }
    else
    {

        [cell isVideoView:YES];
    }
    if([[[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:IMAGE] isEqualToString:@""])
    {
  
        [cell isImageView:NO];
    }
    else
    {
        [cell isImageView:YES];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    myTableViewTag = tableView.tag;
    NSString *keyNumber = [NSString stringWithFormat:@"%d",tableView.tag - 999];
    if (tableView.tag - 999 == 3)
    {
        keyNumber = @"0";
    }
    
    //图片1  视频0 
    NSInteger makrType = 100;
    if (![[[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:VIDEO] isEqualToString:@""])
    {
        makrType = 0;
    }
    else if(![[[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:IMAGE] isEqualToString:@""])
    {
        makrType = 1;
    }
    //抢占、采用
    NSInteger stateId = [[dataDictionary objectForKey:keyNumber][indexPath.row][CONDITION] integerValue];
    ClueDetailViewController *clueDetail = [[ClueDetailViewController alloc]initWithType:1 State:stateId Mark:makrType];
    
    clueDetail.titleString = [[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:TITLE];
    clueDetail.dateString = [[[dataDictionary objectForKey:keyNumber]objectAtIndex:indexPath.row]objectForKey:ADDTIME];
   
    NSLog(@"%d",clueDetail.linkID);
    
    clueDetail.sourceID = [[dataDictionary objectForKey:keyNumber][indexPath.row][SOURCEID] intValue];
    
    [self.navigationController pushViewController:clueDetail animated:YES];
}
#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == myScrollView)
    {
        for (UIButton *btn in buttonArray)
        {
            btn.selected = NO;
        }
        int temp = scrollView.contentOffset.x / SCREENWIDTH;
        [buttonArray[temp] setSelected:YES];
        
            if ([tempDictionary objectForKey:[NSString stringWithFormat:@"%d",temp]])
            {
                [tempDictionary removeObjectForKey:[NSString stringWithFormat:@"%d",temp]];
                [headerViewArray[temp] beginRefreshing];
//                [self refreshViewBeginRefreshing:headerViewArray[temp]];
            }
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
