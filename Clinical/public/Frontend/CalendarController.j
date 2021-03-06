@import <AppKit/CPCollectionViewItem.j>
@import <AppKit/CPTokenField.j>

var G_filtered;

@implementation CalendarItem:_CPTokenFieldToken

-(void) mouseDown:event
{   [self setThemeState:CPThemeStateEditing];
	[super mouseDown:event]
}

-(void) mouseUp:event
{   [self unsetThemeState:CPThemeStateEditing];
    [self sendAction:[self action] to:[self target]];
	[super mouseUp:event]
}
@end

var _DOW_NAMES=['MO','DI','MI','DO','FR','SA','SO'];
var _itemcache=[];
@implementation CalendarHeaderItem: CPCollectionViewItem
{	unsigned dow;
}
- initWithDOW: aDow
{	self=[super init];
	dow=aDow;
	return self;
}
-(CPView) loadView
{	var myview=[CPTextField new];
	[myview setFont:[CPFont systemFontOfSize: 18]];
    [myview setTextColor: [CPColor darkGrayColor] ];
	_view= myview;
}
-(void) setRepresentedObject: someObject
{	if(someObject) [_view setStringValue: _DOW_NAMES[someObject.dow]];
}

@end

@implementation CalendarDayItem: CPCollectionViewItem
{	id day;
	id mydocview;
}
-(void) connection: someConnection didReceiveData: data
{
	var arr = JSON.parse( data );
	var i,l=arr.length;
	var mybutton;
	for(i=0;i<l;i++)
	{	mybutton=[CalendarItem new];

        var re = new RegExp("^[0-9]{4}-[0-9]{2}-[0-9]{2} ([0-9]{2}:[0-9]{2}).+");
        var m = re.exec(arr[i]["event_date"]);
        var title=arr[i]["name"];
        if(m && m[1] !=='00:00') title=m[1]+" "+title;
		[mybutton setStringValue: title ];
		[mybutton setFont: [CPFont systemFontOfSize:9]];
		[mybutton setTextColor:  arr[i]["type"]==1? [CPColor blackColor]:[CPColor darkGrayColor] ];
		[mybutton setTarget: [[self collectionView] delegate]];
		[mybutton setAction:@selector(open:)];
		[mybutton setRepresentedObject:arr[i]];
		var tt=arr[i]["tooltip"];
		if(tt)
		{	[mybutton setToolTip: tt];
		}
		[mybutton setFrame:CPMakeRect(2,i*20,125,19)];
		[mydocview addSubview:mybutton];
        if(i)
        {
            var buttonframe= [mydocview convertRect:[mybutton frame] toView: [mydocview superview]]
            [mydocview setFrame:CGRectUnion([mydocview frame], buttonframe)]
        }
	}
}

-(CPView) _viewForDateString:(CPString) aday
{	var myview=[CPBox new];
	var re = new RegExp("(....)-(..)-(..)");
	var m = re.exec(aday);
	if(m)  [myview setTitle:m[3]];

	[myview setTitleFont: [CPFont boldSystemFontOfSize: 18] ]
	[myview setTitlePosition: CPBelowTop];
    [myview setBorderType:  CPLineBorder ];
    [myview setBorderWidth:  0 ];
	[myview setBoxType: CPBoxSeparator]

	var myscroller=[[CPScrollView alloc] initWithFrame:CPMakeRect(0,0,150,100)];
	[myscroller setAutohidesScrollers: YES];
	 mydocview=[[CPView alloc] initWithFrame:CPMakeRect(2,20,130,60)];
	[myscroller setDocumentView: mydocview];
	[myview setContentView: myscroller];
	if(aday)
	{	var myurl=HostURL+"/CT/CAL/"+ aday+'?session='+ window.G_SESSION;
        if(G_filtered)
            myurl+="&personal=1";
		var myreq=[CPURLRequest requestWithURL: myurl];
		[CPURLConnection connectionWithRequest: myreq delegate: self];
	}
	return myview;
}
-(CPView) loadView
{	var myview= _itemcache[day]? _itemcache[day] : (_itemcache[day]=[self _viewForDateString: day]);
	[self setView: myview];
	return myview;
}
-(void) setRepresentedObject: someObject
{	day=[someObject valueForKey:"day"];
	[super setRepresentedObject: someObject];
	[self loadView];
}

-(void) setSelected:(BOOL) state
{    [_view setValue:state? [CPColor yellowColor]: [CPColor colorWithWhite:(190.0 / 255.0) alpha: 1.0]  forThemeAttribute:@"border-color"];
}

@end

@implementation CalendarController : CPObject
{	id	calendarWindow;
	id	calendarView;
	id	calendarHeader;
    id  filterSwitch;
	id	month @accessors;
	id	year @accessors;
}
- (void) setMonth:(unsigned) aMonth
{	month=aMonth;
	if(month && year) [self loadCalendarForMonth: month andYear: year];
}
- (void) setYear:(unsigned) aYear
{	year=aYear;
	if(month && year) [self loadCalendarForMonth: month andYear: year];
}

- (void) loadCalendarForMonth:(unsigned) month andYear:(unsigned) year
{
    G_filtered=[filterSwitch state];
	var myreq=[CPURLRequest requestWithURL: HostURL +"/CT/CAL/"+ year+"/"+month ];
	var data=[[CPURLConnection sendSynchronousRequest: myreq returningResponse: nil]  rawString];
	var arr = JSON.parse( data );
	if(!arr) arr=[];
	var i,l=arr.length;
	var content=[CPMutableArray new];

	for(i=0;i<l;i++)
	{	[content addObject: [CPDictionary dictionaryWithObjects: [arr[i]["day"]] forKeys:["day"]] ];
	}
	[calendarView setContent: content];
}

-(void)changeFilterForMe:sender
{
    _itemcache=[];
    [self loadCalendarForMonth: month andYear: year]
}

- (void) selectDate:(CPString)myDate
{	var arr=[calendarView content];
	var i,l=[arr count];
	for (i=0 ; i<  l ; i++)
	{	if ([[arr objectAtIndex:i] objectForKey:"day"] == myDate)
		{   [calendarView setSelectionIndexes:[CPIndexSet indexSetWithIndex: i]];
            break;
        }
	}
}

-(void) selectToday: sender
{	var now=[[CPDate date] description];
	var re = new RegExp("^(....)-(..)-(..)");
	var m = re.exec(now);
	[self setMonth: m[2]];
	[self setYear:  m[1]];
	[self selectDate: m[1]+"-"+m[2]+"-"+m[3] ];
}


- (void) init
{
    if(self=[super init]){
        [CPBundle loadRessourceNamed: "Calendar.gsmarkup" owner:self];
        [calendarView setDelegate: self];
        var i;
        var arr=[];
        for (i=0 ; i<  7 ; i++)
        {	var header=[[CalendarHeaderItem alloc] initWithDOW:i];
            arr.push(header)
        }
        [calendarHeader setContent:arr];
        [self selectToday: self];
    }
    return self;
}

-(void) open: sender
{	var piz=[sender representedObject]["piz"];
//	if(piz) [[DocsCalController alloc] initWithPIZ:piz];
}

-(void)createConflictList: sender
{   document.location='/CT/conflictlist?session='+ window.G_SESSION;
}

@end

