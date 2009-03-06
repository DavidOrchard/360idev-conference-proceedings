//
//  OffTestAppDelegate.m
//  OffTest
//
//  Created by Emanuele Cipolloni on 11/10/2008.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "TransformAppDelegate.h"

#include "iPhone_Routines.h"

@implementation TransformAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	
	struct CGRect rect = CGRectMake(0.0f, 20.0f, 320.0f, 460.0f); 
	
	_screenView = [[ScreenView alloc] initWithFrame: rect];
	
	screenSurface = _screenView.pixels;
	
	[window addSubview: _screenView ];
	
	[_screenView initControls];

	// Override point for customization after app launch	
    [window makeKeyAndVisible];
	
	
	iPhone_Video_Init((char*)[[[NSBundle mainBundle] bundlePath] UTF8String]);
	
	timer = [ NSTimer scheduledTimerWithTimeInterval:1.0/60.0 
													 target: self 
													 selector: @selector(handleTimer:) 
													 userInfo: nil 
													 repeats: YES ];
	
	}

- (void)dealloc {
	iPhone_Video_End();
	
	[window release];
	[super dealloc];
}

- (void) handleTimer: (NSTimer *) timer {
	BOOL processedEvent;

	iPhone_Video_LoadFrame(&dirtyRect);
	
	cgdirtyRect = CGRectMake(dirtyRect.xmin, dirtyRect.ymin, dirtyRect.xmax, dirtyRect.ymax);
	
	processedEvent = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
}

@end
