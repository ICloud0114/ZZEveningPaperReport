/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIButton (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    switch ([CheckNetwork checkCurrentNetWorkStatus])
    {
        case NotReachable:
        {
            DLog(@"没有网络");
            options = SDWebImageCacheMemoryOnly;
            return;
            break;
        }
        case ReachableViaWWAN:
        {
            DLog(@"正在使用3G网络");
            options = SDWebImageCacheMemoryOnly;
            return;
            break;
        }
        case ReachableViaWiFi:
        {
            DLog(@"正在使用wifi网络");
            break;
        }
        default:
            break;
    }
    
    for (UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [view removeFromSuperview];
        }
        
    }
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [activityView startAnimating];
    [self addSubview:activityView];
    [activityView release];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    [self setImage:placeholder forState:UIControlStateNormal];
    [self setImage:placeholder forState:UIControlStateSelected];
    [self setImage:placeholder forState:UIControlStateHighlighted];


    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    [self setImage:placeholder forState:UIControlStateNormal];
    [self setImage:placeholder forState:UIControlStateSelected];
    [self setImage:placeholder forState:UIControlStateHighlighted];

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)setBackgroundImageWithURL:(NSURL *)url
{
    [self setBackgroundImageWithURL:url placeholderImage:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setBackgroundImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    for (UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [view removeFromSuperview];
        }
        
    }
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [activityView startAnimating];
    [self addSubview:activityView];
    [activityView release];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    [self setBackgroundImage:placeholder forState:UIControlStateNormal];
    [self setBackgroundImage:placeholder forState:UIControlStateSelected];
    [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];

    if (url)
    {
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"background" forKey:@"type"];
        [manager downloadWithURL:url delegate:self options:options userInfo:info];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setBackgroundImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setBackgroundImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setBackgroundImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    [self setBackgroundImage:placeholder forState:UIControlStateNormal];
    [self setBackgroundImage:placeholder forState:UIControlStateSelected];
    [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];

    if (url)
    {
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"background" forKey:@"type"];
        [manager downloadWithURL:url delegate:self options:options userInfo:info success:success failure:failure];
    }
}
#endif


- (void)cancelCurrentImageLoad
{
    @synchronized(self)
    {
        [[SDWebImageManager sharedManager] cancelForDelegate:self];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    float scale = 0.0;
    if (image.size.width > 1024)
    {
        scale = 1024 / image.size.height;
    }
    else
    {
        scale = 1.0;
    }
    image = [self scaleImage:image toScale:scale];
    
    if ([[info valueForKey:@"type"] isEqualToString:@"background"])
    {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:image forState:UIControlStateSelected];
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    else
    {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateSelected];
        [self setImage:image forState:UIControlStateHighlighted];
    }
}

#pragma mark 等比压缩图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{

    
    for (UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [view removeFromSuperview];
        }
        
    }
    
    if (image == nil)
    {
        if ([[info valueForKey:@"type"] isEqualToString:@"background"])
        {
            [self setBackgroundImage:[self imageForState:UIControlStateNormal] forState:UIControlStateNormal];
            [self setBackgroundImage:[self imageForState:UIControlStateSelected] forState:UIControlStateSelected];
            [self setBackgroundImage:[self imageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
        }
        else
        {
            [self setImage:[self backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
            [self setImage:[self backgroundImageForState:UIControlStateSelected] forState:UIControlStateSelected];
            [self setImage:[self backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
        }

    }
    else
    {
        float scale = 0.0;
        if (image.size.width > 1024)
        {
            scale = 1024 / image.size.height;
        }
        else
        {
            scale = 1.0;
        }
        image = [self scaleImage:image toScale:scale];
        
        if ([[info valueForKey:@"type"] isEqualToString:@"background"])
        {
            [self setBackgroundImage:image forState:UIControlStateNormal];
            [self setBackgroundImage:image forState:UIControlStateSelected];
            [self setBackgroundImage:image forState:UIControlStateHighlighted];
        }
        else
        {
            [self setImage:image forState:UIControlStateNormal];
            [self setImage:image forState:UIControlStateSelected];
            [self setImage:image forState:UIControlStateHighlighted];
        }
    }
}

@end
