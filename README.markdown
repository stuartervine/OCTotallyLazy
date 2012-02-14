## Funcky - Functional extensions to Objective-C.

Funcky is a framework that adds functional behaviour to Objective C collection objects.

### Examples

These exclude any imports and use the Funcky base type of Sequence or LazySequence, eager methods are available on NSArray, NSSet and NSDictionary.

    [sequence(@"one", @"two", @"three", nil) head]; //outputs @"one".
    [sequence(@"one", @"two", @"three", nil) headOption]; //outputs [Some some:@"one"]
    [sequence(@"one", @"two", @"three", nil) tail]; //outputs sequence(@"two", @"three", nil)
    [sequence(num(3), num(2), num(1), nil) take:2]; //outputs sequence(num(3), num(2), nil)
    [sequence(num(3), num(2), num(1), nil) takeWhile:FY_greaterThan(2)]; //outputs sequence(num(3), nil)
    
    