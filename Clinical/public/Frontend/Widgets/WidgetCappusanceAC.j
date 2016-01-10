@import <AppKit/CPControl.j>
@import "WidgetSimpleString.j"

@implementation CPString(CappusanceFix)
-(id) rawString
{
    return self;
}
-(id) name
{
    return self;
}
@end

@implementation WidgetStore : FSStore
{
    id _delegate;
}
-(void) writeChangesInObject:(id)obj
{
   [_delegate _reverseSetBinding]
}
@end

var _myStore;
@implementation WidgetCappusanceAC : WidgetSimpleString 
{
    id _myAC;
}
+ initialize
{   _myStore = [WidgetStore new];
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

    _myStore._delegate=self;

	return _myView;
}
-(void)insert:(id)sender
{
    [_myAC insert:sender]
    [self _reverseSetBinding];
}
-(void)remove:(id)sender
{
    [_myAC remove:sender]
    [self _reverseSetBinding];
}
-(void) setObjectValue:(id)aValue
{
    var o= JSON.parse(aValue);
    if (o && [o isKindOfClass:CPArray]){
        var i, l = [o count];
        var a = [];
        var someEntity=_myAC._entity;
        someEntity._store=_myStore;
        for(i=0; i<l; i++)
        {
                var t=[[FSObject alloc] initWithEntity:someEntity];
                [t _setDataFromJSONObject: JSON.parse( o[i] )];
                [a addObject:t];
        }
        [_myAC setContent:a];
    }
}
-(id) objectValue
{
    var ao = [_myAC arrangedObjects];
    var i, l = [ao count];
    var a = [];
    for(i=0; i<l; i++)
    {   var o=[ao objectAtIndex:i];
        
        a.push([ ([o isKindOfClass:FSObject]? [o dictionary]:o) toJSON]);
    }
alert("objectValue "+ JSON.stringify(a))
    return JSON.stringify(a);
}

@end

