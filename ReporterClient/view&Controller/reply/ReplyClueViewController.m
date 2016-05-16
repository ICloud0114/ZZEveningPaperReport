//
//  ReplyClueViewController.m
//  ReporterClient
//
//  Created by easaa on 4/14/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "ReplyClueViewController.h"
#import "ReplyView.h"
#import "ReplyCell.h"
#import "MJRefresh.h"
//#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
@interface ReplyClueViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,MJRefreshBaseViewDelegate>
{
    CustomNavigation *myNavigationBar;
    UITableView *myTableView;
    ReplyView *myReplyView;
    
    NSInteger pageIndex;
    NSInteger pageSize;
    NSMutableArray *listMutableArray;
    
    MJRefreshFooterView *footerView;
    MJRefreshHeaderView *headerView;
//    MBProgressHUD *HUD;
}

@end

@implementation ReplyClueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        listMutableArray = [NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //第一次刷新
    [self refreshView:headerView];
    [myTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
	// Do any additional setup after loading the view.
//    mainView = [[UIView alloc]init];
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
    myNavigationBar.titleLabel.text = @"回复";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT, SCREENWIDTH,SCREENHEIGHT - NAVHEIGHT - INCREMENT - 40)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:myTableView];
    
    headerView = [MJRefreshHeaderView header];
    headerView.scrollView = myTableView;
    headerView.delegate = self;
    footerView = [MJRefreshFooterView footer];
    footerView.scrollView = myTableView;
    footerView.delegate = self;
    
    myReplyView = [[ReplyView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - 49, SCREENWIDTH, 49)];
    myReplyView.replyTextField.delegate = self;
    [myReplyView.sendButton addTarget:self action:@selector(sendReply:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myReplyView];
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = @"Loading";
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    
//    [HUD hide:YES];
    // 刷新表格
    [myTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark 下拉刷新
- (void)refreshView:(MJRefreshBaseView *)refreshView
{
//    [HUD show:YES];
    pageIndex = 1;
    pageSize = 10;
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           [NSNumber numberWithInt:pageSize],PAGESIZE,
                                           [NSNumber numberWithInt:pageIndex],PAGEINDEX,
                                           [NSNumber numberWithInt:_sourceID],SOURCEID,
                                           nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        NSMutableDictionary *receiveDictionary = [EAHTTPRequest getSourceReply:sendDictionary];
        NSLog(@"刷新数据10002:%@", receiveDictionary);

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
            {
                if ([[receiveDictionary objectForKey:TOTAL] intValue]  > 0)
                {
                    NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
                    [listMutableArray removeAllObjects];
                    [listMutableArray addObjectsFromArray:tempArray];
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
#pragma mark 上拉加载
- (void)reLoadView:(MJRefreshBaseView *)refreshView
{
    

    ++ pageIndex;
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           [NSNumber numberWithInt:pageSize],PAGESIZE,
                                           [NSNumber numberWithInt:pageIndex],PAGEINDEX,
                                           [NSNumber numberWithInt:_sourceID],SOURCEID,
                                           nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableDictionary *receiveDictionary = [EAHTTPRequest getSourceReply:sendDictionary];
        NSLog(@"刷新数据20000:%@", receiveDictionary);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
            {
                if ([[receiveDictionary objectForKey:TOTAL] intValue] - listMutableArray.count > 0)
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
            [self performSelector:@selector(doneWithView:) withObject:refreshView ];
            
        });
    });
    

    
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
/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJCollectionViewController--dealloc---");
    [headerView free];
    [footerView free];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


- (void)sendReply:(id)sender
{
    
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
    [NSNumber numberWithInt:_sourceID],SOURCEID,
    [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID],USERID,
    [[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_DICTIONARY]objectForKey:REALNAME],@"username",
    myReplyView.replyTextField.text,COMMENT,nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        NSMutableDictionary *receiveDictionary = [EAHTTPRequest setSourceReply:sendDictionary];
        NSLog(@"加载数据:%@", receiveDictionary);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self refreshView:headerView];
            myReplyView.replyTextField.text = @"";
            [self.view endEditing:YES];
  
        });
    });
    
    
}

- (void)onTapGesture:(id)sender
{
    [self.view endEditing:YES];
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
    return listMutableArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 70;
    ReplyCell *cell =[[ReplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"simpleTableIdentifier"];
   CGFloat height = [cell setContentlabelText:[[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"replycontent"]];

//    NSLog(@"%d   %f",indexPath.row, height);
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[ReplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.positionsLabel.text = @"记者";


    
    if ([[[listMutableArray objectAtIndex:indexPath.row]objectForKey:PORTRAIT] isEqualToString:@""])
    {
        cell.headImage.image = [UIImage imageNamed:@"pl_photo"];
    }
    else
    {
        NSString *imageURL = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:PORTRAIT];
        
        [cell.headImage setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"pl_photo"]];
    }


//    cell.contentlabel.text = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"replycontent"];
    [cell setContentlabelText:[[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"replycontent"]];
    
    cell.areaDatelabel.text = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"replytime"];
    cell.userlabel.text = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"replyusername"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [clearColorView setHidden:NO];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendReply:nil];
    return YES;
}

#pragma mark keyboardNotification
-(void)keyboardShow:(NSNotification *)senderNotification
{
    [UIView animateWithDuration:2 animations:^
     {
         [myReplyView setFrame:CGRectMake(myReplyView.frame.origin.x, SCREENHEIGHT - [[[senderNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height - myReplyView.frame.size.height, myReplyView.frame.size.width, myReplyView.frame.size.height)];
     }
     ];
}

-(void)keyboardHide:(NSNotification *)senderNotification
{
    [UIView animateWithDuration:0.2 animations:^
     {
         [myReplyView setFrame:CGRectMake(myReplyView.frame.origin.x, SCREENHEIGHT - myReplyView.frame.size.height, myReplyView.frame.size.width, myReplyView.frame.size.height)];
     }
     ];
}

-(void)keyboardChange:(NSNotification *)senderNotification
{
    [UIView animateWithDuration:0.2 animations:^
     {
         [myReplyView setFrame:CGRectMake(myReplyView.frame.origin.x, SCREENHEIGHT - [[[senderNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height - myReplyView.frame.size.height, myReplyView.frame.size.width, myReplyView.frame.size.height)];
     }
     ];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
