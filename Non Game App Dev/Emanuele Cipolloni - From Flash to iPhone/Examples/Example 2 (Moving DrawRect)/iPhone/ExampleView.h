#import <UIKit/UIKit.h>


@interface ExampleView : UIView {
	NSTimer* myTimer;

	CGContextRef context;
	UITouch *lastTouch;
	
	CGPoint touchPoint;
	
	BOOL mouseDown;
}

@end
