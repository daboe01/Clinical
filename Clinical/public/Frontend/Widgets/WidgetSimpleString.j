@import <AppKit/CPControl.j>

@implementation WidgetSimpleString : CPObject // shouldn't this be a viewontroller?
{
    id _myView;
    id _myVisitValue;
}
+ viewClass
{	return CPTextField;
}
+(CGRect) size
{
    return CGSizeMake(60,25);
}

-(id) initWithVisitValue:(id)currentProcedureValue
{
    if( self = [super init])
    {    _myVisitValue = currentProcedureValue;
    }
    return self;
}
- viewWithFrame:(CGRect) myFrame
{
	_myView =[[[[self class] viewClass] alloc] initWithFrame: myFrame];
    [_myView setEditable:YES];
    [_myView setBezeled:YES];
    [_myView bind:CPValueBinding toObject:_myVisitValue withKeyPath:"value_full" options:nil];
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

