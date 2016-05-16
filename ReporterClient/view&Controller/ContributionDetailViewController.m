//
//  ContributionDetailViewController.m
//  ReporterClient
//
//  Created by easaa on 4/14/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "ContributionDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>

//#define BASEURLSTRING @"http:api.pahn.cn"
#define BASEURLSTRING @"http://113.105.159.115:5021"

@interface ContributionDetailViewController ()<UIWebViewDelegate>
{
    CustomNavigation *myNavigationBar;
    UILabel *titleLabel;
    UIImageView *mediaTypeImageView;
    UIImageView *markImageView;
    UIImageView *markVideoView;
    
    NSMutableDictionary *dataDic;
    UIWebView *newsWebview;
    
    NSString *videosURL;
    UIScrollView *myScrollerView;
    NSMutableArray *numVideo;
    
}
@end

@implementation ContributionDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        numVideo = [[NSMutableArray alloc] init];
        dataDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}
-(void)dealloc
{
    //移除掉通知中心
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = BGCOLOR;
//    UIView *mainView = [[UIView alloc]init];
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

    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT, SCREENWIDTH, 55)];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 110, 30)];
    [titleView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:WRITETITLECOLOR];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height, SCREENWIDTH - 170, 15)];
    [titleView addSubview:dateLabel];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = TIMECOLOR;
    [dateLabel setFont:[UIFont systemFontOfSize:12]];

    
    mediaTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 36 - 10, 17, 36, 20)];
    [titleView addSubview:mediaTypeImageView];
    
    markImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 150, 30, 20, 16)];
    [titleView addSubview:markImageView];
    
    markVideoView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 130, 30, 20, 16)];
    [titleView addSubview:markVideoView];
    
    [self.view addSubview:titleView];
    
    [self setBackImage:_stateID];
