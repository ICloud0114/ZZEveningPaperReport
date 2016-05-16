//
//  PhotoViewController.m
//  ReporterClient
//
//  Created by smile on 14-4-16.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
@interface PhotoViewController ()

@end

@implementation PhotoViewController
{
    UIImageView *photoImageView;
    CustomNavigation *myNavigation;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor: [UIColor blackColor]];
    
    myNavigation = [[CustomNavigation alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    [myNavigation.backgroundImageView setImage: [PhotoViewController createImageWithColor:[UIColor blackColor]]];
    [self.view addSubview:myNavigation];
    [myNavigation.leftButton addTarget:self action:@selector(backLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [myNavigation.leftButton setHidden:NO];
    
    photoImageView = [[UIImageView alloc] init];

    CGFloat x = SCREENWIDTH - 40;
    CGFloat y =_photoImage.size.height * x / _photoImage.size.width;
    if (self.view.frame.size.height <= 480)
    {
        if (y >= 400)
        {
            y = 400;
        }
    }
    else
    {
        if (y >= 480)
        {
            y = 480;
        }
    }
//    UIImage *ima;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        __block ima = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
//    });
//    
//    float b = ima.size.height;
    
    if (self.imageURL)
    {
        [photoImageView setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:nil];
         photoImageView.bounds = CGRectMake(0, 0, x, 300);
    }
    else
    {
        photoImageView.image = _photoImage;
        photoImageView.bounds = CGRectMake(0, 0, x, y);
    }
    
   
    photoImageView.center = CGPointMake(160, self.view.frame.size.height / 2 + 24);
    
    [self.view addSubview:photoImageView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [myNavigation setFrame:CGRectMake(0, 20, SCREENWIDTH, 44)];
    }
    
}

-(void)backLastViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//生成纯色图片的函数
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
