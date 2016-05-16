//
//  AccountInfoViewController.m
//  ReporterClient
//
//  Created by easaa on 4/14/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "LoginViewController.h"
#import "ModifypwdViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
@interface AccountInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, UIAlertViewDelegate>
{
    UITableView *myTableView;
    CustomNavigation *myNavigationBar;
    UIImageView *headPicture;
    NSString *imageString;
    
    MBProgressHUD *HUD;
}


@end

@implementation AccountInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:BGCOLOR];
	// Do any additional setup after loading the view.
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
    myNavigationBar.titleLabel.text = @"个人信息";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myNavigationBar];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT, SCREENWIDTH,SCREENHEIGHT - NAVHEIGHT - INCREMENT)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"Loading";
    
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changeHeadPicture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册选择",nil];
    actionSheet.tag=0;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [actionSheet showInView:self.view];
    
}

- (void)changePasswordAction
{
    ModifypwdViewController *modifyPWD = [[ModifypwdViewController alloc]init];
    [self.navigationController pushViewController:modifyPWD animated:YES];
}

- (void)logoutAction
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAutoLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"begin================");
    NSLog(@"%d", [[NSUserDefaults standardUserDefaults]boolForKey:@"isAutoLogin"]);
    NSLog(@"end==================");
    
    LoginViewController *logout = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:Nil];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PASSWORD_ZZ];
   

    [self.navigationController pushViewController:logout animated:YES];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
//有多少段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
//每段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 3;
    }
    else if(section == 2)
    {
        return 2;
    }
    else
    {
       return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 0;
    }
    return 20;
}
//每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return 80;
    }
    else if(indexPath.section ==1)
    {
        return 44;
    }
    else if(indexPath.section == 2 || indexPath.section == 3)
    {
        return 45;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    NSInteger section=[indexPath section];
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
//         cell.backgroundColor = [UIColor blackColor];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIImageView *topLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    
    UIImageView *bottomLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    
    
    switch (section) {
        case 0:
        {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 75)];
            headPicture = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 95, 12, 50, 50)];
           
            headPicture.layer.cornerRadius = 25;
            headPicture.layer.borderWidth = 0;
            headPicture.layer.borderColor = [UIColor clearColor].CGColor;
            headPicture.layer.masksToBounds = YES;
            
            if ([[ [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:PORTRAIT] isEqualToString:@""])
            {
                [headPicture setImage: [UIImage imageNamed:@"use_photo"]];
            }
            else
            {
                NSString *imagurl = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:PORTRAIT];
                [headPicture setImageWithURL:[NSURL URLWithString:imagurl] placeholderImage:[UIImage imageNamed:@"use_photo"]];
            }
            UILabel *headpic = [[UILabel alloc]initWithFrame:CGRectMake(20, 27, 73, 21)];
            headpic.textAlignment = NSTextAlignmentLeft;
            headpic.backgroundColor = [UIColor clearColor];
            headpic.text = @"头像";
            [headerView addSubview:headPicture];
            [headerView addSubview:headpic];
            [cell addSubview:headerView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [topLine setFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
//            [bottomLine setFrame:CGRectMake(0, 74, SCREENWIDTH, 1)];
        }
            break;
        case 1:
        {
            UILabel *labelString = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, SCREENWIDTH - 75 - 25, 40)];
            labelString.backgroundColor = [UIColor clearColor];
            labelString.textAlignment = NSTextAlignmentRight;
            switch (index) {
                case 0:
                {
                    cell.textLabel.text = @"姓名：";
                    labelString.text = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY] objectForKey:REALNAME];
                    [topLine setFrame:CGRectMake(15, 0, SCREENWIDTH - 30, 1)];
                    [bottomLine setFrame:CGRectMake(15, 43, SCREENWIDTH - 30, 1)];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"职务：";
                    labelString.text = @"记者";
                    [topLine setFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
                    [bottomLine setFrame:CGRectMake(15, 43, SCREENWIDTH - 30, 1)];
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"部门：";
                    labelString.text = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:@"department"];
                    [topLine setFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
                    [bottomLine setFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
                }
                    break;
                
                default:
                    break;
            }
            [cell addSubview:labelString];
        }
            break;
        case 2:
        {
            
            if (index == 0)
            {
                cell.textLabel.text = @"手机：";
                UILabel *labelString = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, SCREENWIDTH - 75 - 25, 40)];
                labelString.backgroundColor = [UIColor clearColor];
                labelString.textAlignment = NSTextAlignmentRight;
                labelString.text = [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY] objectForKey:USERMOBILE];
                [cell addSubview:labelString];
                
                [topLine setFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
                [bottomLine setFrame:CGRectMake(0, 44, SCREENWIDTH, 0)];
            }
            else
            {
                UILabel *updatePassword = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREENWIDTH - 100, 45)];
                updatePassword.textAlignment = NSTextAlignmentLeft;
                updatePassword.text = @"修改密码";
                updatePassword.textColor = [UIColor blackColor];
                [cell addSubview:updatePassword];
                [topLine setFrame:CGRectMake(15, 0, SCREENWIDTH - 30, 1)];
                [bottomLine setFrame:CGRectMake(0, 44, SCREENWIDTH, 1)];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        }
            break;
        case 3:
        {
            
            UIImageView *logoutImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH - 300)/2, 2, 300, 40)];
            logoutImage.image = [UIImage imageNamed:@"login_logo"];
            [cell addSubview:logoutImage];
            UILabel *logout = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
            logout.backgroundColor = [UIColor clearColor];
            logout.textAlignment = NSTextAlignmentCenter;
            logout.text = @"退出账号";
            logout.textColor = [UIColor whiteColor];
            [cell addSubview:logout];
            
            
            [topLine setFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
            [bottomLine setFrame:CGRectMake(0, 44, SCREENWIDTH, 0)];
           
        }
            break;
            
        default:
            break;
    }
    [cell addSubview:topLine];
    [cell addSubview:bottomLine];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        [self changeHeadPicture];
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 1)
        {
            [self changePasswordAction];
        }
        
    }
    else if (indexPath.section == 3)
    {
        [self logoutAction];
    }
}

