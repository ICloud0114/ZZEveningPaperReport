//
//  ClueDetailViewController.m
//  ReporterClient
//
//  Created by easaa on 4/14/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "ClueDetailViewController.h"
#import "BottomMediaView.h"
#import "ReplyClueViewController.h"
#import "WriteNewsViewController.h"
#import "UIImageView+WebCache.h"
@interface ClueDetailViewController ()<UIAlertViewDelegate,UIWebViewDelegate>
{
    CustomNavigation *myNavigationBar;
    BottomMediaView *bottomView;
//    UIView *mainView;
    
    UILabel *titleLabel;
    UIImageView *_mediaTypeImageView;
    UIImageView *_markImageView;
    UIImageView *_isVideoImageView;
    UIImageView *_isImageImageView;
    NSMutableArray *dataArray ;
    UIWebView *newsWebview;
    
    NSString *imagesURL;
    NSString *videosURL;
    
    
    UIScrollView *myScrollerView;
    NSMutableArray *numVideo;
    
}
@end

@implementation ClueDetailViewController

-(void)dealloc
{
    //移除掉通知中心
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        numVideo = [[NSMutableArray alloc] init];
        dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}
//重写方法显示不同的内容
-(id)initWithType:(NSInteger)type State:(NSInteger)state Mark:(NSInteger)mark
{
    self = [super init];
    if (self)
    {
        self.stateID = state;
        self.markID = mark;
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BGCOLOR;
//    mainView = [[UIView alloc]init];
//    mainView.backgroundColor = BGCOLOR;
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
    
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT + INCREMENT)];
    myNavigationBar.leftButton.hidden = NO;
    
    bottomView = [[BottomMediaView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - 49, SCREENWIDTH, 49)];
    
    [bottomView.grabButton addTarget:self action:@selector(grabSource:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.employButton addTarget:self action:@selector(employSource:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.replyButton addTarget:self action:@selector(replyInfomation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    [bottomView setHidden:YES];
    
    
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT, SCREENWIDTH, 55)];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20 - 36, 30)];
    [titleView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:WRITETITLECOLOR];
    titleLabel.text = _titleString;
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height, 150, 15)];
    [titleView addSubview:dateLabel];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = TIMECOLOR;
    [dateLabel setFont:[UIFont systemFontOfSize:12]];
    dateLabel.text = _dateString;
    
    
    _mediaTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 10 - 36 + 5, 17, 36, 20)];
    [titleView addSubview:_mediaTypeImageView];
    
    
    _isImageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(170, 30, 21, 15)];
    [titleView addSubview:_isImageImageView];
    
    _isVideoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 30, 21, 15)];
    [titleView addSubview:_isVideoImageView];
    
    
    _markImageView = [[UIImageView alloc]initWithFrame:CGRectMake(170, 30, 21, 15)];
    [titleView addSubview:_markImageView];
    
    
    
    [self.view addSubview:titleView];
    
    
//    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 53, 320, 2)];
//    [lineImageView setImage:[UIImage imageNamed:@"line"]];
//    [titleView addSubview:lineImageView];
    
    myScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 55 + NAVHEIGHT + INCREMENT,SCREENWIDTH , SCREENHEIGHT - NAVHEIGHT - INCREMENT- 55  - bottomView.frame.size.height)];
    myScrollerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myScrollerView];
    
    
    
    
    newsWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 55 + NAVHEIGHT + INCREMENT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - INCREMENT- 55  - bottomView.frame.size.height)];
    [myScrollerView addSubview:newsWebview];
    newsWebview.opaque = NO;
    newsWebview.backgroundColor = [UIColor clearColor];
    [newsWebview scalesPageToFit];
    [newsWebview setDelegate:self];
    


    [NSThread detachNewThreadSelector:@selector(getReceiveData) toTarget:self withObject:nil];

    
    
}

