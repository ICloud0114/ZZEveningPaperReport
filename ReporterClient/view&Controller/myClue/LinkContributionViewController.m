//
//  LinkContributionViewController.m
//  ReporterClient
//
//  Created by easaa on 4/30/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "LinkContributionViewController.h"
#import "ContributionDetailViewController.h"
#import "LinkDetailCell.h"
@interface LinkContributionViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    CustomNavigation *myNavigationBar;
    UITableView *myTableView;
    NSMutableArray *listMutableArray;
}
@end

@implementation LinkContributionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:BGCOLOR];
    listMutableArray = [NSMutableArray array];
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
//    myNavigationBar.titleLabel.text = @"我的线索";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT, SCREENWIDTH  ,SCREENHEIGHT - NAVHEIGHT - INCREMENT)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundView = nil;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    [self.view addSubview:myTableView];
    
    
   [NSThread detachNewThreadSelector:@selector(getLinkContribution) toTarget:self withObject:nil];//获取关联稿件
    
}

- (void)getLinkContribution
{
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           
                                           [NSNumber numberWithInt:_clueID],@"clueId",
                                           nil];
    NSLog(@"%@",sendDictionary);
    
    NSMutableDictionary *receiveDictionary = [EAHTTPRequest getRelevancymanuscriptList:sendDictionary];
    
    NSLog(@"%@",receiveDictionary);
    [self performSelectorOnMainThread:@selector(checkReceiveData:) withObject:receiveDictionary waitUntilDone:YES];
    
}
- (void)checkReceiveData:(NSMutableDictionary *)receiveDictionary
{
    if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
    {
        if ([[receiveDictionary objectForKey:TOTAL] intValue] > 0)
        {
            NSArray *tempArray =  [receiveDictionary objectForKey:DATA];
            [listMutableArray addObjectsFromArray:tempArray];
            [myTableView reloadData];
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
        return 1;
    }
//    return listMutableArray.count;
    
    
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
    cell.titleLabel.text = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"Title"];
    cell.contentLabel.text = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"uploadingTime"];
    //状态
    [ cell setMarkInteger:[listMutableArray[0][STATE] intValue] + 1];
    //判内容是什么类型
    
    // 0 视频  1 图片

    if ([[[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"isvideo"] intValue])
    {
        [cell isVideoView:YES];
    }
    else
    {
        [cell isVideoView:NO];
    }
    if([[[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"isimg"] intValue])
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
    
    //1 视频  0 图片
    NSInteger markType = 100;
    if ([[[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"isvideo"] intValue])
    {
        markType = 1;
    }
    else if([[[listMutableArray objectAtIndex:indexPath.row]objectForKey:@"isimg"] intValue])
    {
        markType = 0;
    }
    
    NSInteger stateId = [listMutableArray [0][STATE] integerValue];
    //状态(0未采用，1抢占，2采用)
    ContributionDetailViewController *contributionDetail = [[ContributionDetailViewController alloc]init];
    
//    contributionDetail.titleString = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:TITLE];
//    contributionDetail.dateString = [[listMutableArray objectAtIndex:indexPath.row]objectForKey:ADDTIME];
//    
//    
//    
//    NSLog(@"%d",contributionDetail.linkID);
    
    contributionDetail.stateID = stateId;
    contributionDetail.markID = markType;
    contributionDetail.manuscriptID = [listMutableArray[indexPath.row][@"manuscriptid"] intValue];
    
    [self.navigationController pushViewController:contributionDetail animated:YES];
    
    
}
@end
