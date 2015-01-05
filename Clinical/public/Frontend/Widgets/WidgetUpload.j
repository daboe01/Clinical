@import <AppKit/CPControl.j>
@import "WidgetCappusance.j"

var _sharedUploadManager;

@implementation WidgetUpload : WidgetCappusance 
{
    id _queueController @accessors(property=queueController);
	id _cuploader;
	id _dropTarget;
}
-(CPView) view
{   var r=[super view]
   _cuploader =[[Cup alloc] initWithURL:BaseURL+"DBI/vvdocuments/idvisitvalue/"+[_myVisitValue valueForKey:"id"]];
    [self setQueueController:[_cuploader queueController]];
    [_cuploader setDropTarget:_dropTarget];
    [_cuploader setRemoveCompletedFiles:YES];
    [_cuploader setAutoUpload:YES];
    [_cuploader setDelegate:self];
// <!> todo:
// load list of uploaded files into a second tableview.
// support download and delete on them
    return r;
}
- (void)cup:(Cup)aCup uploadDidCompleteForFile:(CupFile)aFile
{
}

@end

