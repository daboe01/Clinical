@import <AppKit/CPControl.j>

// fixme: janus-controls do not adjust width when the user rearranges table colums

@implementation ReturnSensitiveTextField : CPTextField

-(void) keyUp:event
{
    if(event._characters=="\t")
    {
        (event._modifierFlags & CPShiftKeyMask)? [_delegate _moveUp:self]:[_delegate _moveDown:self];
    } else [super keyUp:event];
}

- (void)insertNewline:sender
{
	[super insertNewline:sender];
	[_delegate _moveDown:self];
}
- (void)moveDown:sender
{
	[_delegate _moveDown:self];
}
- (void)moveUp:sender
{
	[_delegate _moveUp:self];
}

- (void)mouseUp:(CPEvent)event
{
    [super mouseUp:event];
  	[_delegate _selectAppropriateRow:self];
}

@end


@implementation TableViewControl : CPControl
{   id          _myView;
    CPString    _face @accessors(property=face);
    CPString    _disabledFace @accessors(property=disabledFace);
    BOOL        _editable  @accessors(property=editable);
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- viewClass
{	return ReturnSensitiveTextField;
}

- (void)setObjectValue:(id)myVal
{	_value = myVal;
	[_myView unbind:CPValueBinding];
    [self _installView];
	[_myView bind:CPValueBinding toObject:_value withKeyPath:_face options:nil];
}

-(void) _installView
{  [_myView removeFromSuperview];
    _myView = [[[self viewClass] alloc] initWithFrame:[self bounds]];

    if (_editable && [_myView respondsToSelector:@selector(setEditable:)])
        [_myView setEditable:YES];
    if ([_myView respondsToSelector:@selector(setSelectable:)])
        [_myView setSelectable:YES];

    [self addSubview:_myView];
    [_myView setThemeState:_themeState];
    [_myView unsetThemeState:CPThemeStateEditable];  // text is black in selected rows otherwise
}

// this is necessary to make column resizing work
- (void) setFrame:(CGRect)aRect
{
    [super setFrame:aRect];
    [_myView setFrame:[self bounds]];
}

- (void)setThemeState:(id)aState
{   [super setThemeState:aState];
    [_myView setThemeState:aState];
}
- (void)unsetThemeState:(id)aState
{   [super unsetThemeState:aState];
    [_myView unsetThemeState:aState];
}

- (void) _moveSelectionIntoDirection:direction
{	var tv=[self superview];
	if(![tv isKindOfClass: CPTableView])  tv=[tv superview]
	var nextRow=[tv selectedRow] + direction;
	if(nextRow < 0 || nextRow >= [tv numberOfRows]) return; 
	[tv selectRowIndexes:[CPIndexSet indexSetWithIndex:nextRow] byExtendingSelection:NO];
    [tv editColumn:1 row:nextRow withEvent:nil select:YES];
}

- (void) _moveUp:sender
{
    [self _moveSelectionIntoDirection:-1]
}
- (void) _moveDown:sender
{
    [self _moveSelectionIntoDirection:+1]
}

- (void) _selectAppropriateRow:sender
{
	var tv=[self superview];
	if(![tv isKindOfClass: CPTableView])  tv=[tv superview]
	[tv selectRowIndexes:[CPIndexSet indexSetWithIndex:[tv rowForView:sender]] byExtendingSelection:NO];
}

- (id)initWithCoder:(id)aCoder
{
    self=[super initWithCoder:aCoder];
    if (self)
    {
        _face=[aCoder decodeObjectForKey:"_face"];
        _editable=[aCoder decodeObjectForKey:"_editable"];
        _disabledFace=[aCoder decodeObjectForKey:"_disabledFace"];
    }
    return self;
}

- (void)encodeWithCoder:(id)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_face forKey:"_face"];
    [aCoder encodeObject:_disabledFace forKey:"_disabledFace"];
    [aCoder encodeObject:_editable forKey:"_editable"];
}

- (void)setEditable:(BOOL)isEditable
{	_editable = isEditable;
	[_myView setEditable:_editable];
}

@end


