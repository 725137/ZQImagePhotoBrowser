//
//  ZQImageBrowser.h
//  qzc
//
//  Created by jxm apple on 16/8/8.
//  Copyright © 2016年 xinggenji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZQImageBrowserModel;
@class ZQImageBrowser;
@class ZQImageBrowserCell;


typedef void(^LongPressHandlerBlock)(ZQImageBrowser* broser,ZQImageBrowserCell * cell);

@protocol ZQImageBrowserDelegate <NSObject>

-(void) longPresshandler:(ZQImageBrowser*)browser cell:(ZQImageBrowserCell*)cell;

@end

@interface ZQImageBrowser : UIView


@property(nonatomic,assign) NSInteger selectedIndex;

@property(copy,nonatomic) NSArray <ZQImageBrowserModel*> *models;

@property (nonatomic, weak)  id<ZQImageBrowserDelegate> delegate;

-(void) longPresshandlerWithBlock:(LongPressHandlerBlock)block;

-(void) show;

@end
