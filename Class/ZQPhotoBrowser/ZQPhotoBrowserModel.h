//
//  ZQPhotoBrowserModel.h
//  qzc
//
//  Created by jxm apple on 16/11/28.
//  Copyright © 2016年 xinggenji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZQPhotoBrowserModel : NSObject

@property (nonatomic, copy)  NSString * imageUrl;

@property (nonatomic, copy)  NSString * caption;

@property(nonatomic,copy) UIImage * thumImage;

@property(nonatomic,copy) UIImage * sourceImage;

@end
