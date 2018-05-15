//
//  ViewController.m
//  JXSegmentPager
//
//  Created by HJXICon on 2018/5/14.
//  Copyright © 2018年 beiyugame. All rights reserved.
//

#import "ViewController.h"
#import "JXSegmentPageController.h"
#import "TableViewController.h"
#import "CollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 40)];
    [btn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 160, 80, 40)];
    [btn1 addTarget:self action:@selector(customAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"customAction" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    
}

- (IBAction)pushAction:(UIButton *)sender {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
    flowLayout.headerReferenceSize = CGSizeZero;
    CollectionViewController *collectionVC = [[CollectionViewController alloc]initWithCollectionViewLayout:flowLayout];
    JXSegmentPageController *pageVc = [[JXSegmentPageController alloc]initWithControllers:[[TableViewController alloc]init],collectionVC,[[ViewController alloc]init], nil];
    
    
    // your code
    pageVc.segmentMiniTopInset = 64;
    if (@available(iOS 11.0, *)) {
        pageVc.segmentMiniTopInset = 84;
    }
    pageVc.headerHeight = 200;
    pageVc.segmentHeight = 44;
//    pageVc.freezenHeaderWhenReachMaxHeaderHeight = YES;
    [self.navigationController pushViewController:pageVc animated:YES];
}
- (IBAction)customAction:(UIButton *)sender {
    
    [self.navigationController pushViewController:[[TableViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSString *)segmentTitle{
    return @"Controller";
}

@end
