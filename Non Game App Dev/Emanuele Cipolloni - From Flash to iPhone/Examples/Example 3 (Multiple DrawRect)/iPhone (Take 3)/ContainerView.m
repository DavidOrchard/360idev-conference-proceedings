#import "ContainerView.h"

@implementation ContainerView

#pragma mark Init
// Init
// ==========================================================================
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		mouseDown = false;
		
		touchPoint = CGPointZero;
				
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
		
		[self handleTouchAtPoint];
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	
	if([allTouches count]==1){
		lastTouch = [touches anyObject];	
		
		touchPoint = [lastTouch locationInView:self];
		
		[self handleTouchAtPoint];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseDown = NO;
}

-(void) handleTouchAtPoint {
	UIView *rectView = NULL;
	
	for (int i = [self.subviews count]-1; i >= 0 ; i--)
	{
		rectView = [self.subviews objectAtIndex:i];
	
		if (CGRectContainsPoint([rectView frame], touchPoint)) {
			rectView.center = touchPoint;
			break;
		}
	}
}

#pragma mark Timer
// Timer
// ==========================================================================
- (void)timerFired:(NSTimer *)timer{

	// this tells it to redraw by calling drawRect again, never call drawRect directly
	[self setNeedsDisplay];
}
@end
