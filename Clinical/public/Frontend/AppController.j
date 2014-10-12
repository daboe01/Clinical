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

@implementation CPButtonBar(addbutton)
- (CPButton) addButtonWithImageName:(CPString) aName target:(id) aTarget action:(SEL) aSelector
{   var sendimage=[[CPImage alloc] initWithContentsOfFile: [CPString stringWithFormat:@"%@/%@", [[CPBundle mainBundle] resourcePath], aName]];
    var newbutton = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 35, 25)];
    [newbutton setBordered:NO];
    [newbutton setImage:sendimage];
    [newbutton setImagePosition:CPImageOnly];
    [newbutton setTarget:aTarget];
    [newbutton setAction:aSelector];
    [self setButtons: [[self buttons] arrayByAddingObject:newbutton] ];
    return newbutton;
}
@end

@implementation FSArrayController(targetaction)
- (void) reload:(id)sender
{   [self reload];
}
@end


@implementation CPNull(length)
-(unsigned) length {return 0;}
@end

@implementation CPDate(shortDescription)
- (CPString)shortDescription
{
    return [CPString stringWithFormat:@"%04d-%02d-%02d", self.getFullYear(), self.getMonth() + 1, self.getDate()];
}
- (id)initWithShortString:(CPString)description
{
    var format = /(\d{4})-(\d{2})-(\d{2})/,
        d = description.match(new RegExp(format));
    return new Date(d[1], d[2] - 1, d[3]);
}
- (CPString)stringValue
{
    return [self shortDescription]
}
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
	id      trialPropAnnotationsController;
	id	billingsController;
	id	accountsController;
	id	transactionsController;
	id	personnelCostsController;
	id	balancedController;
	id	proceduresCatController;
	id	proceduresVisitController;
	id	groupPersonnelController;
    id  autocompletionController;

	id	addTXWindow;
	id	accountsTV;
	id	addTxTV;
	id	accountPopover;

	id mainController @accessors;
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
{   [accountPopover close];
    [balancedController reload];
}

-(void) duplicateKoKaVisit: sender
{   var idoldvisit=[visitsController valueForKeyPath: "selection.id"];
    [visitsController insert: self];
    var idnewvisit=[visitsController valueForKeyPath: "selection.id"];
    var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/copyover_koka_visit/"+idoldvisit+"/"+idnewvisit];
    [CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];

    [proceduresVisitController reload];
}

-(void) reorderVisits: sender
{
    var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
    var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/reorder_visits/"+idtrial];
    [CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];
    [visitsController reload];
}
-(void) reloadVisits: sender
{
    [visitsController reload];
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

