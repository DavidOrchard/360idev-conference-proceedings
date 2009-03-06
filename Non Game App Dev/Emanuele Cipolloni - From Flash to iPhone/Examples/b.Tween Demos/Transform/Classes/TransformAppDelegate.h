//
//  OffTestAppDelegate.h
//  OffTest
//
//  Created by Emanuele Cipolloni on 11/10/2008.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScreenView.h"


@interface TransformAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	
	ScreenView *_screenView;
	
	TsRECT dirtyRect;
	
	NSTimer *timer;
}


@property (nonatomic, retain) UIWindow *window;

@end

