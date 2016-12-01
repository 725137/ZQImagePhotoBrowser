//
//  ZQPhotoBrowserCell.m
//  qzc
//
//  Created by jxm apple on 16/11/28.
//  Copyright © 2016年 xinggenji. All rights reserved.
//

#import "ZQPhotoBrowserCell.h"
#import "ZQPhotoBrowserModel.h"
#import "DACircularProgressView.h"
#import "UIImageView+WebCache.h"

@interface ZQPhotoBrowserCell () <UIScrollViewDelegate>

@property(nonatomic,strong) UIImageView * imageView;

@property(nonatomic,strong) UITextView * captionTextView;

@property(nonatomic,strong) UIScrollView * scrollView;

@property (nonatomic, assign) CGRect adJustFrame;

@property (nonatomic, strong) DACircularProgressView* loadingView;

@end

@implementation ZQPhotoBrowserCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

-(void) setupUI {
    
    //显示圈
    self.loadingView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 120.0f)];
    self.loadingView.userInteractionEnabled = NO;
    self.loadingView.thicknessRatio = 0.12;
    self.loadingView.roundedCorners = NO;
    self.loadingView.hidden = YES;
    self.loadingView.center = self.contentView.center;

    
    
    //scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
    
    
    //图片imageview
    self.imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    self.imageView.center = self.scrollView.center;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    self.captionTextView = [[UITextView alloc]init];
    self.captionTextView.textColor = [UIColor whiteColor];
    self.captionTextView.font = [UIFont systemFontOfSize:15];

    self.captionTextView.scrollEnabled = YES;
    self.captionTextView.editable = NO;
    self.captionTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.captionTextView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    
    [self.scrollView addSubview:self.imageView];
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.loadingView];
    [self.contentView addSubview:self.captionTextView];

    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];
    
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [self.scrollView addGestureRecognizer:tap];
    [self.scrollView addGestureRecognizer:longPress];

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
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    self.scrollView.frame = self.contentView.bounds;
    
    CGSize contentSize = self.contentView.frame.size;
    
    
    CGSize captionViewSize =  [self.captionTextView sizeThatFits:contentSize];
    
    CGFloat captionViewX = 0;
    CGFloat captionViewY = 0;
    CGFloat captionViewH = captionViewY;
    
    if (captionViewSize.height <= contentSize.height*0.4) {
        
        captionViewY = contentSize.height - captionViewSize.height;
        
        captionViewH = captionViewSize.height;
        
    }else {
        
        captionViewY = contentSize.height *0.6;
        
        captionViewH = contentSize.height*0.4;
    }


    
    self.captionTextView.frame = CGRectMake(captionViewX, captionViewY, self.contentView.frame.size.width, captionViewH);
    

}


-(void) setModel:(ZQPhotoBrowserModel *)model {
    
    _model = model;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.contentSize = self.bounds.size;
    self.imageView.transform = CGAffineTransformIdentity;
    self.imageView.center = [UIApplication sharedApplication].keyWindow.center;
    
    self.captionTextView.text = model.caption;
    self.captionTextView.hidden = self.isHidenCaption;
    
    [self hideLoadingView];
    

    if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:model.imageUrl]]) {
        
        NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:model.imageUrl]];
        UIImage* image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:key];
        
        self.model.sourceImage = image;
    }
    
    if (model.sourceImage) {
        
        self.imageView.image = model.sourceImage;
        
       self.imageView.frame = [UIScreen mainScreen].bounds;
    }
    else {
        self.imageView.frame = [UIScreen mainScreen].bounds;
        [self downloadImage];
    }

}

-(void) setHidenCaption:(BOOL)hidenCaption {
    
    _hidenCaption = hidenCaption;

    self.captionTextView.hidden = hidenCaption;

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

- (void)downloadImage
{
    CGRect tempFrame = CGRectMake(0, 0, 60, 60);
    self.imageView.frame = tempFrame;
    self.imageView.center = [UIApplication sharedApplication].keyWindow.center;
    self.imageView.clipsToBounds = YES;
    self.imageView.image = self.model.thumImage;
    [self showLoadingView];
    
    @synchronized(self)
    {
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:self.model.thumImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            [self.loadingView setProgress:receivedSize * 1.0 / expectedSize animated:NO];
            
        }
        completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
                                     
            if (!error) {

                self.imageView.image = image;
                self.imageView.frame = self.contentView.bounds;
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
