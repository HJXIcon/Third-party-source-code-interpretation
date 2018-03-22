//
//  ViewController.m
//  JXPhotosView
//
//  Created by HJXICon on 2018/3/20.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "ViewController.h"
#import "JXPhotoBrowser.h"

@interface ViewController ()<JXPhotoBrowserDelegate>
@property (nonatomic, assign) CGFloat progressFloat;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)showAction:(UIButton *)sender {
    
    JXPhotoBrowser *p = [[JXPhotoBrowser alloc]init];
    p.delegate = self;
    p.currentImageIndex = 0;
    p.imageCount = 2;
    [p show];
}

- (UIImage *)photoBrowser:(JXPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    return [UIImage imageNamed:@"1"];
}
@end
