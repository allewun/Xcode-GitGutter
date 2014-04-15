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
    
    SEL originalSelector = @selector(annotationAtSidebarPoint:);
    SEL swizzledSelector = @selector(xxx_annotationAtSidebarPoint:);
    
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
  unsigned long long value = 31;//[self xxx_lineNumberForPoint:point];

  NSLog(@"point = %@", NSStringFromPoint(NSPointFromCGPoint(point)));
  NSLog(@"value = %llu", value);

  
  return 31;
}

- (void)xxx_drawLineNumbersInSidebarRect:(struct CGRect)arg1
                           foldedIndexes:(unsigned long long *)arg2
                                   count:(unsigned long long)arg3
                           linesToInvert:(id)arg4
                          linesToReplace:(id)arg5
                        getParaRectBlock:(id)arg6 {

  NSLog(@"******************************");
  NSLog(@"rect           = %@", NSStringFromRect(NSRectFromCGRect(arg1)));
  NSLog(@"foldedIndexes  = %llu", *arg2);
  NSLog(@"count          = %llu", arg3);
  NSLog(@"linesToInvert  = %@", arg4);
  NSLog(@"linesToReplace = %@", arg5);
  NSLog(@"paraRectBlock  = %@", arg6);
  NSLog(@"******************************");
  
  
  [self xxx_drawLineNumbersInSidebarRect:arg1
                           foldedIndexes:arg2
                                   count:arg3
                           linesToInvert:arg4
                          linesToReplace:arg5
                        getParaRectBlock:arg6];
  31;
}

- (id)xxx_annotationAtSidebarPoint:(CGPoint)point {
  id idk = [self xxx_annotationAtSidebarPoint:point];
  
  NSLog(@"idk = %@", [idk class]);
  
  return idk;
  
}

@end


