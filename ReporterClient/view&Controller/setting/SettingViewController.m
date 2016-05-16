//
//  SettingViewController.m
//  ReporterClient
//
//  Created by easaa on 4/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "SettingViewController.h"
#import "AccountInfoViewController.h"
#import "AboutUsViewController.h"
#import "UIImageView+WebCache.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    CustomNavigation *myNavigationBar;
    NSString *versionURLString;

    UIImageView *headPicture;

}

@end

@implementation SettingViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMyTableView) name:@"reloadAccount" object:nil];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadMyTableView
{
    [myTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:BGCOLOR];
//    UIView *mainView = [[UIView alloc]init];
//    mainView.backgroundColor = BGCOLOR;
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
    myNavigationBar.titleLabel.text = @"设置";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, myNavigationBar.frame.size.height, SCREENWIDTH,195) style:UITableViewStylePlain];

    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showPersonalCenter
{
    AccountInfoViewController *personalCenter = [[AccountInfoViewController alloc]init];
    [self.navigationController pushViewController:personalCenter animated:YES];
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
    return 2;
}
//每段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
//        return 2;
        return 1;
    }
    else
        return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 20;
}
//每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 )
    {
        return 75;
    }
    else
    {
        return 40;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger index = indexPath.row;
    NSInteger section=[indexPath section];
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell ==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
            
        }
//    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    UIImageView *topLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    
    UIImageView *bottomLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    
    [cell addSubview:topLine];
    [cell addSubview:bottomLine];
    if (section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 75)];
        headerView.backgroundColor = [UIColor clearColor];
        headPicture  = [[UIImageView alloc]initWithFrame:CGRectMake(5, 12, 50, 50)];
        
        headPicture.layer.cornerRadius = 25;
        headPicture.layer.borderWidth = 0;
        headPicture.layer.borderColor = [UIColor clearColor].CGColor;
        headPicture.layer.masksToBounds = YES;
        
        if ([[ [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:PORTRAIT] isEqualToString:@""])
        {
            [headPicture setImage: [UIImage imageNamed:@"user_pic"]];
        }
        else
        {
            NSString *imagurl = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:PORTRAIT];
            [headPicture setImageWithURL:[NSURL URLWithString:imagurl] placeholderImage:[UIImage imageNamed:@"user_pic"]];

            
        }
        
        UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(86, 12, 73, 21)];
        userName.textAlignment = NSTextAlignmentLeft;
        userName.backgroundColor = [UIColor clearColor];
        userName.text = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY] objectForKey:REALNAME];
        
        UILabel *reporter = [[UILabel alloc]initWithFrame:CGRectMake(156, 12, 73, 21)];
        reporter.text = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:@"department"];
        reporter.backgroundColor = [UIColor clearColor];
        reporter.font = [UIFont systemFontOfSize:14];
        
        UILabel *userAccount = [[UILabel alloc]initWithFrame:CGRectMake(86, 41, 51, 21)];
        userAccount.text = @"账号：";
        userAccount.backgroundColor = [UIColor clearColor];
        userAccount.font = [UIFont systemFontOfSize:14];
        
        UILabel *userID = [[UILabel alloc]initWithFrame:CGRectMake(130, 40, 100, 21)];
        userID.backgroundColor = [UIColor clearColor];
        userID.text = [[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME];
        
        
        
        userID.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:headPicture];
        [headerView addSubview:userName];
        [headerView addSubview:reporter];
        [headerView addSubview:userAccount];
        [headerView addSubview:userID];
        
        [cell addSubview:headerView];
        [topLine setFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        [bottomLine setFrame:CGRectMake(0, 74, SCREENWIDTH, 1)];
    }
    else
    {
//        if (index == 0)
//        {
//            cell.textLabel.text = @"检测新版本";
//            cell.textLabel.font = [UIFont systemFontOfSize:14];
//            [topLine setFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
//            [bottomLine setFrame:CGRectMake(0, 74, cell.frame.size.width, 0)];
//        }
//        else
//        {
            cell.textLabel.text = @"关于";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            [topLine setFrame:CGRectMake(15, 0, cell.frame.size.width - 30, 1)];
            [topLine setFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
            [bottomLine setFrame:CGRectMake(0, 39, cell.frame.size.width, 1)];
//        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger index = indexPath.row;
    NSInteger section=[indexPath section];

    if (section == 0)
    {
        [self performSelector:@selector(showPersonalCenter) withObject:Nil afterDelay:0];
    }
    else
    {
//        if (index == 0)
//        {
//           [NSThread detachNewThreadSelector:@selector(checkVersionUpdate) toTarget:self withObject:nil];//检查版本更新
//        }
//        else
//        {
            AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:aboutUs animated:YES];
//        }
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    headerView.backgroundColor = BGCOLOR;

    return headerView;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

-(void)checkVersionUpdate
{
    NSDictionary *sendDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"mobiletype",@"1",@"versionsType",nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        NSMutableDictionary *versionMutableDictionary = [EAHTTPRequest getMobileVersion:sendDictionary];
        NSLog(@"%@",versionMutableDictionary);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[versionMutableDictionary objectForKey:DATA] isKindOfClass:[NSArray class]]) {
                [self performSelectorOnMainThread:@selector(showUpdate:) withObject:[[versionMutableDictionary objectForKey:@"data"]objectAtIndex:0] waitUntilDone:YES];
            }
            else
            {
                NSString *string  = @"服务器无响应，请稍后重试";
                if([[versionMutableDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                {
                    
                    string = [versionMutableDictionary objectForKey:ERROR];
                    
                }
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            
        });
    });
    
    
    


}
-(void)showUpdate:(NSDictionary *)receiveDictionary
{
    if ([[receiveDictionary objectForKey:@"name"] isKindOfClass:[NSString class]])
    {
        if (![[receiveDictionary objectForKey:@"name"] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]])
        {
            
            versionURLString = [receiveDictionary objectForKey:@"url"];
            if ([[receiveDictionary objectForKey:@"bewrite"] isKindOfClass:[NSString class]])
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"版本更新 %@",[receiveDictionary objectForKey:@"name"] ]message:[receiveDictionary objectForKey:@"bewrite"] delegate:self cancelButtonTitle:@"稍后更新" otherButtonTitles:@"确定",nil];
                [alertView setTag:814];
                [alertView show];
            }
            
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"message:@"当前已经是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alertView setTag:666];
            [alertView show];
            
        }
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"message:[receiveDictionary objectForKey:ERROR] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alertView setTag:111111];
        [alertView show];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag)
    {
        case 814:
        {
            if (buttonIndex == 0)
            {
            }
            else
            {
                NSLog(@"%@",versionURLString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionURLString]];
            }
            
        }
        case 666:
        {
            
        }
            break;
            
            
            
        default:
            break;
    }
    
}
@end
