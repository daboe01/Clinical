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
{    var request = [CPURLRequest requestWithURL: [self baseURL]+"/"+[someEntity name]+"/"+aKey+"/"+someval+"?session="+ window.G_SESSION];
    return request;
}
-(CPURLRequest) requestForFuzzilyAddressingObjectsWithKey: aKey equallingValue: (id) someval inEntity:(FSEntity) someEntity
{    var request = [CPURLRequest requestWithURL: [self baseURL]+"/"+[someEntity name]+"/"+aKey+"/like/"+someval+"?session="+ window.G_SESSION];
    return request;
}
-(CPURLRequest) requestForAddressingAllObjectsInEntity:(FSEntity) someEntity
{    return [CPURLRequest requestWithURL: [self baseURL]+"/"+[someEntity name]+"?session="+ window.G_SESSION ];
}

@end

// fixme<!> refactor to cappusance
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
- (void) registerWithArrayController:(CPArrayController) aController plusTooltip:(CPString)ptt minusTooltip:(CPString)mtt
{
    [[self buttons][1] bind:CPEnabledBinding toObject:aController withKeyPath:"selectedObjects.@count" options: nil];
    if(ptt)
        [[self buttons][0] setToolTip: ptt]
    if(mtt)
        [[self buttons][1] setToolTip: mtt]
    //<!> fixme add insert and remove actions unless already wired!
}
- (void) registerWithArrayController:(CPArrayController) aController
{
    [self registerWithArrayController:aController plusTooltip:nil minusTooltip:nil]
}

@end

// fixme<!> refactor to cappusance
@implementation FSArrayController(targetaction)
- (void) reload:(id)sender
{   [self reload];
}
@end
@implementation CPDate(shortDescription)
- (CPString)shortDescription
{
    return [CPString stringWithFormat:@"%04d-%02d-%02d", self.getFullYear(), self.getMonth() + 1, self.getDate()];
}
- (CPString)stringValue
{
    return [self shortDescription];
}

- (id)initWithShortString:(CPString)description
{
    var format = /^(\d{4})-(\d{2})-(\d{2}).*/,
        d = description.match(new RegExp(format));
    return new Date(parseInt(d[1], 10), d[2] - 1, parseInt(d[3], 10));
}
+ dateWithShortString:(CPString) astr
{   return astr? [[CPDate alloc] initWithShortString:astr]: nil //[CPDate new];
}
@end


@implementation CPNull(length)
-(unsigned) length {return 0;}
@end

@implementation AppController : CPObject
{   id    store @accessors;    

    id    trialsController;
    id    propertiesController;
    id    processesController;
    id    dokusController;
    id    dokusController2;
    id    pdokusController;
    id    pdokusController2;
    id    personnelController;
    id    personnelEventController;
    id    personnelEventCatController;
    id    trialpersonnelController;
    id    groupsController;
    id    groupsControllerAll;
    id    rolesController;
    id    statesController;
    id    doctagsController;
    id    pdoctagsController;
    id    propertiesCatController;
    id    groupassignmentController;
    id    personnelPropCatController;
    id    personnelPropController;
    id    patientsController;
    id    patientVisitsController;
    id    patientVisitsController2;
    id    visitsController;
    id    visitDatesController;
    id    statusController;
    id    tagesinfosController;
    id    trialPropAnnotationsController;
    id    billingsController;
    id    accountsController;
    id    transactionsController;
    id    personnelCostsController;
    id    balancedController;
    id    proceduresCatController;
    id    proceduresVisitController;
    id    proceduresPersonnelController;
    id    groupPersonnelController;
    id    autocompletionController;
    id    adminButtonBar;
    id    pdocumentsButtonBar;
    id    visitProcsTV;
    id    visitpersoBB;
    id    visitprocBB;
    id    persoEventsTV;
    id    graphicalPicker;

    id    addTXWindow;
    id    accountsTV;
    id    addTxTV;
    id    accountPopover;

    id    mainController @accessors;
    id    _uploadMode;
    id    popover;
	id    addPropsWindow;
	id    addPropsTV;
}

-(CPString) uploadURL
{
    var url=_uploadMode? [personnelController valueForKeyPath: "selection.id"]+"?suffix=p": [trialsController valueForKeyPath: "selection.id"];
    return HostURL+"/upload/"+ url;
}

// this is to make the currently GUI controller globally available (to get access to e.g. scale)
-(id) mainController
{    return [[CPApp mainWindow] delegate] || mainController;
}

