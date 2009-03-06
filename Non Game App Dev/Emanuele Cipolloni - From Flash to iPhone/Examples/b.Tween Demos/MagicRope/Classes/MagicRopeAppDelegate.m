//
//  OffTestAppDelegate.m
//  OffTest
//
//  Created by Emanuele Cipolloni on 11/10/2008.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MagicRopeAppDelegate.h"
#include "eyeGT_App.h"
#import <Foundation/NSRunLoop.h>

@implementation MagicRopeAppDelegate

@synthesize window;

#define pidBOTTOMBANNER 5000

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	
	struct CGRect rect = CGRectMake(0.0f, 20.0f, 320.0f, 460.0f); 
	
	_canvasView = [[CanvasView alloc] initWithFrame: rect];
	
	screenSurface = _canvasView.pixels;
	
	[window addSubview: _canvasView ];
	
	// Override point for customization after app launch	
    [window makeKeyAndVisible];
	
	eyeGT_App_Init();
	
	timer = [ NSTimer scheduledTimerWithTimeInterval:1.0/60.0 
													 target: self 
													 selector: @selector(handleTimer:) 
													 userInfo: nil 
													 repeats: YES ];
	
	}

- (void)dealloc {
	eyeGT_App_End();
	
	[window release];
	[super dealloc];
}

- (void) handleTimer: (NSTimer *) timer {
	BOOL processedEvent;
	
	eyeGT_App_RenderFrame(&dirtyRect);
	
	cgdirtyRect = CGRectMake(dirtyRect.xmin, dirtyRect.ymin, dirtyRect.xmax, dirtyRect.ymax);
	
	processedEvent = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
}

@end