- (void)getReceiveData
{
    
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           
                                           [NSNumber numberWithInt:_sourceID],SOURCEID,
                                           nil];
    NSMutableDictionary *receiveDictionary = [EAHTTPRequest getSourceDetail:sendDictionary];
    NSLog(@"刷新数据:%@", receiveDictionary);
//     NSString *msg = [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"msg"];
    
    [self performSelectorOnMainThread:@selector(checkResultData:) withObject:receiveDictionary waitUntilDone:YES];
//    [self checkResultData:receiveDictionary];
}

-(void)checkResultData:(NSDictionary *)receiveDictionary
{
    
    if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
    {
        
//        NSString *msg = [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"msg"];
        
        if ([[receiveDictionary objectForKey:DATA] count] > 0)
        {
            
            NSLog(@"%@",[[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"details"]);
            
            NSString *urlString = [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"url"];
            [newsWebview loadHTMLString: [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"details"] baseURL:[NSURL URLWithString:urlString]];
            
            
            NSDictionary *dic = [[receiveDictionary objectForKey:DATA]objectAtIndex:0];
            imagesURL = [dic objectForKey:@"image"];
            videosURL = [dic objectForKey:@"video"];
            
            
            NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"title"],NEWSTITLE,
                                   [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"details"],NEWSCONTENTS,
                                   [dic objectForKey:@"addtime"],@"dateString",
                                   self.titleString,@"linkTitle",
                                   nil];
            
            ///////////////////
            
            
            if(self.type == 0) //线索关联
            {
                [self setBackImage:self.stateID];
                //        [self setMediaType:self.markID];
                if (![videosURL isEqualToString:@""])
                {
                    [self isVideoView:YES];
                }
                if(![imagesURL isEqualToString:@""])
                {
                    [self isImageView:YES];
                }
                [bottomView setHidden:YES];
                [newsWebview setFrame:CGRectMake(0, 55 + NAVHEIGHT + INCREMENT, SCREENWIDTH, SCREENHEIGHT - 55 - NAVHEIGHT - INCREMENT)];
                
                [myNavigationBar.rightButton setFrame:CGRectMake(SCREENWIDTH - 50 - 15, INCREMENT + 9, 50, 25)];
                [myNavigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"relevance_btn"] forState:UIControlStateNormal];
                [myNavigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"relevance_btn_after"] forState:UIControlStateHighlighted];
                [myNavigationBar.rightButton addTarget:self action:@selector(linkNews:) forControlEvents:UIControlEventTouchUpInside];
//                [myNavigationBar.rightButton setTitle:@"关联" forState:UIControlStateNormal];
                
                
                if (self.stateID == 2)
                {
                    [myNavigationBar.rightButton setHidden:YES];
                }
                else
                {
                    [myNavigationBar.rightButton setHidden:NO];
                }
                
            }
            else if (self.type == 1) //查看线索
            {
                
                
                [bottomView setHidden:NO];
                [self setBackImage:self.stateID];
                //        [self setMediaType:self.markID];
                if (![videosURL isEqualToString:@""])
                {
                    [self isVideoView:YES];
                }
                if(![imagesURL isEqualToString:@""])
                {
                    [self isImageView:YES];
                }
                switch (self.stateID)
                {
                    case 2:
                    {
                        [bottomView.grabButton setHidden:YES];
                        [bottomView.grapLabel setHidden:YES];
                        [bottomView.employButton setSelected:YES];
                        [bottomView.employButton setHidden:YES];
                        bottomView.employLabel.text = @"已采用";
                        bottomView.employLabel.textColor = [UIColor redColor];
                    }
                        break;
                    case 1:
                    {
                        [bottomView.employButton setHidden:YES];
                        [bottomView.employLabel setHidden:YES];
                        [bottomView.grabButton setHidden:YES];
                        bottomView.grapLabel.text = @"已抢占";
                        bottomView.grapLabel.textColor  = [UIColor redColor];
                    }
                        break;
                    default:
                        break;
                }
                
            }
            else if(self.type == 2)// 我的线索
            {
                if (self.stateID == 2)
                {
                    [self setBackImage:self.stateID];
                    //            [self setMediaType:self.markID];
                    if (![videosURL isEqualToString:@""])
                    {
                        [self isVideoView:YES];
                    }
                    if(![imagesURL isEqualToString:@""])
                    {
                        [self isImageView:YES];
                    }
                    [bottomView setHidden:YES];
                    [newsWebview setFrame:CGRectMake(0, 55 + NAVHEIGHT + INCREMENT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - INCREMENT - 55)];
                }
                else if(self.stateID == 1)
                {
                    //            [self setBackImage:self.stateID];
                    //            [self setMediaType:self.markID];
                    
                    if (![videosURL isEqualToString:@""])
                    {
                        [self isVideoView:YES];
                    }
                    if(![imagesURL isEqualToString:@""])
                    {
                        [self isImageView:YES];
                    }
                    [bottomView setHidden:NO];
                    [bottomView.replyButton setHidden:YES];
                    [bottomView.employButton setHidden:NO];
                    
                    bottomView.grapLabel.text = @"取消抢占";
                    bottomView.grapLabel.textColor = LINKCLURCOLOR;
                    
                    [bottomView.employLabel setFrame:CGRectMake(self.view.frame.size.width - 80, 10, 60, 30)];
                    [bottomView.employButton setFrame:CGRectMake(self.view.frame.size.width - 80, 10, 60, 30)];
                    [bottomView.grabButton setSelected:YES];
                    
                }
                
            }
            
            ///////////////////
            
            