-(void)updateUserInfo
{
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                            [[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID],USERID,
                                            nil];
    
    if ([imageString isKindOfClass:[NSString class]])
    {
        [sendDictionary setObject:imageString forKey:PORTRAIT];
    }
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSMutableDictionary *receiveDictionary = [EAHTTPRequest setPortraitUpdate:sendDictionary];
        NSLog(@"修改头像:%@", receiveDictionary);
            
            if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
            {
                if ([[receiveDictionary objectForKey:DATA] count] > 0)
                {
                    if ([[[[receiveDictionary objectForKey:DATA] objectAtIndex:0] objectForKey:@"State"] integerValue] == 1)
                    {
                        
                        NSMutableDictionary *loginDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                               [[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME],USERNAME,
                                                               [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_ZZ],PASSWORD,
                                                               nil];

                       NSMutableDictionary *loginReceiveDictionary = [EAHTTPRequest setMemberLogin:loginDictionary];
                       
    
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                            NSString *string = nil;
                              
                              if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                              {
                                  if ([[receiveDictionary objectForKey:DATA] count] > 0)
                                  {
                                      string = [[[receiveDictionary objectForKey:DATA] objectAtIndex:0] objectForKey:MSG];
                                  }
                                  if(string == nil || [string isEqualToString:@""])
                                  {
                                      string = @"服务器无响应，请稍后重试";
                                  }
                                  
                              }
                              else
                              {
                                  string = [receiveDictionary objectForKey:ERROR];
                                  
                              }
                              UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                              [alertView show];
                              if ([[loginReceiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                              {
                                  if ([[loginReceiveDictionary objectForKey:DATA] count] > 0)
                                  {
                                      [[NSUserDefaults standardUserDefaults] setObject:[[loginReceiveDictionary objectForKey:DATA] objectAtIndex:0] forKey:USER_INFO_DICTIONARY];
                                      [[NSUserDefaults standardUserDefaults]synchronize];
                                      
                                      [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadAccount" object:nil];
                                  }
                              }

                          });
                    }
                }
            }
            
        });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    headerView.backgroundColor = [UIColor colorwithHexString:@"#F8F8F8"];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

-(void)updateUserPhoto:(NSData *)userPhotoImageData
{
    
    NSDictionary *sendDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:
                                     [NSString stringWithFormat:@"123456.png"],PICTURENAME,
                                     //                                                 [NSString stringWithFormat:@"123456.mp4"],@"videoname",
                                     userPhotoImageData,IMG,
                                     nil];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *receiveDictionary = [EAHTTPRequest setAccessoryPicAdd:sendDictionary];
        NSLog(@"上传图片：%@",receiveDictionary);
        
        
//        dispatch_async(dispatch_get_main_queue(), ^{
    
            [HUD hide:YES];
            if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
            {
                if ([[receiveDictionary objectForKey:DATA] count] > 0)
                {
                    if([[[receiveDictionary objectForKey:DATA] objectAtIndex:0] isKindOfClass:[NSString class]])
                    {
                        imageString = [[receiveDictionary objectForKey:DATA] objectAtIndex:0];
                        [self updateUserInfo];
                    }
                    else
                    {
                    }
                }
            }

//        });
//    });
    
    
    }

-(NSString *)createFileNameByDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}
-(void)backHeadViewToUserInforController:(UIImage *)headImage
{
    headPicture.image = headImage;
    //先存图片。然后再上传
    NSString *dateString = [self createFileNameByDate];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ZZCaches/image"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    NSString *pathString = [diskCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",dateString]];
    NSData *imageData = UIImagePNGRepresentation(headImage);
    [imageData writeToFile:pathString atomically:YES];
    
//    [NSThread detachNewThreadSelector:@selector(updateUserPhoto:) toTarget:self withObject:imageData];
    
    
    [self updateUserPhoto:imageData];

    
}
#pragma mark Camera View Delegate Methods

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    // 取得相应的选中图片
    [headPicture setImage:img];//

        [HUD show:YES];
        [picker dismissViewControllerAnimated:YES completion:^{
           
            [self backHeadViewToUserInforController:img];
    
            }];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==0)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.editing=YES;
        picker.delegate = self;
        picker.allowsEditing=YES;
        if(buttonIndex == 0)
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            
        }
        else if(buttonIndex == 1)
        {
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
            
        }
        else if (buttonIndex == 2)
        {
            [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
        }
        
        
    }

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
