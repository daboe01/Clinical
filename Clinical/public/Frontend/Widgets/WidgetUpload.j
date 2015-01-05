@import <AppKit/CPControl.j>
@import "WidgetCappusance.j"

var _sharedUploadManager;

@implementation WidgetUpload : WidgetCappusance 
{
	id queueController @accessors;
	id myCuploader @accessors;
	id tableView;
	id uploadWindow;
}

@end

