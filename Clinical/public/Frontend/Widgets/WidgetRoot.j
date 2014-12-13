@import <AppKit/CPControl.j>

@implementation WidgetRoot : CPObject
{

}
+(CPView) viewClass
{	return CPTextField;
}
+(CPArray) listOfViewClasses
{
    return ["WidgetSimpleString", "WidgetOSDI"];
}
@end

