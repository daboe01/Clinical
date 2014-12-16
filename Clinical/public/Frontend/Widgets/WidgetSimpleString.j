@import <AppKit/CPControl.j>

@implementation WidgetSimpleString : CPObject
{
    id _myView;
}
+ viewClass
{	return CPTextField;
}
+(CGRect) size
{
    return CGSizeMake(60,25);
}

- viewWithFrame:(CGRect) myFrame
{
	_myView =[[[[self class] viewClass] alloc] initWithFrame: myFrame];
    [_myView setEditable:YES];
    [_myView setBezeled:YES];
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

