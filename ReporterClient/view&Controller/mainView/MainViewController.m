//
//  MainViewController.m
//  ReporterClient
//
//  Created by easaa on 4/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "MainViewController.h"

#import "WriteNewsViewController.h"
#import "SeeClueViewController.h"
#import "MyContributionViewController.h"
#import "MyClueViewController.h"
#import "SettingViewController.h"

#import "UIImageView+WebCache.h"

#import "LinkDetailCell.h"
#import "ClueDetailViewController.h"

#import "AccountInfoViewController.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;

}
//@property (weak, nonatomic) IBOutlet UIImageView *headPicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *headPicture;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


- (IBAction)setting:(id)sender;
- (IBAction)writeNews:(id)sender;
- (IBAction)seeClue:(id)sender;
- (IBAction)myContribution:(id)sender;
- (IBAction)myClue:(id)sender;
//- (IBAction)mailBox:(id)sender;
//- (IBAction)fellowList:(id)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadHeadPicture) name:@"reloadAccount" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{

}
- (void)reloadHeadPicture
{
    [self.headPicture setImageWithURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:@"portrait"]] placeholderImage:[UIImage imageNamed:@"user_pic_default"]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
//    self.userName.text = [self.dataDictionary objectForKey:@"userName"];
    [self.view setBackgroundColor:BGCOLOR];
    self.userName.text = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:@"realname"];
    self.departmentLabel.text = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:@"department"];
    self.positionLabel.text = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:@"groupname"];
    
    self.headPicture.layer.cornerRadius = 33;
    self.headPicture.layer.borderWidth = 0;
    self.headPicture.layer.borderColor = [UIColor clearColor].CGColor;
    self.headPicture.layer.masksToBounds = YES;
    
    [self.headPicture setImageWithURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:@"portrait"]] placeholderImage:[UIImage imageNamed:@"user_pic_default"]];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self getClueData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getClueData
{
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:10],PAGESIZE,
                                           [NSNumber numberWithInt:1],PAGEINDEX,
                                           [NSNumber numberWithInt:0],SOURCETIME,
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
                    [dataArray addObjectsFromArray:tempArray];
//                    [dataDictionary setObject:listMutableArray forKey:keyNumber];
                    [self.myTableView reloadData];
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
        });
    });
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
    
    return dataArray.count;
    
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
    
//    NSString *keyNumber = [NSString stringWithFormat:@"%d",tableView.tag - 999];
//    if (tableView.tag - 999 == 3)
//    {
//        keyNumber = @"0";
//    }
    cell.titleLabel.text = [[dataArray objectAtIndex:indexPath.row]objectForKey:TITLE];
    cell.contentLabel.text = [[dataArray objectAtIndex:indexPath.row]objectForKey:ADDTIME];
    if ([dataArray [indexPath.row][CONDITION] intValue] == 1 ||
        [dataArray [indexPath.row][CONDITION] intValue] == 2)
    {
        [ cell setMarkInteger:[dataArray [indexPath.row][CONDITION] intValue]];
    }
    else
    {
        [cell setMarkInteger:0];
    }
    //判内容是什么类型
    
    NSLog(@"begin================");
    NSLog(@"video = %@",[[dataArray objectAtIndex:indexPath.row]objectForKey:VIDEO] );
    NSLog(@"image = %@",[[dataArray objectAtIndex:indexPath.row]objectForKey:IMAGE] );
    NSLog(@"end==================");
    //图片1  视频0
    
    if ([[[dataArray objectAtIndex:indexPath.row]objectForKey:VIDEO] isEqualToString:@""])
    {
        [cell isVideoView:NO];
    }
    else
    {
        
        [cell isVideoView:YES];
    }
    if([[[dataArray objectAtIndex:indexPath.row]objectForKey:IMAGE] isEqualToString:@""])
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
//    NSString *keyNumber = [NSString stringWithFormat:@"%d",tableView.tag - 999];
//    if (tableView.tag - 999 == 3)
//    {
//        keyNumber = @"0";
//    }
    
    //图片1  视频0
    NSInteger makrType = 100;
    if (![[[dataArray objectAtIndex:indexPath.row]objectForKey:VIDEO] isEqualToString:@""])
    {
        makrType = 0;
    }
    else if(![[[dataArray objectAtIndex:indexPath.row]objectForKey:IMAGE] isEqualToString:@""])
    {
        makrType = 1;
    }
    //抢占、采用
    NSInteger stateId = [dataArray [indexPath.row][CONDITION] integerValue];
    ClueDetailViewController *clueDetail = [[ClueDetailViewController alloc]initWithType:1 State:stateId Mark:makrType];
    
    clueDetail.titleString = [[dataArray objectAtIndex:indexPath.row]objectForKey:TITLE];
    clueDetail.dateString = [[dataArray objectAtIndex:indexPath.row]objectForKey:ADDTIME];
    
    NSLog(@"%d",clueDetail.linkID);
    
    clueDetail.sourceID = [dataArray [indexPath.row][SOURCEID] intValue];
    
    [self.navigationController pushViewController:clueDetail animated:YES];
}

#pragma mark ButtonAction
- (IBAction)setting:(id)sender
{
//    SettingViewController *settingVC = [[SettingViewController alloc]init];
//    [self.navigationController pushViewController:settingVC animated:YES];
    
    AccountInfoViewController *account = [[AccountInfoViewController alloc]init];
    [self.navigationController pushViewController:account animated:YES];

}

- (IBAction)writeNews:(id)sender
{
    WriteNewsViewController *writeNews = [[WriteNewsViewController alloc]init];
    [self.navigationController pushViewController:writeNews animated:YES];
}

- (IBAction)seeClue:(id)sender
{
    SeeClueViewController *seeClueVC = [[SeeClueViewController alloc]init];
    [self.navigationController pushViewController:seeClueVC animated:YES];
}

- (IBAction)myContribution:(id)sender
{
    MyContributionViewController *myContributionVC = [[MyContributionViewController alloc]init];
    [self.navigationController pushViewController:myContributionVC animated:YES];
}

- (IBAction)myClue:(id)sender
{
    MyClueViewController *myClueVC = [[MyClueViewController alloc]init];
    [self.navigationController pushViewController:myClueVC animated:YES];
}

//- (IBAction)mailBox:(id)sender
//{
//    MailBoxViewController *mailBoxVC = [[MailBoxViewController alloc]init];
//    [self.navigationController pushViewController:mailBoxVC animated:YES];
//}
//
//- (IBAction)fellowList:(id)sender
//{
//    FellowListViewController *fellowListVC = [[FellowListViewController alloc]init];
//    [self.navigationController pushViewController:fellowListVC animated:YES];
//}
@end
