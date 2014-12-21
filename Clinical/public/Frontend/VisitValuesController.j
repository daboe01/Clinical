@import <AppKit/CPControl.j>
@import "Widgets/WidgetSimpleString.j"

// todo:
// unbind upon window close
// groups by tabs
// zwischenueberschriften

@implementation VisitValuesController : CPObject  // shouldn't this be a windowcontroller?
{
    CPWindow _window;

}
+(CPArray) listOfViewClasses
{
    return ["WidgetSimpleString", "WidgetOSDI"];
}

var LABEL_WIDTH     = 200;
var LABEL_HEIGHT    =  23;
var INTERITEM_SPACE =  20;

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
    [_window setTitle:"eCRF for "+[aVisit valueForKeyPath:"patient.name"]+" visit: "+[aVisit valueForKeyPath:"visit.name"]];

// <!> fixme: add scrollview(s) inside a tabview
    var i, l=[visitProcedureValues count];
    var cursor_values= CGPointMake(LABEL_WIDTH, INTERITEM_SPACE);
    var cursor_labels= CGPointMake( INTERITEM_SPACE, INTERITEM_SPACE);
    for(i=0; i<l; i++)
    {
         var currentProcedureValue=[visitProcedureValues objectAtIndex:i];
         var className=[currentProcedureValue valueForKeyPath:"visit_procedure.procedure_full.widgetclassname"];
         if (!className) continue;
         var newWidgetClass=[CPClassFromString(className) class];
         var widgetSize=[newWidgetClass size];
         var newWidget=[[newWidgetClass alloc] initWithVisitValue:currentProcedureValue];
         [[_window contentView] addSubview:[newWidget viewWithFrame:CGRectMake(cursor_values.x, cursor_values.y, widgetSize.width, widgetSize.height)]];
         var newLabel=[[CPTextField alloc] initWithFrame:CGRectMake(cursor_labels.x, cursor_labels.y+ (widgetSize.height-LABEL_HEIGHT)/2, LABEL_WIDTH, LABEL_HEIGHT)];
         [newLabel setStringValue: [currentProcedureValue valueForKeyPath:"visit_procedure.procedure_full.name"] ];
         [[_window contentView] addSubview:newLabel];
         cursor_values.y+= widgetSize.height + INTERITEM_SPACE;
         cursor_labels.y+= widgetSize.height + INTERITEM_SPACE;
    }
    [_window makeKeyAndOrderFront:self]
}

@end

