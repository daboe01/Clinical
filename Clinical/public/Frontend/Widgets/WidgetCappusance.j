@import <AppKit/CPControl.j>
@import "WidgetSimpleString.j"

@implementation CPString(CappusanceFix)
-(id) rawString
{
    return self;
}
@end

// fixme: use runtime interception of unimplemented method to support infinite number of properties
@implementation WidgetCappusance : WidgetSimpleString 
{
    id value1 @accessors;
    id value2 @accessors;
    id value3 @accessors;
    id value4 @accessors;
    id value5 @accessors;
    id value6 @accessors;
    id value7 @accessors;
    id value8 @accessors;
    id value9 @accessors;
    id value10 @accessors;
    id value11 @accessors;
    id value12 @accessors;
    id value13 @accessors;
    id value14 @accessors;
    id value15 @accessors;
    id value16 @accessors;
    id value17 @accessors;
    id value18 @accessors;
    id value19 @accessors;
    id value20 @accessors;
    id value21 @accessors;
    id value22 @accessors;
    id value23 @accessors;
    id value24 @accessors;
    id value25 @accessors;
}

+ (Class)_binderClassForBinding:(CPString)aBinding
{
    return [_CPValueBinder class];
}
- (void)_reverseSetBinding
{
    var binderClass = [[self class] _binderClassForBinding:CPValueBinding],
        theBinding = [binderClass getBinding:CPValueBinding forObject:self];

    [theBinding reverseSetValueFor:@"objectValue"];
}
- (void)_setBinding
{
    var binderClass = [[self class] _binderClassForBinding:CPValueBinding],
        theBinding = [binderClass getBinding:CPValueBinding forObject:self];

    [theBinding setValueFor:@"objectValue"];
}

- (id)view
{
    var parameter=[_myVisitValue valueForKeyPath:"visit_procedure.procedure_full.widgetparameters"];
	[CPBundle loadGSMarkupData:parameter externalNameTable:[CPDictionary dictionaryWithObject:self forKey:"CPOwner"] localizableStringsTable:nil inBundle:nil tagMapping:nil];
    [self bind:CPValueBinding toObject:_myVisitValue withKeyPath:"value_full" options:nil];
	return _myView;
}
-(void) setValue1:(id)aValue
{
    value1 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue2:(id)aValue
{
    value2 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue3:(id)aValue
{
    value3 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue4:(id)aValue
{
    value4 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue5:(id)aValue
{
    value5 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue6:(id)aValue
{
    value6 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue7:(id)aValue
{
    value7 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue8:(id)aValue
{
    value8 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue9:(id)aValue
{
    value9 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue10:(id)aValue
{
    value10 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue11:(id)aValue
{
    value11 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue12:(id)aValue
{
    value12 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue13:(id)aValue
{
    value13 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue14:(id)aValue
{
    value14 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue15:(id)aValue
{
    value15 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue16:(id)aValue
{
    value16 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue17:(id)aValue
{
    value17 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue18:(id)aValue
{
    value18 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue19:(id)aValue
{
    value19 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue20:(id)aValue
{
    value20 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue21:(id)aValue
{
    value21 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue22:(id)aValue
{
    value22 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue23:(id)aValue
{
    value23 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue24:(id)aValue
{
    value24 = aValue;
    [self _reverseSetBinding];
}
-(void) setValue25:(id)aValue
{
    value25 = aValue;
    [self _reverseSetBinding];
}
-(void) setObjectValue:(id)aValue
{
    var o= JSON.parse(aValue);
    if (o){
        [self willChangeValueForKey:"value1"];
        value1=o["value1"];
        [self didChangeValueForKey:"value1"];
        [self willChangeValueForKey:"value2"];
        value2=o["value2"];
        [self didChangeValueForKey:"value2"];
        [self willChangeValueForKey:"value3"];
        value3=o["value3"];
        [self didChangeValueForKey:"value3"];
        [self willChangeValueForKey:"value4"];
        value4=o["value4"];
        [self didChangeValueForKey:"value4"];
        [self willChangeValueForKey:"value5"];
        value5=o["value5"];
        [self didChangeValueForKey:"value5"];
        [self willChangeValueForKey:"value6"];
        value6=o["value6"];
        [self didChangeValueForKey:"value6"];
        [self willChangeValueForKey:"value7"];
        value7=o["value7"];
        [self didChangeValueForKey:"value7"];
        [self willChangeValueForKey:"value8"];
        value8=o["value8"];
        [self didChangeValueForKey:"value8"];
        [self willChangeValueForKey:"value9"];
        value9=o["value9"];
        [self didChangeValueForKey:"value9"];
        [self willChangeValueForKey:"value10"];
        value10=o["value10"];
        [self didChangeValueForKey:"value10"];
        [self willChangeValueForKey:"value11"];
        value11=o["value11"];
        [self didChangeValueForKey:"value11"];
        [self willChangeValueForKey:"value12"];
        value12=o["value12"];
        [self didChangeValueForKey:"value12"];
        [self willChangeValueForKey:"value13"];
        value13=o["value13"];
        [self didChangeValueForKey:"value13"];
        [self willChangeValueForKey:"value14"];
        value14=o["value14"];
        [self didChangeValueForKey:"value14"];
        [self willChangeValueForKey:"value15"];
        value15=o["value15"];
        [self didChangeValueForKey:"value15"];
        [self willChangeValueForKey:"value16"];
        value16=o["value16"];
        [self didChangeValueForKey:"value16"];
        [self willChangeValueForKey:"value17"];
        value17=o["value17"];
        [self didChangeValueForKey:"value17"];
        [self willChangeValueForKey:"value18"];
        value18=o["value18"];
        [self didChangeValueForKey:"value18"];
        [self willChangeValueForKey:"value19"];
        value19=o["value19"];
        [self didChangeValueForKey:"value19"];
        [self willChangeValueForKey:"value20"];
        value20=o["value20"];
        [self didChangeValueForKey:"value20"];
        [self willChangeValueForKey:"value21"];
        value21=o["value21"];
        [self didChangeValueForKey:"value21"];
        [self willChangeValueForKey:"value22"];
        value22=o["value22"];
        [self didChangeValueForKey:"value22"];
        [self willChangeValueForKey:"value23"];
        value23=o["value23"];
        [self didChangeValueForKey:"value23"];
        [self willChangeValueForKey:"value24"];
        value24=o["value24"];
        [self didChangeValueForKey:"value24"];
        [self willChangeValueForKey:"value25"];
        value25=o["value25"];
        [self didChangeValueForKey:"value25"];
    }
}
-(id) objectValue
{
    var o = {"value1": value1, "value2": value2, "value3": value3, "value4": value4, "value5": value5, "value6": value6, "value7": value7, "value8": value8, "value9": value9, "value10": value10,
              "value11": value11, "value12": value12, "value13": value13, "value14": value14, "value15": value15, "value16": value16, "value17": value17, "value18": value18, "value19": value19,
              "value20": value20, "value21": value21, "value22": value22, "value23": value23, "value24": value24, "value25": value25};
    return JSON.stringify(o);
}

@end

