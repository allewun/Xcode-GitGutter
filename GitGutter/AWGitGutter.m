//
//  AWGitGutter.m
//  AWGitGutter
//
//  Created by Allen Wu on 4/5/14.
//    Copyright (c) 2014 Allen Wu. All rights reserved.
//

#import "AWGitGutter.h"
#import <objc/runtime.h>



static NSString * const IDESourceCodeEditorDidFinishSetupNotification = @"IDESourceCodeEditorDidFinishSetup";
static NSString * const IDEEditorDocumentDidChangeNotification = @"IDEEditorDocumentDidChangeNotification";
static NSString * const IDESourceCodeEditorTextViewBoundsDidChangeNotification = @"IDESourceCodeEditorTextViewBoundsDidChangeNotification";


static AWGitGutter *sharedPlugin;

@interface AWGitGutter()
@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation AWGitGutter

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
  NSLog(@"GIT GUTTER LOADED");
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
      
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidFinishSetup:) name:IDESourceCodeEditorDidFinishSetupNotification object:nil];
    }
    return self;
}

- (void)onDidFinishSetup:(NSNotification *)sender {
  NSLog(@"sender = %@", sender);
  
  if (![[sender object] respondsToSelector:@selector(containerView)]) {
    NSLog(@"Could not fetch editor container view");
    return;
  }
  if (![[sender object] respondsToSelector:@selector(scrollView)]) {
    NSLog(@"Could not fetch editor scroll view");
    return;
  }
  if (![[sender object] respondsToSelector:@selector(textView)]) {
    NSLog(@"Could not fetch editor text view");
    return;
  }
  if (![[sender object] respondsToSelector:@selector(sourceCodeDocument)]) {
    NSLog(@"Could not fetch editor document");
    return;
  }
  
  NSLog(@"******* [sender object] = %@", [sender object]);
  
  /* Get Editor Components */
  NSDocument *editorDocument      = [[sender object] performSelector:@selector(sourceCodeDocument)];
  NSView *editorContainerView     = [[sender object] performSelector:@selector(containerView)];
  NSScrollView *editorScrollView  = [[sender object] performSelector:@selector(scrollView)];
  NSTextView *editorTextView      = [[sender object] performSelector:@selector(textView)];
  
  [self logMethods:[sender object]];
  
  NSLog(@"------------------");
  [self printViewHierarchy:[sender object]];
  NSLog(@"==================");
  
  [editorTextView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewWidthSizable | NSViewHeightSizable];
  
  editorTextView.backgroundColor = [NSColor clearColor];
  editorScrollView.backgroundColor = [NSColor blueColor];
  
  // Create gutter
  CGFloat width = 200;
  
  NSRect gutterRect = NSMakeRect(editorContainerView.bounds.size.width - width,
                                 0,
                                 width,
                                 editorScrollView.bounds.size.height);
  NSView* gutterView = [[NSView alloc] initWithFrame:gutterRect];
  gutterView.layer.backgroundColor = [NSColor redColor].CGColor;
  
  NSLog(@"editorDocument = %@", editorDocument);
  NSLog(@"editorContainerView = %@", editorContainerView);
  NSLog(@"editorScrollView = %@", editorScrollView);
  NSLog(@"editorTextView = %@", editorTextView);
  NSLog(@"gutterView = %@", gutterView);
  
  [editorContainerView addSubview:gutterView];
}

- (void)printViewHierarchy:(id)view {
  NSLog(@"%@", [view description]);
  
  
  
  for (id subview in [view subviews]) {
    [self printViewHierarchy:subview];
  }
}

- (void)logMethods:(id)object {
  unsigned int methodCount = 0;
  
  // List the methods of the class instance "myClass"
  Method* methods = class_copyMethodList([object class], &methodCount);
  for (int i=0; i<methodCount; i++)
  {
    char buffer[256];
    SEL name = method_getName(methods[i]);
    char *returnType = method_copyReturnType(methods[i]);
    NSLog(@"Method: (%s) %@", returnType, NSStringFromSelector(name));

    free(returnType);
    // self, _cmd + any others
//    unsigned int numberOfArguments = method_getNumberOfArguments(methods[i]);
//    for(int j=0; j<numberOfArguments; j++)
//    {
//      method_getArgumentType(methods[i], j, buffer, 256);
//      NSLog(@"The type of argument %d is %s", j, buffer);
//    }
  }
  free(methods);
}


- (void) logProperties:(id)object {
 
 NSLog(@"----------------------------------------------- Properties for object %@", object);
 
 @autoreleasepool {
   unsigned int numberOfProperties = 0;
   objc_property_t *propertyArray = class_copyPropertyList([object class], &numberOfProperties);
   for (NSUInteger i = 0; i < numberOfProperties; i++) {
     objc_property_t property = propertyArray[i];
     NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
     NSLog(@"Property %@ Value: %@", name, [object valueForKey:name]);
   }
   free(propertyArray);
 }
 NSLog(@"-----------------------------------------------");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
