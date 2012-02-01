#import <Foundation/Foundation.h>
#import "Option.h"

@interface Some : Option <Option>
+ (Option *)some:(id)value;
@end