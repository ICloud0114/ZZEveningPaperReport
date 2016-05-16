//
//  GuideViewController.m
//  PageScrollSample
//

#import "GuideViewController.h"


#define SPACE_WIDTH 20
//#define CONTENT_SIZEHEIGHT 480
//#define CONTENT_SIZEWEIGHT 320
#define GUIDE_VIEW_COLOR [UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.0]

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height);
    myScrollView = [[UIScrollView alloc] initWithFrame:frame] ;
    myScrollView.clipsToBounds = YES;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.delegate = self;
    
    [self.view addSubview:myScrollView];
    
    NSInteger contentWidth = myScrollView.frame.size.width - SPACE_WIDTH;
    
    NSFileManager *file = [NSFileManager defaultManager];
    NSBundle *bundle =[NSBundle mainBundle];
    NSString *str = [bundle pathForResource:@"guide" ofType:@"bundle"];
    NSArray *list = nil;
    if ([file fileExistsAtPath:str]) {
        list = [file contentsOfDirectoryAtPath:str error:nil];
    }
    NSInteger count = list.count/3;
    for (int i = 0; i < count; ++i)
    {
        CGRect frame = {(contentWidth + SPACE_WIDTH) * i, 0, SCREENWIDTH, self.view.frame.size.height};
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        NSString *path;
        if (h >= 568)
        {
            path  = [NSString stringWithFormat:@"guide%d_568h@2x.png",i+1];
        }
        else
        {
            path  = [NSString stringWithFormat:@"guide%d.png",i+1];
        }
        
        NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"guide.bundle"];
        NSString *image_path = [main_images_dir_path stringByAppendingPathComponent:path];
        [imageView setImage:[UIImage imageWithContentsOfFile:image_path]];
        imageView.userInteractionEnabled = YES;
        if (i == count-1)
        {
            //最后一张时创建一个button
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
        }
        [myScrollView addSubview:imageView];
    }
    myScrollView.contentSize = CGSizeMake((contentWidth + SPACE_WIDTH) * count, self.view.frame.size.height);
}

- (void)loginAction
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7 ;  // 动画持续时间(秒)
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";//效果
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    [self performSelector:@selector(moveToLeftSide) withObject:nil afterDelay:1];//1秒后执行Animation
}
- (void)loginActionWithAnimationDefault
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0];
    self.view.alpha = 0;
    [UIView commitAnimations];
    [self.view removeFromSuperview];

}
#pragma mark - 图片向左效果
- (void)moveToLeftSide {
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改rView坐标
                         self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.view removeFromSuperview];
                     }];
}
#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSFileManager *file = [NSFileManager defaultManager];
    NSBundle *bundle =[NSBundle mainBundle];
    NSString *str = [bundle pathForResource:@"guide" ofType:@"bundle"];
    NSArray *list = nil;
    if ([file fileExistsAtPath:str])
    {
        list = [file contentsOfDirectoryAtPath:str error:nil];
    }
    
    CGPoint offset = scrollView.contentOffset;
    if (offset.x>(list.count/3-1)* SCREENWIDTH +50)
    {
        [self loginActionWithAnimationDefault];
    }
}

@end
