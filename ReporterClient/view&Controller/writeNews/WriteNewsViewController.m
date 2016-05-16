//
//  WriteNewsViewController.m
//  ReporterClient
//
//  Created by easaa on 4/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "WriteNewsViewController.h"
#import "MyContributionViewController.h"
#import "MyClueViewController.h"
#import "SeeClueViewController.h"
#import "LinkClueViewController.h"
#import "BottomMediaView.h"
#import "MediaFootView.h"
#import "PhotoViewController.h"
#import "MBProgressHUD.h"
#import "LinkClueCell.h"
#import "LinkMediaCell.h"

#import "UIImageView+WebCache.h"
@interface WriteNewsViewController ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    CustomNavigation *myNavigation;
    BottomMediaView *mediaView;
    UILabel *textViewPlaceholderLabel;
    
    NSMutableArray *videoMutableArray;    //视频
    NSMutableArray *photoMutableArray;    //照片
    NSMutableArray *linkNewsMutableArray; //关联线索
    NSMutableArray *newsMutableArray;     //编写新闻
    
    NSMutableArray *imageViews;            //图片
    NSMutableArray *videoViews;            //视频图片
    
    NSString *reporterId;                   // 用户id
    NSString *linknewsId;                   // 关联线索的id
    
    NSMutableArray *news;
    NSMutableArray *photos;
    NSMutableArray *viedos;
    NSString *dataPath ;
    NSString *linkTitle;
    
    NSMutableArray *imagesUrl;
    NSMutableArray *videosUrl;
    
    MBProgressHUD *_HUD;
    NSMutableArray *seclectPhotoArray;//在从查看页面进入编写新闻的时候  暂时需要保存的图片 或则视频的编号 只有保存时候才删除本地 否者不删除本地
    NSMutableArray *seclectVideoArray;//同上
    
    NSMutableArray *imagesArr;//关联新闻里图片的url
    NSMutableArray *videosArr;//关联新闻连视频的url
    
    
    NSString *videos;
    NSString *imageUrls;
    
    
    NSString *Id;   //self.stateTpye==0时候用到
}
@end

@implementation WriteNewsViewController
-(id)initWithGetNSMutableArray:(NSMutableArray*)array StateType:(NSInteger)stateType
{
    self.stateTpye = 100;
    self = [super init];
    if (self)
    {
        self.dataArray = array;
        NSLog(@"=====%@",self.dataArray);
        self.stateTpye = stateType; //0 本地 1 采用
        
        //statetype = 1
        imagesUrl = [[NSMutableArray alloc] init];
        videosUrl = [[NSMutableArray alloc] init];
        
        //statetype = 0
        seclectPhotoArray = [[NSMutableArray alloc] init];
        seclectVideoArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}
-(void)dealloc
{
    //移除掉通知中心
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"title" object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        self.stateTpye = 100;
        news = [[NSMutableArray alloc] init];
        photos = [[NSMutableArray alloc] init];
        viedos = [[NSMutableArray alloc] init];
        
        imagesArr = [[NSMutableArray alloc] init];
        videosArr = [[NSMutableArray alloc] init];
        
        linknewsId =@"";
        linkTitle = @"";
        imageViews = [[NSMutableArray alloc] init];
        videoViews = [[NSMutableArray alloc] init];

        newsMutableArray  = [[NSMutableArray alloc] init];
        photoMutableArray = [[NSMutableArray alloc] init];
        videoMutableArray = [[NSMutableArray alloc] init];
        linkNewsMutableArray = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLinkNews:) name:@"title" object:nil];

        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        reporterId = [[userDefaultes objectForKey:USER_INFO_DICTIONARY] objectForKey:USERID];
        NSLog(@"%@",reporterId);
        
        videos = @"";
        imageUrls = @"";
        Id = @"";

        
        
//        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//        NSMutableDictionary *mutdic = [userDefaultes objectForKey:@"mutDic"];
//        NSArray *numArr = [mutdic objectForKey:@"tableNum"];
//        NSArray *disheArr = [mutdic objectForKey:@"disheArr"];
        
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;

    myNavigation = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT + INCREMENT)];
    myNavigation.titleLabel.text = @"编写新闻";
    [myNavigation.leftButton addTarget:self action:@selector(backLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [myNavigation.leftButton setHidden:NO];
    [self.view addSubview:myNavigation];
    
    
    
    headView = [[EditNewsView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 240)];


    mediaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVHEIGHT + INCREMENT + 10, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - INCREMENT - 10) style:UITableViewStylePlain];
    mediaTableView.showsVerticalScrollIndicator = NO;
    [mediaTableView setDataSource:self];
    [mediaTableView setDelegate:self];
    [mediaTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mediaTableView setSeparatorColor:[UIColor clearColor]];
    [mediaTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mediaTableView];

    
    MediaFootView *footView = [[MediaFootView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    [footView.saveButton addTarget:self action:@selector(savefile:) forControlEvents:UIControlEventTouchUpInside];
    [footView.upLoadButton addTarget:self action:@selector(updatafile:) forControlEvents:UIControlEventTouchUpInside];
    mediaTableView.tableFooterView = footView;
    mediaTableView.tableHeaderView = headView;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(endEditing)];
    [self.view addGestureRecognizer:tap];
    
    
    if ([self.dataArray[0] count] != 0)
    {
        headView.titleTextView.text = [self.dataArray[0] objectForKey:@"Title"];
        
        if ([[self.dataArray[0] objectForKey:@"contents"] rangeOfString:@"<p>"].length > 0)
        {
             headView.contentTextView.text = [[[self.dataArray[0] objectForKey:@"contents"]componentsSeparatedByString:@"<p>"][1] componentsSeparatedByString:@"</p>"][0];
        }
        else
        {
            headView.contentTextView.text = [[self.dataArray[0] objectForKey:@"contents"]componentsSeparatedByString:@"<"][0];
        }
        
        if (![[self.dataArray[0] objectForKey:@"Id"] isEqual:@"0"])
        {
            Id = [self.dataArray[0] objectForKey:@"Id"];
        }
        else
        {
            Id = @"0";
        }
        if (![headView.titleTextView.text  isEqualToString:@""])
        {
            headView.textLable.hidden = YES;
        }
        if (![headView.contentTextView.text  isEqualToString:@""])
        {
            headView.textViewPlaceholderLabel.hidden = YES;
        }
        
        if (![[self.dataArray[0] objectForKey:@"linkTitle"] isEqualToString:@""])
        {
            [linkNewsMutableArray addObject:[self.dataArray[0] objectForKey:@"linkTitle"]];
            
        }
//        else
//        {
//            [linkNewsMutableArray addObject:[self.dataArray[0] objectForKey:@"Title"]];
//        }
    }
    if ([self.dataArray[1] count] != 0)
    {
        linknewsId = [NSString stringWithFormat:@"%d",self._sourceID];
        //[photoMutableArray addObject:self.dataArray[1]];
        for (id dic in self.dataArray[1])
        {
            
            if (self.stateTpye == 1||self.stateTpye == 2)
            {
                if ([dic isKindOfClass:[NSDictionary class]])
                {
                    if (![[dic objectForKey:@"fileName"] isEqualToString:@""])
                    {
                        [imagesUrl addObject:[dic objectForKey:@"fileName"]];
                        [photoMutableArray addObject:[dic objectForKey:@"fileName"]];
                        
                    }
                }
                
            }
            else //self.stateTpye == 0
            {
                if ([dic isKindOfClass:[NSString class]])
                {
                    [imagesUrl addObject:dic];
                }
                [photoMutableArray addObject:dic];
            }
            
        }
        
    }
    if ([self.dataArray[2] count] != 0)
    {
        //[videoMutableArray addObject:self.dataArray[2]];
        for (id dic in self.dataArray[2])
        {
            
            if (self.stateTpye == 1||self.stateTpye == 2)
            {
                if ([dic isKindOfClass:[NSDictionary class]])
                {
                    if (![[dic objectForKey:@"fileName"] isEqualToString:@""])
                    {
                        [videosUrl addObject:[dic objectForKey:@"fileName"]];
                        [videoMutableArray addObject:[dic objectForKey:@"fileName"]];
                    }
                }
                
            }
            else
            {
                if ([dic isKindOfClass:[NSString class]])
                {
                    [videosUrl addObject:dic];
                }
                [videoMutableArray addObject:dic];
            }
        }
        
    }

    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:_HUD];
    _HUD.delegate =self;
    _HUD.labelText = @"正在加载上传...";
    _HUD.center =CGPointMake(160, 310);
}

