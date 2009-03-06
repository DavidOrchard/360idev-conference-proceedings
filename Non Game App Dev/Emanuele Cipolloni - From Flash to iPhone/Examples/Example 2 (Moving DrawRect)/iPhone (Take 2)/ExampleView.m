#import "ExampleView.h"

@implementation ExampleView

#pragma mark Init
// Init
// ==========================================================================
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		mouseDown = false;
		
		touchPoint = CGPointZero;
		
		zMod = 1.0;
		
		lastSpacing = 0.0;
		
		// start timer
		myTimer = [[NSTimer timerWithTimeInterval:.04 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES] retain];
		[[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
	}
	
    return self;
}

-(void) zoomIn {
	zMod += 1;
}

-(void) zoomOut{
	zMod -= 1;
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
	} else if([allTouches count]==2) {
		UITouch *touch0 = [[allTouches allObjects] objectAtIndex:0];
		UITouch *touch1 = [[allTouches allObjects] objectAtIndex:1];
		CGFloat spacing = 
		[self eucledianDistanceFromPoint:[touch0 locationInView:self] 
								 toPoint:[touch1 locationInView:self]];
		
		lastSpacing = spacing;
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	
	if([allTouches count]==1){
		lastTouch = [touches anyObject];	
		
		touchPoint = [lastTouch locationInView:self];
	} else if ([allTouches count]==2){
		UITouch *touch0 = [[allTouches allObjects] objectAtIndex:0];
		UITouch *touch1 = [[allTouches allObjects] objectAtIndex:1];
		CGFloat spacing = 
		[self eucledianDistanceFromPoint:[touch0 locationInView:self] 
								 toPoint:[touch1 locationInView:self]];
		
		if(lastSpacing > spacing) [self zoomOut];
		else [self zoomIn];
		
		lastSpacing = spacing;
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseDown = NO;
}

#pragma mark Timer
// Timer
// ==========================================================================
- (void)timerFired:(NSTimer *)timer{

	// this tells it to redraw by calling drawRect again, never call drawRect directly
	[self setNeedsDisplay];
}

#pragma mark Drawing
// Drawing
// ==========================================================================
- (void)drawRect:(CGRect)rect {
	
	context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
		
	//Draw the rectangle
	CGContextAddRect(context, CGRectMake(touchPoint.x,touchPoint.y,100 + zMod,100 + zMod));
	
	[[UIColor whiteColor] setFill];
	CGContextDrawPath(context, kCGPathFill);
}

#pragma mark Math
//------------------------------------------------------------------------------
- (CGFloat) eucledianDistanceFromPoint:(CGPoint)from toPoint:(CGPoint)to {
    float dX = to.x - from.x;
    float dY = to.y - from.y;
    
    return sqrt(dX * dX + dY * dY);
}

@end
