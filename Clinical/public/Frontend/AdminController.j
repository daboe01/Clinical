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
@end


@implementation AccountsController : CPObject
{
	id	searchTerm @accessors;
    id accountsWindow;
}

-(void) setSearchTerm: aTerm
{
	if(aTerm && aTerm.length)
	{	[[CPApp delegate].balancedController setFilterPredicate: [CPPredicate predicateWithFormat:"description CONTAINS[cd] %@", aTerm.toLowerCase()]];
	} else [[CPApp delegate].balancedController setFilterPredicate: nil];
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

