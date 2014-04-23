//
//  AWRulerView.m
//  GitGutter
//
//  Created by Allen Wu on 4/22/14.
//  Copyright (c) 2014 Allen Wu. All rights reserved.
//

#import "AWRulerView.h"

@implementation AWRulerView

- (id)initWithScrollView:(NSScrollView *)scrollView orientation:(NSRulerOrientation)orientation {
  self = [super initWithScrollView:scrollView orientation:orientation];
  if (self) {
    
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
  
  NSLog(@"%@", NSStringFromRect(dirtyRect));
  
  [[NSColor redColor] set];
  NSRectFill(dirtyRect);
}

@end
