#import <Foundation/Foundation.h>
#import "Option.h"

@interface None : Option <Option>
+ (Option *)none;
@end