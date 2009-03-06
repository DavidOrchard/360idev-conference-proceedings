#import <UIKit/UIKit.h>


@interface ExampleView : UIView {
	NSTimer* myTimer;

	CGContextRef context;
	UITouch *lastTouch;
	
	CGPoint touchPoint;
	
	UIColor *rectColor; 
	
	BOOL mouseDown;
}

-(void)setRectColor:(UIColor*)ColorName;
@end
