@import <AppKit/CPControl.j>
@import "Widgets/WidgetSimpleString.j"

@implementation VisitValuesController : CPObject
{
    CPWindow _window;

}
+(CPArray) listOfViewClasses
{
    return ["WidgetSimpleString", "WidgetOSDI"];
}

-(void) orderFrontWindowForPatientVisit:(id) aVisit
{
    // visitProcedureValues need to be autocreated upon visit insert in DB so we can guarantee existence for binding
	var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/new_ecrf/"+[aVisit valueForKey:"id"]];
	[myreq setHTTPMethod:"POST"];
	[CPURLConnection sendSynchronousRequest:myreq returningResponse: nil];
    [[aVisit._entity relationOfName:"visitvalues"] _invalidateCache];
    var visitProcedureValues=[aVisit valueForKey:"visitvalues" synchronous:YES];

    _window=[[CPWindow alloc] initWithContentRect:CGRectMake(100,100, 500, 500)
                          styleMask:CPTitledWindowMask|CPClosableWindowMask|CPMiniaturizableWindowMask|CPResizableWindowMask];
    var i, l=[visitProcedureValues count];
    var cursor_values= CGPointMake(100, 0);
    var cursor_labels= CGPointMake(  1, 0);
    for(i=0; i<l; i++)
    {
         var currentProcedureValue=[visitProcedureValues objectAtIndex:i];
         var className=[currentProcedureValue valueForKeyPath:"visit_procedure.procedure_full.widgetclassname"];
         if (!className) continue;
         var newWidgetClass=[CPClassFromString(className) class];
         var newLabel=[[CPTextField alloc] initWithFrame: CGRectMake(cursor_labels.x, cursor_labels.y, 100, 23)];
         [newLabel setStringValue: [currentProcedureValue valueForKeyPath:"visit_procedure.procedure_full.name"] ];
         [[_window contentView] addSubview:newLabel];
         var widgetSize=[newWidgetClass size];
         var newWidget=[[newWidgetClass alloc] initWithVisitValue:currentProcedureValue];
         [[_window contentView] addSubview:[newWidget viewWithFrame:CGRectMake(cursor_values.x, cursor_values.y, widgetSize.width, widgetSize.height)]];
         cursor_values.y+= widgetSize.height + 20; //<!> fixme: make symbolic constant
         cursor_labels.y+= widgetSize.height + 20; //<!> fixme: make symbolic constant
    }
    [_window makeKeyAndOrderFront:self]
}

@end

