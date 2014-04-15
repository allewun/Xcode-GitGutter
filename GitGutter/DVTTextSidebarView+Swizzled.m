//
//  DVTTextSidebarView+Swizzled.m
//  GitGutter
//
//  Created by Allen Wu on 4/15/14.
//  Copyright (c) 2014 Allen Wu. All rights reserved.
//

#import "DVTTextSidebarView+Swizzled.h"
#import <objc/runtime.h>
#import <Cocoa/Cocoa.h>

@implementation DVTTextSidebarView (Swizzled)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(lineNumberForPoint:);
    SEL swizzledSelector = @selector(xxx_lineNumberForPoint:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
      class_replaceMethod(class,
                          swizzledSelector,
                          method_getImplementation(originalMethod),
                          method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  });
}

- (unsigned long long)xxx_lineNumberForPoint:(CGPoint)point {
  unsigned long long value = [self xxx_lineNumberForPoint:point];
  NSLog(@"swizzled");
  NSLog(@"point = %@", NSStringFromPoint(NSPointFromCGPoint(point)));
  NSLog(@"value = %llu", value);

  
  return value;
}

@end


