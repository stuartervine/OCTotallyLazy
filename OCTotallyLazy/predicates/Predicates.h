#import "Types.h"

@interface Predicates : NSObject
+ (PREDICATE)alternate:(BOOL)startState;

+ (PREDICATE)andLeft:(PREDICATE)left withRight:(PREDICATE)right;

+ (PREDICATE)orLeft:(PREDICATE)left withRight:(PREDICATE)right;

+ (PREDICATE)countTo:(int)n;

+ (PREDICATE)containedIn:(NSArray *)existing;

+ (PREDICATE)containsString:(NSString *)toMatch;

+ (PREDICATE)equalTo:(id)comparable;

+ (PREDICATE)everyNth:(int)n;

+ (PREDICATE)greaterThan:(NSNumber *)comparable;

+ (PREDICATE)lessThan:(NSNumber *)comparable;

+ (PREDICATE)lessThanOrEqualTo:(NSNumber *)comparable;

+ (PREDICATE)not:(PREDICATE)predicate;

+ (PREDICATE)startsWith:(NSString *)prefix;

+ (PREDICATE)whileTrue:(PREDICATE)predicate;
@end

extern PREDICATE TL_alternate(BOOL startState);
extern PREDICATE TL_and(PREDICATE left, PREDICATE right);
extern PREDICATE TL_or(PREDICATE left, PREDICATE right);
extern PREDICATE TL_countTo(int n);
extern PREDICATE TL_containedIn(NSArray *existing);
extern PREDICATE TL_containsString(NSString *toMatch);
extern PREDICATE TL_equalTo(id comparable);
extern PREDICATE TL_everyNth(int n);
extern PREDICATE TL_greaterThan(NSNumber *comparable);
extern PREDICATE TL_lessThan(NSNumber *comparable);
extern PREDICATE TL_lessThanOrEqualTo(NSNumber *comparable);
extern PREDICATE TL_not(PREDICATE predicate);
extern PREDICATE TL_startsWith(NSString *prefix);
extern PREDICATE TL_whileTrue(PREDICATE predicate);