//    [self setMediaType:_markID];
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 53, SCREENWIDTH, 2)];
    [lineImageView setImage:[UIImage imageNamed:@"line"]];
    [titleView addSubview:lineImageView];
    
    newsWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT + 55, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - INCREMENT - 55 )];
    
    newsWebview.opaque = NO;
    newsWebview.backgroundColor = [UIColor clearColor];

    [newsWebview scalesPageToFit];
    newsWebview.delegate = self;
    
    myScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT + INCREMENT + 55,SCREENWIDTH , SCREENHEIGHT - NAVHEIGHT - INCREMENT- 55 )];
    myScrollerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myScrollerView];
    [myScrollerView addSubview:newsWebview];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:_manuscriptID],@"manuscriptid",
                                               nil];
        NSMutableDictionary *receiveDictionary = [EAHTTPRequest getManuscriptDetail:sendDictionary];
        NSLog(@"刷新数据:%@", receiveDictionary);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
            {
                if ([[receiveDictionary objectForKey:DATA] count] > 0)
                {
                    NSLog(@"%@",[[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"contents"]);
                    
                    [dataDic setObject:[[receiveDictionary objectForKey:DATA]objectAtIndex:0] forKey:DATA];
                    
                    titleLabel.text = [[dataDic objectForKey:DATA]objectForKey:@"Title"];
                    dateLabel.text = [[dataDic objectForKey:DATA] objectForKey:@"uploadingTime"];
                    
                    videosURL = [[dataDic objectForKey:DATA] objectForKey:@"videos"];
                    
                    NSString *urlString = @"";
                    [newsWebview loadHTMLString: [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"contents"] baseURL:[NSURL URLWithString:urlString]];
                    if (![[[dataDic objectForKey:DATA]objectForKey:@"images"] isEqualToString:@""])
                    {
                        [self isImageView:YES];
                    }
                    
                    if (![videosURL isEqualToString:@""])
                    {
                        [self isVideoView:YES];
                        
                        [numVideo addObjectsFromArray:[videosURL componentsSeparatedByString:@","]];
                        for (int i = 0; i < (numVideo.count / 3 + 1); i ++)
                        {
                            for (int j = 0; j< 3; j ++)
                            {
                                if (j + 3 * i < numVideo.count)
                                {
                                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 102 * j, 10 + 105 * i, 90, 90)];
                                    //                        UIImageView *clicekVide = [[UIImageView alloc] initWithFrame:CGRectMake(32, 32, 35, 35)];
                                    UIButton *clicekVide = [[UIButton alloc] initWithFrame:CGRectMake(32, 32, 35, 35)];
                                    
                                    
                                    clicekVide.tag = 1314 + 3 * i + j;
                                    clicekVide.frame = CGRectMake(27, 27, 35, 35);
                                    
                                    //                        clicekVide.image = [UIImage imageNamed:@"play_btn@2x.png"];
                                    NSString *string=nil;
                                    if ([numVideo[i] rangeOfString:@"mp4"].length > 0)
                                    {
                                        string = [numVideo[i] componentsSeparatedByString:@"mp4"][0];
                                    }
                                    else
                                    {
                                        string = [numVideo[i] componentsSeparatedByString:@"3gp"][0];
                                    }

                                    
                                    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@%@jpg",BASEURLSTRING,string]] placeholderImage:[UIImage imageNamed:@"video1@2x.png"]];
                                    imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
                                    [myScrollerView addSubview:imageView];
                                    [imageView addSubview:clicekVide];
                                    imageView.userInteractionEnabled = YES;
                                    
                                    
                                    [clicekVide setBackgroundImage:[UIImage imageNamed:@"play_btn@2x.png"] forState:UIControlStateNormal];
                                    clicekVide.transform = CGAffineTransformMakeRotation(-M_PI_2);
                                    [clicekVide addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchDown];
                                    
                                }
                            }
                        }
//                        if (numVideo.count%3 == 0)
//                        {
//                            [newsWebview setFrame:CGRectMake(0, 10+100*(numVideo.count/3), 320,newsWebview.scrollView.contentSize.height)];
//                             myScrollerView.contentSize = CGSizeMake(0, newsWebview.frame.size.height+50+100*(numVideo.count/3));
//                        }
//                        else
//                        {
//                            [newsWebview setFrame:CGRectMake(0, 10+100*(numVideo.count/3+1), 320,newsWebview.scrollView.contentSize.height)];
////                           [newsWebview sizeThatFits:(CGSize)]
//                             myScrollerView.contentSize = CGSizeMake(0, newsWebview.frame.size.height+50+100*(numVideo.count/3+1));
//                        }
                    }
                    else
                    {
                        [newsWebview setFrame:CGRectMake(0, 0, SCREENWIDTH,myScrollerView.frame.size.height)];
                         myScrollerView.contentSize = CGSizeMake(0, newsWebview.frame.size.height);
                    }
//                    myScrollerView.contentSize = CGSizeMake(0, newsWebview.frame.size.height+10+100*(numVideo.count/3));

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
        });
    });
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"]floatValue];
    
    NSLog(@"%f",webViewHeight);
    if (numVideo.count % 3 == 0)
    {
        [newsWebview setFrame:CGRectMake(0, 10 + 100 * (numVideo.count / 3), SCREENWIDTH,webViewHeight)];
        myScrollerView.contentSize = CGSizeMake(0, newsWebview.scrollView.contentSize.height+50 + 100 * (numVideo.count / 3));
    }
    else
    {
        [newsWebview setFrame:CGRectMake(0, 10+100*(numVideo.count/3+1), SCREENWIDTH,webViewHeight)];
        //                           [newsWebview sizeThatFits:(CGSize)]
        myScrollerView.contentSize = CGSizeMake(0, newsWebview.scrollView.contentSize.height+50+100*(numVideo.count/3+1));
    }
}
-(void)playVideo:(UIButton*)tap
{
    //    UIImageView *imagview = (UIImageView *)tap.view;
    MPMoviePlayerViewController * ctl = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURLSTRING,numVideo[tap.tag-1314]]]];
    // 播放完毕 发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self presentMoviePlayerViewControllerAnimated:ctl];
}
- (void)playToEnd
{
    NSLog(@"播放完毕");
    [self dismissMoviePlayerViewControllerAnimated];
}

//#pragma mark -- 选择标志图片
//-(void)setMediaType:(NSInteger)markInteger
//{
//    switch (markInteger)
//    {
//        case 0://图片
//        {
//            [markImageView setImage:[UIImage imageNamed:@"picture_icon@2x.png"]];
//            
//        }
//            break;
//        case 1://视频
//        {
//            [markImageView setImage:[UIImage imageNamed:@"video_icon@2x.png"]];
//            
//        }
//            break;
//        default:
//        {
//            [markImageView setImage:nil];
//        }
//            break;
//    }
//}
#pragma mark media type
- (void)isImageView:(BOOL)isImage
{
    if (isImage)
    {
        [markImageView setImage:[UIImage imageNamed:@"video_pic"]];
    }
    else
    {
        [markImageView setImage:nil];
    }
}

- (void)isVideoView:(BOOL)isVideo
{
    if (isVideo)
    {
        [markVideoView setImage:[UIImage imageNamed:@"video_icon@2x.png"]];
    }
    else
    {
        [markVideoView setImage:nil];
    }
}

-(void)setBackImage:(NSInteger)index
{
    switch (index)
    {
        case 2://已上传
        {
            [mediaTypeImageView setImage:[UIImage imageNamed:@"upload_pic"]];
            
        }
            break;
        case 3://已审核
        {
            [mediaTypeImageView setImage:[UIImage imageNamed:@"approve_pic"]];
            
        }
            break;
        case 4://已发布
        {
            [mediaTypeImageView setImage:[UIImage imageNamed:@"publish_pic"]];
            
        }
            break;
        default:
        {
            [mediaTypeImageView setImage:nil];
        }
            break;
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

@end
