//
//  ViewController.m
//  JXRefresh
//
//  Created by HJXICon on 2018/2/27.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "ViewController.h"
#import "JXRefreshNormalHeader.h"
#import "JXRefresh.h"
#import "JXRefreshChiBaoZiHeader.h"
#import "JXRefreshChiBaoZiFooter.h"

@interface ViewController ()
@property (nonatomic, weak) JXRefreshChiBaoZiHeader *header;
@property (nonatomic, weak) JXRefreshChiBaoZiFooter *footer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JXRefreshChiBaoZiHeader *header = [JXRefreshChiBaoZiHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.header endRefreshing];
        });
    }];
    
    header.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    self.header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.jx_header = header;
    
    
    
    JXRefreshChiBaoZiFooter *footer = [JXRefreshChiBaoZiFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.footer endRefreshing];
        });
    }];
    
    self.footer = footer;
//    footer.refreshingTitleHidden = YES;
    self.footer.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    self.tableView.jx_footer = footer;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"index == %ld",indexPath.row];
    
    return cell;
}


@end
