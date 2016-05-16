//
//  MyContributionViewController.m
//  ReporterClient
//
//  Created by easaa on 4/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "MyContributionViewController.h"
#import "LinkDetailCell.h"
#import "SearchViewController.h"
#import "MJRefresh.h"
#import "UNLoadViewController.h"
#import "ContributionDetailViewController.h"
//#import "MBProgressHUD.h"
@interface MyContributionViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,MJRefreshBaseViewDelegate>
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
    NSString *reporterId;
    
    //    NSString *fileName;//文件名字
    NSMutableDictionary *tempDictionary;//用来存headView的tag 判断是否第一次刷新
    //    MBProgressHUD *HUD;
    NSInteger unLoadCount;
}
@end

@implementation MyContributionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        pageIndex = 1;
        pageSize = 10;
        listMutableArray = [[NSMutableArray alloc]init];
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        reporterId = [[userDefaultes objectForKey:USER_INFO_DICTIONARY] objectForKey:USERID];
        NSLog(@"%@",reporterId);
        
        // 刷新 未上传
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDateUI" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDateUI:) name:@"reloadDateUI" object:nil];
        
    }
    return self;
}
- (void)dealloc
{
    for (MJRefreshHeaderView *header in headerViewArray) {
        [header free];
    }
    for (MJRefreshFooterView *footer in footerViewArray) {
        [footer free];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)reloadDateUI:(NSNotification*)info
{
    [self refreshView:headerViewArray[0] AndTag:@"10000"];
    [self refreshView:headerViewArray[1] AndTag:@"10001"];
    [self refreshView:headerViewArray[2] AndTag:@"10002"];
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
    buttonArray = [NSMutableArray array];
    tableViewArray = [NSMutableArray array];
    headerViewArray = [NSMutableArray array];
    footerViewArray = [NSMutableArray array];
    dataDictionary = [NSMutableDictionary dictionary];
    tempDictionary = [NSMutableDictionary dictionary];
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
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    myNavigationBar.titleLabel.text = @"我的稿件";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    NSArray *textArray=@[@"全部",@"未上传",@"已上传",@"已审核",@"已发布"];
    buttonArray=[NSMutableArray array];
    
    for (int i = 0; i < 5 ; i ++)
    {
        selectButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH / 5 * i, NAVHEIGHT + INCREMENT, SCREENWIDTH / 5, 38)];
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
        if (i < 4)
        {
            UIImageView *singleLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
            [singleLine setFrame:CGRectMake(SCREENWIDTH / 5 * (i + 1) - 1, NAVHEIGHT + INCREMENT, 2, 37)];
            [self.view addSubview:singleLine];
        }
        
    }
    
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT + 38 , SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - INCREMENT - 38)] ;
    myScrollView.clipsToBounds = YES;
    myScrollView.pagingEnabled = YES;
    myScrollView.bounces = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    for (int count = 0 ; count < 5; ++count)
    {
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(myScrollView.frame.size.width * count, 0, myScrollView.frame.size.width  ,myScrollView.frame.size.height) style:UITableViewStylePlain];
        myTableView.tag = count + 1000;
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.backgroundColor = [UIColor clearColor];
        [myScrollView addSubview:myTableView];
        if (count == 0)
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
    }
    
    myScrollView.contentSize = CGSizeMake(SCREENWIDTH * 5, 0);
    
    [headerViewArray[0] beginRefreshing];
    [tempDictionary removeObjectForKey:@"0"];
    
    //小菊花
    //    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //    [self.view addSubview:HUD];
    //    HUD.labelText = @"Loading";
}



