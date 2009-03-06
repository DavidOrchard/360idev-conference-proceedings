#import <UIKit/UIKit.h>


@interface ExampleView : UIView {
	NSTimer* myTimer;

	CGContextRef context;
	UITouch *lastTouch;
	
	CGPoint touchPoint;
	
	BOOL mouseDown;
	
	float lastSpacing;
	float zMod;
}

- (CGFloat) eucledianDistanceFromPoint:(CGPoint)from toPoint:(CGPoint)to;
-(void)zoomIn;
-(void)zoomOut;

@end