var _itemsControllerHash;
@implementation TableViewPopup: TableViewControl
{	id	_itemsController @accessors(property=itemsController);
	CPString _itemsFace @accessors(property=itemsFace);
	CPString _itemsValue @accessors(property=itemsValue);
	CPString _itemsIDs @accessors(property=itemsIDs);
	CPString _itemsPredicateFormat @accessors(property=itemsPredicateFormat);
}
+(void) initialize
{	[super initialize];
	_itemsControllerHash=[CPMutableArray new];
}
-(void) setItemsController: aController
{	_itemsControllerHash[[self hash]]= aController
	_itemsController=aController;
}
- viewClass
{	return FSPopUpButton;
}

- (id)initWithCoder:(id)aCoder
{
    self=[super initWithCoder:aCoder];
    if (self != nil)
    {
		_itemsController = _itemsControllerHash[[aCoder decodeObjectForKey:"_itemsController"]];
		_itemsFace =[aCoder decodeObjectForKey:"_itemsFace"];
		_itemsValue =[aCoder decodeObjectForKey:"_itemsValue"];
		_itemsIDs =[aCoder decodeObjectForKey:"_itemsIDs"];
		_itemsPredicateFormat =[aCoder decodeObjectForKey:"_itemsPredicateFormat"];

    }
    return self;
}

- (void)encodeWithCoder:(id)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject: [self hash] forKey:"_itemsController"];
    [aCoder encodeObject: _itemsFace forKey:"_itemsFace"];
    [aCoder encodeObject: _itemsValue forKey:"_itemsValue"];
    [aCoder encodeObject: _itemsIDs forKey:"_itemsIDs"];
    [aCoder encodeObject: _itemsPredicateFormat forKey:"_itemsPredicateFormat"];

}

-(void) setObjectValue:(id)myVal
{	_value= myVal;
	[_myView unbind:"itemArray"];
	[_myView unbind:"selectedTag"];
    [self _installView];
	if(!_itemsController)
	{	[_myView setItemArray:[]];
	} else
    {   var options=@{"PredicateFormat": _itemsPredicateFormat, "valueFace": _itemsValue, "Owner":_value};
        [_myView bind:"itemArray" toObject: _itemsController withKeyPath:_itemsFace options:options];
    }
    if(!_face)   // cell based
    {   [_myView setTarget:self]
        [_myView setAction:@selector(viewChanged:)]
        [_myView selectItemWithTag:myVal]
    } else       // view based
	    [_myView bind:"selectedTag" toObject:_value withKeyPath:_face options:nil];
}

- (void) viewChanged:(id)sender
{
    var tv= [self superview];
    tv._editingColumn=[tv columnForView:sender]
    tv._editingRow=[tv rowForView:sender];
    [[tv window] makeFirstResponder:sender];
    [tv _commitDataViewObjectValue:sender];
}

@end

@implementation IconTableViewControl : TableViewControl

+ viewClass
{	return CPImageView;
}

-(void) setObjectValue: myVal
{	_value= myVal;
	if(myVal)
	{	var img= [[CPImage alloc] initWithContentsOfFile: [CPString stringWithFormat:@"%@/%@.png", [[CPBundle mainBundle] resourcePath], myVal]];
		[_myView setImage:img];
	} else
	{   [_myView setImage:nil];
	}
}
-(void) _installView
{	[_myView removeFromSuperview];
	[self addSubview: _myView];
	[_myView setFrame:CPMakeRect(0, 0, 22, 22)];
}

@end


var TableViewJanusControl_typeArray;

@implementation TableViewJanusControl : TableViewPopup
{	CPString	_type @accessors(property=type);
	unsigned	_typeIndex;
}

-(void) _installJanusView
{	if(_myView) [_myView removeFromSuperview];
	else return;
	[self addSubview:_myView];
	[_myView setFrame:[self bounds]];
	[_myView setFace:_face];
	[_myView setThemeState:_themeState];
	if( [_myView isKindOfClass:TableViewPopup])
	{	[_myView setItemsFace: _itemsFace];
		[_myView setItemsValue: _itemsValue];
		[_myView setItemsIDs: _itemsIDs]
		[_myView setItemsPredicateFormat:_itemsPredicateFormat];
		[_myView setItemsController:_itemsController];
	} else
	{	[_myView setEditable:_editable];
	}
}

