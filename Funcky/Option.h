#import <Foundation/Foundation.h>
#import "Mappable.h"
#import "Foldable.h"

@protocol Option <Mappable, Foldable>
-(id)get;
@end

@interface Option : NSObject <Option>
+(id)option:(id)value;
@end