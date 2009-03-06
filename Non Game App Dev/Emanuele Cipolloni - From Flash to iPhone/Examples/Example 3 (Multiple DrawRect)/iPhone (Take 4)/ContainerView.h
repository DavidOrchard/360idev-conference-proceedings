#import <UIKit/UIKit.h>


@interface ContainerView : UIView {
	NSTimer* myTimer;

	CGContextRef context;
	UITouch *lastTouch;
	
	CGPoint touchPoint;
	BOOL mouseDown;
}

-(void) handleTouchAtPoint;

@end
