@import <Foundation/CPObject.j>
@import <AppKit/CPAlert.j>
@import <AppKit/CPUserDefaultsController.j>
@import <Renaissance/Renaissance.j>

@import <Cup/Cup.j>
@import <Cup/CupByteCountTransformer.j>

var _sharedUploadManager;


@implementation UploadManager : CPObject
{	id queueController @accessors;
	id myCuploader @accessors;
	id tableView;
	id uploadWindow;
	var appController @accessors;
}

+ sharedUploadManager
{	if(!_sharedUploadManager)
	{	_sharedUploadManager=[self new];
		_sharedUploadManager.appController= [CPApp delegate];

		 _sharedUploadManager.myCuploader=[[Cup alloc] initWithURL:[_sharedUploadManager.appController uploadURL] ];
		 _sharedUploadManager.queueController=[_sharedUploadManager.myCuploader queueController]
		[CPBundle loadRessourceNamed: "UploadManager.gsmarkup" owner: _sharedUploadManager];
		[_sharedUploadManager.myCuploader setDropTarget: _sharedUploadManager.tableView];
		[_sharedUploadManager.myCuploader setRemoveCompletedFiles: YES];
		[_sharedUploadManager.myCuploader setAutoUpload: YES];
		[_sharedUploadManager.myCuploader setDelegate: _sharedUploadManager];
	}
    [_sharedUploadManager.appController addObserver:_sharedUploadManager forKeyPath: [CPApp delegate]._uploadMode?"personnelController.selection": "trialsController.selection" options:nil context:nil];
	[_sharedUploadManager.myCuploader setURL: [_sharedUploadManager.appController uploadURL]];
	[_sharedUploadManager.uploadWindow makeKeyAndOrderFront:self];
	return _sharedUploadManager;
}

- (void)observeValueForKeyPath: keyPath ofObject: object change: change context: context
{	[_sharedUploadManager.myCuploader setURL: [_sharedUploadManager.appController uploadURL]];
}


- (void)cup:(Cup)aCup uploadDidCompleteForFile:(CupFile)aFile
{
    if( [CPApp delegate]._uploadMode)
    {
        [[CPApp delegate].pdokusController reload];
        [[CPApp delegate].pdokusController2 reload];
    } else
    {   [[CPApp delegate].dokusController reload];
        [[CPApp delegate].dokusController2 reload];
    }
}

@end