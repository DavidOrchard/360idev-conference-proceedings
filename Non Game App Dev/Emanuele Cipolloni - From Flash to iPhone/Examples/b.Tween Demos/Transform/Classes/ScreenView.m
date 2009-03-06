#include "eyeGT.h"
#include "eyeGTTypes.h"
#include "eyeGTSym.h"

#import "ScreenView.h"
#include "iPhone_Routines.h"

@implementation ScreenView 

@synthesize pixels;

static ScreenView *sharedInstance = nil;
void updateScreen() {
	[sharedInstance performSelectorOnMainThread:@selector(updateScreen) withObject:nil waitUntilDone: NO];
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self == [super initWithFrame:frame]) {

		sharedInstance = self;
		
		
        int w = 320;
        int h = 460;
		
		CGColorSpaceRef		color_space = CGColorSpaceCreateDeviceRGB();

		#if 0
		int					bitspercomponent = 5;
		
		rowBytes			= w * 2; 
		pixels				= malloc(h * rowBytes);
		bm_ctx				= CGBitmapContextCreate(pixels, w, h, bitspercomponent, rowBytes, color_space, kCGBitmapByteOrder16Host | kCGImageAlphaNoneSkipFirst);
		#else
		int					bitspercomponent = 8;
		
		rowBytes			= w * 4;
		pixels				= malloc(h * rowBytes);
		bm_ctx				= CGBitmapContextCreate(pixels, w, h, bitspercomponent, rowBytes, color_space,  /*kCGBitmapByteOrder32Host*/ kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little /*kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst*/ /*kCGBitmapByteOrder32Host | kCGImageAlphaNoneSkipFirst*/);
		#endif
		
		CGColorSpaceRelease(color_space);
		 
		[self setOpaque:YES];
		
		// Set up the ability to track multiple touches.
		[self setMultipleTouchEnabled:YES];

		Touched = false;
	}
	
	return self;
}

- (void)dealloc {
	if (bm_ctx)
		CGContextRelease(bm_ctx);        
	

	[super dealloc];
}

- (void)updateScreen {
	[sharedInstance setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
	CGContextRef	ctx = UIGraphicsGetCurrentContext();
	
	img = CGBitmapContextCreateImage(bm_ctx);
	CGContextDrawImage(ctx, rect, img);
	
	CFRelease(img);
}

- (BOOL)ignoresMouseEvents {

    return NO;
}

- (BOOL)canHandleGestures {

   return NO;
}


// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSUInteger numTaps = [[touches anyObject] tapCount];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	if (numTaps == 1)
	{
		NSUInteger touchCount = 0;
		
		NSSet *touches2 = [event allTouches];
		
		for (UITouch *touch in touches2) {
			
			switch (touchCount)
			{
				case 0: 
				{
					location1 = [touch locationInView:self];
				} break;
					
				case 1: 
				{
					location2 = [touch locationInView:self];
				} break;
			}
			
			touchCount++;
		}
		
		
		if (touchCount == 1)
		{	
			inMouseDown(location1.x, location1.y);
		}
	}
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	//UITouch*			touch = [[event touchesForView:self] anyObject];
	
	NSUInteger touchCount = 0;
	
	NSSet *touches2 = [event allTouches];
	
	for (UITouch *touch in touches2){
		
		switch (touchCount)
		{
			case 0: 
			{
				location1 = [touch locationInView:self];
			} break;
				
			case 1: 
			{
				location2 = [touch locationInView:self];
			} break;
		}
		
		touchCount++;
	}
	
	if (touchCount == 1)
	{	
		inMouseMove(location1.x, location1.y);
	}
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	Touched = false;
	
	inMouseUp(location1.x, location1.y);
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	Touched = false;
	
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
	inMouseUp(location1.x, location1.y);
}
@end
