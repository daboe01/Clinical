@import <AppKit/CPControl.j>
@import "WidgetCappusance.j"

var _sharedUploadManager;

@implementation WidgetUpload : WidgetCappusance 
{
	id _cuploader;
	id _dropTarget;
}
-(id) initWithVisitValue:(id)aProcedureValue
{
    if( self = [super initWithVisitValue:aProcedureValue])
    {   _cuploader =[[Cup alloc] initWithURL:BaseURL+"/DBI/".[aProcedureValue valueForKey:"id"]]
		[_cuploader setDropTarget:_dropTarget];
		[_cuploader setRemoveCompletedFiles:YES];
		[_cuploader setAutoUpload:YES];
		[_cuploader setDelegate:self];
    }
    return self;
}
- (void)cup:(Cup)aCup uploadDidCompleteForFile:(CupFile)aFile
{
}

@end

