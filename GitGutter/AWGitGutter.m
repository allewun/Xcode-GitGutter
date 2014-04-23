//
//  AWGitGutter.m
//  AWGitGutter
//
//  Created by Allen Wu on 4/5/14.
//    Copyright (c) 2014 Allen Wu. All rights reserved.
//

#import "AWGitGutter.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "AWRulerView.h"


static NSString * const IDESourceCodeEditorDidFinishSetupNotification = @"IDESourceCodeEditorDidFinishSetup";
static NSString * const IDEEditorDocumentDidChangeNotification = @"IDEEditorDocumentDidChangeNotification";
static NSString * const IDESourceCodeEditorTextViewBoundsDidChangeNotification = @"IDESourceCodeEditorTextViewBoundsDidChangeNotification";


static AWGitGutter *sharedPlugin;

@interface AWGitGutter()
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) id hook;
@property (nonatomic, strong) id hook2;
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
//      [[NSNotificationCenter defaultCenter] addObserver:self] selector:@selector(notif:) name:NSTextViewWillChangeNotifyingTextViewNotification object:nil];
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
  
  NSLog(@"scrollView address = %@", editorScrollView);

  
  NSTextView *editorTextView      = [[sender object] performSelector:@selector(textView)];
  
//  [self logMethods:[sender object]];
  
  
  NSLog(@"------------------");
  [self printViewHierarchy:editorScrollView level:0];
  NSLog(@"==================");
  
  // hook is now DVTTextSidebarView
  objc_msgSend(self.hook, NSSelectorFromString(@"setLineNumberFont:"), [NSFont fontWithName:@"Arial" size:10]);
  objc_msgSend(self.hook, NSSelectorFromString(@"setSidebarWidth:"), 28.0);
  objc_msgSend(self.hook, NSSelectorFromString(@"setFoldbarWidth:"), 7.0);
  objc_msgSend(self.hook, NSSelectorFromString(@"setLineNumberTextColor:"), [NSColor greenColor]);

  // hook2 is DVTSourceTextView

  [self dumpInfo:[self.hook2 class]];
  
//  NSLog(@"hook2's superclasses:");
//  [self logSuperClasses:self.hook2];
  
  [((NSClipView *)self.hook2) setFrameOrigin:NSMakePoint(30, 50)];
  
  NSScrollView* box = [[NSScrollView alloc] initWithFrame:NSMakeRect(((NSView*)self.hook).frame.size.width, 0, 5, ((NSView*)self.hook).frame.size.height)];
  box.backgroundColor = [NSColor colorWithRed:0 green:1 blue:0 alpha:0.5];
  
  AWRulerView* box2 = [[AWRulerView alloc] init];
  box2.frame = NSMakeRect(((NSView*)self.hook).frame.size.width, 0, 5, ((NSView*)self.hook).frame.size.height);
  
  [editorScrollView addSubview:box2];
  
//  editorContainerView.frame = (CGRect){
//    .origin.x = editorContainerView.frame.origin.x + 100,
//    .origin.y = editorContainerView.frame.origin.y + 100,
//    .size.width = editorContainerView.frame.size.width - 200,
//    .size.height = editorContainerView.frame.size.height - 200
//  };
//  
//  
//  
//  editorScrollView.bounds = (CGRect){
//    .origin.x = editorScrollView.bounds.origin.x + 100,
//    .origin.y = editorScrollView.bounds.origin.y + 100,
//    .size = editorScrollView.bounds.size
////    .size.width = editorScrollView.frame.size.width - 200,
////    .size.height = editorScrollView.frame.size.height - 200
//  };
  
  
  [self dumpInfo:[self.hook class]];
  
  NSLog(@"clientview??? = %@", [self.hook clientView]);
  
//
//  [self logProperties:editorTextView];
//  
//
//  
//  [self logProperties:self.hook];

  
  [editorTextView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewWidthSizable | NSViewHeightSizable];
  
  editorTextView.backgroundColor = [NSColor clearColor];
  editorScrollView.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.5];
  
//  [editorTextView setFrame:NSMakeRect(100, 100, 100, 100)];
  
  NSLog(@"editorDocument = %@", editorDocument);
  NSLog(@"editorContainerView = %@", editorContainerView);
  NSLog(@"editorScrollView = %@", editorScrollView);
  NSLog(@"editorTextView = %@", editorTextView);
  
}

-(void)dumpInfo:(Class)clazz
{
  u_int count;
  
  Ivar* ivars = class_copyIvarList(clazz, &count);
  NSMutableArray* ivarArray = [NSMutableArray arrayWithCapacity:count];
  for (int i = 0; i < count ; i++)
  {
    const char* ivarName = ivar_getName(ivars[i]);
    [ivarArray addObject:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
  }
  free(ivars);
  
  objc_property_t* properties = class_copyPropertyList(clazz, &count);
  NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
  for (int i = 0; i < count ; i++)
  {
    const char* propertyName = property_getName(properties[i]);
    [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
  }
  free(properties);
  
  Method* methods = class_copyMethodList(clazz, &count);
  NSMutableArray* methodArray = [NSMutableArray arrayWithCapacity:count];
  for (int i = 0; i < count ; i++)
  {
    SEL selector = method_getName(methods[i]);
    const char* methodName = sel_getName(selector);
    [methodArray addObject:[NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding]];
  }
  free(methods);
  
  NSDictionary* classDump = [NSDictionary dictionaryWithObjectsAndKeys:
                             ivarArray, @"ivars",
                             propertyArray, @"properties",
                             methodArray, @"methods",
                             nil];
  
  NSLog(@"%@", classDump);
}

- (void)printViewHierarchy:(id)view level:(int)level {
  
  NSMutableString* indentation = [NSMutableString string];
  for (int i = 0; i < level; i++) {
    [indentation appendString:@"    "];
  }
  
  NSLog(@"%@ (%@) %@", indentation, [view class], [view description]);
  
  if ([view isMemberOfClass:[NSClassFromString(@"DVTTextSidebarView") class]]) {
//    [self logMethods:view];
//    [self logProperties:view];
//    [self logSuperClasses:view];
    self.hook = view;
  }
  else if ([view isMemberOfClass:[NSClassFromString(@"DVTSourceTextView") class]]) {
    self.hook2 = view;
    NSLog(@"caught source text view");
  }
  
  for (id subview in [view subviews]) {
    [self printViewHierarchy:subview level:(level+1)];
  }
}

- (void)logSuperClasses:(id)object {
  if ([object isKindOfClass:[NSObject class]]) {
    NSLog(@"[%@]", [object class]);
    [self logSuperClasses:class_getSuperclass([object class])];
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
    unsigned int numberOfArguments = method_getNumberOfArguments(methods[i]);
    for(int j=0; j<numberOfArguments; j++)
    {
      method_getArgumentType(methods[i], j, buffer, 256);
      NSLog(@"The type of argument %d is %s", j, buffer);
    }
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
