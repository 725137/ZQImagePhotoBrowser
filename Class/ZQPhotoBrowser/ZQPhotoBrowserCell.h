//
//  ZQPhotoBrowserCell.h
//  qzc
//
//  Created by jxm apple on 16/11/28.
//  Copyright © 2016年 xinggenji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZQPhotoBrowserModel;
@class ZQPhotoBrowserCell;

@protocol ZQPhotoBrowserCellDelegate <NSObject>

@optional
-(void) singleTapHandler:(ZQPhotoBrowserCell*) cell;
-(void) longPressHandler:(ZQPhotoBrowserCell*) cell;



@end

@interface ZQPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong)  ZQPhotoBrowserModel * model;

@property (nonatomic, assign,getter=isHidenCaption)  BOOL hidenCaption;

@property (nonatomic, weak)  id<ZQPhotoBrowserCellDelegate> delegate;

@end
