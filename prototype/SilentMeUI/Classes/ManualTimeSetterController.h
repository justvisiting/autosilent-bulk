#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CGGeometry.h>
#import "BaseController.h"

@interface ManualTimeSetterController : BaseController
{
	NSTimeInterval originalSeconds;
	bool origEnabled;
	UIDatePicker* pickerView;
}
- (ManualTimeSetterController *) init;
@end