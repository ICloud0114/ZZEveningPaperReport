//
//  AboutUsViewController.m
//  ReporterClient
//
//  Created by easaa on 4/14/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
{
    CustomNavigation *myNavigationBar;
    UILabel *aboutUs;
}
@end

@implementation AboutUsViewController

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
    myNavigationBar.titleLabel.text = @"关于";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    aboutUs = [[UILabel alloc]initWithFrame:CGRectMake(10, NAVHEIGHT + INCREMENT + 10, 300, 340)];
    aboutUs.backgroundColor = [UIColor clearColor];
    aboutUs.textColor=[UIColor blackColor];
    aboutUs.font=[UIFont systemFontOfSize:14];
    aboutUs.numberOfLines=0;
    aboutUs.lineBreakMode=NSLineBreakByWordWrapping;
    
//    [NSThread detachNewThreadSelector:@selector(getReceiveData) toTarget:self withObject:nil];
    
    NSString *string = @"郑州晚报记者端-----主要供报社内部使用，是报社新媒体和报纸稿源的重要获取平台。记者、编辑可以通过手机、电脑和网络，在新闻现场完成写稿、改稿、传送、签发的全过程，从而减少工作环节，提高工作效率，有效提升和加强新闻传播的时效性。";
    [self setContentlabelText:string];
    [self.view addSubview:aboutUs];
}


- (void)getReceiveData
{
    
//    NSDictionary *receiveDictionary = [EAHTTPRequest getAboutDetail:nil];
//    
//    [self performSelectorOnMainThread:@selector(checkResultData:) withObject:receiveDictionary waitUntilDone:YES];
}

-(void)checkResultData:(NSDictionary *)receiveDictionary
{
//    
//    if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
//    {
//        NSString *aboutString = [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:@"about"];
//        [self setContentlabelText:aboutString];
//    }
//    else
//    {
//        NSString *string  = @"服务器无响应，请稍后重试";
//        if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
//        {
//            
//            string = [receiveDictionary objectForKey:ERROR];
//            
//        }
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }
    
    
}

-(void)setContentlabelText:(NSString *)text
{
    CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT)];
    aboutUs.frame=CGRectMake(10, NAVHEIGHT + INCREMENT + 10, size.width,size.height);
    aboutUs.text=text;
    
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
