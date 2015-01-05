@import <AppKit/CPControl.j>
@import "WidgetCappusance.j"

var _sharedUploadManager;

@implementation WidgetUpload : WidgetCappusance 
{
    id _queueController @accessors(property=queueController);
	id _cuploader;
	id _dropTarget;
	id _vvDocumentsController;
}
- store
{   return [CPApp store].store;
}
-(CPView) view
{   var r=[super view]
    _cuploader =[[Cup alloc] initWithURL:BaseURL+"DBI/vvdocuments/idvisitvalue/"+[_myVisitValue valueForKey:"id"]];
    [self setQueueController:[_cuploader queueController]];
    [_cuploader setDropTarget:_dropTarget];
    [_cuploader setRemoveCompletedFiles:YES];
    [_cuploader setAutoUpload:YES];
    [_cuploader setDelegate:self];

    var myreq=[CPURLRequest requestWithURL:"/DBI/vvdocuments/idvisitvalue/"+[_myVisitValue valueForKey:"id"] +'?session='+ window.G_SESSION];
    [CPURLConnection connectionWithRequest:myreq delegate:self];
    [vvDocumentsController setContent:[[self store] fetchObjectsForURLRequest:myreq inEntity: _vvDocumentsController._entity requestDelegate:nil]];
    return r;
}

- (void)cup:(Cup)aCup uploadDidCompleteForFile:(CupFile)aFile
{
}

@end

