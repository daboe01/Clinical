/*
 */

/////////////////////////////////////////////////////////


@import <Foundation/CPObject.j>
@import <Renaissance/Renaissance.j>


/////////////////////////////////////////////////////////

@implementation AdminController : CPObject
{
	id	popover;
	id	addPropsWindow;
	id	addPropsTV;
    id  pDocumentsBB;
    id  graphicalPicker;
    id  datePickerPopover;
    id  teamMeetingBB;
    id  progress;
	id	persoSearchTerm @accessors;
}
-(void) setPersoSearchTerm:aTerm
{
	if(aTerm && aTerm.length)
	{   var term= aTerm.toLowerCase();
        [[CPApp delegate].personnelController setFilterPredicate: [CPPredicate predicateWithFormat:"name CONTAINS[cd] %@ or ldap CONTAINS[cd] %@ or email CONTAINS[cd] %@", term, term, term]];
	} else [[CPApp delegate].personnelController setFilterPredicate: nil];
}

-(void) _performPostLoadInit
{
	var button=[pDocumentsBB addButtonWithImageName:"download.png" target:[CPApp delegate] action:@selector(doDownload:)];
    [button setToolTip:"Download/view document"];
    [button bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"dokusController.selection.@count" options:nil];
    [pDocumentsBB registerWithArrayController:[CPApp delegate].dokusController plusTooltip:"Upload document" minusTooltip:"Delete selected document..."];
    button=[teamMeetingBB addButtonWithImageName:"reload.png" target:self action:@selector(checkForEmailResponses:)];
    [button setToolTip:"Check for answers"];
}

-(void) cancelAddProperty: sender
{	[popover close];
}
-(void) performAddProperty: sender
{	[popover close];
	var pcController=[CPApp delegate].personnelPropCatController;
	var pController=[CPApp delegate].personnelPropController;
	var selected=[pcController selectedObjects];
	var idpersonnel=[[CPApp delegate].personnelController valueForKeyPath:"selection.id"];
	var l=[selected count];
	for(var i=0; i< l; i++)
	{	var pk=[[selected objectAtIndex:i] valueForKey:"id"];
		[pController addObject:@{"idproperty": pk, "idpersonnel": idpersonnel} ];
	}
}
-(void) addProperty: sender
{
	if( !popover)
	{	 popover=[CPPopover new];
		[popover setDelegate:self];
		[popover setAnimates:YES];
		[popover setBehavior: CPPopoverBehaviorTransient ];
		[popover setAppearance: CPPopoverAppearanceMinimal];
		var myViewController=[CPViewController new];
		[popover setContentViewController: myViewController];
		[myViewController setView: [addPropsWindow contentView]];
	
	}
	[popover showRelativeToRect:NULL ofView: sender preferredEdge: nil];
}
-(void) removeProperty: sender
{	var pController=[CPApp delegate].personnelPropController;
	[pController remove: self];
}
-(void) removeCatProperty: sender
{	var pController=[CPApp delegate].personnelPropCatController;
	[pController remove: self];
}
-(void) addCatProperty: sender
{	var pController=[CPApp delegate].personnelPropCatController;
	[pController insert: self];
	[addPropsTV editColumn:0 row:[addPropsTV selectedRow] withEvent:nil  select:YES];
}

-(void) sendMeetingInvitations:sender
{
    var idmeeting = [[CPApp delegate].teamMeetingsController valueForKeyPath:"selection.id"];
	var myreq=[CPURLRequest requestWithURL:"/CT/invite_teammeeting/"+idmeeting+'?session='+ window.G_SESSION];
	[myreq setHTTPMethod:"POST"];
	[CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];
}

-(void) checkForEmailResponses:sender
{
	var myreq=[CPURLRequest requestWithURL:"/CT/check_teammeeting_responses/"+'?session='+ window.G_SESSION];
    [progress startAnimation:self];
    [CPURLConnection connectionWithRequest:myreq delegate:self];
}

-(void) connection: someConnection didReceiveData: data
{
    [[CPApp delegate].meetingAttendeesController reload];
    [progress stopAnimation:self];

}

-(void) insertGroup:sender
{
    [[CPApp delegate].groupsControllerAll addObject:@{"name": "New group"}];

}
-(void) removeGroup:sender
{
    [[CPApp delegate].groupsControllerAll remove:self];
}
-(void) insertState:sender
{
    [[CPApp delegate].statesController addObject:@{"name": "New state", "type": 0}];

}
-(void) removeState:sender
{
    [[CPApp delegate].statesController remove:self];
}


- (BOOL)tableView:(CPTableView)tableView shouldEditTableColumn:(CPTableColumn)column row:(int)row {
	var identifier= [column identifier];
	if(identifier === 'title' || identifier === 'location')
	{   return YES;
	}
	datePickerPopover =[CPPopover new];
	[datePickerPopover setDelegate:self];
	[datePickerPopover setAnimates:NO];
	[datePickerPopover setBehavior: CPPopoverBehaviorTransient];
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
	[graphicalPicker setMinDate:[CPDate distantPast]];
	[graphicalPicker setMaxDate:[CPDate distantFuture]];
	var frame = [tableView frameOfDataViewAtColumn:[[tableView tableColumns] indexOfObject:column] row:row];
	[datePickerPopover showRelativeToRect:frame ofView:tableView preferredEdge:nil];
	[[tableView window] makeKeyAndOrderFront:self];
	return YES;
}