-(void) setObjectValue:(id)myVal
{	_value=myVal;
	[[self subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    _typeIndex=0;
	if (_value && _type)
	{	_typeIndex= [_value valueForKeyPath:_type];
	}
    _myView = [[[self viewClass] alloc] initWithFrame:[self frame]];
	var d = _disabledFace && [_value valueForKeyPath:_disabledFace];
	if(!d)
    {   [self _installJanusView];
        [_myView setObjectValue:_value];
    }
}


+(void) initialize
{	[super initialize];
	TableViewJanusControl_typeArray=[TableViewControl, TableViewPopup];
}

// 0: textfield
// 1: popup

-(void) setType:(unsigned) aType
{	_type=aType;
}
- viewClass
{
	return TableViewJanusControl_typeArray[_typeIndex];
}
- (id)initWithCoder:(id)aCoder
{
    self=[super initWithCoder:aCoder];
    if (self != nil)
    {	[self setType: [aCoder decodeObjectForKey:"_type"]];
    }
	return self;
}
- (void)encodeWithCoder:(id)aCoder
{	[super encodeWithCoder:aCoder];
    [aCoder encodeObject: _type forKey:"_type"];
}

- itemsController
{	return [_myView itemsController];
}
- (void)setEditable:(BOOL)isEditable
{	_editable=isEditable;
}

@end

@implementation GSMarkupTagTableViewControl:GSMarkupTagControl
+ (CPString) tagName
{
  return @"tableViewControl";
}

+ (Class) platformObjectClass
{
	return [TableViewControl class];
}

- (id) initPlatformObject: (id)platformObject
{	platformObject = [super initPlatformObject: platformObject];
  
	var editable = [self boolValueForAttribute: @"editable"];
	if (editable == 1) [platformObject setEditable: YES];
	var face = [self stringValueForAttribute: @"face"];
	if (face != nil) [platformObject setFace: face];
	var disabled_face = [self stringValueForAttribute: @"disabledFace"];
	if (disabled_face != nil)
	{
		[platformObject setDisabledFace: disabled_face];
	}

	return platformObject;
}

@end


@implementation GSMarkupTagTableViewPopup: GSMarkupTagTableViewControl
+ (CPString) tagName
{
  return @"tableViewPopup";
}

+ (Class) platformObjectClass
{
	return [TableViewPopup class];
}

- (id) initPlatformObject: (id)platformObject
{	platformObject = [super initPlatformObject: platformObject];
  
	var itemsFace = [self stringValueForAttribute: @"itemsFace"];
	if (itemsFace != nil) [platformObject setItemsFace: itemsFace];
	var itemsValue = [self stringValueForAttribute: @"itemsValue"];
	if (itemsValue != nil) [platformObject setItemsValue: itemsValue];
	var itemsIDs = [self stringValueForAttribute: @"itemsIDs"];
	if (itemsIDs != nil) [platformObject setItemsIDs: itemsIDs];
	var itemsPredicateFormat = [self stringValueForAttribute: @"itemsPredicateFormat"];
	if (itemsPredicateFormat != nil) [platformObject setItemsPredicateFormat: itemsPredicateFormat];

	return platformObject;
}

@end

@implementation GSMarkupTagTableViewJanusControl: GSMarkupTagTableViewPopup
+ (CPString) tagName
{
  return @"tableViewJanusView";
}

+ (Class) platformObjectClass
{
	return [TableViewJanusControl class];
}

- (id) initPlatformObject: (id)platformObject
{	platformObject = [super initPlatformObject: platformObject];
  
	var type = [self stringValueForAttribute: @"typeFace"];
	[platformObject setType: type];

	return platformObject;
}

@end


@implementation GSMarkupTagIconTableViewControl:GSMarkupTagControl
+ (CPString) tagName
{
  return @"iconTableViewControl";
}

+ (Class) platformObjectClass
{
	return [IconTableViewControl class];
}
@end
