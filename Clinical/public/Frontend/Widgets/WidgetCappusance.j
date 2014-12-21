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
}

+ (Class)_binderClassForBinding:(CPString)aBinding
{
    return [_CPValueBinder class];
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
    if (value1 !== aValue)
    {
        value1 = aValue;
debugger
        [self setObjectValue:[self objectValue]];
    }
}
-(void) setObjectValue:(id)aValue
{
    var o= JSON.parse(aValue);
    if (o){
        _value1=o["value1"];
        _value2=o["value2"];
        _value3=o["value3"];
    }
}
-(id) objectValue
{
    return [@{"value1": value1, "value2": value2, "value3": value3} toJSON];
}

@end

