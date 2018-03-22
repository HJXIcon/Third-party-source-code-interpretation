//
//  JXPhotoPreviewCell.m
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoPreviewCell.h"
#import "JXPhotoBrowserConst.h"
#import "JXPhotoModel.h"
#import "JXPhotoPreView.h"

@interface JXPhotoPreviewCell()

@end

@implementation JXPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI{
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, JXScreenW, JXScreenH)];
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView = contentScrollView;
    [self.contentView addSubview:contentScrollView];
    
    JXPhotoPreView *imageView = [[JXPhotoPreView alloc] init];
    _photoPreView = imageView;
    imageView.previewCell = self;
    [self.contentScrollView addSubview:imageView];
}

- (void)setPhotoModel:(JXPhotoModel *)photoModel{
    _photoModel = photoModel;
    _photoPreView.photo = photoModel;
}



@end