-(void) _commitDateValue:(id)sender
{
    [[sender._table window] makeKeyAndOrderFront:self];  // this has to come first (otherwise FF breaks)
    [datePickerPopover close];
    [sender._table _commitDataViewObjectValue:sender];
    [sender._table setNeedsDisplay:YES];
}

@end


@implementation GSMarkupTagAdminController:GSMarkupTagObject
+ (CPString) tagName
{
  return @"adminController";
}

+ (Class) platformObjectClass
{
	return [AdminController class];
}
@end

@implementation RightAlignedTextField : CPTextField
- (id)initWithFrame:(CGRect)aFrame {
    self = [super initWithFrame:aFrame];
    if (self) {
        [self setValue:CPRightTextAlignment forThemeAttribute:'alignment'];
    }
    return self;
}
-(void) setObjectValue:(id)aVal
{
    [super setObjectValue:[CPString stringWithFormat:"%5.2f", aVal]];
}
@end

@implementation CPObject(_IDSearch)
-(CPString) _quotedID
{   return ","+[self valueForKey:"id"]+","
}
@end

@implementation AccountsController : CPObject
{
	id	searchTerm @accessors;
	id	searchTermGlobal @accessors;
    id  accountsWindow;
    id  transactionsBB;
    id  accountsBB;
    id  progress;
}

-(void) setSearchTerm:aTerm
{
	if(aTerm && aTerm.length)
	{	[[CPApp delegate].balancedController setFilterPredicate: [CPPredicate predicateWithFormat:"description CONTAINS[cd] %@", aTerm.toLowerCase()]];
	} else [[CPApp delegate].balancedController setFilterPredicate: nil];
}
-(void) setSearchTermGlobal:aTerm
{
	if(aTerm && aTerm.length)
	{
        var myreq=[CPURLRequest requestWithURL:"/CT/filter_accounts/"+aTerm];
        var filter=[CPURLConnection sendSynchronousRequest:myreq returningResponse:nil];
        if(filter && [filter rawString]) [[CPApp delegate].accountsController setFilterPredicate: [CPPredicate predicateWithFormat:"%@ CONTAINS _quotedID", [filter rawString]]];
        [self setSearchTerm:aTerm];
	} else
    {   [[CPApp delegate].accountsController setFilterPredicate: nil];
        [self setSearchTerm:nil];
    }
}

// number formatting
- (CPString)stringForObjectValue:(id)theObject
{	return [CPString stringWithFormat:"%.2f", parseFloat(theObject)];
}
- (id)objectValueForString:(CPString)aString error:(CPError)theError
{	return parseFloat(aString);
}


- (id)init
{   self = [super init];
    [[[CPApp delegate].accountsController entity] setFormatter: self forColumnName:"balance"];
    [[[CPApp delegate].balancedController entity] setFormatter: self forColumnName:"balance"];
    [[[CPApp delegate].balancedController entity] setFormatter: self forColumnName:"amount_change"];
    return self;    
}
-(void) insertAccount: sender
{   var accountsController=[CPApp delegate].accountsController;
	[accountsController addObject:@{"name": "New account", "idgroup": [[CPApp delegate].groupsController valueForKeyPath:"selection.id"] } ];
}

-(void) removeAccount: sender
{
	var myalert = [CPAlert new];
	[myalert setMessageText: "Are you sure you want to delete this account together with all transactions?"];
	[myalert addButtonWithTitle:"Cancel"];
	[myalert addButtonWithTitle:"Delete"];
	[myalert beginSheetModalForWindow: accountsWindow modalDelegate:self didEndSelector:@selector(deleteAccountWarningDidEnd:code:context:) contextInfo: nil];
}
- (void)deleteAccountWarningDidEnd:(CPAlert)anAlert code:(id)code context:(id)context
{   if(code)
	{   var accountsController=[CPApp delegate].accountsController;
        [accountsController remove:self];
    }
}

-(void) _performPostLoadInit
{
	[transactionsBB addButtonWithImageName:"reload.png" target:self action:@selector(reloadFromSAP:)];
	[accountsBB addButtonWithImageName:"reload.png" target:self action:@selector(reloadAccounts:)];

}
-(void) reloadAccounts:sender
{
// <!> fixme: it would be better to fix relaod of arraycontroller instead of this workaround here.
    [[CPApp delegate].accountsController._entity _invalidatePKCache];
    [[CPApp delegate].accountsController setContent:[[CPApp delegate].accountsController._entity allObjects]];
}

-(void) reloadFromSAP:sender
{
    var idaccount=[[CPApp delegate].accountsController valueForKeyPath:"selection.id"];
    var myreq=[CPURLRequest requestWithURL:"/CT/reload_account/"+idaccount+"?session="+ window.G_SESSION];
    [CPURLConnection connectionWithRequest: myreq delegate:self];
    [progress startAnimation:self];
}
-(void) connection: someConnection didReceiveData: data
{
    [[CPApp delegate].balancedController reload]
    [progress stopAnimation:self];

}
@end


@implementation GSMarkupTagAccountsController:GSMarkupTagObject
+ (Class) platformObjectClass
{
	return [AccountsController class];
}
@end

@implementation GSMarkupTagRightAlignedTextField:GSMarkupTagControl
+ (Class) platformObjectClass
{
	return [RightAlignedTextField class];
}
@end

