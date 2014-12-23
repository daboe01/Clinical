@import "WidgetCappusance.j"


@implementation WidgetOSDI : WidgetCappusance 
{
}

- _calculateOSDI
{
    var sum= (value1+value2+value3+value4+value5+value6+value7+value8+value9+value10+value11+value12)*25
    var answered=(value1>=0?1:0)+(value2>=0?1:0)+(value3>=0?1:0)+(value4>=0?1:0)+(value5>=0?1:0)+(value6>=0?1:0)+(value7>=0?1:0)+(value8>=0?1:0)+(value9>=0?1:0)+(value10>=0?1:0)+(value11>=0?1:0)+(value12>=0?1:0)

    var osdi=Math.round(sum/answered, 2);
    [self willChangeValueForKey:"value13"];
    value13=osdi;
    [self didChangeValueForKey:"value13"];
}

- (void)_reverseSetBinding
{
    [super _reverseSetBinding];
    [self _calculateOSDI]
}

-(void) setObjectValue:(id)aValue
{
    [super setObjectValue:aValue];
    [self _calculateOSDI]
}

@end