- (void)getAllContribution:(MJRefreshBaseView *)refreshView
{
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:pageSize],PAGESIZE,
                                           [NSNumber numberWithInt:pageIndex],PAGEINDEX,
                                           [NSNumber numberWithInt:0],STATE,
                                           [[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID],@"uid",nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
        NSFileManager *fm = [NSFileManager defaultManager];
        //找到文件，判断是不是存在
        NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent:plistfile];
        NSMutableArray *localArray = [[NSMutableArray alloc] init];
        
        if ([fm fileExistsAtPath:fileName] )
        {
            NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:fileName];
            NSArray *news = [dicplist objectForKey:@"News"];
            NSArray *photos = [dicplist objectForKey:@"Photos"];
            NSArray *videos = [dicplist objectForKey:@"Videos"];
            
            
            [localArray addObject:news];
            [localArray addObject:photos];
            [localArray addObject:videos];
            //            unLoadCount = 0;
            unLoadCount = [localArray[0] count];
            
        }
        else
        {
            unLoadCount = 0;
        }
        NSMutableDictionary *receiveDictionary = [EAHTTPRequest getMaymanuscriptList:sendDictionary];
        NSLog(@"刷新数据:%@", receiveDictionary);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
            {
                if ([[receiveDictionary objectForKey:DATA] count] > 0)
                {
                    
                    NSArray *tempArray = [receiveDictionary objectForKey:DATA];
                    
                    if (unLoadCount == 0)
                    {
                        if (pageIndex == 1)
                        {
                            //
                            [dataDictionary setObject:tempArray forKey:@"0"];
                        }
                        else
                        {
                            NSMutableArray *keyWordMutableArray = [[NSMutableArray alloc] init];
                            [keyWordMutableArray addObjectsFromArray:[dataDictionary objectForKey:@"0"]];
                            
                            [keyWordMutableArray addObjectsFromArray:tempArray];
                            [dataDictionary setObject:keyWordMutableArray forKey:@"0"];
                        }
                        
                    }
                    else
                    {
                        if (pageIndex == 1)
                        {
                            [dataDictionary setObject:localArray forKey:@"0"];
                        }
                        
                        [[dataDictionary objectForKey:@"0"][0] addObjectsFromArray:tempArray];
                    }
                    
                }
                else
                {
                    if (unLoadCount)
                    {
                        [dataDictionary setObject:localArray forKey:@"0"];
                    }
                    else
                    {
                        
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

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    //    [HUD hide:YES];
    // 刷新表格
    for (UITableView *tb in tableViewArray)
    {
        if (tb.tag - 1000 == refreshView.tag - 10000  ||tb.tag - 1000 == refreshView.tag - 20000)
        {
            
            [tb reloadData];
            if (refreshView.tag >= 20000)
            {
                [tb scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
            NSLog(@"刷新tableView ");
            NSLog(@"%d",tb.tag);
        }
    }
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark 下拉刷新
- (void)refreshView:(MJRefreshBaseView *)refreshView AndTag:(NSString *)tag
{
    NSLog(@"mainThread:%@,  currentThread: %@",[NSThread mainThread], [NSThread currentThread]);
    //    [HUD show:YES];
    pageIndex = 1;
    
    int temp = [tag intValue] - 10000;
    NSString *keyword = [NSString stringWithFormat:@"%d",temp];
    if (temp == 1)
    {
        //存到plist文件
        NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
        NSFileManager *fm = [NSFileManager defaultManager];
        //找到文件，判断是不是存在
        NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent:plistfile];
        if ([fm fileExistsAtPath:fileName] )
        {
            NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:fileName];
            NSArray *news = [dicplist objectForKey:@"News"];
            NSArray *photos = [dicplist objectForKey:@"Photos"];
            NSArray *videos = [dicplist objectForKey:@"Videos"];
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:news];
            [tempArray addObject:photos];
            [tempArray addObject:videos];
            
            //            [dataDictionary removeAllObjects];
            [dataDictionary setObject:tempArray forKey:tag];
        }
        [self performSelector:@selector(doneWithView:) withObject:refreshView];
    }
    
    else if(temp == 0)
    {
        [self performSelector:@selector(getAllContribution:) withObject:refreshView];
        
    }
    else
    {
        NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:pageSize],PAGESIZE,
                                               [NSNumber numberWithInt:pageIndex],PAGEINDEX,
                                               [NSNumber numberWithInt:temp],STATE,
                                               [[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID],@"uid",nil];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableDictionary *receiveDictionary = [EAHTTPRequest getMaymanuscriptList:sendDictionary];
            NSLog(@"刷新数据:%@", receiveDictionary);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    if ([[receiveDictionary objectForKey:DATA] count] > 0)
                    {
                        NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                        //                [listMutableArray removeAllObjects];
                        //                [listMutableArray addObjectsFromArray:tempArray];
                        
                        [dataDictionary removeObjectForKey:keyword];
                        [dataDictionary setObject:[NSMutableArray arrayWithArray:tempArray] forKey:keyword];
                    }
                    //            else
                    //            {
                    //                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"暂时没有数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    //                [alertView show];
                    //            }
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
- (void)reLoadView:(MJRefreshBaseView *)refreshView AndTag:(NSString *)tag
{
    ++ pageIndex;
    int temp = [tag intValue] - 20000;
    NSString *keyword = [NSString stringWithFormat:@"%d",temp];
    if (temp == 1)
    {
        //存到plist文件
        NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
        NSFileManager *fm = [NSFileManager defaultManager];
        //找到文件，判断是不是存在
        NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent:plistfile];
        if ([fm fileExistsAtPath:fileName] )
        {
            NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:fileName];
            //            [listMutableArray setArray:[dicplist objectForKey:@"News"]];
            //            NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:fileName];
            NSArray *news = [dicplist objectForKey:@"News"];
            NSArray *photos = [dicplist objectForKey:@"Photos"];
            NSArray *videos = [dicplist objectForKey:@"Videos"];
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:news];
            [tempArray addObject:photos];
            [tempArray addObject:videos];
            
            //            [dataDictionary removeAllObjects];
            [dataDictionary setObject:tempArray forKey:tag];
            
            
        }
        [self performSelector:@selector(doneWithView:) withObject:refreshView];
    }
    
    else if(temp == 0)
    {
        [self performSelector:@selector(getAllContribution:) withObject:refreshView];
    }
    else
    {
        NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:pageSize],PAGESIZE,
                                               [NSNumber numberWithInt:pageIndex],PAGEINDEX,
                                               [NSNumber numberWithInt:temp],STATE,
                                               [[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID],@"uid",nil];
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSMutableDictionary *receiveDictionary = [EAHTTPRequest getMaymanuscriptList:sendDictionary];
            NSLog(@"刷新数据:%@", receiveDictionary);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    if ([[receiveDictionary objectForKey:DATA] count] > 0)
                    {
                        NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                        //                [listMutableArray addObjectsFromArray:tempArray];
                        NSMutableArray *keyWordMutableArray = [dataDictionary objectForKey:keyword];
                        [keyWordMutableArray addObjectsFromArray:tempArray];
                        [dataDictionary setObject:keyWordMutableArray forKey:keyword];
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
        
        [self refreshView:refreshView AndTag:[NSString stringWithFormat:@"%d",refreshView.tag]];
    }
    else if([refreshView isKindOfClass:[MJRefreshFooterView class]])
    {
        [self reLoadView:refreshView AndTag:[NSString stringWithFormat:@"%d",refreshView.tag]];
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
/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */

- (void)showSearchView:(id)sender
{
    SearchViewController *searchView = [[SearchViewController alloc]init];
    searchView.searchType = 2;
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)onButtonClicked:(UIButton *)sender
{
    for (int i=0; i < 5; i++)
    {
        if(i == sender.tag)
        {
            [buttonArray[i] setSelected:YES];
            if ([tempDictionary objectForKey:[NSString stringWithFormat:@"%d",i]])
            {
                [tempDictionary removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
                [headerViewArray[i] beginRefreshing];
                //                [self refreshViewBeginRefreshing:headerViewArray[i]];
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
    
    NSString *keyword = [NSString stringWithFormat:@"%d",tableView.tag  - 1000];
    NSArray *tempArray = nil;
    if ([keyword isEqualToString:@"1" ])
    {
        tempArray = [dataDictionary objectForKey:@"10001"][0];
    }
    else if([keyword isEqualToString:@"0"])
    {
        if (unLoadCount == 0)
        {
            tempArray = [dataDictionary objectForKey:@"0"];
        }
        else
        {
            tempArray = [dataDictionary objectForKey:keyword][0];
            NSLog(@"tempArray =========%d",tempArray.count);
        }
        
    }
    else
    {
        tempArray = [dataDictionary objectForKey:keyword];
    }
    NSLog(@"%@:%i", keyword, tempArray.count);
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
    
    NSString *keyword = [NSString stringWithFormat:@"%d",tableView.tag - 1000];
    switch (tableView.tag - 1000)
    {
        case 0:
        {
            
            if (unLoadCount == 0)
            {
                cell.titleLabel.text = [[[dataDictionary objectForKey:keyword] objectAtIndex:indexPath.row]objectForKey:@"Title"];
                
                cell.contentLabel.text = [[[dataDictionary objectForKey:keyword] objectAtIndex:indexPath.row] objectForKey:@"uploadingTime"];
                NSString *str = [dataDictionary objectForKey:keyword] [indexPath.row][STATE];
                [ cell setClueType:[str intValue]];

                if ([[[[dataDictionary objectForKey:keyword] objectAtIndex:indexPath.row] objectForKey:@"isvideo"] intValue] == 1)
                {
                    [cell isVideoView:YES];
                }
                else
                {
                    [cell isVideoView:NO];
                }
                if([[[[dataDictionary objectForKey:keyword] objectAtIndex:indexPath.row]objectForKey:@"isimg"] intValue] == 1)
                {
                    [cell isImageView:YES];
                }
                else
                {
                    [cell isImageView:NO];
                }

            }
            
            else if (indexPath.row < unLoadCount)
            {
                NSMutableArray *tempArray = [dataDictionary objectForKey:keyword];
                cell.titleLabel.text = [[[dataDictionary objectForKey:keyword][0] objectAtIndex:indexPath.row] objectForKey:@"Title"];
                
                cell.contentLabel.text = [[[dataDictionary objectForKey:keyword][0] objectAtIndex:indexPath.row]objectForKey:@"dateString"];
                [ cell setClueType:0];
                //判内容是什么类型

                NSLog(@"%d",[tempArray[2] count]);
                NSLog(@"%d",[tempArray[2][indexPath.row] count]);
                
                if ([tempArray[2][indexPath.row] count] != 0)
                {
                    [cell isVideoView:YES];
                }
                else
                {
                    [cell isVideoView:NO];
                }
                if([tempArray[1][indexPath.row] count] != 0)
                {
                    [cell isImageView:YES];
                }
                else
                {
                    [cell isImageView:NO];
                }
                

            }
            else
            {
                cell.titleLabel.text = [[[dataDictionary objectForKey:keyword][0] objectAtIndex:indexPath.row]objectForKey:@"Title"];
                
                cell.contentLabel.text = [[[dataDictionary objectForKey:keyword][0] objectAtIndex:indexPath.row] objectForKey:@"uploadingTime"];
                NSString *str = [dataDictionary objectForKey:keyword][0] [indexPath.row][STATE];
                [ cell setClueType:[str intValue]];

                if ([[[[dataDictionary objectForKey:keyword][0] objectAtIndex:indexPath.row] objectForKey:@"isvideo"] intValue] == 1)
                {
                    [cell isVideoView:YES];
                }
                else
                {
                    [cell isVideoView:NO];
                }
                if([[[[dataDictionary objectForKey:keyword][0] objectAtIndex:indexPath.row]objectForKey:@"isimg"] intValue] == 1)
                {
                    [cell isImageView:YES];
                }
                else
                {
                    [cell isImageView:NO];
                }

            }
            
        }
            break;
        case 1:
        {
            NSMutableArray *tempArray = [dataDictionary objectForKey:@"10001"];
            cell.titleLabel.text = [[[dataDictionary objectForKey:@"10001"][0] objectAtIndex:indexPath.row] objectForKey:@"Title"];
            
            cell.contentLabel.text = [[[dataDictionary objectForKey:@"10001"][0] objectAtIndex:indexPath.row]objectForKey:@"dateString"];
            //判内容是什么类型

            NSLog(@"%d",[tempArray[2] count]);
            NSLog(@"%d",[tempArray[2][indexPath.row] count]);
            
            if ([tempArray[2][indexPath.row] count] != 0)
            {
                [cell isVideoView:YES];
            }
            else
            {
                [cell isVideoView:NO];
            }
            if([tempArray[1][indexPath.row] count] != 0)
            {
                [cell isImageView:YES];
            }
            else
            {
                [cell isImageView:NO];
            }
            

            
        }
            break;
        default:
        {
            NSLog(@">>>>>%@",[NSThread currentThread]);
            cell.titleLabel.text = [[[dataDictionary objectForKey:keyword]objectAtIndex:indexPath.row]objectForKey:@"Title"];
            
            cell.contentLabel.text = [[[dataDictionary objectForKey:keyword]objectAtIndex:indexPath.row]objectForKey:@"uploadingTime"];
            NSString *str = [dataDictionary objectForKey:keyword][indexPath.row][STATE];
            [ cell setClueType:[str intValue]];

            if ([[[[dataDictionary objectForKey:keyword]objectAtIndex:indexPath.row]objectForKey:@"isvideo"] intValue] == 1)
            {
                [cell isVideoView:YES];
            }
            else
            {
                [cell isVideoView:NO];
            }
            if([[[[dataDictionary objectForKey:keyword]objectAtIndex:indexPath.row]objectForKey:@"isimg"] intValue] == 1)
            {
                [cell isImageView:YES];
            }
            else
            {
                [cell isImageView:NO];
            }

        }
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (tableView.tag - 1000)
    {
            
        case 0:
        {
            
            if (unLoadCount == 0)
            {
                NSString *keyword = [NSString stringWithFormat:@"%d",tableView.tag - 1000];
                //
                NSInteger markType = 100;
                if ([[[[dataDictionary objectForKey:keyword] objectAtIndex:indexPath.row]objectForKey:@"isvideo"] intValue] == 1)
                {
                    markType = 1;
                }
                else if([[[[dataDictionary objectForKey:keyword] objectAtIndex:indexPath.row]objectForKey:@"isimg"] intValue] == 1)
                {
                    markType = 0;
                }
                else
                {
                    markType = 100;
                }
                ContributionDetailViewController *contributionDetail = [[ContributionDetailViewController alloc]init];
                contributionDetail.manuscriptID = [[dataDictionary objectForKey:keyword][indexPath.row][@"manuscriptid"] intValue];
                NSInteger stateId = [[dataDictionary objectForKey:keyword][indexPath.row][STATE] integerValue];
                contributionDetail.stateID = stateId;
                contributionDetail.markID = markType;
                [self.navigationController pushViewController:contributionDetail animated:YES];
            }
            else if (indexPath.row < unLoadCount)
            {
                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                //存到plist文件
                NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
                NSFileManager *fm = [NSFileManager defaultManager];
                //找到文件，判断是不是存在
                NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                                      stringByAppendingPathComponent:plistfile];
                if ([fm fileExistsAtPath:fileName] )
                {
                    NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:fileName];
                    [dataArray addObject:[dicplist objectForKey:@"News"][indexPath.row]];
                    [dataArray addObject:[dicplist objectForKey:@"Photos"][indexPath.row]];
                    [dataArray addObject:[dicplist objectForKey:@"Videos"][indexPath.row]];
                }
                
                NSDictionary *dataDictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 dataArray, @"data",
                                                 [NSNumber numberWithInteger:indexPath.row],@"index",
                                                 nil];
                
                UNLoadViewController *unLoad = [[UNLoadViewController alloc] initWithGetNSDictionary:dataDictionary1];
                
                [self.navigationController pushViewController:unLoad animated:YES];
            }
            else
            {
                NSString *keyword = [NSString stringWithFormat:@"%d",tableView.tag - 1000];
                //
                NSInteger markType = 100;
                if ([[[[dataDictionary objectForKey:keyword][0] objectAtIndex:indexPath.row]objectForKey:@"isvideo"] intValue] == 1)
                {
                    markType = 1;
                }
                else if([[[[dataDictionary objectForKey:keyword][0] objectAtIndex:indexPath.row]objectForKey:@"isimg"] intValue] == 1)
                {
                    markType = 0;
                }
                else
                {
                    markType = 100;
                }
                ContributionDetailViewController *contributionDetail = [[ContributionDetailViewController alloc]init];
                contributionDetail.manuscriptID = [[dataDictionary objectForKey:keyword][0][indexPath.row][@"manuscriptid"] intValue];
                NSInteger stateId = [[dataDictionary objectForKey:keyword][0][indexPath.row][STATE] integerValue];
                contributionDetail.stateID = stateId;
                contributionDetail.markID = markType;
                [self.navigationController pushViewController:contributionDetail animated:YES];
                
            }
        }
            break;
        case 1:
        {
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            //存到plist文件
            NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
            NSFileManager *fm = [NSFileManager defaultManager];
            //找到文件，判断是不是存在
            NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                                  stringByAppendingPathComponent:plistfile];
            if ([fm fileExistsAtPath:fileName] )
            {
                NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:fileName];
                [dataArray addObject:[dicplist objectForKey:@"News"][indexPath.row]];
                [dataArray addObject:[dicplist objectForKey:@"Photos"][indexPath.row]];
                [dataArray addObject:[dicplist objectForKey:@"Videos"][indexPath.row]];
            }
            
            NSDictionary *dataDictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             dataArray, @"data",
                                             [NSNumber numberWithInteger:indexPath.row],@"index",
                                             nil];
            
            UNLoadViewController *unLoad = [[UNLoadViewController alloc] initWithGetNSDictionary:dataDictionary1];
            
            [self.navigationController pushViewController:unLoad animated:YES];
        }
            break;
        default:
        {
            NSString *keyword = [NSString stringWithFormat:@"%d",tableView.tag - 1000];
            //
            NSInteger markType = 100;
            if ([[[[dataDictionary objectForKey:keyword]objectAtIndex:indexPath.row]objectForKey:@"isvideo"] intValue] == 1)
            {
                markType = 1;
            }
            else if([[[[dataDictionary objectForKey:keyword]objectAtIndex:indexPath.row]objectForKey:@"isimg"] intValue] == 1)
            {
                markType = 0;
            }
            else
            {
                markType = 100;
            }
            //抢占、采用
            //            NSInteger stateId = [[dataDictionary objectForKey:keyword][indexPath.row][STATE] integerValue];
            //            ClueDetailViewController *clueDetail = [[ClueDetailViewController alloc]initWithType:1 State:stateId Mark:makrType];
            //
            //            clueDetail.titleString = [[[dataDictionary objectForKey:keyword]objectAtIndex:indexPath.row]objectForKey:TITLE];
            //            clueDetail.dateString = [[[dataDictionary objectForKey:keyword]objectAtIndex:indexPath.row]objectForKey:@"uploadingTime"];
            //
            //
            //
            //            NSLog(@"%d",clueDetail.linkID);
            //
            //            clueDetail.sourceID = [[dataDictionary objectForKey:keyword][indexPath.row][@"manuscriptid"] intValue];
            //
            //            [self.navigationController pushViewController:clueDetail animated:YES];
            ContributionDetailViewController *contributionDetail = [[ContributionDetailViewController alloc]init];
            //            contributionDetail.manuscriptID = [listMutableArray[indexPath.row][@"manuscriptid"] intValue];
            contributionDetail.manuscriptID = [[dataDictionary objectForKey:keyword][indexPath.row][@"manuscriptid"] intValue];
            NSInteger stateId = [[dataDictionary objectForKey:keyword][indexPath.row][STATE] integerValue];
            contributionDetail.stateID = stateId;
            contributionDetail.markID = markType;
            [self.navigationController pushViewController:contributionDetail animated:YES];
        }
            break;
            
    }
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
            //            [self refreshViewBeginRefreshing:headerViewArray[temp]];
            [headerViewArray[temp] beginRefreshing];
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
