// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <UIKit/UIKit.h>
/*！
 主要负责cell通过key值进行缓存高度的功能
 */
@interface FDKeyedHeightCache : NSObject
//判断缓存中是否存在key为值的缓存高度
- (BOOL)existsHeightForKey:(id<NSCopying>)key;
//对指定key的cell设置高度为height
- (void)cacheHeight:(CGFloat)height byKey:(id<NSCopying>)key;
//从缓存中获取对应key的cell的高度height值
- (CGFloat)heightForKey:(id<NSCopying>)key;

// Invalidation

//从缓存中删除指定key的cell的值
- (void)invalidateHeightForKey:(id<NSCopying>)key;
//移除缓存中所有的cell的高度缓存值
- (void)invalidateAllHeightCache;
@end

@interface UITableView (FDKeyedHeightCache)

/// Height cache by key. Generally, you don't need to use it directly.
@property (nonatomic, strong, readonly) FDKeyedHeightCache *fd_keyedHeightCache;
@end
