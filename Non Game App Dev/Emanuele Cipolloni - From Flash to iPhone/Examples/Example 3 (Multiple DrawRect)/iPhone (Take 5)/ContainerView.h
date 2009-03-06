#import <UIKit/UIKit.h>


@interface ContainerView : UIView {
	NSTimer* myTimer;

	CGContextRef context;
	UITouch *lastTouch;
	
	UIView *rectView;
	
	CGPoint touchPoint;
	BOOL mouseDown;
	
	float rotAngle;
}

-(void) handlesetTouchAtPoint;
-(void) handlereleaseTouchAtPoint;
-(void) handlemoveTouchAtPoint;

- (void)animategrowTouchAtPoint:(UIImageView *)theView;
- (void)animateshrinkTouchAtPoint:(UIImageView *)theView;

@end
