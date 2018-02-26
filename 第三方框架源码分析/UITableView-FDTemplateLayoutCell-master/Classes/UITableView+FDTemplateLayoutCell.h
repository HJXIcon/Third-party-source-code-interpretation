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
#import "UITableView+FDKeyedHeightCache.h"
#import "UITableView+FDIndexPathHeightCache.h"
#import "UITableView+FDTemplateLayoutCellDebug.h"


/*！
 提供接口方法方便用户定义cell的数据源，以及帮助我们计算cell的高度
 */
@interface UITableView (FDTemplateLayoutCell)

/// Access to internal template layout cell for given reuse identifier.
/// Generally, you don't need to know these template layout cells.
///
/// @param identifier Reuse identifier for cell which must be registered.
///

/* 为给定的重用标识符访问内部模板布局单元格。
* 一般来说，你不需要知道这些模板布局单元格。
* @param identifier重用必须注册的单元格的标识符。
*/
- (__kindof UITableViewCell *)fd_templateCellForReuseIdentifier:(NSString *)identifier;

/// Returns height of cell of type specifed by a reuse identifier and configured
/// by the configuration block.
///
/// The cell would be layed out on a fixed-width, vertically expanding basis with
/// respect to its dynamic content, using auto layout. Thus, it is imperative that
/// the cell was set up to be self-satisfied, i.e. its content always determines
/// its height given the width is equal to the tableview's.
///
/// @param identifier A string identifier for retrieving and maintaining template
///        cells with system's "-dequeueReusableCellWithIdentifier:" call.
/// @param configuration An optional block for configuring and providing content
///        to the template cell. The configuration should be minimal for scrolling
///        performance yet sufficient for calculating cell's height.
///

/* 返回由重用标识符指定并配置的类型的单元格的高度, 并通过block来配置。
 * 单元格将被放置在固定宽度，垂直扩展的基础上，相对于其动态内容，使用自动布局。
 * 因此，这些必要的单元被设置为自适应，即其内容总是确定它的宽度给定的宽度等于tableview的宽度。
 * @param identifier用于检索和维护模板的字符串标识符cell通过系统方法
 * '- dequeueReusableCellWithIdentifier：'
 * @param configuration用于配置和提供内容的可选块到模板单元格。
 * 配置应该是最小的滚动性能足以计算单元格的高度。
 */

- (CGFloat)fd_heightForCellWithIdentifier:(NSString *)identifier configuration:(void (^)(id cell))configuration;

/// This method does what "-fd_heightForCellWithIdentifier:configuration" does, and
/// calculated height will be cached by its index path, returns a cached height
/// when needed. Therefore lots of extra height calculations could be saved.
///
/// No need to worry about invalidating cached heights when data source changes, it
/// will be done automatically when you call "-reloadData" or any method that triggers
/// UITableView's reloading.
///
/// @param indexPath where this cell's height cache belongs.
///

/* 计算的高度将通过其索引路径进行高速缓存，当需要时返回高速缓存的高度，因此，可以节省大量额外的高度计算。
 * 无需担心数据源更改时使缓存高度无效，它将在调用“-reloadData”或任何触发方法时自动完成UITableView的重新加载。
 * @param indexPath此单元格的高度缓存所属的位置。
 */
- (CGFloat)fd_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration;

/// This method caches height by your model entity's identifier.
/// If your model's changed, call "-invalidateHeightForKey:(id <NSCopying>)key" to
/// invalidate cache and re-calculate, it's much cheaper and effective than "cacheByIndexPath".
///
/// @param key model entity's identifier whose data configures a cell.
///

/* 此方法通过模型实体的标识符缓存高度。
 * 如果你的模型改变，调用“-invalidateHeightForKey:(id <NSCopying>)key”到无效缓存并重新计算，它比“cacheByIndexPath”方便得多。
 * @param key model entity的标识符，其数据配置一个单元格。
 */
- (CGFloat)fd_heightForCellWithIdentifier:(NSString *)identifier cacheByKey:(id<NSCopying>)key configuration:(void (^)(id cell))configuration;

@end

@interface UITableView (FDTemplateLayoutHeaderFooterView)

/// Returns header or footer view's height that registered in table view with reuse identifier.
///
/// Use it after calling "-[UITableView registerNib/Class:forHeaderFooterViewReuseIdentifier]",
/// same with "-fd_heightForCellWithIdentifier:configuration:", it will call "-sizeThatFits:" for
/// subclass of UITableViewHeaderFooterView which is not using Auto Layout.
///
- (CGFloat)fd_heightForHeaderFooterViewWithIdentifier:(NSString *)identifier configuration:(void (^)(id headerFooterView))configuration;

@end

@interface UITableViewCell (FDTemplateLayoutCell)

/// Indicate this is a template layout cell for calculation only.
/// You may need this when there are non-UI side effects when configure a cell.
/// Like:
///   - (void)configureCell:(FooCell *)cell atIndexPath:(NSIndexPath *)indexPath {
///       cell.entity = [self entityAtIndexPath:indexPath];
///       if (!cell.fd_isTemplateLayoutCell) {
///           [self notifySomething]; // non-UI side effects
///       }
///   }
///
/*
* 指示这是仅用于计算的模板布局单元格。
* 当配置单元格时，如果有非UI的副作用，你可能需要这个。
* 类似:
*   - (void)configureCell:(FooCell *)cell atIndexPath:(NSIndexPath *)indexPath {
*       cell.entity = [self entityAtIndexPath:indexPath];
*       if (!cell.fd_isTemplateLayoutCell) {
*           [self notifySomething]; // non-UI side effects
*       }
*   }
*/

@property (nonatomic, assign) BOOL fd_isTemplateLayoutCell;

/// Enable to enforce this template layout cell to use "frame layout" rather than "auto layout",
/// and will ask cell's height by calling "-sizeThatFits:", so you must override this method.
/// Use this property only when you want to manually control this template layout cell's height
/// calculation mode, default to NO.
///

/* 启用以强制此模板布局单元格使用“框架布局”而不是“自动布局”，
 * 并且通过调用“-sizeThatFits：”来询问单元格的高度，所以你必须重写这个方法。
 * 仅当要手动控制此模板布局单元格的高度时才使用此属性
 * 计算模式，默认为NO。
 */
@property (nonatomic, assign) BOOL fd_enforceFrameLayout;

@end
