#import "ExampleView.h"

@implementation ExampleView

#pragma mark Init
// Init
// ==========================================================================
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {		
		// start timer
		myTimer = [[NSTimer timerWithTimeInterval:.04 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES] retain];
		[[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
	}
	
    return self;
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
	CGContextAddRect(context, CGRectMake(0,0,100,100));
		
	[[UIColor redColor] setFill];
	CGContextDrawPath(context, kCGPathFill);
}
@end
