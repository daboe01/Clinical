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
    id value1;
    id value2;
    id value3;
}

- (id)viewAtPosition:(CGPoint) myPoint
{
    var parameter=[_myVisitValue valueForKeyPath:"visit_procedure.procedure_full.widgetparameters"];
	[CPBundle loadGSMarkupData:parameter externalNameTable:[CPDictionary dictionaryWithObject:self forKey:"CPOwner"] localizableStringsTable:nil inBundle:nil tagMapping:nil];
    var
	return _myView;
}

-(void) setObjectValue:(id)aValue
{
    [_myView setStringValue:aValue];
}
-(id) objectValue
{
    return [_myView stringValue];
}

@end

