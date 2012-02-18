#import "Enumerable.h"
@protocol Flattenable
- (id<Enumerable>)flatten;
@end