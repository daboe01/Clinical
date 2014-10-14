@import <AppKit/CPControl.j>

@implementation TableViewControl : CPControl
{	id	_myView;
	CPString _face @accessors(property=face);
	BOOL	_editable  @accessors(property=editable);
}
+ viewClass
{	return CPTextField;
}
- initWithFrame:(CGRect) myFrame
{	self=[super initWithFrame: myFrame];
	_myView =[[[[self class] viewClass] alloc] initWithFrame: myFrame];
	return self;
}

-(void) setObjectValue: myVal
{	_value= myVal;
	var v= _face? [myVal valueForKeyPath: _face]:myVal;
	[_myView setObjectValue: v||""];
}
-(void) _installView
{	[_myView removeFromSuperview];
	[self addSubview: _myView];
	var mybounds= [self bounds];
	//mybounds.size.height+=2;
	[_myView setFrame:mybounds];
	[_myView setTarget: self];
	[_myView setAction: @selector(viewChanged:)];
	[_myView setAutoresizingMask: CPViewWidthSizable| CPViewHeightSizable];
 	[self setAutoresizingMask: CPViewWidthSizable| CPViewHeightSizable];
}

- (void) viewChanged: sender
{	if(_face)
		[[self objectValue] setValue:[sender stringValue] forKeyPath: _face];
	else
	{	_value=[sender objectValue];
		[[self superview] _commitDataViewObjectValue: self];
	}
}

- (id)initWithCoder:(id)aCoder
{
    self=[super initWithCoder:aCoder];
    if (self != nil)
    {
		_myView =[aCoder decodeObjectForKey:"_myView"];
		_face=[aCoder decodeObjectForKey:"_face"];
		_editable=[aCoder decodeObjectForKey:"_editable"];
		if(_editable) [self setEditable:YES];
        [self _installView];
		
    }
    return self;
}

- (void)encodeWithCoder:(id)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_myView forKey:"_myView"];
    [aCoder encodeObject:_face forKey:"_face"];
    [aCoder encodeObject:_editable forKey:"_editable"];

}

-(void) setThemeState: aState
{	[super   setThemeState: aState];
	[_myView setThemeState: aState];
}
-(void) unsetThemeState: aState
{	[super   unsetThemeState: aState];
	[_myView unsetThemeState: aState];
}
- (void)mouseDown:(CPEvent)  theEvent {
	[[self nextResponder] mouseDown:theEvent];
}

- (void)setEditable:(BOOL)isEditable
{	_editable=isEditable;
	if(_editable)
	{	[_myView setEditable:YES];
		[_myView setSendsActionOnEndEditing:YES];
		[_myView setSelectable:YES];
		[_myView selectText:nil];
		[_myView setBezeled:NO];
		[_myView setDelegate:self];
	}
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

// unfortunately, this is necessary to fool CPTableView.
-(BOOL) isKindOfClass: aClass
{	if(aClass === [CPButton class]) return YES;
	return [super isKindOfClass: aClass];
}
+ initialize
{	self=[super initialize];
	_itemsControllerHash=[CPMutableArray new];
	return self;
}
-(void) setItemsController: aController
{	_itemsControllerHash[[self hash]]= aController
}
+ viewClass
{	return FSPopUpButton;
}
- initWithFrame:(CGRect) myFrame
{	self=[super initWithFrame: myFrame];

	return self;
}

- (void) viewChanged: sender
{
	if(_face)
	    [[self objectValue] setValue:[sender selectedTag] forKeyPath: _face];
	else
	{
		_value=[sender selectedTag];
		[[self superview] _commitDataViewObjectValue: self];
	}

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
- (void)mouseDown:(CPEvent)  theEvent {
    [_myView mouseDown:theEvent];
}
-(void) _setupView
{	if(!_itemsController)
	{	[_myView setItemArray:[]];
		return;
	}
	var options=@{"PredicateFormat": _itemsPredicateFormat, "valueFace": _itemsValue, "Owner":_value};
	[_myView bind:"itemArray" toObject: _itemsController withKeyPath: _itemsFace options: options];
}

-(void) setObjectValue: myVal
{
	_value= myVal;
	[self _setupView];
	var v=_face? [myVal valueForKeyPath: _face]: myVal;
	if(_myView) _myView._value= (v || -1);
	[_myView setSelectedTag: v || -1];
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


