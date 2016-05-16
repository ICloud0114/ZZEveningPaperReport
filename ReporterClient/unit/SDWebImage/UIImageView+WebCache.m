/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"

BOOL flagOfAutoSize;

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    flagOfAutoSize = NO;
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder AutoSize:(BOOL)autoSetSize
{
    flagOfAutoSize = autoSetSize;
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
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

    self.image = placeholder;

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

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
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

#pragma mark 等比压缩图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    return scaledImage;
    
}


- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    if (image == nil)
    {
        
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
        self.image = image;
        [self setNeedsLayout];
    }

}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
//    UIView *view = [self viewWithTag:814];
//    if (view !=nil)
//    {
//        [view removeFromSuperview];
//    }
    for (UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [view removeFromSuperview];
            view = nil;
        }    
    }
    
    if (image == nil)
    {
        
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
        
        self.image = image;
        if (flagOfAutoSize == YES)
        {
            if (image.size.height == 0 || image.size.width == 0 || self.frame.size.height == 0 || self.frame.size.width == 0)
            {
                return;
            }
    //        DLog(@"测试图片：H:%f,W:%f  原图：H:%f,W:%f  父图：H:%f,W:%f",image.size.height, image.size.width,  self.frame.size.height, self.frame.size.width, self.superview.frame.size.height, self.superview.frame.size.width);
            
            if (image.size.height > self.frame.size.height / self.frame.size.width * image.size.width)//实际图片较高
            {
                [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width / image.size.height * self.frame.size.height, self.frame.size.height)];

                [self setFrame:CGRectMake(self.frame.origin.x + (self.superview.frame.size.width - self.frame.size.width) / 2, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];

            }
            else
            {

                [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, image.size.height / image.size.width * self.frame.size.width)];
                
                [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + (self.superview.frame.size.height - self.frame.size.height) / 2, self.frame.size.width, self.frame.size.height)];
            }

        }
        
        [self setNeedsLayout];
    }
}

@end
