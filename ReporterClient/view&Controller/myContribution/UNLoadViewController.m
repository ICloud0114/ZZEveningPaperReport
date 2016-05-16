//
//  UNLoadViewController.m
//  ReporterClient
//
//  Created by smile on 14-4-24.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "UNLoadViewController.h"
#import "LinkClueCell.h"
#import "LinkMediaCell.h"
#import "PhotoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WriteNewsViewController.h"
#import "UIImageView+WebCache.h"
@interface UNLoadViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UNLoadViewController
{
    CustomNavigation *myNavigation;
    UITableView *mediaTableView;
    UILabel *titleLabel;
    UILabel *contentLable;
    UILabel *dateLabel;
    
    NSMutableArray *videoMutableArray;    //视频
    NSMutableArray *photoMutableArray;    //照片
    
    NSMutableArray *linkNewsMutableArray; //关联线索
    NSDictionary *dataDictionary;
}
-(void)dealloc
{
    
    //移除掉通知中心
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}
-(id)initWithGetNSDictionary:(NSDictionary*)Dictionary
{
    //    self.dataArray = array;
    self = [super init];
    if (self)
    {
        dataDictionary = Dictionary;
        self.dataArray = dataDictionary[@"data"];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        linkNewsMutableArray = [[NSMutableArray alloc] init];
        photoMutableArray = [[NSMutableArray alloc] init];
        videoMutableArray = [[NSMutableArray alloc] init];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
    
    myNavigation = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT + INCREMENT)];
    myNavigation.titleLabel.text = @"编写新闻";
    [myNavigation.leftButton addTarget:self action:@selector(backLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [myNavigation.leftButton setHidden:NO];
    [myNavigation.rightButton setHidden:NO];
    
    
    [myNavigation.rightButton setFrame:CGRectMake(SCREENWIDTH - 26 - 20, INCREMENT + 9, 26, 26)];
    [myNavigation.rightButton setBackgroundImage:[UIImage imageNamed:@"write_btn"] forState:UIControlStateNormal];
    [myNavigation.rightButton setBackgroundImage:[UIImage imageNamed:@"write_btn_after"] forState:UIControlStateHighlighted];
    [myNavigation.rightButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigation];
    
    
    
    mediaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT, SCREENWIDTH, self.view.frame.size.height - NAVHEIGHT - INCREMENT) style:UITableViewStylePlain];
    mediaTableView.showsVerticalScrollIndicator = NO;
    [mediaTableView setDataSource:self];
    [mediaTableView setDelegate:self];
    [mediaTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mediaTableView setSeparatorColor:[UIColor clearColor]];
    [mediaTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mediaTableView];
    
    
    UIView *titleView = [[UIView alloc]init];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 30)];
    [titleView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:WRITETITLECOLOR];
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x,
                                                         titleLabel.frame.origin.y +
                                                         titleLabel.frame.size.height,
                                                         150, 15)];
    
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = TIMECOLOR;
    [dateLabel setFont:[UIFont systemFontOfSize:12]];
    [titleView addSubview:dateLabel];
    
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 53, SCREENWIDTH, 2)];
    [lineImageView setImage:[UIImage imageNamed:@"line"]];
    [titleView addSubview:lineImageView];
    
    
    contentLable = [[UILabel alloc] init];
    contentLable.numberOfLines = 0;
    contentLable.backgroundColor = [UIColor clearColor];
    [contentLable setFont:[UIFont systemFontOfSize:14]];
    [contentLable setTextColor:WRITETITLECOLOR];
    [titleView addSubview:contentLable];
    
    
    if ([self.dataArray[0] count] != 0)
    {
        titleLabel.text = [self.dataArray[0] objectForKey:@"Title"];
        
        if ([[self.dataArray[0] objectForKey:@"contents"] rangeOfString:@"</p>"].length > 0)
        {
            contentLable.text = [[self.dataArray[0] objectForKey:@"contents"] componentsSeparatedByString:@"</p>"][1];
        }
        else
        {
            contentLable.text = [[self.dataArray[0] objectForKey:@"contents"] componentsSeparatedByString:@"<"][0];
        }
        
        CGSize size = [contentLable.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 2000)];
        NSLog(@"%f",size.height);
        if ([contentLable.text isEqualToString:@""])
        {
            [contentLable setFrame:CGRectMake(10, 55, 0, 0)];
            [titleView setFrame:CGRectMake(0, 0, SCREENWIDTH, 55)];
        }
        else
        {
            [contentLable setFrame:CGRectMake(10, 55, 300, size.height+10)];
            [titleView setFrame:CGRectMake(0, 0,SCREENWIDTH,  55+size.height+10)];
        }
        mediaTableView.tableHeaderView = titleView;
        dateLabel.text = [self.dataArray[0] objectForKey:@"dateString"];
        if (![[self.dataArray[0] objectForKey:@"linkTitle"] isEqualToString:@""])
        {
            [linkNewsMutableArray addObject:[self.dataArray[0] objectForKey:@"linkTitle"]];
            
        }
    }
    if ([self.dataArray[1] count] != 0)
    {
        //        [photoMutableArray addObject:self.dataArray[1]];
        for (NSDictionary *dic in self.dataArray[1])
        {
            [photoMutableArray addObject:dic];
        }
        
    }
    if ([self.dataArray[2] count] != 0)
    {
        //        [videoMutableArray addObject:self.dataArray[2]];
        for (NSDictionary *dic in self.dataArray[2])
        {
            [videoMutableArray addObject:dic];
        }
    }
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一个
    if (indexPath.row == 0)
    {
        UITableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell0 == nil)
        {
            cell0 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell0.selectionStyle = UITableViewCellSelectionStyleNone;
            cell0.backgroundColor = [UIColor clearColor];
            UIImageView *topLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 290, 2)];
            [topLineImageView setImage:[UIImage imageNamed:@"line"]];
            [cell0 addSubview:topLineImageView];
            
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mediaTableView.frame.size.width, 40)];
            UILabel *linkLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
            linkLable.backgroundColor = [UIColor clearColor];
            linkLable.text = @"关联线索";
            [linkLable setFont:[UIFont systemFontOfSize:16]];
            linkLable.textColor = LINKCLURCOLOR;
            [headerView addSubview:linkLable];
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
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell1.backgroundImageView setFrame:CGRectMake(20, 5, 281, 32)];
        
        
        [cell1.nameLabel setFrame:CGRectMake(15, 7, 280-25, 20)];
        
        cell1.deleteButton.hidden = YES;
        if (linkNewsMutableArray.count != 0)
        {
            cell1.nameLabel.text = linkNewsMutableArray[0];
        }
        else
        {
            //当没有关联的线索时候让button隐藏掉
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
        [cell.topLineImageView setFrame:CGRectMake(15, 0, 290, 2)];
        UIImageView *imgView = nil;
        
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
                        
                        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15+50*j+10*j, 10+70*i, 50, 50)];
                        imgView.userInteractionEnabled = YES;
                        imgView.layer.cornerRadius = 5;
                        imgView.layer.masksToBounds = YES;
                        [imgView addGestureRecognizer:tap];
                        imgView.tag = 1314+5*i+j;
                        
                        if ([photoMutableArray[imgView.tag - 1314] isKindOfClass:[NSString class]])
                        {
                            [imgView setImageWithURL:[NSURL URLWithString:photoMutableArray[imgView.tag-1314]] placeholderImage:[UIImage imageNamed:@"pic_btn_after"]];
                            
                        }
                        else
                        {
                            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[photoMutableArray objectAtIndex:imgView.tag-1314] objectForKey:@"fileName"]]];
                            imgView.image = image;
                        }
                        [cell addSubview:imgView];

                    }
                }
                
            }
            
            cell.addPhoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (imgView.frame.origin.x > 240)
            {
                [cell.addPhoteButton setFrame:CGRectMake(15, imgView.frame.origin.y+70, 50, 50)];
            }
            else
            {
                [cell.addPhoteButton setFrame:CGRectMake(imgView.frame.origin.x+60, imgView.frame.origin.y, 50, 50)];
            }
        }
        [cell.addPhoteButton setBackgroundImage:[UIImage imageNamed:@"pic_btn"] forState:UIControlStateNormal];
        [cell.addPhoteButton setBackgroundImage:[UIImage imageNamed:@"pic_btn_after"] forState:UIControlStateHighlighted];
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
                        
                        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15+50*j+10*j, 10+70*i, 50, 50)];
                        imgView.userInteractionEnabled = YES;
                        imgView.layer.cornerRadius = 5;
                        imgView.layer.masksToBounds = YES;
                        [imgView addGestureRecognizer:tap];
                        imgView.tag = 2314+5*i+j;
                        
                        if ([videoMutableArray[imgView.tag - 2314] isKindOfClass:[NSString class]])
                        {
//                            [imgView setImageWithURL:[NSURL URLWithString:photoMutableArray[imgView.tag-1314]] placeholderImage:[UIImage imageNamed:@"video_h@2x.png"]];
                            imgView.image = [UIImage imageNamed:@"video_btn_after"];
                        }
                        else
                        {
                            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[videoMutableArray objectAtIndex:imgView.tag-2314] objectForKey:@"faceImage"]]];
                            imgView.image = image;
                        }
                        
                        
                        
                        [cell addSubview:imgView];
                    }
                }
                
            }
            
            cell.addVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (imgView.frame.origin.x > 240)
            {
                [cell.addVideoButton setFrame:CGRectMake(15, imgView.frame.origin.y+70, 50, 50)];
            }
            else
            {
                [cell.addVideoButton setFrame:CGRectMake(imgView.frame.origin.x+60, imgView.frame.origin.y, 50, 50)];
            }
        }
        [cell.addVideoButton setBackgroundImage:[UIImage imageNamed:@"video_btn"] forState:UIControlStateNormal];
        [cell.addVideoButton setBackgroundImage:[UIImage imageNamed:@"video_btn"] forState:UIControlStateHighlighted];
        [cell addSubview:cell.addVideoButton];
        
        return cell;
    }
    
}
#pragma mark -- 查看
-(void)seeMedia:(UITapGestureRecognizer*)tap
{
    UIImageView *imageView = (UIImageView*)tap.view;
    NSInteger i = imageView.tag;
    if (i < 2314)
    {
        NSLog(@"查看图片 %d",i);
        UIImage *image = imageView.image;
        NSLog(@"查看图片 %@",image);
        
        UIImage *detailImage = nil ;
        PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
        if ([photoMutableArray[i - 1314] isKindOfClass:[NSString class]])
        {
            photoViewController.imageURL = photoMutableArray[i-1314];
        }
        else
        {
            detailImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[photoMutableArray objectAtIndex:i-1314] objectForKey:@"fileName"]]];
        }
        photoViewController.photoImage = detailImage;
        [self.navigationController pushViewController:photoViewController animated:YES];
    }
    
    else if(i >= 2314)
    {
        NSURL *videoURL = nil;
        if ([videoMutableArray[i - 2314] isKindOfClass:[NSString class]])
        {
            videoURL = [NSURL URLWithString: videoMutableArray[i-2314]];
        }
        else
        {
            //获取到video的地址
            videoURL = [NSURL URLWithString:[[videoMutableArray objectAtIndex:i-2314] objectForKey:@"fileName"]];
        }
        
        //NSURL *videoURL = [[videoMutableArray objectAtIndex:i-2314] objectForKey:@"fileName"];
        
        MPMoviePlayerViewController *ctl = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        //播放完毕 发送通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        [self presentMoviePlayerViewControllerAnimated:ctl];
    }
    
}
- (void)playToEnd
{
    NSLog(@"播放完毕");
    [self dismissMoviePlayerViewControllerAnimated];
}
#pragma mak -- 返回
-(void)backLastViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark -- 编辑
-(void)edit:(id)sender
{
    //StateType: 0 本地 1 采用
    if (self.dataArray.count != 0)
    {
        WriteNewsViewController *writeNews = [[WriteNewsViewController alloc] initWithGetNSMutableArray:self.dataArray StateType:0];
        writeNews.selectIndex = [[dataDictionary objectForKey:@"index"] integerValue];
        [self.navigationController pushViewController:writeNews animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
