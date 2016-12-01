//
//  ZQImageModel.h
//  qzc
//
//  Created by jxm apple on 16/8/8.
//  Copyright © 2016年 xinggenji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZQImageBrowserAnimationMode) {
    ZQImageBrowserAnimationModeBack = 0,
    ZQImageBrowserAnimationModeFade = 1
};

@interface ZQImageBrowserModel : NSObject

@property(nonatomic,copy) NSString * url;

@property(nonatomic,strong) UIImageView* thumImageView;

@property (nonatomic, strong)  UIImage * sourceImage;

@property (nonatomic, assign,getter=isAnimation) BOOL animation ;

@property (nonatomic, assign) ZQImageBrowserAnimationMode exitAnimationMode ;

@end
