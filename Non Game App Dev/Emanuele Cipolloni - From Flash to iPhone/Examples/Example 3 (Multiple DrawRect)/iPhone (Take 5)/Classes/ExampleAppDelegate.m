#import "ExampleAppDelegate.h"
#import "ExampleView.h"
#import "ContainerView.h"

@implementation ExampleAppDelegate


- (void) applicationDidFinishLaunching:(UIApplication *)application {
	
    mWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	

	ContainerView *container = [[[ContainerView alloc] initWithFrame:
							 [[UIScreen mainScreen] applicationFrame]] autorelease];

	
	
	ExampleView *lnView1 = [[[ExampleView alloc] initWithFrame:
 							CGRectMake(0, 0, 100, 100)] autorelease];
						
	[lnView1 setRectColor:[UIColor whiteColor]];
	
	ExampleView *lnView2 = [[[ExampleView alloc] initWithFrame:
							 CGRectMake(30, 30, 100, 100)] autorelease];

	[lnView2 setRectColor:[UIColor redColor]];

   	ExampleView *lnView3 = [[[ExampleView alloc] initWithFrame:
							 CGRectMake(60, 60, 100, 100)] autorelease];
	
	[lnView3 setRectColor:[UIColor greenColor]];

	[mWindow addSubview:container];

	[container addSubview:lnView1];
	[container addSubview:lnView2];
	[container addSubview:lnView3];
	
    [mWindow makeKeyAndVisible];
}

- (void) dealloc {
	[mWindow release];
	[super dealloc];
}


@end