#pragma mark -- 返回上一个页面
-(void)backLastViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 键盘消失
-(void)endEditing
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一个
    if (indexPath.row == 0)
    {
        UITableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell0 == nil)
        {
            cell0 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell0.backgroundColor = [UIColor clearColor];
        
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, mediaTableView.frame.size.width, 40)];

            
//            [headerView addSubview:topView];
            UILabel *linkLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
            linkLable.backgroundColor = [UIColor clearColor];
            linkLable.text = @"关联线索";
            [linkLable setFont:[UIFont systemFontOfSize:16]];
            linkLable.textColor = LINKCLURCOLOR;
            [headerView addSubview:linkLable];
            
            UIButton *linkButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 40, 5, 20, 30)];
            [headerView addSubview:linkButton];
            
            if (linkNewsMutableArray.count == 0)
            {
                linkButton.hidden = NO;
            }
            else
            {
                linkButton.hidden = YES;
            }
            [linkButton setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
            [linkButton setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateHighlighted];
            [linkButton addTarget:self action:@selector(linkNews:) forControlEvents:UIControlEventTouchUpInside];
            [cell0 addSubview:headerView];
        }
        return cell0;
    }
    
    //第二个
    else if (indexPath.row == 1)
    {
        static NSString *ClueCellID = @"ClueCellID";
        LinkClueCell *cell1 = [tableView dequeueReusableCellWithIdentifier:ClueCellID];
        if (cell1 == nil)
        {
            cell1 = [[LinkClueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ClueCellID];
            [cell1.deleteButton addTarget:self action:@selector(deleteLinkNews:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (linkNewsMutableArray.count != 0)
        {
            cell1.nameLabel.text = linkNewsMutableArray[0];
            cell1.deleteButton.hidden = NO;
        }
        else
        {
            //当没有关联的线索时候让button隐藏掉
            cell1.deleteButton.hidden = YES;
            [cell1.backgroundImageView removeFromSuperview];
        }
        
        return cell1;

    }
    
    //第三个
    else if(indexPath.row == 2)
    {
        static NSString *MediaCellID = @"MediaCellID";
        
        LinkMediaCell *cell = [[LinkMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MediaCellID];
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *imgView = nil;
        NSInteger edges = 15;
        CGFloat colWidth = (SCREENWIDTH - 2* edges - 5 * 50) /4.0 ;
        if (photoMutableArray.count == 0)
        {
            cell.addPhoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.addPhoteButton setFrame:CGRectMake(15, 10, 50, 50)];
        }
        else
        {
        
            for (int i = 0; i < (photoMutableArray.count+1)/5+1; i++)
            {
               
                for (int j = 0; j < 5; j++)
                {
                    if (j+5*i < photoMutableArray.count)
                    {
                        // 设置手势，当点击到cell中的某一张图的时候触发相应方法
                        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeMedia:)];
                        
                        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(removeMedia:)];
                        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 50*j+colWidth*j, 10+70*i, 50, 50)];
                        imgView.userInteractionEnabled = YES;
                        imgView.layer.cornerRadius = 5;
                        imgView.layer.masksToBounds = YES;
                        imgView.contentMode = UIViewContentModeScaleToFill;
                        [imgView addGestureRecognizer:tap];
                        [imgView addGestureRecognizer:longPress];
                        imgView.tag = 1314+5*i+j;
                        
                        if (self.stateTpye == 1||self.stateTpye == 2)
                        {
                            if (imgView.tag -1314 <= imagesUrl.count-1 && imagesUrl.count != 0)
                            {
                                //网上的图片
                                if ([photoMutableArray[imgView.tag - 1314] isKindOfClass:[NSString class]])
                                {
                                    [imgView setImageWithURL:[NSURL URLWithString:photoMutableArray[imgView.tag-1314]] placeholderImage:[UIImage imageNamed:@"pic_btn_after"]];
                                    
                                }
                            }
                            else
                            {
                                //本地图片
                                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[photoMutableArray objectAtIndex:imgView.tag-1314] objectForKey:@"fileName"]]];
                                imgView.image = image;
                            }
                            
                        }
                        else if (self.stateTpye == 0)
                        {
                            if ([photoMutableArray[imgView.tag -1314] isKindOfClass:[NSString class]])
                            {
                                [imgView setImageWithURL:[NSURL URLWithString:[photoMutableArray objectAtIndex:imgView.tag-1314]] placeholderImage:[UIImage imageNamed:@"pic_btn_after"]];
                            }
                            else
                            {
                                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[photoMutableArray objectAtIndex:imgView.tag-1314] objectForKey:@"fileName"]]];
                                imgView.image = image;
                            }
                        }
                        else
                        {
                            if (imagesArr.count != 0 && imgView.tag -1314 <= imagesArr.count-1)
                            {
                                [imgView setImageWithURL:[NSURL URLWithString:[photoMutableArray objectAtIndex:imgView.tag-1314]] placeholderImage:[UIImage imageNamed:@"pic_btn_after"]];
                            }
                            else
                            {
                                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[photoMutableArray objectAtIndex:imgView.tag-1314] objectForKey:@"fileName"]]];
                                imgView.image = image;
                            }
                            
                        }
                        
                        [imageViews addObject:imgView];
                        [cell addSubview:imgView];
                    }
                }
                
            }
            
            cell.addPhoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (imgView.frame.origin.x > 4 * (50 + colWidth))
            {
                [cell.addPhoteButton setFrame:CGRectMake(15, imgView.frame.origin.y+70, 50, 50)];
            }
            else
            {
                [cell.addPhoteButton setFrame:CGRectMake(imgView.frame.origin.x + (50 + colWidth), imgView.frame.origin.y, 50, 50)];
            }
        }
        [cell.addPhoteButton setBackgroundImage:[UIImage imageNamed:@"pic_btn"] forState:UIControlStateNormal];
        [cell.addPhoteButton setBackgroundImage:[UIImage imageNamed:@"pic_btn_after"] forState:UIControlStateHighlighted];
        [cell.addPhoteButton addTarget:self action:@selector(upLoadPhoto) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:cell.addPhoteButton];

        return cell;
    }
    
    //第四个
    else
    {
        static NSString *VideoCellID = @"VideoCellID";
        
        LinkMediaCell *cell = [[LinkMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoCellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.topLineImageView.hidden = YES;
        
        UIImageView *imgView = nil;
        NSInteger edges = 15;
        CGFloat colWidth = (SCREENWIDTH - 2* edges - 5 * 50) /4.0 ;
        if (videoMutableArray.count == 0)
        {
            cell.addVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.addVideoButton setFrame:CGRectMake(15, 10, 50, 50)];
        }
        else
        {
            
            for (int i = 0; i < (videoMutableArray.count+1)/5+1; i++)
            {
                
                for (int j = 0; j < 5; j++)
                {
                    if (j+5*i < videoMutableArray.count)
                    {
                        // 设置手势，当点击到cell中的某一张图的时候触发相应方法
                        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeMedia:)];
                        
                        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(removeMedia:)];
                        
                        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 50*j+colWidth*j, 10+70*i, 50, 50)];
                        imgView.userInteractionEnabled = YES;
                        imgView.layer.cornerRadius = 5;
                        imgView.layer.masksToBounds = YES;
                        [imgView addGestureRecognizer:tap];
                        [imgView addGestureRecognizer:longPress];
                        imgView.tag = 2314+5*i+j;

                        if ((self.stateTpye == 1||self.stateTpye == 2) && videosUrl.count!= 0)
                        {
                            [imgView setImage:[UIImage imageNamed:@"video_btn"]];
                        }
                        else if(self.stateTpye == 0)
                        {
                            if ([videoMutableArray[imgView.tag -2314] isKindOfClass:[NSString class]])
                            {
                                [imgView setImage:[UIImage imageNamed:@"video_btn"]];
                            }
                            else
                            {
                                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[videoMutableArray objectAtIndex:imgView.tag-2314] objectForKey:@"faceImage"]]];
                                imgView.image = image;
                            }
                        }
                        else
                        {
                            if (imgView.tag-2314 <= videosArr.count-1 && videosArr.count != 0)
                            {
                                [imgView setImage:[UIImage imageNamed:@"video_btn"]];
                            }
                            
                            else
                            {
                                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[videoMutableArray objectAtIndex:imgView.tag-2314] objectForKey:@"faceImage"]]];
                                imgView.image = image;
                            }

                        }
                        
                        [videoViews addObject:imgView];
                        [cell addSubview:imgView];
                    }
                }
                
            }
            
            cell.addVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (imgView.frame.origin.x > 4 * (50 + colWidth))
            {
                [cell.addVideoButton setFrame:CGRectMake(15, imgView.frame.origin.y+70, 50, 50)];
            }
            else
            {
                [cell.addVideoButton setFrame:CGRectMake(imgView.frame.origin.x + (50 + colWidth), imgView.frame.origin.y, 50, 50)];
            }
        }
        [cell.addVideoButton setBackgroundImage:[UIImage imageNamed:@"video_btn"] forState:UIControlStateNormal];
        [cell.addVideoButton setBackgroundImage:[UIImage imageNamed:@"video_btn_after"] forState:UIControlStateHighlighted];
        [cell.addVideoButton addTarget:self action:@selector(upLoadVideo) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:cell.addVideoButton];
        
        return cell;
    }

}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 44;
    }
    
    if(indexPath.row == 1)
    {
        if (linkNewsMutableArray.count == 0)
        {
            return 0.0001;
        }
        return 44;
    }
    
    if (indexPath.row == 2)
    {
        if ((photoMutableArray.count+1)%5 == 0)
        {
             return (photoMutableArray.count+1)/5 * 70;
        }
        return (photoMutableArray.count+1)/5 * 70+70;
    }
    
    else
    {
        if ((videoMutableArray.count+1)%5 == 0)
        {
            return (videoMutableArray.count+1)/5 * 70;
        }
        return (videoMutableArray.count+1)/5 * 70+70;
    }
    
}
#pragma mark  添加关联线索
-(void)addLinkNews:(NSNotification*)info
{
    [linkNewsMutableArray addObject:[info valueForKey:@"object"][0]];
    linkTitle = [NSString stringWithString:[info valueForKey:@"object"][0]];
    linknewsId = [info valueForKey:@"object"][1];
    
    if ([headView.titleTextView.text isEqualToString: @""])
    {
        headView.titleTextView.text = [NSString stringWithString:[info valueForKey:@"object"][0]];
        headView.textLable.text = @"";
    }
    
    self._sourceID = [linknewsId integerValue];
    NSString *imagesURL = [info valueForKey:@"object"][2];
    NSString *videosURL = [info valueForKey:@"object"][3];
    
    
    if (![imagesURL isEqualToString:@""])
    {
        NSArray *imageArr = [imagesURL componentsSeparatedByString:@","];
        for (NSString *str in imageArr)
        {
            NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  str,@"fileName",
                                  nil];
            [imagesArr addObject:dic2];
            [photoMutableArray addObject:str];
        }
 
    }
    
    if (![videosURL isEqualToString:@""])
    {
        NSArray *videoArr = [videosURL componentsSeparatedByString:@","];
        for (NSString *str in videoArr)
        {
            NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     str,@"fileName",
                                     nil];
            [videosArr addObject:dic3];
            [videoMutableArray addObject:str];
        }
    }
    
    //刷新这一行
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indexPath_2=[NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObjects:indexPath_1,indexPath_2, nil];
    [mediaTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
   [mediaTableView reloadData];
}
-(void)deleteLinkNews:(UIButton *)deleteButton
{
    NSIndexPath *indexPath = [mediaTableView indexPathForCell:(LinkClueCell *)deleteButton.superview];
    NSLog(@"----%@",indexPath);
    
    [linkNewsMutableArray removeObjectAtIndex:0];
    linkTitle = @"";
    linknewsId = @"";
    headView.titleTextView.text = @"";
    
    //取消关联 删除掉关联的附件
    if (self.stateTpye == 1|| self.stateTpye == 2)
    {
        for (id object in imagesUrl)
        {
            [photoMutableArray removeObject:object];
        }
        for (id object in videosUrl)
        {
            [videoMutableArray removeObject:object];
        }
        [imagesUrl removeAllObjects];
        [videosUrl removeAllObjects];
    }
    else //if(self.stateTpye == 0)
    {
        for (id object in imagesArr)
        {
            [photoMutableArray removeObject:object];
        }
        for (id object in videosArr)
        {
            [videoMutableArray removeObject:object];
        }
        [imagesArr removeAllObjects];
        [videosArr removeAllObjects];
        
    }

    //刷新这一行
    NSIndexPath *indexPath_2=[NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObjects:indexPath_1,indexPath_2, nil];
    [mediaTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    [mediaTableView reloadData];
}
//push出关联页面
-(void)linkNews:(UIButton*)sender
{
    NSLog(@"----关联新闻");
    LinkClueViewController *linkeViewController = [[LinkClueViewController alloc] init];
    [self.navigationController pushViewController:linkeViewController animated:YES];
}
#pragma mark - 文件上传、保存

-(void)savefile:(id)sender
{
    if( [headView.titleTextView.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入新闻标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        if (self.stateTpye == 1||self.stateTpye == 2)
        {
            for (id object in seclectPhotoArray)
            {
                //            NSFileManager* fileManager=[NSFileManager defaultManager];
                //            [fileManager removeItemAtPath:[seclectPhotoArray[[i integer_t] ] objectForKey:@"fileName" ] error:nil];
                [videoMutableArray removeObject:object];
            }
            for (id object in seclectVideoArray)
            {
                //            NSFileManager* fileManager=[NSFileManager defaultManager];
                //            [fileManager removeItemAtPath:[photoMutableArray[i-1314] objectForKey:@"fileName" ] error:nil];
                [photoMutableArray removeObject:object];
            }
        }
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init] ;
        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        //存到plist文件
        NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
        NSFileManager *fm = [NSFileManager defaultManager];
        
        //找到文件，判断是不是存在
        NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                           objectAtIndex:0]stringByAppendingPathComponent:plistfile];
        
        
        if ([fm fileExistsAtPath:file] )
        {
            NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:file];
            
            [news setArray: [dicplist objectForKey:@"News"]];
            [photos setArray:[dicplist objectForKey:@"Photos"]];
            [viedos setArray:[dicplist objectForKey:@"Videos"]];
            
            if (self.stateTpye == 0)
            {
                NSFileManager* fileManager=[NSFileManager defaultManager];
                //找到那个数组被编辑了 ，然后删除被选中的对象
                for (id i in seclectPhotoArray)
                {
                    [fileManager removeItemAtPath:[photoMutableArray[[i integerValue]] objectForKey:@"fileName" ] error:nil];
                    [photos[self.selectIndex] removeObjectAtIndex: [i integerValue]];
                }
                for (id i in seclectVideoArray)
                {
                    //NSFileManager* fileManager=[NSFileManager defaultManager];
                    [fileManager removeItemAtURL:[NSURL URLWithString:[photoMutableArray[[i integerValue]] objectForKey:@"fileName" ]] error:nil];
                    [fileManager removeItemAtPath:[videoMutableArray[[i integerValue]] objectForKey:@"faceImage"] error:nil];
                    [viedos[self.selectIndex] removeObjectAtIndex:[i integerValue]];
                }
                
                
                [seclectPhotoArray removeAllObjects];
                [seclectVideoArray removeAllObjects];
                
                
                [news removeObjectAtIndex:self.selectIndex];
                [photos removeObjectAtIndex:self.selectIndex];
                [viedos removeObjectAtIndex:self.selectIndex];
                
                
                NSMutableDictionary *linkDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                       headView.titleTextView.text,NEWSTITLE,
                                                       headView.contentTextView.text,NEWSCONTENTS,
                                                       dateString,@"dateString",
                                                       linkTitle,@"linkTitle",
                                                       [NSNumber numberWithInt:self._sourceID],@"Id",
                                                       nil] ;
                
                [news insertObject:linkDictionary atIndex:0];
                [photos insertObject:photoMutableArray atIndex:0];
                [viedos insertObject:videoMutableArray atIndex:0];
            }
            else
            {
                if (linkNewsMutableArray.count != 0)
                {
                    linkTitle = linkNewsMutableArray[0];
                }
                NSMutableDictionary *linkDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                       headView.titleTextView.text,NEWSTITLE,
                                                       headView.contentTextView.text,NEWSCONTENTS,
                                                       dateString,@"dateString",
                                                       linkTitle,@"linkTitle",
                                                       [NSNumber numberWithInt:self._sourceID],@"Id",
                                                       nil] ;
                [news insertObject:linkDictionary atIndex:0];
                [photos insertObject:photoMutableArray atIndex:0];
                [viedos insertObject:videoMutableArray atIndex:0];
                
            }
            
        }
        else
        {
            
            NSMutableDictionary *linkDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                   headView.titleTextView.text,NEWSTITLE,
                                                   headView.contentTextView.text,NEWSCONTENTS,
                                                   dateString,@"dateString",
                                                   linkTitle,@"linkTitle",
                                                   [NSNumber numberWithInt:self._sourceID],@"Id",
                                                   nil] ;
            
            [news insertObject:linkDictionary atIndex:0];
            [photos insertObject:photoMutableArray atIndex:0];
            [viedos insertObject:videoMutableArray atIndex:0];
        }
        
        
        //把三个装进字典中
        NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                news,@"News",
                                                photos,@"Photos",
                                                viedos,@"Videos",
                                                nil];
        
        dataPath = [self dataFilePath:plistfile];
        [plistDictionary writeToFile:dataPath atomically:YES];
        
        //从plist文件读取
        //NSDictionary *dic1=[NSDictionary dictionaryWithContentsOfFile:[self dataFilePath:plistfile]];
        
        
        NSLog(@"---%@",dataPath);
        NSDictionary *dicplist1 = [[NSDictionary alloc] initWithContentsOfFile:file];
        NSLog(@"保存文件---%@",dicplist1);
        
        
        
        //    NSString *plistfile1 = [NSString stringWithFormat:@"plist%@",reporterId];
        //    NSFileManager* fileManager=[NSFileManager defaultManager];
        //    [fileManager removeItemAtPath:plistfile1 error:nil];
        
        //删除plist文件
