//
//  ViewController.m
//  JXHUD
//
//  Created by HJXICon on 2018/2/26.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "ViewController.h"
#import "JXHUD.h"
@interface ViewController ()
@property (nonatomic, strong) JXHUD *hud;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)showDefaultHudAction:(id)sender {
    self.hud = [[JXHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show];
    [self performSelector:@selector(done) withObject:nil afterDelay:2];
}

- (IBAction)showWithLabelAction:(id)sender {
    self.hud = [[JXHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"Hellow world";
    [self.hud show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hud.labelText = @"重新设置labelTextlabelTextlabelTextlabelTextlabelText";
    });
    
    [self performSelector:@selector(done) withObject:nil afterDelay:2];
}

- (IBAction)showOnlyLabelAction:(id)sender {
    self.hud = [[JXHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"Hellow world";
    self.hud.mode = JXHUDModeText;
    [self.hud show];
    [self performSelector:@selector(done) withObject:nil afterDelay:2];
}

- (void)done {
    
    [self.hud hide];
}

@end