//            imagesURL = [dic objectForKey:@"image"];
//            videosURL = [dic objectForKey:@"video"];
            
            NSMutableArray *imageArr1 = [[NSMutableArray alloc] init];
            NSArray *imageArr = [[dic objectForKey:@"image"] componentsSeparatedByString:@","];
            for (NSString *str in imageArr)
            {
                NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      str,@"fileName",
                                      nil];
                [imageArr1 addObject:dic2];
            }
            
            NSMutableArray *videoArr1 = [[NSMutableArray alloc] init];
            NSArray *videoArr = [[dic objectForKey:@"video"] componentsSeparatedByString:@","];
            for (NSString *str in videoArr)
            {
                NSDictionary *dic3 =    [NSDictionary dictionaryWithObjectsAndKeys:
                                         str,@"fileName",
                                         nil];
                [videoArr1 addObject:dic3];
            }
            
            
            [dataArray addObject:dic1];
            [dataArray addObject:imageArr1];
            [dataArray addObject:videoArr1];
            
            if (![videosURL isEqualToString:@""])
            {
                [numVideo addObjectsFromArray:[videosURL componentsSeparatedByString:@","]];
                for (int i = 0; i < (numVideo.count/3+1); i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        if (j + 3 * i < numVideo.count)
                        {
                            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 102 * j, 10 + 105 * i, 90, 90)];
                            //                        UIImageView *clicekVide = [[UIImageView alloc] initWithFrame:CGRectMake(32, 32, 35, 35)];
                            UIButton *clicekVide = [[UIButton alloc] initWithFrame:CGRectMake(32, 32, 35, 35)];
                            
                            
                            clicekVide.tag = 1314 + i;
                            clicekVide.frame = CGRectMake(27, 27, 35, 35);
                            
                            //                        clicekVide.image = [UIImage imageNamed:@"play_btn@2x.png"];
                            
                            NSString *string = [numVideo[i] componentsSeparatedByString:@"mp4"][0];
                            
                            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@jpg",string]] placeholderImage:[UIImage imageNamed:@"video_btn"]];
                            
                            //                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
                            //                        [imageView addGestureRecognizer:tap];
                            
                            [myScrollerView addSubview:imageView];
                            [imageView addSubview:clicekVide];
                            imageView.userInteractionEnabled = YES;
                            
                            
                            [clicekVide setBackgroundImage:[UIImage imageNamed:@"play_btn@2x.png"] forState:UIControlStateNormal];
                            [clicekVide addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchDown];
                            
                        }
                    }
                }
                
                
                
