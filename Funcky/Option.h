#import <Foundation/Foundation.h>
#import "Mappable.h"
#import "Foldable.h"

@interface Option : NSObject <Mappable, Foldable>
-(id)get;
+(id)option:(id)value;
@end

static Option* option(id value) {
    return [Option option:value];
}