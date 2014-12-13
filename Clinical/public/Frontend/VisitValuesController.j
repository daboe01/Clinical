@import <AppKit/CPControl.j>
@import "WidgetSimpleString.j"

@implementation VisitValuesController : CPObject
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

