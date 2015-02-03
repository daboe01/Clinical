@import "WidgetTimestamp.j"

var _STATE_COLORS=[[CPColor whiteColor], [CPColor greenColor], [CPColor redColor]];

@implementation ChartItem: CPCollectionViewItem
{    CPString _char;
    int      _state;
}
-(id) init
{
   if(self=[super init])
   {
       [self setState:0];
   }
   return self;
}
-(void) setState:aState
{
   _state = aState;
   [_view setValue: _STATE_COLORS[_state]  forThemeAttribute:@"background-color"];
}
-(void) state
{
   return _state?  _state : 0;
   [_view setValue: _STATE_COLORS[_state]  forThemeAttribute:@"background-color"];
}

-(CPView) loadView
{
    var myview=[CPBox new];
    [myview setTitle:_char];
    [myview setTitleFont:[CPFont boldSystemFontOfSize:18]]
    [myview setTitlePosition:CPBelowTop];
    [myview setBorderType:CPLineBorder];
    [myview setBorderWidth:0];
    [myview setBoxType:CPBoxSeparator]

    [self setView:myview];
    [self setState:_state]
    return myview;
}

-(void) setRepresentedObject:(id)someObject
{
   _char=someObject;
    [super setRepresentedObject:someObject];
    [self loadView];
}

-(void) setSelected:(BOOL) state
{   [_view setValue:state ? [CPColor blackColor]: [CPColor colorWithWhite:(190.0 / 255.0) alpha: 1.0]  forThemeAttribute:@"border-color"];
}

@end

@implementation ChartView : CPCollectionView
+ (Class)_binderClassForBinding:(CPString)aBinding
{
    return [_CPValueBinder class];
}
- (void)_reverseSetBinding
{
    var binderClass = [[self class] _binderClassForBinding:CPValueBinding],
        theBinding = [binderClass getBinding:CPValueBinding forObject:self];

    [theBinding reverseSetValueFor:@"objectValue"];
}
- (void)_setBinding
{
    var binderClass = [[self class] _binderClassForBinding:CPValueBinding],
        theBinding = [binderClass getBinding:CPValueBinding forObject:self];

    [theBinding setValueFor:@"objectValue"];
}

- (void)keyDown:(CPEvent)anEvent
{
   [super keyDown:anEvent];
   var state = 0;
   switch([anEvent keyCode])
   {
       case 114:   // richtig
           state = 1;
       break;
       case 102:  // falsch
           state = 2;
       break;
   }
   if(state) 
   {   [[self selectionIndexes] enumerateIndexesUsingBlock:function(idx, stop)
       {   [[self itemAtIndex:idx] setState:state];
       }];
       [self moveRight:self];
       [self _reverseSetBinding];
  } 
}
- (void)mouseDown:(CPEvent)anEvent
{
   [super mouseDown:anEvent];
   var o= [self itemAtIndex:[[self selectionIndexes] firstIndex]]
   var state = [o state];
   if([anEvent clickCount] == 2)
   {   [o setState:(state < 2)? state + 1 : 0];
       [self _reverseSetBinding];
   }
}

- (void)deleteBackward:(id)sender
{
    [[self selectionIndexes] enumerateIndexesUsingBlock:function(idx, stop)
       {   [[self itemAtIndex:idx] setState:0];
       }];
    [self _reverseSetBinding];
    [self moveLeft:self];
}
- (id)objectValue
{   var ret="";
    var i,l=[_items count];
    for (i = 0; i <  l; i++)
    {   ret+=[[self itemAtIndex:i] state]+"";
    }
    return ret;
}
- (void)setObjectValue:(id)aStr
{
    if(!aStr) return;
    var arr = [];
    var l = aStr.length;
    l=MIN(l, [_items count])
    for (var i = 0; i <  l; i++)
    {   [[self itemAtIndex:i] setState:aStr[i]];
    }
}

- (id)initWithFrame:(CPFrame)aFrame
{
    if(self=[super initWithFrame:aFrame])
    {   [self setSelectionIndexes:[CPIndexSet indexSetWithIndex:0]];
    }
    return self;
}
@end

@implementation WidgetETDRS : WidgetStopwatch 
{
    id _chartView;
    id _chartPopup;
}

- (void)_setLetterString:(CPString)aStr
{
    if(!aStr) return;
    var arr = [];
    var l = aStr.length;
    for (var i = 0; i <  l; i++) arr.push(aStr[i])
    [_chartView setContent:arr];
}

- (void)setLetters:(id)sender
{
    [self _setLetterString:[_chartPopup titleOfSelectedItem] || ''];
}
- (CPString) letters
{   return [[_chartPopup itemAtIndex:value1 === undefined ? 0: value1] title];
}
- (id)view
{
    var aView=[super view];
    [self _setLetterString:[self letters]];
    [_chartView bind:CPValueBinding toObject:self withKeyPath:"value2" options:nil];
    return aView;
}

// our widget changed (hard-wired to value2)
- (void)setValue2:(id)aVal
{
    var aStr=[_chartView objectValue];
    var letters=[self letters]
    var latex = "~\\\\";
    var score=0;
    var l = letters.length;
    for (var i = 0; i <  l; i++)
    {
        var diacritical="~~ ";
        if(i< aStr.length)
        {   switch(aStr[i])
            {   case '1':
                    score++;
                    diacritical="O"
                break;
                case '2':
                    diacritical="X"
                break;
            }
        }
        latex+="\\rlap{~ {\\Large$^"+letters[i]+"$}}{\\Huge "+diacritical+"}";
        if( ((i+1) % 5 == 0)) latex+="\\\\";
    }
    [self setValue3:score];
    value10=latex;
    [super setValue2:aVal];
}

@end


@implementation GSMarkupTagChartView:GSMarkupTagCollectionView
+ (CPString) tagName
{    return @"chartView";
}

+ (Class) platformObjectClass
{    return [ChartView class];
}
@end
