//
//  ViewController.m
//  JXAspects
//
//  Created by HJXICon on 2018/4/28.
//  Copyright © 2018年 beiyugame. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+aspects.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self performSelector:@selector(run)];
}



@end
