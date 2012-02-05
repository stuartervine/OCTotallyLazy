#import "Sequence.h"

@implementation Sequence {
    NSArray *arguments;
}

- (id)initWith:(NSArray *)someArguments {
    self = [super init];
    arguments = [someArguments retain];
    return self;
}

+ (id)with:(NSMutableArray *)someArguments {
    return [[[Sequence alloc] initWith:someArguments] autorelease];
}

- (NSArray *)asArray {
    return arguments;
}

- (NSSet *)asSet {
    return [NSSet setWithArray:arguments];
}


- (void)dealloc {
    [arguments release];
    [super dealloc];
}
@end