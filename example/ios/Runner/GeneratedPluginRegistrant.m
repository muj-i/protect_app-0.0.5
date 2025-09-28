//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

#if __has_include(<protect_app/ProtectAppPlugin.h>)
#import <protect_app/ProtectAppPlugin.h>
#else
@import protect_app;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
  [ProtectAppPlugin registerWithRegistrar:[registry registrarForPlugin:@"ProtectAppPlugin"]];
}

@end
