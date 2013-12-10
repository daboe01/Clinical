// DocsCalViewer 2
// 28.5.13 by prof. boehringer
// todo:
//	- sortierung umdrehen (neues zuerst)
//  - multipage download fuer alle befunde unterstuetzen
//  - support for "global" annotations, e.g. for ANSB uploads

@import <AppKit/AppKit.j>
@import <Renaissance/Renaissance.j>


var DCNHostURL="http://augimageserver/";
var DCHostURL="/CT/DC/";
var DCBaseURL=DCHostURL+"hydedownload/";
var DCNBaseURL='http://augimageserver/'+"hydedownload/";
var spinnerImg;

CPUserDefaultsSizeKey = @"CPUserDefaultsSizeKey";

GLOBAL_RND=1;

@implementation CPObject (ImageURLHack)

-(CPImage) provideImageForCollectionViewItem: someItem
{	var size=[someItem size];
	if(!size) return nil;
	var rnd=GLOBAL_RND? GLOBAL_RND: Math.floor(Math.random()*1001);
	return [[CPImage alloc] initWithContentsOfFile: DCNBaseURL+[self valueForKey:"name"]+"?size="+size+"&rnd="+rnd];
}
@end

@implementation SimpleImageViewCollectionItem: CPCollectionViewItem
{	CPImage _img;
	CPImageView _imgv;
	unsigned _size @accessors(property=size);
}
-(void) setSize:(insigned) someSize
{	_size=someSize;
	_img=[_representedObject provideImageForCollectionViewItem: self];
	var name=[_representedObject valueForKeyPath:"name"]
	var re = new RegExp("^[^_]+_(....)(..)(..)");
	var m = re.exec(name);
	if(m) [_view setTitle: m[1]+'-'+m[2]+'-'+m[3]];
	[_imgv setToolTip: name];
	[_imgv setImage: _img ];
	var myframe=[_imgv frame];
	if(myframe) [_imgv setFrame: CPMakeRect(myframe.origin.x,myframe.origin.y, _size, _size)];
}
- (void)setImage:(CPImage)image
{	[_imgv setImage: image];
}
-(CPView) loadView
{	_imgv=[CPImageView new];
	[_imgv setImageScaling: CPScaleProportionally];
	var myview=[CPBox new];
	[myview setTitlePosition: CPBelowBottom];
    [myview setBorderType:  CPLineBorder ];
    [myview setBorderWidth:  2.0 ];
	[myview setContentView: _imgv];
	[_imgv setImage: spinnerImg];
	[self setView: myview];
	return myview;
}
-(void) setRepresentedObject: someObject
{	[super setRepresentedObject: someObject];
	[self loadView];
}

-(void) setSelected:(BOOL) state
{    [[self view] setValue:state? [CPColor yellowColor]: [CPColor colorWithWhite:(190.0 / 255.0) alpha: 1.0]  forThemeAttribute:@"border-color"];
}

@end

// for fixing the shift issue on windows
@implementation MyCollectionView : CPCollectionView
- (void)mouseDown:(CPEvent)anEvent
{	_mouseDownEvent = anEvent;
    var location = [self convertPoint:[anEvent locationInWindow] fromView:nil],
        index = [self _indexAtPoint:location];
    if (index >= 0 && index < _items.length)
    {	if (_allowsMultipleSelection && ([anEvent modifierFlags] & CPPlatformActionKeyMask || [anEvent modifierFlags] & CPShiftKeyMask))
        {	var indexes = [_selectionIndexes copy];
			if ([indexes containsIndex:index])
                    [indexes removeIndex:index];
			else    [indexes addIndex:index];
        }  else indexes = [CPIndexSet indexSetWithIndex:index];
        [self setSelectionIndexes:indexes];
    }  else if (_allowsEmptySelection) [self setSelectionIndexes:[CPIndexSet indexSet]];
}
@end


/////////////////////////////////////////////////////////

@implementation DocsCalController : CPObject
{	id	stacksController;
	id	stacksDirController;
	id	stacksContentController;
	id	stacksCollectionView;
	id	typePopup;
	id	pizField;
	id	mainWindow;
	unsigned _itemSize @accessors(property=itemSize);
	id connectionDir;
	id connectionItems;
	id toggleButton;
	id filterButton;
	id pizConnection;
	id historyConnection;
	var userDefaultsDict;
	var emptySignImage;
	var emptyImgView;
}
-(void) setItemSize:(unsigned) someSize
{	_itemSize=someSize;
	[stacksCollectionView setMinItemSize: CPMakeSize(_itemSize,_itemSize)];
	[[stacksCollectionView items] makeObjectsPerformSelector:@selector(setSize:) withObject:_itemSize];
	[userDefaultsDict setObject: _itemSize forKey: CPUserDefaultsSizeKey];
}

