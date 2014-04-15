# GitGutter for Xcode

Documenting my progress... zero experience with non-iOS Cocoa development.

* 4/14/2014
    * Swizzled some methods of `DVTTextSidebarView` to see what can be modified. Doesn't look like I can do much, next steps: retry to add a new view (NSRuler) next to the original gutter.
    * Found [Xcode Explorer](https://github.com/edwardaux/XcodeExplorer), could be useful
* 4/7/2014
    * Tried to move the editorScrollView to the right to make room for a new sibling view (a new gutter), the frame seems to be tied to the editorContainerView, changing scrollview's frame changes the containerview's frame for some reason. Looked at SCMiniMapView.m's show/hide methods to see how they do it
* 4/6/2014
    * Used [SCXodeMiniMap](https://github.com/stefanceriu/SCXcodeMiniMap) as reference to see how they added stuff
    * Development is annoying... build > quit Xcode > restart Xcode > look at the system log to view print statements
    * Use `tail -f /var/log/system.log` to view NSLog's from the plugin... seems like there's no other way to debug
    * Poked around by printing out/traversing the view hierarchy, printing out the methods and properties that the classes contain. Trying to find the left gutter element.
    * Found the gutter, it's a `DVTTextSidebarView` : `NSRulerView`. Looks like it has a lot of properties. Was able to change the font of the line numbers in the gutter successfully.
    * Next steps: try to add a new `NSRulerView` to the right of the existing one
    * Other useful links:
        * [Xcode 5 Internals](https://opensource.plausible.coop/wiki/display/XC/Xcode+5+Internals#Xcode5Internals-IDEFoundation)
        * [xcode-class-dump](https://github.com/JugglerShu/xcode-class-dump/blob/master/docs/IDEKit.h)
        * [Xcode5-RuntimeHeaders](https://github.com/luisobo/Xcode5-RuntimeHeaders/blob/master/DVTKit/DVTTextSidebarView.h)
        * [Xcode 4 plugin development](https://stackoverflow.com/questions/6316921/xcode-4-plugin-development)
        * [Creating an Xcode4 Plugin](http://www.blackdogfoundry.com/blog/creating-an-xcode4-plugin/)
* 4/5/2014
    * Initialized with [template](https://github.com/kattrali/Xcode5-Plugin-Template) for Xcode5 plugins
    * Installed [UI Browser](http://pfiddlesoft.com/uibrowser/) to try to inspect Xcode's "DOM" (as if I were inspecting Firefox's chrome), not too helpful, but learned that the gutter is a "ruler" element
    * Found some [info](http://stackoverflow.com/a/12478484/3418047) about `class-dump` to reverse engineer Apple's code