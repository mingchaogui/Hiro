#import "HiroPlugin.h"
#if __has_include(<hiro/hiro-Swift.h>)
#import <hiro/hiro-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "hiro-Swift.h"
#endif

@implementation HiroPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHiroPlugin registerWithRegistrar:registrar];
}
@end
