#import "OnemoneySdkPlugin.h"
#if __has_include(<onemoney_sdk/onemoney_sdk-Swift.h>)
#import <onemoney_sdk/onemoney_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "onemoney_sdk-Swift.h"
#endif

@implementation OnemoneySdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOnemoneySdkPlugin registerWithRegistrar:registrar];
}
@end
