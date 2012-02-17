## OCTotallyLazy - Functional extensions to Objective-C.

OCTotallyLazy is a framework that adds functional behaviour to Objective C collection objects.

### Examples

The best place to look for examples is in the test classes for now. Here's a small sample of some of the available functional bits and bobs.

These exclude any imports and use the OCTotallyLazy base type of Sequence or LazySequence, eager methods are available on NSArray, NSSet and NSDictionary.

    Eager
    
    [sequence(@"one", @"two", @"three", nil) head]; //outputs @"one".
    [sequence(@"one", @"two", @"three", nil) headOption]; //outputs [Some some:@"one"]
    [sequence(@"one", @"two", @"three", nil) tail]; //outputs sequence(@"two", @"three", nil)
    [sequence(num(3), num(2), num(1), nil) take:2]; //outputs sequence(num(3), num(2), nil)
    [sequence(num(3), num(2), num(1), nil) takeWhile:TL_greaterThan(2)]; //outputs sequence(num(3), nil)
    
    Lazy
    
    [lazySequence(num(1), num(2), nil) cycle]; //outputs lazySequence(num(1), num(2), num(1), num(2)....infinity);
    
### I like it - how do I get it?

So I'm a bit fed up with using 'libraries' that say, just include our source code in your project, or attach our xcode project to your project. So to use this:

- Clone the repo.
- Run

    <OCTotallyLazy_ROOT>/build.sh release
    
- Copy <OCTotallyLazy_Root>/artifacts/OCTotallyLazy.framework to your external libraries folder.
- Import the framework to your project.
- Jobsa good 'un.
    
    