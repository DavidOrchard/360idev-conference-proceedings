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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "eyeGTTypes.h"



void updateScreen();

U8* screenSurface;
CGRect cgdirtyRect;

@interface CanvasView : UIView 
{
	CGContextRef	bm_ctx;
	CGImageRef		img;
	void			*pixels;
	uint32_t		width,
					height,
					rowBytes;
	
	int				initGraphics;

	SFLOAT			CurrScale;
	SFLOAT			CurrDistance;

	SFLOAT			CurrAngle;
	
	CGPoint			location;
	CGPoint			previousLocation;
	Boolean			firstTouch;
	Boolean			touched;
}

@property (nonatomic, readonly) void *pixels;

@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;
@property(nonatomic, readonly) Boolean touched;


@end
