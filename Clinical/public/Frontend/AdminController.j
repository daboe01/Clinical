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

