#import "MemoisedSequence.h"

@implementation MemoisedSequence {
    NSMutableArray *memory;
}

+ (Sequence *)with:(id <Enumerable>)enumerable {
    return [[[MemoisedSequence alloc] initWith:enumerable] autorelease];
}

- (Sequence *)initWith:(id <Enumerable>)enumerator {
    self = [super initWith:enumerator];
    if (self) {
        memory = [[NSMutableArray array] retain];
    }
    return self;
}

- (NSEnumerator *)toEnumerator {
    return [MemoisedEnumerator with:[super toEnumerator] memory:memory];
}

- (void)dealloc {
    [memory release];
    [super dealloc];
}

@end