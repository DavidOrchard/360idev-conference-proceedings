#import "ExampleAppDelegate.h"
#import "ExampleView.h"

@implementation ExampleAppDelegate


- (void) applicationDidFinishLaunching:(UIApplication *)application {
	
    mWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	ExampleView *lnView = [[[ExampleView alloc] initWithFrame:
                         [[UIScreen mainScreen] applicationFrame]] autorelease];
	
    [mWindow addSubview:lnView];
    [mWindow makeKeyAndVisible];
}

- (void) dealloc {
	[mWindow release];
	[super dealloc];
}


@end
