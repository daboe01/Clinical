/*
 * Cappuccino frontend for augclinical
 *
 * Created by daboe01 on Sep, 2013.
 * Copyright 2013, All rights reserved.
 *
 *
 */

/////////////////////////////////////////////////////////

HostURL=""
BaseURL=HostURL+"/";

/////////////////////////////////////////////////////////

@import <Foundation/CPObject.j>
@import <AppKit/AppKit.j>
@import <Renaissance/Renaissance.j>
@import "OperationsController.j"
@import "AdminController.j"
@import "UploadManager.j"
@import "TableViewControl.j"
@import "CalendarController.j"



@implementation SessionStore : FSStore 


-(CPURLRequest) requestForAddressingObjectsWithKey: aKey equallingValue: (id) someval inEntity:(FSEntity) someEntity
{	var request = [CPURLRequest requestWithURL: [self baseURL]+"/"+[someEntity name]+"/"+aKey+"/"+someval+"?session="+ window.G_SESSION];
	return request;
}
-(CPURLRequest) requestForFuzzilyAddressingObjectsWithKey: aKey equallingValue: (id) someval inEntity:(FSEntity) someEntity
{	var request = [CPURLRequest requestWithURL: [self baseURL]+"/"+[someEntity name]+"/"+aKey+"/like/"+someval+"?session="+ window.G_SESSION];
	return request;
}
-(CPURLRequest) requestForAddressingAllObjectsInEntity:(FSEntity) someEntity
{	return [CPURLRequest requestWithURL: [self baseURL]+"/"+[someEntity name]+"?session="+ window.G_SESSION ];
}

@end

@implementation CPNull(length)
-(unsigned) length {return 0;}
@end

@implementation AppController : CPObject
{	id	store @accessors;	

	id	trialsController;
	id	propertiesController;
	id	processesController;
	id	dokusController;
	id	dokusController2;
	id	personnelController;
	id	trialpersonnelController;
	id	groupsController;
	id	groupsControllerAll;
	id	rolesController;
	id	statesController;
	id	doctagsController;
	id	propertiesCatController;
	id	groupassignmentController;
	id	personnelPropCatController;
	id	personnelPropController;
	id	patientsController;
	id	patientVisitsController;
	id	visitsController;
	id	visitDatesController;
	id	statusController;
	id	tagesinfosController;
	id  trialPropAnnotationsController;
	id	billingsController;
	id	accountsController;
	id	transactionsController;
	id	personnelCostsController;
	id	balancedController;
	id	proceduresCatController;
	id	proceduresVisitController;
	id	groupPersonnelController;

	id	addTXWindow;
	id	accountsTV;
	id	addTxTV;
	id	accountPopover;

	id mainController @accessors;
	id	searchTerm @accessors;
}

-(CPString) uploadURL
{
	return HostURL+"/upload/"+[trialsController valueForKeyPath: "selection.id"];
}

// this is to make the currently GUI controller globally available (to get access to e.g. scale)
- mainController
{	return [[CPApp mainWindow] delegate] || mainController;
}

- (void) applicationDidFinishLaunching:(CPNotification)aNotification
{	store=[[SessionStore alloc] initWithBaseURL: HostURL+"/DBI"];
	[CPBundle loadRessourceNamed: "model.gsmarkup" owner:self];
	var mainFile="Operations.gsmarkup";
	var re = new RegExp("t=([^&#]+)");
	var m = re.exec(document.location);
	if(m) mainFile=m[1];
	document.title=mainFile;
	[CPBundle loadRessourceNamed: mainFile owner: self ];
	[[[CPApp mainWindow] delegate] _performPostLoadInit];
}

-(void) delete:sender
{	[[[CPApp keyWindow] delegate] delete:sender];
}

-(void) unsetReferenceVisit:sender
{
	[[visitsController selectedObject] setValue: [CPNull null] forKey:"idreference_visit"];
}

// Konto-stuff (hat keinen eigenen controller)

-(void) makeKorrekturbuchung: sender
{
	if( !accountPopover)
	{	 accountPopover=[CPPopover new];
		[accountPopover setDelegate:self];
		[accountPopover setAnimates:YES];
		[accountPopover setBehavior: CPPopoverBehaviorApplicationDefined ];
		[accountPopover setAppearance: CPPopoverAppearanceMinimal];
		var myViewController=[CPViewController new];
		[accountPopover setContentViewController: myViewController];
		[myViewController setView: [addTXWindow contentView]];
	
	}
	var sel=[[accountsTV selectedRowIndexes] firstIndex];
	var rect= [accountsTV _rectOfRow: sel checkRange:NO];
	[accountPopover showRelativeToRect:rect ofView: accountsTV preferredEdge: nil];
	[[addTxTV window] makeFirstResponder: addTxTV]	
}

-(void) closeKorrekturbuchung: sender
{	[accountPopover close];
	[[accountsController selectedObject] willChangeValueForKey:"balanced"];
	 [accountsController._entity._relations makeObjectsPerformSelector:@selector(_invalidateCache)];
	[[accountsController selectedObject] didChangeValueForKey:"balanced"];

}

-(void) setSearchTerm: aTerm
{
	searchTerm=aTerm
	if(aTerm && aTerm.length)
	{	[trialsController setFilterPredicate: [CPPredicate predicateWithFormat:"fulltext CONTAINS %@", aTerm.toLowerCase()]];
	} else [trialsController setFilterPredicate: nil];

-(void) duplicateKoKaVisit: sender
{	var idoldvisit=[visitsController valueForKeyPath: "selection.id"];
	[visitsController insert: self];
	var idnewvisit=[visitsController valueForKeyPath: "selection.id"];
	var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/copyover_koka_visit/"+idoldvisit+"/"+idnewvisit];
	[CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];
	[[visitsController selectedObject] willChangeValueForKey:"procedures"];
	 [visitsController._entity._relations makeObjectsPerformSelector:@selector(_invalidateCache)];
	[[visitsController selectedObject] didChangeValueForKey:"procedures"];
}


// FIXME: this stuff leaks...
-(void) runPersonnel: sender
{   [[CPApp mainWindow] close];
    [CPBundle loadRessourceNamed: "Personnel.gsmarkup" owner:self];
}
-(void) runAccounts: sender
{   [[CPApp mainWindow] close];
    [CPBundle loadRessourceNamed: "Accounts.gsmarkup" owner:self];
}
-(void) runAdmin: sender
{   [[CPApp mainWindow] close];
    [CPBundle loadRessourceNamed: "Admin.gsmarkup" owner:self];
}
-(void) runOperations: sender
{   [[CPApp mainWindow] close];
    [CPBundle loadRessourceNamed: "Operations.gsmarkup" owner:self];
}

@end


