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

-(void) orderFrontWindowForPatientVisit:(id) aVisit
{
    var visitProcedures=[aVisit valueForKeyPath:"visit.procedures"];
    // visitProcedureValues need to be autocreated upon visit insert in DB so we can guarantee existence for binding
	var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/new_ecrf/"+[aVisit valueForKey:"id"]];
	[CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];
    [[CPApp delegate].patientVisitValuesController reload];
    var visitProcedureValues=[aVisit valueForKey:"values"];

    _window=[[CPWindow alloc] initWithContentRect:CGRectMake(100,100, 500, 500)
                          styleMask:CPTitledWindowMask|CPClosableWindowMask|CPMiniaturizableWindowMask|CPResizableWindowMask];
    var i, l=[visitProcedures count];
    var cursor= CGPointMake(0, 0);
    for(i=0; i<l; i++)
    {
         var currentProcedure=[visitProcedures objectAtIndex:i];
         var className=[currentProcedure valueForKeyPath:"procedure_full.widgetclassname"];
         if (!className) continue;
         var newWidgetClass=[CPClassFromString(className) class];
         var widgetSize=[newWidgetClass size];
         var newWidget=[[newWidgetClass alloc] init];
         [[_window contentView] addSubview:[newWidget viewWithFrame:CGRectMake(cursor.x, cursor.y, widgetSize.width, widgetSize.height)]];
         cursor.y+= widgetSize.height + 20; //<!> fixme: symbolic constant
    }
    [_window makeKeyAndOrderFront:self]
}

@end

