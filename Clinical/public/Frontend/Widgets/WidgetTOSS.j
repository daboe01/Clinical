@import "WidgetTimestamp.j"


@implementation WidgetTOSS : WidgetTimestamp 
{
}

- (void)_calculate
{
    var sum= value3+value4+value5;

    [self willChangeValueForKey:"value6"];
    value6=sum;
    [self didChangeValueForKey:"value6"];
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
