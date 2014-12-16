@import <AppKit/CPControl.j>
@import "Widgets/WidgetSimpleString.j"

@implementation VisitValuesController : CPObject
{
    CPWindow _window;

}
+(CPView) viewClass
{	return CPTextField;
}
+(CPArray) listOfViewClasses
{
    return ["WidgetSimpleString", "WidgetOSDI"];
}
-(void) orderFrontWindowForVisit:(id) aVisit
{
    [[CPWindow alloc] initWithFrame:CGRectMake(100,100, 500, 500)];
    var visitProcedures=[aVisit valueForKey:"visit.procedures"];
    var visitProcedureValues=[aVisit valueForKey:"values"];
    var i, l=[visitProcedures count];
    for(i=0; i<l; i++)
    {
         var currentProcedure=[visitProcedures objectAtIndex:i];
         var className=[currentProcedure valueForKeyPath:"procedure_full.widgetclassname"];
      //   var newWidget=
    }
}

@end

