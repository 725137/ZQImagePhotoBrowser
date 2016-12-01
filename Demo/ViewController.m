//
//  ViewController.m
//  Demo
//
//  Created by jxm apple on 16/11/30.
//  Copyright © 2016年 zq. All rights reserved.
//

#import "ViewController.h"
#import "ZQImage.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property(nonatomic,copy) NSArray * models;
@property(nonatomic,copy) NSArray * headerModels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initModels];
}

-(void) initModels {
    
    ZQImageBrowserModel * headerImageModel = [ZQImageBrowserModel new];
    headerImageModel.url = @"http://h.hiphotos.baidu.com/image/pic/item/55e736d12f2eb93864afcdedd7628535e4dd6feb.jpg";
    headerImageModel.thumImageView = self.headerImageView;
    headerImageModel.exitAnimationMode = ZQImageBrowserAnimationModeFade;

    
    ZQImageBrowserModel * model1 = [ZQImageBrowserModel new];
    model1.url = @"http://h.hiphotos.baidu.com/image/pic/item/6d81800a19d8bc3e26d12124868ba61ea9d34506.jpg";
    model1.thumImageView = self.imageView1;
    
    
    ZQImageBrowserModel * model2 = [ZQImageBrowserModel new];
    model2.url = @"http://t1.mmonly.cc/uploads/allimg/150415/22691-fBtS8O.jpg";
    model2.thumImageView = self.imageView2;
    
    ZQImageBrowserModel * model3 = [ZQImageBrowserModel new];
    model3.url = @"http://t1.mmonly.cc/uploads/allimg/150415/22691-sF0hoc.jpg";
    model3.thumImageView = self.imageView3;
    
    self.models =  [NSArray arrayWithObjects:model1,model2,model3, headerImageModel,nil];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.imageView1 addGestureRecognizer:tap1];
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.imageView2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.imageView3 addGestureRecognizer:tap3];
    

    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.headerImageView addGestureRecognizer:tap4];
    
}

-(void) tap:(UITapGestureRecognizer*)tap {
    
    ZQImageBrowser * browser = [[ZQImageBrowser alloc]initWithFrame:self.view.frame];
    
        browser.models = self.models;
        browser.selectedIndex = tap.view.tag;
        
        [browser longPresshandlerWithBlock:^(ZQImageBrowser *broser, ZQImageBrowserCell *cell) {
            
            NSLog(@"cell:%@",cell);
            
    }];
    
    [browser show];

}

@end
