#import <UIKit/UIKit.h>


@interface ExampleView : UIView {
	CGContextRef context;
	UIColor *rectColor; 
}

-(void)setRectColor:(UIColor*)ColorName;
@end