//        [fm removeItemAtPath:file error:nil];
        
        
        NSDictionary *dicplist2 = [[NSDictionary alloc] initWithContentsOfFile:file];
        NSLog(@"保存文件---%@",dicplist2);
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
        
        if (self.stateTpye == 0)
        {
            // 刷新 未上传
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDateUI" object:nil];
            for (UIViewController *temp in self.navigationController.viewControllers)
            {
                if ([temp isKindOfClass:[MyContributionViewController class]])
                {
                    [self.navigationController popToViewController:temp animated:YES];
                    break ;
                }
            }
        }
        else if (self.stateTpye == 1||self.stateTpye == 2)
        {
            // 刷新 未上传
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDateUI" object:nil];

            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
   }

-(void)updatafile:(id)sender
{
    if( [headView.titleTextView.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入新闻标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        //开始转动小菊花
        [self startAnimation];
        //小菊花
 
        
        //新闻图片上传
        //    NSString *imageUrls = @"";
        if (self.stateTpye == 1||self.stateTpye == 2)
        {
            for (id object in imagesUrl)
            {
                [photoMutableArray removeObject:object];
            }
            for (id object in videosUrl)
            {
                [videoMutableArray removeObject:object];
            }
            [imagesUrl removeAllObjects];
            [videosUrl removeAllObjects];
        }
        else if(self.stateTpye == 0)
        {
            for (id object in imagesUrl)
            {
                if ([object isKindOfClass:[NSString class]])
                {
                    [photoMutableArray removeObject:object];
                }
                
            }
            [imagesUrl removeAllObjects];
            
            for (id object in videosUrl)
            {
                if ([object isKindOfClass:[NSString class]])
                {
                    [videoMutableArray removeObject:object];
                }
            }
            [videosUrl removeAllObjects];
        }
        else
        {
            for (id object in imagesArr)
            {
                [photoMutableArray removeObject:object];
            }
            for (id object in videosArr)
            {
                [videoMutableArray removeObject:object];
            }
            [imagesArr removeAllObjects];
            [videosArr removeAllObjects];
        }
        


        dispatch_queue_t aDQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_async(group, aDQueue, ^{
            for (NSDictionary *dic in photoMutableArray)
            {
                NSDictionary *photoDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 [NSString stringWithFormat:@"123456.png"],PICTURENAME,
                                                 [NSData dataWithContentsOfMappedFile:dic[@"fileName"]],IMG,
                                                 nil];
                
                NSDictionary *receiveDictionary1 = [EAHTTPRequest setAccessoryPicAdd:photoDictionary];
                 NSLog(@"上传图片返回数据：%@",receiveDictionary1);
                if ([[receiveDictionary1 objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    NSLog(@"%@",[receiveDictionary1 objectForKey:@"error"]);
                    
                    if ([[receiveDictionary1 objectForKey:DATA] count] != 0)
                    {
                        NSString *imageUrl =[receiveDictionary1 objectForKey:DATA][0];
                        
                        if ([imageUrl isEqualToString: @""])
                        {
                            imageUrls = imageUrl;
                        }
                        else
                        {
                            if ([imageUrls isEqualToString:@""])
                            {
                                imageUrls = [NSString stringWithFormat:@"%@",imageUrl];
                            }
                            else
                            {
                                imageUrls = [NSString stringWithFormat:@"%@,%@",imageUrls,imageUrl];
                            }
                        }
                    }
                }
            }

            //新闻视频上传
            //    NSString *videos = @"";
            for (NSDictionary *dic in videoMutableArray)
            {
                NSDictionary *videoDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                 [NSString stringWithFormat:@"123456.mp4"],VIDEONAME,
                                                 [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"fileName"]]],IMG,
                                                 nil];
                //缩略图
                //        NSDictionary *photoDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                //                                         [NSString stringWithFormat:@"123.jpg"],PICTURENAME,
                //                                         [NSData dataWithContentsOfMappedFile:dic[@"faceImage"]],IMG,
                //
                //                                         nil];
                NSDictionary *receiveDictionary2 = [EAHTTPRequest setAccessoryVideoAdd:videoDictionary];
                  NSLog(@"上传视频返回数据：%@",receiveDictionary2);
                if ([[receiveDictionary2 objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                  

                    NSLog(@"上传视频频错误：%@",[receiveDictionary2 objectForKey:@"error"]);
                    NSString *string = nil;
                    if ([[receiveDictionary2 objectForKey:DATA] count] != 0)
                    {
                        string = [[[receiveDictionary2 objectForKey:DATA] objectAtIndex:0] objectForKey:STATE];
                        NSLog(@"%@",[[[receiveDictionary2 objectForKey:DATA] objectAtIndex:0] objectForKey:MSG]);
                        
                        if ([string integerValue] == 0)
                        {
                            [_HUD setHidden:YES];
                            string = @"上传失败";
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alertView show];

                            return ;

                        }
                        else
                        {
                            NSString *videoURL = [[receiveDictionary2 objectForKey:DATA][0] objectForKey:URL];
                            if ([videoURL isEqualToString:@"" ])
                            {
                                videos = videoURL;
                            }
                            else
                            {
                                //videos = [NSString stringWithFormat:@"%@,%@",videos,videoURL];
                                //第一次时候只取两个
                                if ([videos isEqualToString:@""])
                                {
                                    videos = [NSString stringWithFormat:@"%@",videoURL];
                                }
                                else
                                {
                                    videos = [NSString stringWithFormat:@"%@,%@",videos,videoURL];
                                }
                            }

                        }
                    }
                }
            }
        });

        
        dispatch_group_notify(group, aDQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //新闻文字
                NSDictionary *titleDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 headView.titleTextView.text,NEWSTITLE,
                                                 headView.contentTextView.text,NEWSCONTENTS,
                                                 reporterId,@"uid",//记者Id
                                                 imageUrls,@"images",//图片
                                                 videos,@"videos",//视频
                                                 linknewsId,LINKNEWSID,//关联新闻Id
                                                 //                                     [NSNumber numberWithInteger:1],STATE,//状态
                                                 nil];
                
                NSDictionary *receiveDictionary = receiveDictionary = [EAHTTPRequest setManuscriptAdd:titleDictionary];
                 NSLog(@"上传新闻返回数据：%@",receiveDictionary);
                NSString *string = nil;
                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                {
                    NSLog(@"%@",[receiveDictionary objectForKey:@"error"]);
                    
                    if ([[receiveDictionary objectForKey:DATA] count] > 0)
                    {
                        string = [[[receiveDictionary objectForKey:DATA] objectAtIndex:0] objectForKey:STATE];
                        if ([string integerValue] == 0)
                        {
                            [_HUD setHidden:YES];
                            string = @"上传失败";
                        }
                        else
                        {
                            [_HUD setHidden:YES];
                            string = @"上传成功";
                            
                            //未上传页面push过来的
                            if (self.stateTpye == 0)
                            {
                                if ([Id isEqual:[NSNumber numberWithInteger:0]])
                                {
                                    NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
                                    NSFileManager *fm = [NSFileManager defaultManager];
                                    
                                    //找到文件，判断是不是存在
                                    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                                       objectAtIndex:0]stringByAppendingPathComponent:plistfile];
                                    
                                    
                                    if ([fm fileExistsAtPath:file] )
                                    {
                                        NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
                                        NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:file];
                                        [news setArray: [dicplist objectForKey:@"News"]];
                                        [photos setArray:[dicplist objectForKey:@"Photos"]];
                                        [viedos setArray:[dicplist objectForKey:@"Videos"]];
                                        
                                        [news removeObjectAtIndex:self.selectIndex];
                                        [photos removeObjectAtIndex:self.selectIndex];
                                        [viedos removeObjectAtIndex:self.selectIndex];
                                        
                                        //把三个装进字典中
                                        NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                news,@"News",
                                                                                photos,@"Photos",
                                                                                viedos,@"Videos",
                                                                                nil];
                                        
                                        dataPath = [self dataFilePath:plistfile];
                                        [plistDictionary writeToFile:dataPath atomically:YES];
                                        
                                        // 刷新 未上传
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDateUI" object:nil];
                                        
                                    }
                                    
                                    for (UIViewController *temp in self.navigationController.viewControllers)
                                    {
                                        if ([temp isKindOfClass:[MyContributionViewController class]])
                                        {
                                            [self.navigationController popToViewController:temp animated:YES];
                                            break ;
                                        }
                                    }
                                }

                                else
                                {
                                    NSDictionary *titleDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                 Id,SOURCEID,
                                                                 reporterId,@"userid",//记者Id
                                                                 [NSNumber numberWithInteger:2],STATE,//状态
                                                                 nil];
                                
                                NSDictionary *receiveDictionary = [EAHTTPRequest setSourceSetState:titleDictionary];
                                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                                {
                                    if ([[receiveDictionary objectForKey:DATA] count] != 0)
                                    {
                                        NSString *string = [[receiveDictionary objectForKey:DATA][0] objectForKey:STATE] ;
                                        if ([string integerValue] ==1)
                                        {
                                            NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
                                            NSFileManager *fm = [NSFileManager defaultManager];
                                            
                                            //找到文件，判断是不是存在
                                            NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                                               objectAtIndex:0]stringByAppendingPathComponent:plistfile];
                                            
                                            
                                            if ([fm fileExistsAtPath:file] )
                                            {
                                                NSString *plistfile = [NSString stringWithFormat:@"plist%@.plist",reporterId];
                                                NSDictionary *dicplist = [[NSDictionary alloc] initWithContentsOfFile:file];
                                                [news setArray: [dicplist objectForKey:@"News"]];
                                                [photos setArray:[dicplist objectForKey:@"Photos"]];
                                                [viedos setArray:[dicplist objectForKey:@"Videos"]];
                                                
                                                [news removeObjectAtIndex:self.selectIndex];
                                                [photos removeObjectAtIndex:self.selectIndex];
                                                [viedos removeObjectAtIndex:self.selectIndex];
                                                
                                                //把三个装进字典中
                                                NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                        news,@"News",
                                                                                        photos,@"Photos",
                                                                                        viedos,@"Videos",
                                                                                        nil];
                                                
                                                dataPath = [self dataFilePath:plistfile];
                                                [plistDictionary writeToFile:dataPath atomically:YES];
                                                // 刷新 未上传
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDateUI" object:nil];
                                            }
                                            
                                            for (UIViewController *temp in self.navigationController.viewControllers)
                                            {
                                                if ([temp isKindOfClass:[MyContributionViewController class]])
                                                {
                                                    [self.navigationController popToViewController:temp animated:YES];
                                                    break ;
                                                }
                                            }
                                        }
                                    }
                                }}
   
                            
                            }
                            //采用页面push过来的
                            else if (self.stateTpye == 2) //我的线索
                            {
                                
                                NSDictionary *titleDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                 [NSNumber numberWithInteger:self._sourceID],SOURCEID,
                                                                 reporterId,@"userid",//记者Id
                                                                 [NSNumber numberWithInteger:2],STATE,//状态
                                                                 nil];
                                
                                NSDictionary *receiveDictionary = [EAHTTPRequest setSourceSetState:titleDictionary];
                                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                                {
                                    if ([[receiveDictionary objectForKey:DATA] count] != 0)
                                    {
                                        NSString *string = [[receiveDictionary objectForKey:DATA][0] objectForKey:STATE] ;
                                        if ([string integerValue] ==1 )
                                        {
                                            //删除本地的数据先
                                            NSFileManager* fileManager=[NSFileManager defaultManager];
                                            for (int i=0; i < photoMutableArray.count; i++)
                                            {
                                                [fileManager removeItemAtPath:[photoMutableArray[i] objectForKey:@"fileName" ] error:nil];
                                            }
                                            for (int i=0; i < videoMutableArray.count; i++)
                                            {
                                                [fileManager removeItemAtURL:[NSURL URLWithString:[videoMutableArray[i] objectForKey:@"fileName" ]] error:nil];
                                                [fileManager removeItemAtPath:[videoMutableArray[i] objectForKey:@"faceImage"] error:nil];
                                            }
                                            
                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyClueData" object:nil];
                                            for (UIViewController *temp in self.navigationController.viewControllers)
                                            {
                                                if ([temp isKindOfClass:[MyClueViewController class]])
                                                {
                                                    [self.navigationController popToViewController:temp animated:YES];
                                                    break ;
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            else if (self.stateTpye == 1)//查看线索
                            {
                                
                                NSDictionary *titleDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                 [NSNumber numberWithInteger:self._sourceID],SOURCEID,
                                                                 reporterId,@"userid",//记者Id
                                                                 [NSNumber numberWithInteger:2],STATE,//状态
                                                                 nil];
                                
                                NSDictionary *receiveDictionary = [EAHTTPRequest setSourceSetState:titleDictionary];
                                if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                                {
                                    if ([[receiveDictionary objectForKey:DATA] count] != 0)
                                    {
                                        NSString *string = [[receiveDictionary objectForKey:DATA][0] objectForKey:STATE] ;
                                        if ([string integerValue] ==1)
                                        {
                                            //删除本地的数据先
                                            NSFileManager* fileManager=[NSFileManager defaultManager];
                                            for (int i=0; i < photoMutableArray.count; i++)
                                            {
                                                [fileManager removeItemAtPath:[photoMutableArray[i] objectForKey:@"fileName" ] error:nil];
                                            }
                                            for (int i=0; i < videoMutableArray.count; i++)
                                            {
                                                [fileManager removeItemAtURL:[NSURL URLWithString:[videoMutableArray[i] objectForKey:@"fileName" ]] error:nil];
                                                [fileManager removeItemAtPath:[videoMutableArray[i] objectForKey:@"faceImage"] error:nil];
                                            }
                                            
                                            [[NSNotificationCenter defaultCenter] postNotificationName: @"reloadSeeClueData" object:nil];
                                            for (UIViewController *temp in self.navigationController.viewControllers)
                                            {
                                                if ([temp isKindOfClass:[SeeClueViewController class]])
                                                {
                                                    
                                                    [self.navigationController popToViewController:temp animated:YES];
                                                    break ;
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                                
                            }
                            else
                            {
                                
                                if ([linknewsId isEqual:@""])
                                {
                                    //删除本地的数据先
                                    NSFileManager* fileManager=[NSFileManager defaultManager];
                                    for (int i=0; i < photoMutableArray.count; i++)
                                    {
                                        [fileManager removeItemAtPath:[photoMutableArray[i] objectForKey:@"fileName" ] error:nil];
                                    }
                                    for (int i=0; i < videoMutableArray.count; i++)
                                    {
                                        [fileManager removeItemAtURL:[NSURL URLWithString:[videoMutableArray[i] objectForKey:@"fileName" ]] error:nil];
                                        [fileManager removeItemAtPath:[videoMutableArray[i] objectForKey:@"faceImage"] error:nil];
                                    }
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                else
                                {
                                    NSDictionary *titleDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                     linknewsId,SOURCEID,
                                                                     reporterId,@"userid",//记者Id
                                                                     [NSNumber numberWithInteger:2],STATE,//状态
                                                                     nil];
                                    
                                    NSDictionary *receiveDictionary = [EAHTTPRequest setSourceSetState:titleDictionary];
                                    if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
                                    {
                                        if ([[receiveDictionary objectForKey:DATA] count] != 0)
                                        {
                                            NSString *string = [[receiveDictionary objectForKey:DATA][0] objectForKey:STATE] ;
                                            if ([string integerValue] ==1)
                                            {
                                                //删除本地的数据先
                                                NSFileManager* fileManager=[NSFileManager defaultManager];
                                                for (int i=0; i < photoMutableArray.count; i++)
                                                {
                                                    [fileManager removeItemAtPath:[photoMutableArray[i] objectForKey:@"fileName" ] error:nil];
                                                }
                                                for (int i=0; i < videoMutableArray.count; i++)
                                                {
                                                    [fileManager removeItemAtURL:[NSURL URLWithString:[videoMutableArray[i] objectForKey:@"fileName" ]] error:nil];
                                                    [fileManager removeItemAtPath:[videoMutableArray[i] objectForKey:@"faceImage"] error:nil];
                                                }
                                                
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        NSLog(@"%@",string);
                    }
                }
                
                if(string == nil || [string isEqualToString:@""])
                {
                    string = @"服务器无响应，请稍后重试";
                }
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                if ([string isEqualToString:@"服务器无响应，请稍后重试"])
                {
                     [self stopAnimation];
                }
            });
        });
    }
}

#pragma mark -- 录像
-(void)upLoadVideo
{
//#if TARGET_IPHONE_SIMULATOR
//    
//#elif TARGET_OS_IPHONE
    NSArray *array = [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceRear];
    NSLog(@"%@",array);
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = NO;
    [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeLow];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    //ipc.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    [imagePickerController setMediaTypes:[NSArray arrayWithObject:@"public.movie"]];
    [imagePickerController setCameraCaptureMode:UIImagePickerControllerCameraCaptureModeVideo];
    //    [imagePickerController setCameraCaptureMode:-1];
	[self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
    

//#endif
    
}
#pragma mark -- 选取图片
-(void)upLoadPhoto
{
    UIActionSheet *choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                        delegate:self
                                                               cancelButtonTitle:@"取消"
                                                          destructiveButtonTitle:nil
                                                               otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [choosePhotoActionSheet showInView:self.view];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUInteger sourceType = 0;
    NSArray *mediaTypeArray = nil;
    //真机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        switch (buttonIndex)
        {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                mediaTypeArray = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
                break;
            case 2:
                return;
        }
    }
    //模拟器
    else
    {
        if (buttonIndex == 1)
        {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        else
        {
            return;
        }
        
        
    }
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    if (mediaTypeArray)
    {
        imagePickerController.mediaTypes = mediaTypeArray;
    }
//    imagePickerController.editing = NO;
//    [imagePickerController setShowsCameraControls:NO];
    imagePickerController.sourceType = sourceType;
	[self presentViewController:imagePickerController animated:YES completion:^{
        
    }];

}


//#pragma mark 等比压缩图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
-(NSString *)createFileNameByDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImagePickerControllerOriginalImage
    UIImage *receiveImage =  [info objectForKey:UIImagePickerControllerOriginalImage];
//    [UIImage imageWithCGImage:receiveImage.CGImage scale:1.0 orientation:UIImageOrientationUp];
    
    NSString *videoFileUrl =  [[info objectForKey:UIImagePickerControllerMediaURL] absoluteString];
//    NSString *videoFileUrl1 =  [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    NSLog(@"拍照、视频返回的数据：%@",info);

    //图片
    if (receiveImage != nil)
    {
        float scale = 0.0;
        if (receiveImage.size.width > SCREENWIDTH)
        {
            scale = SCREENWIDTH / receiveImage.size.width;
        }
        else
        {
            scale = 1.0;
        }
        
//        UIImage *sendImage = [self scaleImage:receiveImage toScale:scale];
        
        NSString *dateString = [self createFileNameByDate];
        
        //生成文件名：
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FZCaches/image"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        NSString *pathString = [diskCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",dateString]];
        
        NSData *imageData = UIImagePNGRepresentation([WriteNewsViewController rotateImage:receiveImage]);
        [imageData writeToFile:pathString atomically:YES];
        
        NSDictionary *audioDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:
                                          pathString,@"fileName",
                                          [NSNumber numberWithInteger:0],@"mediaType",
                                          nil] ;
        [photoMutableArray addObject:audioDictionary];
//        [mediaTableView reloadData];
        [imageViews removeAllObjects];
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:2 inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [mediaTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    
    //视频
    if (videoFileUrl != nil)
    {
        MPMoviePlayerController *videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL: [info objectForKey:UIImagePickerControllerMediaURL]];
        UIImage *theVideoImage = [videoPlayer thumbnailImageAtTime:0.01 timeOption:MPMovieTimeOptionNearestKeyFrame];
        videoPlayer.shouldAutoplay = NO;//不播放视频
        int srch = 51;
        int srcw = 51;
        int h = theVideoImage.size.height;
        int w = theVideoImage.size.width;
        
        if(!(h <= srch && w <= srcw))//屏幕大小
        {
            float b = (float)srcw/w < (float)srch/h ? (float)srcw/w : (float)srch/h;
            CGSize itemSize = CGSizeMake(b*w, b*h);
            UIGraphicsBeginImageContext(itemSize);
            CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
            [theVideoImage drawInRect:imageRect];
            theVideoImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }

        //生成文件名：
        NSString *dateString = [self createFileNameByDate];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FZCaches1/image"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        NSData *videoImageData = [NSData dataWithData:UIImagePNGRepresentation([WriteNewsViewController rotateImage:theVideoImage])];
        NSString *pathString = [diskCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",dateString]];
        [videoImageData writeToFile:pathString atomically:YES];

        
        NSDictionary *audioDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:
                                         [NSNumber numberWithInteger:1],@"mediaType",
                                          videoFileUrl,@"fileName",
                                         pathString,@"faceImage",
                                          nil] ;
        [videoMutableArray addObject:audioDictionary];
        [videoViews removeAllObjects];
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:3 inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [mediaTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
 	[picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark-- 删除、查看Media

-(void)seeMedia:(UITapGestureRecognizer*)tap
{
    UIImageView *imageView = (UIImageView*)tap.view;
    NSInteger i = imageView.tag;
    if (i < 2314)
    {
        NSLog(@"查看图片 %d",i);
        UIImage *image = imageView.image;
        NSLog(@"查看图片 %@",image);
        
        UIImage *detailImage;
        PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
        
        if (self.stateTpye == 1 || self.stateTpye == 2)
        {
            if (imagesUrl.count != 0 && i-1314 <= imagesUrl.count-1)
            {
                photoViewController.imageURL = photoMutableArray[i-1314];
            }
            else
            {
                detailImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[photoMutableArray objectAtIndex:i-1314] objectForKey:@"fileName"]]];
                 photoViewController.photoImage = detailImage;
            }
        }
        else if(self.stateTpye == 0)
        {
            if (imagesArr.count != 0 && i-1314 <= imagesArr.count-1)
            {
                 photoViewController.imageURL = photoMutableArray[i-1314];
            }
            else
            {
                detailImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[photoMutableArray objectAtIndex:i-1314] objectForKey:@"fileName"]]];
                 photoViewController.photoImage = detailImage;
            }
        }
        else
        {
            if (imagesArr.count != 0 && i-1314 <= imagesArr.count-1)
            {
                photoViewController.imageURL = [photoMutableArray[i-1314] objectForKey:@"fileName"];
            }
            else
            {
                detailImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[photoMutableArray objectAtIndex:i-1314] objectForKey:@"fileName"]]];
                photoViewController.photoImage = detailImage;
            }
        }
    
        [self.navigationController pushViewController:photoViewController animated:YES];
    }
    
    else if(i >= 2314)
    {
     //获取到video的地址
        NSURL *videoURL = nil;

        if (self.stateTpye == 1||self.stateTpye == 2 )
        {
            if ( videosUrl.count != 0 && i-2314 <= videosUrl.count)
            {
                videoURL = [NSURL URLWithString: videoMutableArray[i-2314]];
            }
            else
            {
                videoURL = [NSURL URLWithString:[[videoMutableArray objectAtIndex:i-2314] objectForKey:@"fileName"]];
            }
        }
        else if(self.stateTpye == 0)
        {
            if (videosArr.count !=0 && i-2314 <= videosArr.count )
            {
                videoURL = [NSURL URLWithString: videoMutableArray[i-2314]];
            }
            else
            {
                videoURL = [NSURL URLWithString:[[videoMutableArray objectAtIndex:i-2314] objectForKey:@"fileName"]];

            }
        }
        else
        {
            if (videosArr.count !=0 && i-2314 <= videosArr.count-1 )
            {
                videoURL = [NSURL URLWithString: [videoMutableArray[i-2314] objectForKey:@"fileName"]];
            }
            else
            {
                videoURL =[NSURL URLWithString:[[videoMutableArray objectAtIndex:i-2314] objectForKey:@"fileName"]];
            }
        }
        
        MPMoviePlayerViewController * ctl = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        // 播放完毕 发送通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [self presentMoviePlayerViewControllerAnimated:ctl];
    }
    
}
- (void)playToEnd
{
    NSLog(@"播放完毕");
    [self dismissMoviePlayerViewControllerAnimated];
}

