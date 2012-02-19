#import <SenTestingKit/SenTestingKit.h>
#import "../main/OCTotallyLazy.h"
#import "Callables.h"

#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface NSDictionaryTest : SenTestCase
@end

@implementation NSDictionaryTest

- (void)testFilterKeys {
    NSDictionary *dict = dictionary(lazySequence(@"key1", @"key2", nil), lazySequence(@"value1", @"value2", nil));
    assertThat([dict filterKeys:TL_equalTo(@"key1")], equalTo([NSDictionary dictionaryWithObject:@"value1" forKey:@"key1"]));
}

- (void)testFilterValues {
    NSDictionary *dict = dictionary(lazySequence(@"key1", @"key2", nil), lazySequence(@"value1", @"value2", nil));
    assertThat([dict filterValues:TL_equalTo(@"value2")], equalTo([NSDictionary dictionaryWithObject:@"value2" forKey:@"key2"]));
}

-(void)testMap {
    NSDictionary *actual = dictionary(lazySequence(@"key1", @"key2", nil), lazySequence(@"value1", @"value2", nil));
    NSDictionary *expected = dictionary(lazySequence(@"KEY1", @"KEY2", nil), lazySequence(@"VALUE1", @"VALUE2", nil));
    assertThat([actual map:^(id key, id value) {
        return array([key uppercaseString], [value uppercaseString], nil);
    }], equalTo(expected));
}

-(void)testMapValues {
    NSDictionary *actual = dictionary(lazySequence(@"key1", @"key2", nil), lazySequence(@"value1", @"value2", nil));
    NSDictionary *expected = dictionary(lazySequence(@"key1", @"key2", nil), lazySequence(@"VALUE1", @"VALUE2", nil));
    assertThat([actual mapValues:[Callables toUpperCase]], equalTo(expected));
}

-(void)testOptionForKey {
    NSDictionary *dict = dictionary(lazySequence(@"key1", @"key2", nil), lazySequence(@"value1", @"value2", nil));
    assertThat([dict optionForKey:@"key1"], equalTo([Some some:@"value1"]));
    assertThat([dict optionForKey:@"no-key"], equalTo([None none]));
}

@end