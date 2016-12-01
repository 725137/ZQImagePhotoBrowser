//
//  ZQImageBrowserCell.m
//  qzc
//
//  Created by jxm apple on 16/8/8.
//  Copyright © 2016年 xinggenji. All rights reserved.
//

#import "DACircularProgressView.h"
#import "ZQImageBrowserCell.h"
#import "UIImageView+WebCache.h"

@interface ZQImageBrowserCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, assign) CGRect adJustFrame;

@property (nonatomic, strong) DACircularProgressView* loadingView;

@end

@implementation ZQImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setupUI];
    }
    return self;
}

- (void)setupUI
{

    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    self.loadingView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 120.0f)];
    self.loadingView.userInteractionEnabled = NO;

    self.loadingView.thicknessRatio = 0.12;
    self.loadingView.roundedCorners = NO;
    self.loadingView.hidden = YES;
    self.loadingView.center = self.contentView.center;

    self.imageView.center = self.scrollView.center;

    self.imageView.userInteractionEnabled = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];

    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];

    [self.scrollView addGestureRecognizer:tap];
    [self.scrollView addGestureRecognizer:longPress];

    [self.scrollView addSubview:self.imageView];

    [self.contentView addSubview:self.scrollView];

    [self.contentView addSubview:self.loadingView];
}

- (void)hideLoadingView
{

    self.loadingView.hidden = YES;
    self.loadingView.progress = 0;
}

- (void)showLoadingView
{

    self.loadingView.progress = 0;
    self.loadingView.hidden = NO;
    [self.contentView bringSubviewToFront:self.loadingView];
}

- (void)longPress:(UILongPressGestureRecognizer*)longPress
{

    if ([self.delegate respondsToSelector:@selector(longPressHandler:)]) {

        [self.delegate longPressHandler:self];
    }
}

- (void)scrollViewTap:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(singleTapHandler:)]) {

        [self.delegate singleTapHandler:self];
    }

    
    ZQImageBrowserAnimationMode animationMode = self.model.exitAnimationMode;

    if (animationMode == ZQImageBrowserAnimationModeFade) {

        [UIView animateWithDuration:0.25 animations:^{

            self.superview.superview.alpha = 0;

        }
        completion:^(BOOL finished) {

            [self.superview.superview removeFromSuperview];
        }];
    }

    else {
        
        self.backgroundColor = [UIColor clearColor];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.superview.backgroundColor = [UIColor clearColor];
        
        UIView* superView = self.superview.superview;
        
        superView.backgroundColor = [UIColor clearColor];
        
        self.scrollView.contentOffset = CGPointZero;
        self.imageView.transform = CGAffineTransformIdentity;
        self.imageView.backgroundColor = [UIColor clearColor];
        
        self.imageView.center = [UIApplication sharedApplication].keyWindow.center;
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;

        
        self.imageView.frame = [self adJustFrame];

        CGRect frame = [self.model.thumImageView convertRect:self.model.thumImageView.bounds toView:superView];

        [UIView animateWithDuration:0.25 animations:^{

            self.imageView.frame = frame;

        }
        completion:^(BOOL finished) {

            [self.superview.superview removeFromSuperview];
        }];
    }
}

