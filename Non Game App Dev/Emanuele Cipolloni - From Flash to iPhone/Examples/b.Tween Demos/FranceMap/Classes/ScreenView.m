/*

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

#include "eyeGT.h"
#include "eyeGTTypes.h"
#include "eyeGTSym.h"

#import "ScreenView.h"
#include "iPhone_Routines.h"

@implementation ScreenView 

@synthesize pixels;

@synthesize  location;
@synthesize  previousLocation;
@synthesize  touched;


static ScreenView *sharedInstance = nil;
void updateScreen() {
	[sharedInstance performSelectorOnMainThread:@selector(updateScreen) withObject:nil waitUntilDone: NO];
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self == [super initWithFrame:frame]) {

		sharedInstance = self;
		
		touched = false;
		
        int w = 320;
        int h = 460;
		
		CGColorSpaceRef		color_space = CGColorSpaceCreateDeviceRGB();

		#if 0
		int					bitspercomponent = 5;
		//int					components = CGColorSpaceGetNumberOfComponents(color_space);
		
		rowBytes			= w * 2; 
		pixels				= malloc(h * rowBytes);
		bm_ctx				= CGBitmapContextCreate(pixels, w, h, bitspercomponent, rowBytes, color_space, kCGBitmapByteOrder16Host | kCGImageAlphaNoneSkipFirst);
		#else
		int					bitspercomponent = 8;
		//int					components = CGColorSpaceGetNumberOfComponents(color_space);
		
		rowBytes			= w * 4;
		pixels				= malloc(h * rowBytes);
		bm_ctx				= CGBitmapContextCreate(pixels, w, h, bitspercomponent, rowBytes, color_space,  /*kCGBitmapByteOrder32Host*/ kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little /*kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst*/ /*kCGBitmapByteOrder32Host | kCGImageAlphaNoneSkipFirst*/);
		#endif
		
		CGColorSpaceRelease(color_space);
		 
		[self setOpaque:YES];
	}
	
	return self;
}

- (void)dealloc {
	if (bm_ctx)
		CGContextRelease(bm_ctx);        
	
	//pthread_mutex_destroy(&screenUpdateMutex);
	//pthread_cond_destroy(&screenUpdateLock);

	[super dealloc];
}

- (void)updateScreen {
	[sharedInstance setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
	CGContextRef	ctx = UIGraphicsGetCurrentContext();
	
	//CGContextClipToRect(ctx, cgdirtyRect);
	
	img = CGBitmapContextCreateImage(bm_ctx);
	CGContextDrawImage(ctx, rect, img);
	
	CFRelease(img);
}

- (BOOL)ignoresMouseEvents {

    return NO;
}

- (BOOL)canHandleGestures {

   return YES;
}




// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	firstTouch = YES;
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	location = [touch locationInView:self];
	
	inMouseDown(location.x, location.y);
	
	//location.y = bounds.size.height - location.y;
	
	touched = true;
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	
	//CGRect				bounds = [self bounds];
	UITouch*			touch = [[event touchesForView:self] anyObject];
	
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		//previousLocation.y = bounds.size.height - previousLocation.y;
	} else {
		location = [touch locationInView:self];
	    //location.y = bounds.size.height - location.y;
		previousLocation = [touch previousLocationInView:self];
		//previousLocation.y = bounds.size.height - previousLocation.y;
	}
	
	inMouseMove(location.x, location.y);
	
	// Render the stroke
	//[self renderLineFromPoint:previousLocation toPoint:location];
	
	
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		//previousLocation.y = bounds.size.height - previousLocation.y;
		//[self renderLineFromPoint:previousLocation toPoint:location];
	}
	
	inMouseUp(location.x, location.y);
	
	touched = false;
	
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
	touched = false;
	
	inMouseUp(location.x, location.y);
}


/*
- (void)mouseDown:(struct __GSEvent *)event 
{
    CGPoint point = GSEventGetLocationInWindow(event);

    inMouseDown(point.x, point.y - 48.0);

    [super mouseDown:event];

}
 
- (void)mouseUp:(struct __GSEvent *)event 
{
    CGPoint point = GSEventGetLocationInWindow(event);

    inMouseUp(point.x, point.y - 48.0);

    [super mouseUp:event];
}

- (void)mouseDragged:(struct __GSEvent *)event
{
    CGPoint point = GSEventGetLocationInWindow(event);
    
    inMouseMove(point.x, point.y - 48.0);

	//inChangeBack(((int)point.x) % 255);

	//inChangeCoord(point.x, point.y);

    [super mouseDragged:event];

}

- (void)mouseMoved:(struct __GSEvent *)event
{
    CGPoint point = GSEventGetLocationInWindow(event);

    //inMouseMove(point.x, point.y);

    [super mouseMoved:event];

}

- (void)view:(UIView *)view handleTapWithCount:(int)count event:(struct __GSEvent *)event 
{         
	CGPoint point = GSEventGetLocationInWindow(event);  
	
	if (count == 2)
	{
		inDoubleTap(point.x, point.y  - 48.0);
	}
} 

- (void)gestureStarted:(struct __GSEvent *)event {
    CurrScale = GetCurrentScale();	

    CGPoint left = GSEventGetInnerMostPathPosition(event);
    CGPoint right = GSEventGetOuterMostPathPosition(event);

    CurrDistance = sqrt( ((right.x-left.x) * (right.x-left.x)) + ((right.y-left.y) * (right.y-left.y)));

    CurrAngle = GetCurrentAngle();

    [ self gestureChanged: event ];
}

- (void)gestureEnded:(struct __GSEvent *)event {
}

// data conversion
#define Rad2Deg( rad ) ((double) ((rad) * 180.0L / 3.14159265358979312L))
#define Deg2Rad( deg ) ((double) ((deg) * 3.14159265358979312L / 180.0L))

- (void)gestureChanged:(struct __GSEvent *)event {
    CGPoint left = GSEventGetInnerMostPathPosition(event);
    CGPoint right = GSEventGetOuterMostPathPosition(event);

    SFLOAT newDistance = sqrt( ((right.x-left.x) * (right.x-left.x)) + ((right.y-left.y) * (right.y-left.y)));

   if (newDistance != CurrDistance)
   {
	//Calculate new scaling
	SFLOAT NewScale = (newDistance * CurrScale) / CurrDistance;

	inDoScale(NewScale); 
   }

    SFLOAT newAngle = Rad2Deg(atan2(right.x-left.x, right.y-left.y)); 	

   //if (newAngle != CurrAngle)
   {
	//Calculate new angle
	SFLOAT NewAngle = CurrAngle + newAngle;

	inDoAngle(180-newAngle); 
   }
 }
*/
@end
