## Funcky - Functional extensions to Objective-C.

Funcky is a framework that adds functional behaviour to Objective C collection objects.

### Examples

The best place to look for examples is in the test classes for now. Here's a small sample of some of the available functional bits and bobs.

These exclude any imports and use the Funcky base type of Sequence or LazySequence, eager methods are available on NSArray, NSSet and NSDictionary.

    [sequence(@"one", @"two", @"three", nil) head]; //outputs @"one".
    [sequence(@"one", @"two", @"three", nil) headOption]; //outputs [Some some:@"one"]
    [sequence(@"one", @"two", @"three", nil) tail]; //outputs sequence(@"two", @"three", nil)
    [sequence(num(3), num(2), num(1), nil) take:2]; //outputs sequence(num(3), num(2), nil)
    [sequence(num(3), num(2), num(1), nil) takeWhile:FY_greaterThan(2)]; //outputs sequence(num(3), nil)
    
    Lazy Sequences
    
    [lazySequence(num(1), num(2), nil) cycle]; //outputs lazySequence(num(1), num(2), num(1), num(2)....infinity);
    
    