-(void)removeMedia:(UILongPressGestureRecognizer*)longPress
{
    
    NSLog(@"删除图片");
    UIImageView *imageView = (UIImageView*)longPress.view;
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeButton setFrame:CGRectMake(imageView.frame.origin.x + 38,imageView.frame.origin.y - 8 , 20, 20)];
    [imageView.superview addSubview:removeButton];
    [removeButton setBackgroundImage:[UIImage imageNamed:@"pic_del_btn"] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(deleteMedia:) forControlEvents:UIControlEventTouchUpInside];
    NSInteger i = imageView.tag;
    removeButton.tag = i;
}

-(void)deleteMedia:(UIButton*)sender
{
    NSInteger i = sender.tag;
    
    //图片
    if (i < 2314)
    {
        
        
        if ((self.stateTpye == 1||self.stateTpye == 2) && imagesUrl.count <= photoMutableArray.count)
        {
            [imagesUrl removeObjectAtIndex:i-1314];
            [photoMutableArray removeObjectAtIndex:i-1314];
        }
        else
        {
            if (self.stateTpye == 0)
            {
                //删除本地的数据先
//                NSFileManager* fileManager=[NSFileManager defaultManager];
//                [fileManager removeItemAtPath:[photoMutableArray[i-1314] objectForKey:@"fileName" ] error:nil];
                [seclectPhotoArray addObject:photoMutableArray[i-1314]];
                [photoMutableArray removeObjectAtIndex:i-1314];
                
            }
            else
            {
                //删除本地的数据先
                NSFileManager* fileManager=[NSFileManager defaultManager];
                [fileManager removeItemAtPath:[photoMutableArray[i-1314] objectForKey:@"fileName" ] error:nil];
                [photoMutableArray removeObjectAtIndex:i-1314];
            }
        }
        
        if (imageViews.count != 0)
        {
            [imageViews removeObjectAtIndex:i-1314];
        }
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:2 inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [mediaTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //视频
    else if(i >= 2314)
    {
        
        if ((self.stateTpye == 1||self.stateTpye == 2) && videosUrl.count <= videoMutableArray.count)
        {
//            [videosUrl removeObjectAtIndex:i-2314];
//            [videoMutableArray removeObjectAtIndex:i-2314];
            [seclectVideoArray addObject:videoMutableArray[i-2314]];

        }
        else
        {
            if (self.stateTpye == 0)
            {
                [seclectVideoArray addObject:videoMutableArray[i-2314]];
                //选中被删除的那个图片 不保存的时候不删除图片 ，保存的时候在删除图片 或者视频
                [videoMutableArray removeObjectAtIndex:i-2314];
            }
            else
            {
                NSFileManager* fileManager=[NSFileManager defaultManager];
                [fileManager removeItemAtURL:[NSURL URLWithString:[videoMutableArray[i-2314] objectForKey:@"fileName" ]] error:nil];
                [fileManager removeItemAtPath:[videoMutableArray[i-2314] objectForKey:@"faceImage"] error:nil];
                [videoMutableArray removeObjectAtIndex:i-2314];
            }
        }
        
        //删除掉所有的videoView
        if (videoViews.count != 0)
        {
            [videoViews removeObjectAtIndex:i-2314];
        }
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:3 inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [mediaTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }

}
#pragma mark 存储plist文件的路径
-(NSString *)dataFilePath:(NSString *)dataString
{
    /*常量NSDocumentDirectory表明我们正在查找Documents目录路径，第二个常量NSUserDomainMask表示的是把搜索范围定在应用程序沙盒中，YES表示的是希望希望该函数能查看用户主目录*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //  数组索引0处Documentd目录，
    NSString *documentDirectory = [paths objectAtIndex:0];
    //    返回一个kFileName的完整路径
    return [documentDirectory stringByAppendingPathComponent:dataString];
}
#pragma mark – MBProgressHUDDelegate 代理
- (void) startAnimation
{
	[_HUD show:YES];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = YES;
}

- (void) stopAnimation
{
	[_HUD hide:YES];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark UIAlertView 代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

#pragma mark -- image的翻转
+(UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
@end

