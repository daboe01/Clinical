@import "WidgetTimestamp.j"


@implementation WidgetTOSS : WidgetStopwatch 
{
}

- (void)_calculate
{
    var sum= value3+value4+value5;

    [self willChangeValueForKey:"value1"];
    value1=sum;
    [self didChangeValueForKey:"value1"];
}

- (void)_reverseSetBinding
{
    [super _reverseSetBinding];
    [self _calculate]
}

-(void) setObjectValue:(id)aValue
{
    [super setObjectValue:aValue];
    [self _calculate]
}

@end
