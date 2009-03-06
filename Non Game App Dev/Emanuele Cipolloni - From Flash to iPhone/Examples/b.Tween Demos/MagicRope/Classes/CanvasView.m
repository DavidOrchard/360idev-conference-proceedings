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

#import "CanvasView.h"
#include "eyeGT_App.h"

@implementation CanvasView 

@synthesize pixels;

@synthesize  location;
@synthesize  previousLocation;
@synthesize  touched;


static CanvasView *sharedInstance = nil;
void updateScreen() {
	[sharedInstance performSelectorOnMainThread:@selector(updateScreen) withObject:nil waitUntilDone: NO];
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self == [super initWithFrame:frame]) {

		sharedInstance = self;
		
		touched = false;
		
        int w = 320;
        int h = 460;
		
		CGColorSpaceRef			color_space;
		int						depth = 32;
		
		
		[self setOpaque:YES];
		rowBytes		= w*(depth/8);
		pixels			= malloc(h*rowBytes);
		color_space		= CGColorSpaceCreateDeviceRGB();
		bm_ctx			= CGBitmapContextCreate(pixels, w, h, 8, rowBytes, color_space, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault /*kCGImageAlphaPremultipliedFirst*/ /*kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little*/ /*kCGBitmapByteOrder32Host | kCGImageAlphaNoneSkipFirst*/);

		CGColorSpaceRelease(color_space);
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

   return YES;
}


// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*	touch = [[event touchesForView:self] anyObject];
	firstTouch = YES;
	
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	location = [touch locationInView:self];
	
	DoPointerDown(location.x, location.y);
	
	touched = true;
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	UITouch*			touch = [[event touchesForView:self] anyObject];
	
	//Convert touch point from UIView referential to OpenGL one (upside-down flip)
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
	} else {
		location = [touch locationInView:self];

		previousLocation = [touch previousLocationInView:self];
	}
	
	DoPointerMove(location.x, location.y);
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*	touch = [[event touchesForView:self] anyObject];
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
	}
	
	DoPointerUp(location.x, location.y);
	
	touched = false;
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
	touched = false;
	
	DoPointerUp(location.x, location.y);
}
@end
