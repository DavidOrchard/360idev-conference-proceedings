#import "ContainerView.h"

@implementation ContainerView

#pragma mark Init
// Init
// ==========================================================================
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		mouseDown = false;
		
		touchPoint = CGPointZero;
		
		rectView = NULL;
		
		rotAngle = 0.0;
				
		// start timer
		myTimer = [[NSTimer timerWithTimeInterval:.04 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES] retain];
		[[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
	}
	
    return self;
}

#pragma mark Touches
// Touches
// ==========================================================================
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSSet *allTouches = [event allTouches];
	
	if([allTouches count]==1){
		mouseDown = YES;
		lastTouch = [touches anyObject];
		
		touchPoint = [lastTouch locationInView:self];
		
		[self handlesetTouchAtPoint];
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	
	if([allTouches count]==1){
		lastTouch = [touches anyObject];	
		
		touchPoint = [lastTouch locationInView:self];
		
		[self handlemoveTouchAtPoint];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseDown = NO;
	
	[self handlereleaseTouchAtPoint];
	
	rectView = NULL;
}

-(void) handlesetTouchAtPoint {
	for (int i = [self.subviews count]-1; i >= 0 ; i--)
	{
		rectView = [self.subviews objectAtIndex:i];
		
		if (CGRectContainsPoint([rectView frame], touchPoint)) {
			
			[self bringSubviewToFront:rectView];
			
			rectView.center = touchPoint;
			
			[self animategrowTouchAtPoint:rectView];
			
			break;
		}
	}
}

-(void) handlereleaseTouchAtPoint {
	for (int i = [self.subviews count]-1; i >= 0 ; i--)
	{
		rectView = [self.subviews objectAtIndex:i];
		
		if (CGRectContainsPoint([rectView frame], touchPoint)) {

			[self animateshrinkTouchAtPoint:rectView];

			break;
		}
	}
}

-(void) handlemoveTouchAtPoint {
	for (int i = [self.subviews count]-1; i >= 0 ; i--)
	{
		rectView = [self.subviews objectAtIndex:i];
	
		if (CGRectContainsPoint([rectView frame], touchPoint)) {
			
			[self bringSubviewToFront:rectView];
			
			rectView.center = touchPoint;
			break;
		}
	}
}

#pragma mark -
#pragma mark === Animating subviews ===
#pragma mark

#define GROW_ANIMATION_DURATION_SECONDS 0.15    // Determines how fast a piece size grows when it is moved.
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15  // Determines how fast a piece size shrinks when a piece stops moving.

// Scales up a view slightly which makes the piece slightly larger, as if it is being picked up by the user.
- (void)animategrowTouchAtPoint:(UIImageView *)theView {
	// Pulse the view by scaling up, then move the view to under the finger.
	NSValue *touchPointValue = [[NSValue valueWithCGPoint:touchPoint] retain];
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
	theView.transform = transform;
	[UIView commitAnimations];
}

// Scales down the view and moves it to the new position. 
- (void)animateshrinkTouchAtPoint:(UIImageView *)theView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];

	// Set the transform back to the identity, thus undoing the previous scaling effect.
	theView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];	
}


#pragma mark Timer
// Timer
// ==========================================================================
- (void)timerFired:(NSTimer *)timer{

	if (rectView)
	{
		rotAngle += 0.1;
		
		if (rotAngle > 360.0)
		{
			rotAngle = 0.0;
		}
		
		//rectView.transform = CGAffineTransformMakeRotation(rotAngle);
	}
	
	// this tells it to redraw by calling drawRect again, never call drawRect directly
	[self setNeedsDisplay];
}
@end