//                if (numVideo.count%3 == 0)
//                {
//                    [newsWebview setFrame:CGRectMake(0, 10+100*(numVideo.count/3), 320,myScrollerView.frame.size.height)];
//                    myScrollerView.contentSize = CGSizeMake(0, newsWebview.frame.size.height+50+100*(numVideo.count/3));
//                }
//                else
//                {
//                    [newsWebview setFrame:CGRectMake(0, 10+100*(numVideo.count/3+1), 320,myScrollerView.frame.size.height)];
//                    myScrollerView.contentSize = CGSizeMake(0, newsWebview.frame.size.height+50+100*(numVideo.count/3+1));
//                }
            }
            else
            {
               [newsWebview setFrame:CGRectMake(0, 0, SCREENWIDTH,myScrollerView.frame.size.height)];
                myScrollerView.contentSize = CGSizeMake(0, newsWebview.frame.size.height);
            }
            [newsWebview reload];
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
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"]floatValue];
    
    NSLog(@"%f",webViewHeight);
    if (numVideo.count % 3 == 0)
    {
        [newsWebview setFrame:CGRectMake(0, 10 + 100 * (numVideo.count / 3), SCREENWIDTH,webViewHeight)];
        myScrollerView.contentSize = CGSizeMake(0, newsWebview.scrollView.contentSize.height + 50 + 100 * (numVideo.count / 3));
    }
    else if(numVideo.count%3 != 0)
    {
        [newsWebview setFrame:CGRectMake(0, 10+100*(numVideo.count / 3 + 1), SCREENWIDTH,webViewHeight)];
        //                           [newsWebview sizeThatFits:(CGSize)]
        myScrollerView.contentSize = CGSizeMake(0, newsWebview.scrollView.contentSize.height+50+100*(numVideo.count/3+1));
    }
}
-(void)playVideo:(UIButton*)tap
{
//    UIImageView *imagview = (UIImageView *)tap.view;
    MPMoviePlayerViewController * ctl = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:numVideo[tap.tag-1314]]];
    // 播放完毕 发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self presentMoviePlayerViewControllerAnimated:ctl];
}
- (void)playToEnd
{
    NSLog(@"播放完毕");
    [self dismissMoviePlayerViewControllerAnimated];
}


#pragma mark -- 选择标志图片
//-(void)setMediaType:(NSInteger)markInteger
//{
//    switch (markInteger)
//    {
//        case 1://图片
//        {
//            [_markImageView setImage:[UIImage imageNamed:@"picture_icon@2x.png"]];
//            
//        }
//            break;
//        case 0://视频
//        {
//            [_markImageView setImage:[UIImage imageNamed:@"video_icon@2x.png"]];
//            
//        }
//            break;
//        default:
//        {
//            [_markImageView setImage:nil];
//        }
//            break;
//    }
//}
#pragma mark media type
- (void)isImageView:(BOOL)isImage
{
    if (isImage)
    {
        [_isImageImageView setImage:[UIImage imageNamed:@"pic_pic"]];
    }
    else
    {
        [_isImageImageView setImage:nil];
    }
}

