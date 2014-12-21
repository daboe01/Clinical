@import <AppKit/CPControl.j>
@import "WidgetSimpleString.j"

@implementation CPString(CappusanceFix)
-(id) rawString
{
    return self;
}
@end

@implementation WidgetCappusance : WidgetSimpleString 
{
    id value1 @accessors;
    id value2 @accessors;
    id value3 @accessors;
}

- (id)view
{
    var parameter=[_myVisitValue valueForKeyPath:"visit_procedure.procedure_full.widgetparameters"];
	[CPBundle loadGSMarkupData:parameter externalNameTable:[CPDictionary dictionaryWithObject:self forKey:"CPOwner"] localizableStringsTable:nil inBundle:nil tagMapping:nil];
	return _myView;
}
-(void) setValue1
{
    [self setObjectValue:[self objectValue]]
}
-(void) setObjectValue:(id)aValue
{
    [self setValue1:[aValue objectForKey:"value1"]];
    [self setValue2:[aValue objectForKey:"value2"]];
    [self setValue3:[aValue objectForKey:"value3"]];
}
-(id) objectValue
{
    return @{"value1": value1, "value2": value2, "value3": value3};
}

@end

