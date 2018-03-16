//
//  YYMemoryCache.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/7.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 YYMemoryCache is a fast in-memory cache that stores key-value pairs.
 In contrast to NSDictionary, keys are retained and not copied.
 The API and performance is similar to `NSCache`, all methods are thread-safe.
 
 YYMemoryCache objects differ from NSCache in a few ways:
 
 * It uses LRU (least-recently-used) to remove objects; NSCache's eviction method
   is non-deterministic.
 * It can be controlled by cost, count and age; NSCache's limits are imprecise.
 * It can be configured to automatically evict objects when receive memory 
   warning or app enter background.
 
 The time of `Access Methods` in YYMemoryCache is typically in constant time (O(1)).
 */
@interface YYMemoryCache : NSObject

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

/** The name of the cache. Default is nil. //缓存名称，默认为nil */
@property (nullable, copy) NSString *name;

/** The number of objects in the cache (read-only) //缓存总数量 */
@property (readonly) NSUInteger totalCount;

/** The total cost of objects in the cache (read-only). //缓存总开销 */
@property (readonly) NSUInteger totalCost;


#pragma mark - Limit
///=============================================================================
/// @name Limit
///=============================================================================

/**
 The maximum number of objects the cache should hold.
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit—if the cache goes over the limit, some objects in the
 cache could be evicted later in backgound thread.
 
 //数量上限，默认为NSUIntegerMax，也就是无上限
 */
@property NSUInteger countLimit;

/**
 The maximum total cost that the cache can hold before it starts evicting objects.
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit—if the cache goes over the limit, some objects in the
 cache could be evicted later in backgound thread.
 //开销上限，默认为NSUIntegerMax，也就是无上限
 */
@property NSUInteger costLimit;

/**
 The maximum expiry time of objects in cache.
 
 @discussion The default value is DBL_MAX, which means no limit.
 This is not a strict limit—if an object goes over the limit, the object could 
 be evicted later in backgound thread.
 //缓存时间上限，默认为DBL_MAX，也就是无上限
 */
@property NSTimeInterval ageLimit;

/**
 The auto trim check time interval in seconds. Default is 5.0.
 
 @discussion The cache holds an internal timer to check whether the cache reaches 
 its limits, and if the limit is reached, it begins to evict objects.
 
//清理超出上限之外的缓存的操作间隔时间，默认为5s
 */
@property NSTimeInterval autoTrimInterval;

/**
 If `YES`, the cache will remove all objects when the app receives a memory warning.
 The default value is `YES`.
 
 //收到内存警告时是否清理所有缓存，默认为YES
 */
@property BOOL shouldRemoveAllObjectsOnMemoryWarning;

/**
 If `YES`, The cache will remove all objects when the app enter background.
 The default value is `YES`.
 
 //app进入后台是是否清理所有缓存，默认为YES
 */
@property BOOL shouldRemoveAllObjectsWhenEnteringBackground;

/**
 A block to be executed when the app receives a memory warning.
 The default value is nil.
 
 //收到内存警告的回调block
 */
@property (nullable, copy) void(^didReceiveMemoryWarningBlock)(YYMemoryCache *cache);

/**
 A block to be executed when the app enter background.
 The default value is nil.
 
 //进入后台的回调block
 */
@property (nullable, copy) void(^didEnterBackgroundBlock)(YYMemoryCache *cache);

/**
 If `YES`, the key-value pair will be released on main thread, otherwise on
 background thread. Default is NO.
 
 @discussion You may set this value to `YES` if the key-value object contains
 the instance which should be released in main thread (such as UIView/CALayer).
 
 //缓存清理是否在后台进行，默认为NO
 */
@property BOOL releaseOnMainThread;

/**
 If `YES`, the key-value pair will be released asynchronously to avoid blocking 
 the access methods, otherwise it will be released in the access method  
 (such as removeObjectForKey:). Default is YES.
 
 //缓存清理是否异步执行，默认为YES
 */
@property BOOL releaseAsynchronously;


#pragma mark - Access Methods
///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 Returns a Boolean value that indicates whether a given key is in cache.
 
 @param key An object identifying the value. If nil, just return `NO`.
 @return Whether the key is in cache.
 
 //是否包含某个缓存
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 Returns the value associated with a given key.
 
 @param key An object identifying the value. If nil, just return nil.
 @return The value associated with key, or nil if no value is associated with key.
 
 //获取缓存对象
 */
- (nullable id)objectForKey:(id)key;

/**
 Sets the value of the specified key in the cache (0 cost).
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 @discussion Unlike an NSMutableDictionary object, a cache does not copy the key 
 objects that are put into it.
 
 //写入缓存对象
 */
- (void)setObject:(nullable id)object forKey:(id)key;

/**
 Sets the value of the specified key in the cache, and associates the key-value 
 pair with the specified cost.
 
 @param object The object to store in the cache. If nil, it calls `removeObjectForKey`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 @param cost   The cost with which to associate the key-value pair.
 @discussion Unlike an NSMutableDictionary object, a cache does not copy the key
 objects that are put into it.
 
 //写入缓存对象，并添加对应的开销
 */
- (void)setObject:(nullable id)object forKey:(id)key withCost:(NSUInteger)cost;

/**
 Removes the value of the specified key in the cache.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 
 //移除某缓存
 */
- (void)removeObjectForKey:(id)key;

/**
 Empties the cache immediately.
 
 //移除所有缓存
 */
- (void)removeAllObjects;


#pragma mark - Trim
///=============================================================================
/// @name Trim
///=============================================================================

/**
 Removes objects from the cache with LRU, until the `totalCount` is below or equal to
 the specified value.
 @param count  The total count allowed to remain after the cache has been trimmed.
 
 //清理缓存到指定个数
 */
- (void)trimToCount:(NSUInteger)count;

/**
 Removes objects from the cache with LRU, until the `totalCost` is or equal to
 the specified value.
 @param cost The total cost allowed to remain after the cache has been trimmed.
 
 //清理缓存到指定开销
 */
- (void)trimToCost:(NSUInteger)cost;

/**
 Removes objects from the cache with LRU, until all expiry objects removed by the
 specified value.
 @param age  The maximum age (in seconds) of objects.
 
 //清理缓存时间小于指定时间的缓存
 */
- (void)trimToAge:(NSTimeInterval)age;

@end

NS_ASSUME_NONNULL_END
