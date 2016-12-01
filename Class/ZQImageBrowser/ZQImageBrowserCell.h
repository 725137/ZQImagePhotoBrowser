//
//  ZQImageBrowserCell.h
//  qzc
//
//  Created by jxm apple on 16/8/8.
//  Copyright © 2016年 xinggenji. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZQImageBrowserModel.h"

@class ZQImageBrowserCell;

@protocol ZQImageBrowserCellDelegate <NSObject>

-(void) singleTapHandler:(ZQImageBrowserCell*) cell;

-(void) longPressHandler:(ZQImageBrowserCell*) cell;



@end

@interface ZQImageBrowserCell : UICollectionViewCell

@property(nonatomic,strong) ZQImageBrowserModel * model;

@property (nonatomic, weak)  id<ZQImageBrowserCellDelegate> delegate;

@end
