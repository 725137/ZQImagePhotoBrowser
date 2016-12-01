//
//  MainVC.m
//  Demo
//
//  Created by jxm apple on 16/11/30.
//  Copyright © 2016年 zq. All rights reserved.
//

#import "MainVC.h"
#import "ViewController.h"
#import "ZQPhoto.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
  
    UIBarButtonItem * test = [[UIBarButtonItem alloc]initWithTitle:@"aaaa" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
    
    self.toolbarItems = @[test];
    
    //模拟设置状态栏颜色
    self.navigationController.toolbar.barTintColor = [UIColor redColor];
    //模拟设置导航标题色
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.navigationController setToolbarHidden:NO];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 ) {
        ViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VC1ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1 ){
        
        [self showPhtoDemo];
        
    }
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

-(void) showPhtoDemo {
    
    ZQPhotoBrowserVC * bvc = [[ZQPhotoBrowserVC alloc]init];

    
    
    
    ZQPhotoBrowserModel * model1 = [ZQPhotoBrowserModel new];
    model1.imageUrl = @"http://img3.cache.netease.com/photo/0001/2016-12-01/C76H7UJ300AO0001.jpg";
    model1.caption = @"当地时间2016年11月30日，美国华盛顿，美国总统奥巴马于白宫会见2016诺贝尔化学奖获得者弗雷泽·斯托达特于，物理奖获得者J·迈克尔·科斯特利兹，经济学奖获得者奥利弗·哈特";
    
    ZQPhotoBrowserModel * model2 = [ZQPhotoBrowserModel new];
    model2.imageUrl = @"http://img3.cache.netease.com/photo/0001/2016-12-01/C76E1EI300AP0001.jpg";
    model2.caption = @"2016年11月30日消息，深圳，11月25日，一篇名为《罗一笑，你给我站住》的文章刷爆朋友圈。然而，网上开始出现大量质疑，称患癌女童事件是一场“带血的营销”，是一场借病炒作。处于风口浪尖中的罗尔，面对外界的种种质疑给予了回应";
    
    
    ZQPhotoBrowserModel * model3 = [ZQPhotoBrowserModel new];
    model3.imageUrl = @"http://img3.cache.netease.com/photo/0001/2016-12-01/900x600_C76E1F7K00AP0001.jpg";
    model3.caption = @"罗尔发文表示，目前笑笑所需要的医药费已经足够，请停止公众号赞赏和其他捐助。11月30日上午，深圳市小铜人金融服务有限公司相关负责人回应：据不完全统计，仅30日凌晨腾讯开通的捐款通道，已收到捐赠200余万；按照小铜人金服承诺的，将实现50万元的捐赠。“近日，我们会对外公布捐款明细等内容，谣言将不攻自破。”该公司同时表示，目前深圳市民政部门已经介入，共同监督这笔善款的使用。”2016年11月30日，深圳，罗一笑的父亲罗尔现身回应传言";
    

    ZQPhotoBrowserModel * model4 = [ZQPhotoBrowserModel new];
    model4.imageUrl = @"http://img6.cache.netease.com/photo/0001/2016-12-01/900x600_C76E1G0G00AP0001.jpg";
    model4.caption = @"罗尔在接受采访时最后也表示，自己家庭目前可以负担医治女儿笑笑的花费，网友进日来捐助的费用已经超过女儿治病所需";
    
    NSArray * models = @[model1,model2,model3,model4];

    
    bvc.models = models;
    
    //bvc.toolbarItems = [self tabBarItemsWithProfile:profile];
    bvc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    
    UIBarButtonItem * test11 = [[UIBarButtonItem alloc]initWithTitle:@"bbbbb" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
    
    bvc.toolbarItems = @[test11];
    
    [self.navigationController pushViewController:bvc animated:YES];
}

-(void) rightBtnClick {
    
    NSLog(@"你点击了右上角button...");
}

@end
