#import "ExampleView.h"

@implementation ExampleView

#pragma mark Init
// Init
// ==========================================================================
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		mouseDown = false;
		
		touchPoint = CGPointZero;
		
		rotAngle = 0.0;
				
		bunny = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 180.0f)] autorelease];
		
		[bunny setImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Joey" ofType:@"png" inDirectory:@"/"]] retain]];	
		
		[self addSubview:bunny];
		
		bunny.center = CGPointMake(160.0, 230.0);
		
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
	
	if([allTouches count] == 1){
		mouseDown = YES;
		lastTouch = [touches anyObject];
		
		touchPoint = [lastTouch locationInView:self];
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	
	if([allTouches count]==1){
		lastTouch = [touches anyObject];	
		
		touchPoint = [lastTouch locationInView:self];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseDown = NO;
}

#pragma mark Timer
// Timer
// ==========================================================================
- (void)timerFired:(NSTimer *)timer{

	if (bunny)
	{
		rotAngle += 0.1;
		
		if (rotAngle > 360.0)
		{
			rotAngle = 0.0;
		}
		
		bunny.transform = CGAffineTransformMakeRotation(rotAngle);
	}

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
	CGContextAddRect(context, CGRectMake(touchPoint.x,touchPoint.y,100,100));
	
	[[UIColor whiteColor] setFill];
	CGContextDrawPath(context, kCGPathFill);
}
@end
