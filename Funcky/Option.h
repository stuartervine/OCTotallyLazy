#import <Foundation/Foundation.h>
#import "Mappable.h"
#import "Foldable.h"
@class Sequence;

@interface Option : NSObject <Mappable, Foldable>
-(id)get;
-(id)getOrElse:(id)other;
-(id)getOrInvoke:(id (^)())funcBlock;
-(Sequence *)asSequence;
+(id)option:(id)value;
@end

static Option* option(id value) {
    return [Option option:value];
}