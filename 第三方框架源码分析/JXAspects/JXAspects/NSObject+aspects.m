//
//  NSObject+aspects.m
//  JXAspects
//
//  Created by HJXICon on 2018/4/28.
//  Copyright © 2018年 beiyugame. All rights reserved.
//

#import "NSObject+aspects.h"
#import <objc/message.h>

@implementation NSObject (aspects)

+ (void)load{
    IMP originalImplementation = class_replaceMethod(self.class, @selector(forwardInvocation:), (IMP)jx_forwardInvocation, "v@:@");
    
}

static void jx_forwardInvocation(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
    NSLog(@"jx_forwardInvocation -- ");
}



@end