-(void) connection: someConnection didReceiveData: data
{	var piz=[pizField stringValue];
	try{
	var arr = JSON.parse( data );
	} catch(e)
	{}
	if(!arr) arr=[];
	var i,l=arr.length;


	if(someConnection === connectionDir)
	{	for(i=0; i < l; i++)
		{	[stacksDirController addObject: [CPDictionary dictionaryWithObjects: [arr[i], piz] forKeys:["name", "piz"]] ];
		}
		var preselect_type;
		var re = new RegExp("#([^&#]+)");
		var m = re.exec(document.location);
		if(m)  preselect_type=m[1];
		else
		{	if(![toggleButton state]) preselect_type='Arztbriefe Klinikum';
			else if ([[stacksDirController arrangedObjects] count])
				preselect_type=[[[stacksDirController arrangedObjects] objectAtIndex:0] valueForKeyPath:"name"];
		}
		if(preselect_type)
		{	[typePopup selectItemWithTitle: preselect_type ];
			if(![typePopup selectedItem]) [typePopup selectItemAtIndex: 0];
		}
		[self changeType: self];
	} else if(someConnection === connectionItems)
	{	var content=[CPMutableArray new];
		for(i=0;i<l;i++)
		{	[content addObject: [CPDictionary dictionaryWithObjects: [arr[i], piz] forKeys:["name", "piz"]] ];
		}
		[stacksContentController setContent: [content sortedArrayUsingDescriptors: [[CPSortDescriptor sortDescriptorWithKey:@"name" ascending: NO selector:@selector(compare:)]] ] ];

		[emptyImgView removeFromSuperview];

		if(![content count])
		{	[[mainWindow contentView] addSubview: emptyImgView];
			if(![toggleButton state])
			{	[toggleButton setState: 1];
				[[CPRunLoop currentRunLoop] performSelector:@selector(toggleBase:) target:self argument: toggleButton order:10000 modes:[CPDefaultRunLoopMode]];
			}
		}

		[self setItemSize: [self itemSize]];
	}
}

-(void)_invalidateImages
{	[[stacksCollectionView items] makeObjectsPerformSelector:@selector(setImage:) withObject: spinnerImg];
}

-(void)loadPIZ: sender
{	[self _invalidateImages];

	var piz=[pizField stringValue];

	[stacksController addObject: [CPDictionary dictionaryWithObject: piz forKey:"piz"] ];
	if(![[stacksDirController arrangedObjects] count])
	{	var myurl=DCBaseURL+'dir/'+piz;
		if([filterButton state]) myurl+='&src=Aug';
		connectionDir=[CPURLConnection connectionWithRequest: [CPURLRequest requestWithURL: myurl] delegate: self];
	}
}

-(void)changeType: sender
{	[self _invalidateImages];

	var type=[[typePopup selectedItem] title];
	var piz=[pizField stringValue];
	var myurl=DCBaseURL+'/dir/'+piz+'/'+type;
	if([filterButton state]) myurl+='&src=Aug';

	connectionItems=[CPURLConnection connectionWithRequest: [CPURLRequest requestWithURL: myurl ] delegate: self];
}

- initWithPIZ:(CPString) myPiz
{	self=[super init];
	[CPBundle loadRessourceNamed: "DocsCal.gsmarkup" owner:self];

	[self setItemSize: 600 ];

	spinnerImg=[[CPImage alloc] initWithContentsOfFile: [CPString stringWithFormat:@"%@/%@", [[CPBundle mainBundle] resourcePath],"spinner.gif" ]];
	emptyImgView=[[CPImageView alloc] initWithFrame: CPMakeRect(100,100,741,656)];
	[emptyImgView setImage: [[CPImage alloc] initWithContentsOfFile: [CPString stringWithFormat:@"%@/%@", [[CPBundle mainBundle] resourcePath],"ListEmpty.png" ]]];
	[mainWindow setInitialFirstResponder: pizField ];
	[mainWindow makeKeyAndOrderFront:self ];

	[pizField setStringValue:myPiz];
	[self loadPIZ: self];
	return self;
}


// doubleclick-> download

-(void) collectionView: someView didDoubleClickOnItemAtIndex: someIndex
{	var o=[[someView itemAtIndex: someIndex] representedObject];
	if([[someView itemAtIndex: someIndex]._imgv image] != spinnerImg )
	{	document.location=DCBaseURL+[o valueForKeyPath:"name"];
	} else
	{	[[CPAlert alertWithError:"Bitte das Laden des Bildes abwarten"] runModal];
	}
}

-(void) toggleBase:sender
{	[self _invalidateImages];

	DCBaseURL=DCHostURL+  ( [sender state]? 'docscal': 'hyde') + 'download/';
	DCNBaseURL=DCNHostURL+  ( [sender state]? 'docscal': 'hyde') + 'download/';

	[self changeFilter: sender];
}

-(void) changeFilter:sender
{	[stacksController setContent:[]];
	[stacksDirController setContent:[]];
	[self loadPIZ: pizField];
}


@end

@implementation GSMarkupTagMyCollectionView : GSMarkupTagCollectionView
+ (CPString) tagName
{	return @"myCollectionView";
}

+ (Class) platformObjectClass
{	return [MyCollectionView class];
}
@end
