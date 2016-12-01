//
//  ZQImageBrowser.m
//  qzc
//
//  Created by jxm apple on 16/8/8.
//  Copyright © 2016年 xinggenji. All rights reserved.
//

#import "ZQImageBrowser.h"
#import "ZQImageBrowserCell.h"
#import "ZQImageBrowserModel.h"
#import "SDWebImageManager.h"

@interface ZQImageBrowser () <UICollectionViewDelegate,UICollectionViewDataSource,ZQImageBrowserCellDelegate>

@property (strong,nonatomic) UICollectionView * collectionView;

@property(strong,nonatomic) UIPageControl * pageControl;

@property(nonatomic,copy) LongPressHandlerBlock longPressHandlerBlock;

@end

@implementation ZQImageBrowser


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

-(void) setupUI {
    
    UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:collectionLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.hidesForSinglePage = YES;
    
    CGRect pageFrame = [UIScreen mainScreen].bounds;
    
    pageFrame.origin.y = CGRectGetMaxY(self.bounds) - 44;
    
    pageFrame.size.height = 44;
    
    self.pageControl.frame = pageFrame;

    
    self.backgroundColor = [UIColor clearColor];

    
    [self.collectionView registerClass:[ZQImageBrowserCell class] forCellWithReuseIdentifier:@"ZQImageBrowserCell"];
    
    [self addSubview:self.collectionView];
    
    [self addSubview:self.pageControl];
    
}


-(void) show {
    
    ZQImageBrowserModel * model  = self.models[self.selectedIndex];
    
    model.animation = YES;
    
    self.pageControl.hidden = NO;
    
    self.pageControl.numberOfPages = self.models.count;
    self.pageControl.currentPage = self.selectedIndex;
   
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [window addSubview:self];
    
}

-(void) singleTapHandler:(ZQImageBrowserCell *)cell {
    
    self.pageControl.hidden = YES;
}

-(void)longPressHandler:(ZQImageBrowserCell *)cell {
    
    if ([self.delegate respondsToSelector:@selector(longPresshandler:cell:)]) {
        
        [self.delegate longPresshandler:self cell:cell];
    }
    
    if (self.longPressHandlerBlock) {
        
        self.longPressHandlerBlock(self,cell);
    }
}

-(void) longPresshandlerWithBlock:(LongPressHandlerBlock)block {
    
    self.longPressHandlerBlock = block;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.models.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZQImageBrowserCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ZQImageBrowserCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    ZQImageBrowserModel * model  = self.models[indexPath.row];
    
    cell.model = model;
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake( self.collectionView.frame.size.width , self.collectionView.frame.size.height );
}


-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return  CGFLOAT_MIN;
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = ((scrollView.contentOffset.x) / self.collectionView.frame.size.width);
}

@end