- (CGRect)adJustFrame
{

    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;

    CGSize resultSize = CGSizeZero;
    CGRect resultFrame = CGRectZero;
    
    if (self.imageView.image.size.width == 0 || self.imageView.image.size.height == 0) {
        
        return resultFrame;
    }

    else if (self.imageView.image.size.width == self.imageView.image.size.height) {

        CGFloat scale = boundsWidth / self.imageView.image.size.width;

        resultSize.width = self.imageView.image.size.width * scale;

        resultSize.height = self.imageView.image.size.height * scale;
    }

    else if (self.imageView.image.size.width > self.imageView.image.size.height) { //宽比高大,先缩宽

        CGFloat scale = boundsWidth / self.imageView.image.size.width;

        resultSize.width = self.imageView.image.size.width * scale;
        resultSize.height = self.imageView.image.size.height * scale;

        if (resultSize.height > boundsHeight) { //宽度合适以后,再次比较高度是否超了,超了再次缩小宽

            scale = boundsHeight / resultSize.height;
            resultSize.width = resultSize.width * scale;
            resultSize.height = resultSize.height * scale;
        }
    }
    else if (self.imageView.image.size.width < self.imageView.image.size.height) {

        CGFloat scale = boundsHeight / self.imageView.image.size.height;

        resultSize.width = self.imageView.image.size.width * scale;
        resultSize.height = self.imageView.image.size.height * scale;

        if (resultSize.width > boundsWidth) {

            scale = boundsWidth / resultSize.width;
            resultSize.width = resultSize.width * scale;
            resultSize.height = resultSize.height * scale;
        }
    }
    
    
    resultFrame.size = resultSize;
    resultFrame.origin.y = [UIApplication sharedApplication].keyWindow.center.y - (resultSize.height * 0.5);

    resultFrame.origin.x = [UIApplication sharedApplication].keyWindow.center.x - (resultSize.width * 0.5);

    _adJustFrame = resultFrame;

    return _adJustFrame;
}

- (void)setModel:(ZQImageBrowserModel*)model
{

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.contentSize = self.bounds.size;
    self.imageView.transform = CGAffineTransformIdentity;
    self.imageView.center = [UIApplication sharedApplication].keyWindow.center;

    [self hideLoadingView];

    _model = model;

    if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:model.url]]) {

        NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:model.url]];
        UIImage* image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:key];

        self.model.sourceImage = image;
    }

    if (model.sourceImage) {

        self.imageView.image = model.sourceImage;

        if (model.isAnimation) {
            CGRect frame = [model.thumImageView convertRect:model.thumImageView.bounds toView:self.superview];

            self.imageView.frame = frame;

            [UIView animateWithDuration:0.5 animations:^{

                self.imageView.frame = [UIScreen mainScreen].bounds;
            }];

            model.animation = NO;
        }
        else {
            self.imageView.frame = [UIScreen mainScreen].bounds;
        }
    }
    else {
        self.imageView.frame = [UIScreen mainScreen].bounds;
        [self downloadImage];
    }
}

- (void)downloadImage
{
    CGRect tempFrame = CGRectMake(0, 0, 60, 60);
    self.imageView.frame = tempFrame;
    self.imageView.center = [UIApplication sharedApplication].keyWindow.center;
    self.imageView.clipsToBounds = YES;
    self.imageView.image = self.model.thumImageView.image;
    [self showLoadingView];

    @synchronized(self)
    {

        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.url] placeholderImage:self.model.thumImageView.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

            [self.loadingView setProgress:receivedSize * 1.0 / expectedSize animated:NO];

        }
            completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {

                if (!error) {

                    self.model.sourceImage = image;
                    self.imageView.image = image;
                    self.imageView.frame = self.bounds;
                }
                [self hideLoadingView];

            }];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{

    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView*)scrollView withView:(UIView*)view atScale:(CGFloat)scale
{

    CGSize contentSize = self.scrollView.contentSize;

    if (self.adJustFrame.size.height * scale < contentSize.height) {
        self.scrollView.alwaysBounceVertical = NO;
        contentSize.height = self.adJustFrame.size.height * scale;
    }
    else {
        self.scrollView.alwaysBounceVertical = YES;
        contentSize.height = self.bounds.size.height * scale;
    }

    if (self.adJustFrame.size.width * scale < contentSize.width) {
        self.scrollView.alwaysBounceHorizontal = NO;
        contentSize.width = self.adJustFrame.size.width * scale;
    }
    else {
        self.scrollView.alwaysBounceHorizontal = YES;
        contentSize.width = self.bounds.size.width * scale;
    }

    self.scrollView.contentSize = contentSize;

    [self centerForImage];
}

- (void)scrollViewDidZoom:(UIScrollView*)scrollView
{

    [self centerForImage];
}

- (void)centerForImage
{

    CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width) ? (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height) ? (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;

    self.imageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
        self.scrollView.contentSize.height * 0.5 + offsetY);
}

@end