- (void) applicationDidFinishLaunching:(CPNotification)aNotification
{    store=[[SessionStore alloc] initWithBaseURL: HostURL+"/DBI"];
    [CPBundle loadRessourceNamed: "model.gsmarkup" owner:self];
    var mainFile="Operations.gsmarkup";
    var re = new RegExp("t=([^&#]+)");
    var m = re.exec(document.location);
    if (m) mainFile=m[1];
    document.title=mainFile;
    [CPBundle loadRessourceNamed: mainFile owner: self];

// fixme: this restriction should be enforced in session and backend
    var o=[personnelController._entity._store  fetchObjectsWithKey:"ldap" equallingValue:window.G_USERNAME inEntity:personnelController._entity options:@{"FSSynchronous": 1}];
	[personnelController setSelectedObjects:o];

    [[[CPApp mainWindow] delegate] _performPostLoadInit];
}

-(void) delete:sender
{    [[[CPApp keyWindow] delegate] delete:sender];
}

-(void) unsetReferenceVisit:sender
{
    [[visitsController selectedObject] setValue: [CPNull null] forKey:"idreference_visit"];
}

// Konto-stuff (hat keinen eigenen controller)

-(void) makeKorrekturbuchung: sender
{
    if( !accountPopover)
    {    accountPopover=[CPPopover new];
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

-(void)downloadKoKa: sender
{	var idtrial=[trialsController valueForKeyPath:"selection.id"];
	document.location='/CT/download_koka/'+idtrial+'?session='+ window.G_SESSION;
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

	[pdokusController2 addObserver:self forKeyPath:"selection" options: nil context: nil];
	[pdokusController addObserver:self forKeyPath:"selection.tag" options: nil context: nil];
	var button=[pdocumentsButtonBar addButtonWithImageName:"download.png" target:self action:@selector(doDownload:)];
    [button bind:CPEnabledBinding toObject:self withKeyPath:"pdokusController.selection.@count" options:nil];
    [pdocumentsButtonBar registerWithArrayController:pdokusController];
}

-(void) _reloadDokus
{
    [pdokusController reload];
    [pdokusController2 reload];

}

- (void)observeValueForKeyPath: keyPath ofObject: object change: change context: context
{	if(object == pdokusController2)
	{
		[pdokusController setFilterPredicate: [CPPredicate predicateWithFormat:"tag = %@", [object valueForKeyPath:"selection.tag"] ]];

	} else if(object == pdokusController)
    {   if([change objectForKey:"CPKeyValueChangeOldKey"] !== [change objectForKey:"CPKeyValueChangeNewKey"])
        {   [[CPRunLoop currentRunLoop] performSelector:@selector(_reloadDokus) target:self argument: nil order:0 modes:[CPDefaultRunLoopMode]];
        }
    }
}


-(void) uploadPersoDoku:sender
{
    _uploadMode=1;
	[UploadManager sharedUploadManager];

}
- (void)deleteDocWarningDidEnd:(CPAlert)anAlert code:(id)code context:(id)context
{   if(code)
	{	[pdokusController removeObjectsAtArrangedObjectIndexes:[pdokusController selectionIndexes] ];
	}
}

-(void) deletePersoDoku:sender
{	var myalert = [CPAlert new];
	[myalert setMessageText: "Are you sure you want to delete this document?"];
	[myalert addButtonWithTitle:"Cancel"];
	[myalert addButtonWithTitle:"Delete"];
	[myalert beginSheetModalForWindow:[CPApp mainWindow] modalDelegate:self didEndSelector:@selector(deleteDocWarningDidEnd:code:context:) contextInfo: nil];
}
-(void) doDownload: sender
{	var trialsController=[CPApp delegate].trialsController;
	var id=[personnelController valueForKeyPath:"selection.id"];
	var iddoku=[pdokusController valueForKeyPath:"selection.name"];
	window.open("/CT/pdownload/"+id+"/"+iddoku, 'download_window');
}

-(void) cancelAddProperty: sender
{	[popover close];
}
-(void) performAddProperty: sender
{	[popover close];
	var selected=[personnelPropCatController selectedObjects];
	var idpersonnel=[[CPApp delegate].personnelController valueForKeyPath:"selection.id"];
	var l=[selected count];
	for(var i=0; i< l; i++)
	{	var pk=[[selected objectAtIndex:i] valueForKey:"id"];
		[personnelPropController addObject:@{"idproperty": pk, "idpersonnel": idpersonnel} ];
	}
}
-(void) addProperty: sender
{    popover=[CPPopover new];
    [popover setDelegate:self];
    [popover setAnimates:YES];
    [popover setBehavior: CPPopoverBehaviorTransient ];
    [popover setAppearance: CPPopoverAppearanceMinimal];
    var myViewController=[CPViewController new];
    [popover setContentViewController: myViewController];
    [myViewController setView: [addPropsWindow contentView]];
	[popover showRelativeToRect:NULL ofView: sender preferredEdge: nil];
}
-(void) removeProperty: sender
{
	[personnelPropController remove: self];
}





// KOKA und Visit procedures
-(void) insertVisitProcedure: sender
{	[proceduresVisitController insert:sender];
    [self tableView:visitProcsTV shouldEditTableColumn:[[visitProcsTV tableColumns] objectAtIndex:[visitProcsTV findColumnWithTitle:"procedure_name"]]
                                                   row:[visitProcsTV selectedRow]];
}
-(void) removeVisitProcedure: sender
{	[proceduresVisitController remove:sender];
}

- (BOOL)tableView:(CPTableView)tableView shouldEditTableColumn:(CPTableColumn)column row:(int)row {
    if(tableView === visitProcsTV){
        var columnIndex = [[tableView tableColumns] indexOfObject:column];
        var scrollView=[tableView enclosingScrollView];
        var frame = [tableView frameOfDataViewAtColumn:[[tableView tableColumns] indexOfObject:column] row:row];
        frame=[tableView convertRect:frame toView: scrollView]
        frame.origin.y-=2;
        frame.size.height=30;
        frame.size.width+=8;
        var combobox=[[CPComboBox alloc] initWithFrame:frame];
         combobox.tableViewEditedRowIndex = row;
         combobox.tableViewEditedColumnObj = column;
        [combobox setCompletes:YES];
        [combobox setForceSelection:YES];
	    [combobox setAutoresizingMask: CPViewWidthSizable];
        [combobox setTarget:tableView];
        [combobox setAction:@selector(_commitDataViewObjectValue:)];
        [combobox bind:CPContentValuesBinding  toObject:proceduresCatController withKeyPath: "arrangedObjects.name" options:nil];
        [tableView _setObjectValueForTableColumn:column row:row forView:combobox];
        [scrollView addSubview:combobox]; // positioned:CPWindowAbove relativeTo:tableView
       [[tableView window] makeFirstResponder:combobox];
        [combobox setDelegate:self];
        return NO;
    } else if(tableView == persoEventsTV)
    {
       var identifier= [column identifier];
       if (identifier === 'comment')
       {   return YES;
       }

       datePickerPopover =[CPPopover new];
       [datePickerPopover setDelegate:self];
       [datePickerPopover setAnimates:NO];
       [datePickerPopover setBehavior: CPPopoverBehaviorTransient ];
       [datePickerPopover setAppearance: CPPopoverAppearanceMinimal];
       var myViewController=[CPViewController new];
       [datePickerPopover setContentViewController:myViewController];
       [myViewController setView:graphicalPicker];
       [graphicalPicker setLocale: [[CPLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
       graphicalPicker.tableViewEditedRowIndex = row;
       graphicalPicker.tableViewEditedColumnObj = column;
       graphicalPicker._table = tableView;
       [tableView _setObjectValueForTableColumn:column row:row forView:graphicalPicker];
       [graphicalPicker setTarget:self];
       [graphicalPicker setAction:@selector(_commitDateValue:)];
       var frame = [tableView frameOfDataViewAtColumn:[[tableView tableColumns] indexOfObject:column] row:row];
       [datePickerPopover showRelativeToRect:frame ofView:tableView preferredEdge: nil];
       [[tableView window] makeKeyAndOrderFront:self];
       return YES;
   }
   return NO;
}
-(void) _commitDateValue:(id)sender
{
    [datePickerPopover close];
    [[sender._table window] makeKeyAndOrderFront:self]
    [sender._table _commitDataViewObjectValue:sender];
    [sender._table setNeedsDisplay:YES];
}

// for combobox
- (void)_controlTextDidEndEditing:(CPTextField) object
{
    [object setDelegate:nil];
    if(object) [[object target] _commitDataViewObjectValue:object]
    var win=[object window];
    [win makeFirstResponder:visitProcsTV]
    [object removeFromSuperview];
}

- (void)controlTextDidEndEditing:(CPNotification)aNotification
{
    [self _controlTextDidEndEditing:[aNotification object]];
}
- (void) controlTextDidBlur:(CPNotification)aNotification
{
    [self _controlTextDidEndEditing:[aNotification object]];
}

-(void)cancelOperation:sender
{
// fixme!
}
// END: KOKA und Visit procedures


// MISC stuff
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

