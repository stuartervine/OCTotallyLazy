#import <Foundation/Foundation.h>
#import "Mappable.h"
#import "Foldable.h"
#import "Enumerable.h"
#import "Flattenable.h"
@class LazySequence;

@interface Option : NSObject <Mappable, Foldable, Enumerable, Flattenable>
-(id)get;
-(id)getOrElse:(id)other;
-(id)getOrInvoke:(id (^)())funcBlock;
-(LazySequence *)asSequence;
+(id)option:(id)value;
@end

static Option* option(id value) {
    return [Option option:value];
}