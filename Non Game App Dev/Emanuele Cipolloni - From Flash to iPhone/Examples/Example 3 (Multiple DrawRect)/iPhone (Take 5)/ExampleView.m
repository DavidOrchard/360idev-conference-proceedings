#import "ExampleView.h"

@implementation ExampleView

#pragma mark Init
// Init
// ==========================================================================
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		rectColor = [UIColor whiteColor];
		
		[self setOpaque:false];
	}
	
    return self;
}

#pragma mark Drawing
// Drawing
// ==========================================================================
- (void)drawRect:(CGRect)rect {
	
	context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
		
	//Draw the rectangle
	CGContextAddRect(context, CGRectMake(0,0,100,100));
	
	[rectColor setFill];
	CGContextDrawPath(context, kCGPathFill);
}

-(void)setRectColor:(UIColor*)ColorName {
	rectColor = ColorName;
}
@end
