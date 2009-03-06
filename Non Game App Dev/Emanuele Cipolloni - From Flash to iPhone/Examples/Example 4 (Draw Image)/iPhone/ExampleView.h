#import <UIKit/UIKit.h>


@interface ExampleView : UIView {
	NSTimer* myTimer;

	CGContextRef context;
	UITouch *lastTouch;
	
	CGPoint touchPoint;
	
	UIImageView *bunny;
	
	float rotAngle;
	
	BOOL mouseDown;
}

@end
