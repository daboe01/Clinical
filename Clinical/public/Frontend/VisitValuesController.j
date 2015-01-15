@import <AppKit/CPControl.j>
@import "Widgets/WidgetSimpleString.j"
@import "Widgets/WidgetCappusance.j"
@import "Widgets/WidgetOSDI.j"
@import "Widgets/WidgetTOSS.j"
@import "Widgets/WidgetTimestamp.j"
@import "Widgets/WidgetUpload.j"

// todo:
// make this a popup instead of a window
// unbind upon window/popup close
// groups by tabs (write -numberOfTabItems and itemsForTabIndex:)

@implementation VisitValuesController : CPViewController
{
    CPWindow _window;
    CPSize   _parentSize;
}

var LABEL_WIDTH     = 200;
var LABEL_HEIGHT    =  15;
var INTERITEM_SPACE =  20;

-(id) initWithParentSize:(CPSize) aSize
{
    if(self = [super init])
    {   _parentSize=aSize;
    }
    return self;
}
-(void) loadView
{
    // visitProcedureValues need to be autocreated upon visit insert in DB so we can guarantee existence for binding
	var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/new_ecrf/"+[_representedObject valueForKey:"id"]];
	[myreq setHTTPMethod:"POST"];
	[CPURLConnection sendSynchronousRequest:myreq returningResponse: nil];
    [[_representedObject._entity relationOfName:"visitvalues"] _invalidateCache];
    var visitProcedureValues=[_representedObject valueForKey:"visitvalues" synchronous:YES];

    _view = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 0, 800, _parentSize.height - 32)];
    [_view setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
    var contentView = [[CPBox alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_view setDocumentView:contentView]

    var i, l=[visitProcedureValues count];
    var valueCursor= CGPointMake(LABEL_WIDTH + INTERITEM_SPACE, INTERITEM_SPACE);
    var labelCursor= CGPointMake(INTERITEM_SPACE, INTERITEM_SPACE);
    var contentRect= [contentView frame]
    for(i=0; i<l; i++)
    {
         var currentProcedureValue=[visitProcedureValues objectAtIndex:i];
         var className=[currentProcedureValue valueForKeyPath:"visit_procedure.procedure_full.widgetclassname"];
         if (!className) continue;
         var newWidgetClass=[CPClassFromString(className) class];
         var newWidget=[[newWidgetClass alloc] initWithVisitValue:currentProcedureValue];
         var newView= [newWidget view];
         [contentView addSubview:newView];
         [newView setFrameOrigin:valueCursor];

         var widgetSize=[newWidget size];
         var newLabel=[[CPTextField alloc] initWithFrame:CGRectMake(labelCursor.x, labelCursor.y+ (widgetSize.height-LABEL_HEIGHT)/2, LABEL_WIDTH, LABEL_HEIGHT)];
         [newLabel setStringValue: [currentProcedureValue valueForKeyPath:"visit_procedure.procedure_full.name"]];
         [contentView addSubview:newLabel];
         valueCursor.y+= widgetSize.height + INTERITEM_SPACE;
         labelCursor.y+= widgetSize.height + INTERITEM_SPACE;
         contentRect.size.height = MAX(contentRect.size.height, valueCursor.y);
         contentRect.size.width = MAX(contentRect.size.width, valueCursor.x + widgetSize.width + INTERITEM_SPACE);
    }
    [contentView setFrame:contentRect];
    [_view scrollToEndOfDocument:self];
}

-(void) popoverDidClose:aPopover
{
    [[_view subviews] enumerateObjectsUsingBlock:(function(anObject, idx, stop) { [CPBinder unbindAllForObject:anObject]})];
    [[_view subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)]; 
    [_view removeFromSuperview]; 

}

@end

