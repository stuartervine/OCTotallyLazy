## OCTotallyLazy - Functional extensions to Objective-C.

OCTotallyLazy is a framework that adds functional behaviour to Objective C collection objects.

### Examples

The best place to look for examples is in the test classes for now. Here's a small sample of some of the available functional bits and bobs.

These use the base type of Sequence (lazy), eager methods are available on NSArray, NSSet and NSDictionary. They also use the shorthand syntax.

### Import the library

    import <OCTotallyLazy/OCTotallyLazy.h>

### Eager

    [sequence(@"one", @"two", @"three", nil) head]; //outputs @"one".
    [sequence(@"one", @"two", @"three", nil) headOption]; //outputs [Some some:@"one"]

### Lazy

    [sequence(@"one", @"two", nil) cycle]; //outputs sequence(@"one", @"two", @"one", @"two"....infinity);
    [sequence(@"one", @"two", @"three", nil) tail]; //outputs sequence(@"two", @"three", nil)
    [sequence(@"three", @"two", @"one", nil) take:2]; //outputs sequence(@"three", @"two", nil)
    [sequence(num(3), num(2), num(1), nil) takeWhile:TL_greaterThan(2)]; //outputs sequence(num(3), nil)


### Shorthand, for the totally lazy

The above examples are still quite noisy. There is shorthand syntax available too. Include the following above the library import.

    #define TL_SHORTHAND
    #define TL_LAMBDA
    #define TL_LAMBDA_SHORTHAND
    import <OCTotallyLazy/OCTotallyLazy.h>

Then you can do fun stuff such as:

    [sequence(num(1), num(2), num(3), nil) find:not(eqTo(num(1))]; //outputs

### Lambda craziness

Verbose:

    [sequence(@"bob", @"fred", @"wilma", nil) map:^(NSString *item){return [item uppercaseString];}] //outputs sequence(@"BOB", @"FRED", @"WILMA", nil)

A bit more sane:

    [sequence(@"bob", @"fred", @"wilma", nil) map:lambda(s, [s uppercaseString])] //outputs sequence(@"BOB", @"FRED", @"WILMA", nil)

A bit mental (but a bit like scala):

    [sequence(@"bob", @"fred", @"wilma", nil) map:_([_ uppercaseString])] //outputs sequence(@"BOB", @"FRED", @"WILMA", nil)


### I like it - how do I get it?

So I'm a bit fed up with using 'libraries' that say, just include our source code in your project, or attach our xcode project to your project. So to use this:

- Clone the repo.
- Run <CHECKOUT_DIR>/build.sh test
- Run <CHECKOUT_DIR>/build.sh release
- Copy <CHECKOUT_DIR>/artifacts/OCTotallyLazy.framework to your external libraries folder.
- Import the framework to your project.
- Jobsa good 'un.
    
    