- (void)isVideoView:(BOOL)isVideo
{
    if (isVideo)
    {
        [_isVideoImageView setImage:[UIImage imageNamed:@"video_pic"]];
    }
    else
    {
        [_isVideoImageView setImage:nil];
    }
}
-(void)setBackImage:(NSInteger)index
{
    switch (index)
    {
        case 0://采用
        {
           
            [_mediaTypeImageView setImage:nil];
        }
            break;
        case 1://抢占
        {
            [_mediaTypeImageView setImage:[UIImage imageNamed:@"grab_pic"]];
            
        }
            break;
        case 2://已上传
        {
             [_mediaTypeImageView setImage:[UIImage imageNamed:@"used_pic"]];
            
        }
            break;
//        case 2://已上传
//        {
//            [_mediaTypeImageView setImage:[UIImage imageNamed:@"shangchuan_icon@2x.png"]];
//            
//        }
//            break;
//        case 3://已审核
//        {
//            [_mediaTypeImageView setImage:[UIImage imageNamed:@"shenhe_icon@2x.png"]];
//            
//        }
//            break;
//        case 4://已发布
//        {
//            [_mediaTypeImageView setImage:[UIImage imageNamed:@"fabu_icon@2x.png"]];
//            
//        }
            break;
        default:
        {
            [_mediaTypeImageView setImage:nil];
        }
            break;
    }

}
#pragma mark --返回线索关联
-(void)linkNews:(id)sender
{
    for (UIViewController *temp in self.navigationController.viewControllers)
    {
        if ([temp isKindOfClass:[WriteNewsViewController class]])
        {
            [self.navigationController popToViewController:temp animated:YES];
            break ;
        }
    }

    NSArray *arr = @[titleLabel.text,[NSNumber numberWithInteger:_sourceID],imagesURL,videosURL];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"title" object:arr];
}
- (void)grabSource:(UIButton *)sender
{
    if (!sender.selected)
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"是否抢占该资源" message:@"线索抢占成功后，进入“我的线索”其他人将无法抢占该线索" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [av show];
    }
    else
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"是否取消抢占" message:@"取消抢占后，其他人将抢占抢占该线索" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [av show];
    }
    
}
- (void)updateSourceWithKey:(NSInteger)key// 抢占线索//取消抢占
{
    
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           [NSNumber numberWithInt:_sourceID],SOURCEID,
                                           [NSNumber numberWithInt:key],STATE,
                                           [[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID],USERID,nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *receiveDictionary = [EAHTTPRequest setSourceSetState:sendDictionary];
        NSLog(@"数据:%@", receiveDictionary);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *string = nil;
            if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
            {
                if ([[receiveDictionary objectForKey:DATA] count] > 0)
                {
                    string = [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:MSG];
                    bottomView.grabButton.selected = !bottomView.grabButton.selected;
                    if (key == 0)
                    {
                        bottomView.grapLabel.text = @"抢占资源";
                        bottomView.grapLabel.textColor = [UIColor blackColor];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyClueData" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else if(key == 1)
                    {
                        bottomView.grapLabel.text = @"已抢占";
                        bottomView.grapLabel.textColor = [UIColor redColor];
                        
                        [bottomView.employLabel setHidden:YES];
                        [bottomView.employButton setHidden:YES];
                        [bottomView.grabButton setHidden:YES];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadSeeClueData" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
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
        });
    });
   
    
    
    

}


-(void)employSource:(UIButton *)sender
{
    if (dataArray.count == 0)
    {

    }
    else
    {
        switch (self.type)
        {
            case 1://查看线索
            {
                WriteNewsViewController *writeNews = [[WriteNewsViewController alloc] initWithGetNSMutableArray:dataArray StateType:1];
                writeNews._sourceID = _sourceID;
                [self.navigationController pushViewController:writeNews animated:YES];
            }
                break;
            case 2://我的线索
            {
                WriteNewsViewController *writeNews = [[WriteNewsViewController alloc] initWithGetNSMutableArray:dataArray StateType:2];
                 writeNews._sourceID = _sourceID;
                [self.navigationController pushViewController:writeNews animated:YES];
            }
                break;
            default:
                break;
        }

    }
    
    
    
    
    
    
//    sender.selected = !sender.selected;
}

- (void)replyInfomation:(UIButton *)sender
{
    ReplyClueViewController * replyClue = [[ReplyClueViewController alloc]init];
    
    replyClue.sourceID = _sourceID;
    [self.navigationController pushViewController:replyClue animated:YES];
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

#pragma mark-UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
        if (bottomView.grabButton.selected)
        {
            [self updateSourceWithKey:0];
        }
        else
        {
            [self updateSourceWithKey:1];
            
        }

    }
    else if(buttonIndex == 1)
    {
        
    }
}
@end
