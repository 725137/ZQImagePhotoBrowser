//
//  ZQPhotoBrowserVC.m
//  qzc
//
//  Created by jxm apple on 16/11/28.
//  Copyright © 2016年 xinggenji. All rights reserved.
//

#import "ZQPhotoBrowserVC.h"
#import "ZQPhotoBrowserCell.h"
#import "ZQPhotoBrowserModel.h"



#define lightBGColor [UIColor colorWithRed:20/255.0 green:20/255.0 blue:25/255.0 alpha:1]

#define normalBGColor [UIColor blackColor]

@interface ZQPhotoBrowserVC () <UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,ZQPhotoBrowserCellDelegate>

@property(nonatomic,assign) BOOL needHiden;
@property(nonatomic,strong) UICollectionView * collectionView;



@property(nonatomic,copy) UIColor * oldToolBarTinColor;
@property(nonatomic,copy) UIColor * oldToolTinColor;
@property(nonatomic,assign) BOOL oldToolBarHiden;
@property(nonatomic,assign)CGFloat oldToolBarAlpha;

@property(nonatomic,copy) UIColor * oldNavBarTinColor;
@property(nonatomic,copy) UIColor * oldNavTinColor;
@property(nonatomic,assign) BOOL oldNavBarHiden;
@property(nonatomic,assign)CGFloat oldNavAlpha;
@property(nonatomic,assign)CGFloat oldNavBgAlpha;
@property(nonatomic,copy) NSDictionary * oldNavTitleAttributes;

@property(nonatomic,assign)UIStatusBarStyle oldStatusBarStyle;
@property(nonatomic,assign)BOOL oldHidenStatus;

@end

@implementation ZQPhotoBrowserVC

static NSString * const reuseIdentifier = @"PhotoCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void) initNavAndToolBar {
    
    if (self.toolbarItems) {
        self.navigationController.toolbar.barTintColor = lightBGColor;
        self.navigationController.toolbar.tintColor = [UIColor whiteColor];
        [self.navigationController setToolbarHidden:NO animated:NO];
    }else {
        [self.navigationController setToolbarHidden:YES animated:NO];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14], NSFontAttributeName,
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self backupNavAndToolBar:self];
    
    [self initNavAndToolBar];
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    
     [self restoreNavAndToolBar:self.navigationController.topViewController];
    
    [super viewWillDisappear:animated];
}


-(void) backupNavAndToolBar:(UIViewController*)vc {
    
   
    //备份toolBar
    self.oldToolBarTinColor = vc.navigationController.toolbar.barTintColor;
    self.oldToolTinColor = vc.navigationController.toolbar.tintColor;
    self.oldToolBarHiden = vc.navigationController.isToolbarHidden;
    self.oldToolBarAlpha = vc.navigationController.toolbar.alpha;
   
    
    //备份navBar
    self.oldNavAlpha = vc.navigationController.navigationBar.alpha;
    self.oldNavTinColor = vc.navigationController.navigationBar.tintColor;
    self.oldNavBarTinColor = vc.navigationController.navigationBar.barTintColor;
    self.oldNavBgAlpha = [[vc.navigationController.navigationBar subviews] objectAtIndex:0].alpha;
    self.oldNavAlpha = vc.navigationController.navigationBar.alpha;
    self.oldNavTitleAttributes = vc.navigationController.navigationBar.titleTextAttributes;
    
     [vc.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    
    //备份statusBar
    self.oldHidenStatus = [UIApplication sharedApplication].isStatusBarHidden;
    self.oldStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
}

-(void)restoreNavAndToolBar:(UIViewController*)vc {

    [vc.navigationController setToolbarHidden:self.oldToolBarHiden animated:NO];
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UINavigationControllerHideShowBarDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        vc.navigationController.toolbar.barTintColor = self.oldToolBarTinColor;
        vc.navigationController.toolbar.tintColor =   self.oldToolTinColor ;
        vc.navigationController.toolbar.alpha = self.oldToolBarAlpha;
    });
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:self.oldHidenStatus];
    [[UIApplication sharedApplication] setStatusBarStyle:self.oldStatusBarStyle];
    
    vc.navigationController.navigationBar.alpha = self.oldNavAlpha;
    vc.navigationController.navigationBar.tintColor = self.oldNavTinColor;
    vc.navigationController.navigationBar.barTintColor = self.oldNavBarTinColor;
    [[vc.navigationController.navigationBar subviews] objectAtIndex:0].alpha = self.oldNavBgAlpha;
    vc.navigationController.navigationBar.alpha = self.oldNavAlpha;
    vc.navigationController.navigationBar.titleTextAttributes = self.oldNavTitleAttributes;
    
    [[[vc.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:self.oldNavAlpha];
}

-(void) setupUI {
    
    self.navigationController.delegate = self;
    
    UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:collectionLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;

    [self.collectionView registerClass:[ZQPhotoBrowserCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = lightBGColor;
    
    [self.view addSubview:self.collectionView];

    if (self.toolbarItems) {

        self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.toolbar.frame.size.height );
        
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void) setModels:(NSArray<ZQPhotoBrowserModel *> *)models {
    
    _models = models;
    
    if (models.count > 0) {
        self.title = [NSString stringWithFormat:@"%zd/%zd",1,self.models.count];
    }
}

-(void) singleTapHandler:(ZQPhotoBrowserCell*) cell {
    
    self.needHiden = !self.needHiden;

    if (self.needHiden) {
        
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            [self.navigationController.navigationBar setAlpha:0];
            self.collectionView.backgroundColor = normalBGColor;
            if (self.toolbarItems) {
                 [self.navigationController.toolbar setAlpha:0];
            }
           
        } completion:^(BOOL finished) {
            
            [self.navigationController setNavigationBarHidden:YES animated:NO];//会自动显示navbar
             if (self.toolbarItems) {
                  [self.navigationController setToolbarHidden:YES animated:NO];
             }
  
            [[UIApplication sharedApplication] setStatusBarHidden:self.needHiden withAnimation:UIStatusBarAnimationFade];
            
            cell.hidenCaption = self.needHiden;
            
        }];
        
    }else {
        
        [[UIApplication sharedApplication] setStatusBarHidden:self.needHiden withAnimation:UIStatusBarAnimationFade];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UINavigationControllerHideShowBarDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            
            if (self.toolbarItems) {
                [self.navigationController setToolbarHidden:NO animated:NO];
                [self.navigationController.toolbar setAlpha:1];
            }

            [self.navigationController.navigationBar setAlpha:1];
            cell.hidenCaption = self.needHiden;
            
            self.collectionView.backgroundColor = lightBGColor;
        });
    }
    
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZQPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ZQPhotoBrowserModel * model = self.models[indexPath.row];
    
    cell.model = model;
    
    cell.hidenCaption = self.navigationController.navigationBar.isHidden;
    
    cell.delegate = self;
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake( collectionView.frame.size.width , collectionView.frame.size.height );
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



-(void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
     ((ZQPhotoBrowserCell*)cell).hidenCaption = self.navigationController.navigationBar.isHidden;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger selectedIndex = ((scrollView.contentOffset.x) / self.collectionView.frame.size.width);
    self.title = [NSString stringWithFormat:@"%zd/%zd",selectedIndex+1,self.models.count];
}

@end
