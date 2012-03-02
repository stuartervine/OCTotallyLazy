#import <OCTotallyLazy/OCTotallyLazy.h>
#import "GroupedEnumerator.h"


@implementation GroupedEnumerator {
    NSEnumerator *enumerator;
    int groupSize;
}

- (GroupedEnumerator *)initWithEnumerator:(NSEnumerator *)anEnumerator groupSize:(int)aGroupSize {
    self = [super init];
    enumerator = [anEnumerator retain];
    groupSize = aGroupSize;
    return self;
}

- (id)nextObject {
    int position = 0;
    id item;
    NSMutableArray *collect = [NSMutableArray array];
    while(position < groupSize && (item = enumerator.nextObject) != nil) {
        [collect addObject:item];
        position++;
    }

    return (position == 0) ? nil : collect;
}

- (void)dealloc {
    [enumerator release];
    [super dealloc];
}

+ (GroupedEnumerator *)with:(NSEnumerator *)enumerator groupSize:(int)groupSize {
 return [[[GroupedEnumerator alloc] initWithEnumerator:enumerator groupSize:groupSize] autorelease];

}
@end