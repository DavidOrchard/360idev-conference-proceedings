#import "ExampleAppDelegate.h"
#import "ExampleView.h"

@implementation ExampleAppDelegate


- (void) applicationDidFinishLaunching:(UIApplication *)application {
	
    mWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	ExampleView *lnView1 = [[[ExampleView alloc] initWithFrame:
 							CGRectMake(0, 0, 100, 100)] autorelease];
						
	[lnView1 setRectColor:[UIColor whiteColor]];
	
	ExampleView *lnView2 = [[[ExampleView alloc] initWithFrame:
							 CGRectMake(0, 0, 100, 100)] autorelease];

	[lnView2 setRectColor:[UIColor redColor]];

   	ExampleView *lnView3 = [[[ExampleView alloc] initWithFrame:
							 CGRectMake(0, 0, 100, 100)] autorelease];
	
	[lnView3 setRectColor:[UIColor greenColor]];

	[mWindow addSubview:lnView1];
	[mWindow addSubview:lnView2];
	[mWindow addSubview:lnView3];
	
    [mWindow makeKeyAndVisible];
}

- (void) dealloc {
	[mWindow release];
	[super dealloc];
}


@end
