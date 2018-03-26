//
//  ViewController.m
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "ViewController.h"
#import "JXPhotoBrowser.h"
#import "SDImageCache.h"

@interface ViewController ()<JXPhotoBrowserDataSource>
@property (nonatomic, strong) NSArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SDImageCache sharedImageCache]cleanDisk];
    [[SDImageCache sharedImageCache]clearDisk];
    [[SDImageCache sharedImageCache]clearMemory];
}

- (IBAction)show:(UIButton *)sender {
    
    
    JXPhotoBrowser *p = [JXPhotoBrowser photoBrowser];
    // 1.2 创建图片原图链接数组
    NSMutableArray *originalImageUrls = [NSMutableArray array];
    // 添加图片(原图)链接
    [originalImageUrls addObject:@"http://ww3.sinaimg.cn/large/006ka0Iygw1f6bqm7zukpj30g60kzdi2.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/61b69811gw1f6bqb1bfd2j20b4095dfy.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/54477ddfgw1f6bqkbanqoj20ku0rsn4d.jpg"];
    [originalImageUrls addObject:@"http://ww4.sinaimg.cn/large/006ka0Iygw1f6b8gpwr2tj30bc0bqmyz.jpg"];
    [originalImageUrls addObject:@"http://ww2.sinaimg.cn/large/9c2b5f31jw1f6bqtinmpyj20dw0ae76e.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/536e7093jw1f6bqdj3lpjj20va134ana.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/75b1a75fjw1f6bqn35ij6j20ck0g8jtf.jpg"];
    [originalImageUrls addObject:@"http://ww4.sinaimg.cn/bmiddle/406ef017jw1ec40av2nscj20ip4p0b29.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/86afb21egw1f6bq3lq0itj20gg0c2myt.jpg"];
    self.images = originalImageUrls;
    
    p.sourceImageContainerView = sender;
    p.dataSource = self;
    [p show];
}

- (IBAction)hide:(UIButton *)sender {
    
}

- (NSInteger)photoBrowserCurrentImageIndex:(JXPhotoBrowser *)browser{
    NSInteger index = arc4random_uniform(self.images.count);
    return index;
}

- (NSInteger)photoBrowserImageCount:(JXPhotoBrowser *)browser{
    
    return self.images.count;
}

- (UIImage *)photoBrowser:(JXPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    return [UIImage imageNamed:@"1"];
}


- (NSURL *)photoBrowser:(JXPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return self.images[index];
}

@end
