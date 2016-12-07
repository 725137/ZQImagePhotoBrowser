# ZQImagePhotoBrowser
简单易用的ios仿微信和网易图片浏览器

## 说明
非常轻巧的图片浏览器,现在市面上的图片浏览器要么写得非常复杂,不利于修改和扩展,要么存在一些问题,
比如影响导航栏,比如超高图片的显示等.所以我自已搞了个图片浏览器,每个浏览器的代码总共只有几百行,清析易懂

##演示图片: (gif 动画下载慢,请稍后...)
 ![image](https://github.com/725137/ZQImagePhotoBrowser/blob/master/browserDemoGif.gif?raw=true)

## 1.ZQImageBrowser
 用于显示类微信那种飞出来又飞回去的图片,继承自UIView,可以方便的加到任何地方,只需要指定原UIImageView,它就可以帮你实现飞来飞去的效果,自带两种动画效果.
 一种是飞来飞去的.一种是用于显示头像的,淡入淡出的效果

### 注意
  info.plist中应该设置View controller-based status bar appearance 为 YES
###示例代码

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


## 1.ZQPhotoBrowser
继承自UIViewController,可以自由设定其导航栏目和toolbar

###示例代码:

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


