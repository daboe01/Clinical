/*
 *  CPTextView.j
 *  AppKit
 *
 *  Created by Daniel Boehringer on 27/12/2013.
 *  All modifications copyright Daniel Boehringer 2013.
 *  Based on original
 *  Created by Emmanuel Maillard on 27/02/2010.
 *  Copyright Emmanuel Maillard 2010.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import "CPText.j"
@import "CPParagraphStyle.j"
@import "CPTextStorage.j"
@import "CPTextContainer.j"
@import "CPLayoutManager.j"
@import <AppKit/CPFontManager.j>
@import "CPFontManagerAdditions.j"
@import "RTFProducer.j"
@import "RTFParser.j"

@class _CPRTFProducer;
@class _CPRTFParser;

_MakeRangeFromAbs = function(a1, a2)
{
    return (a1 < a2) ? CPMakeRange(a1, a2 - a1) : CPMakeRange(a2, a1 - a2);
};
_MidRange = function(a1)
{
    return FLOOR((CPMaxRange(a1) + a1.location) / 2);
};

_characterTripletFromStringAtIndex=function(string, index)
{
    if([string isKindOfClass:CPAttributedString])
        string = string._string;

    var tripletRange = _MakeRangeFromAbs(MAX(0, index - 1), MIN(string.length, index + 2)),
        ret = [string substringWithRange:tripletRange];

    if (tripletRange.length < 3 && index == 0)
    {
        ret = " " + ret;
    }

    return ret;
}
_regexMatchesStringAtIndex=function(regex, string, index)
{
    var triplet = _characterTripletFromStringAtIndex(string, index);

    return regex.exec(triplet)  !== null;
}


@implementation CPPlatformPasteboard(SafariFix)

- (boolean)nativePasteEvent:(DOMEvent)aDOMEvent
{
    // This shouldn't happen.
    if (!supportsNativeCopyAndPaste)
        return;

    var value;
    if (aDOMEvent.clipboardData && aDOMEvent.clipboardData.setData)
        value = aDOMEvent.clipboardData.getData('text/plain');
    else
        value = _DOMWindow.clipboardData.getData("Text");

    if ([value length])
    {
        var pasteboard = [CPPasteboard generalPasteboard];

        if ([pasteboard _stateUID] != value)
        {
            [pasteboard declareTypes:[CPStringPboardType] owner:self];
            [pasteboard setString:value forType:CPStringPboardType];
        }
    }

    var anEvent = [self _fakeClipboardEvent:aDOMEvent type:"v"],
        platformWindow = [[anEvent window] platformWindow];

    anEvent._suppressCappuccinoPaste = YES;
    anEvent._isFake = YES;

    // By default we'll stop the native handling of the event since we're handling it ourselves. However, we need to
    // stop it before we send the event so that the event can overrule our choice. CPTextField for instance wants the
    // default handling when focused (which is to insert into the field).
    [platformWindow _propagateCurrentDOMEvent:NO]

    [CPApp sendEvent:anEvent];

    [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    if (![platformWindow _willPropagateCurrentDOMEvent])
        _CPDOMEventStop(aDOMEvent, self);

    return false;
}
@end

// FIXME: move to theme!
@implementation CPColor(CPTextViewExtensions)

+ (CPColor)selectedTextBackgroundColor
{
    return [CPColor colorWithHexString:"99CCFF"];
}
+ (CPColor)selectedTextBackgroundColorUnfocussed
{
    return [CPColor colorWithHexString:"CCCCCC"];
}

@end


/*
    CPSelectionGranularity
*/
CPSelectByCharacter = 0;
CPSelectByWord      = 1;
CPSelectByParagraph = 2;


var kDelegateRespondsTo_textShouldBeginEditing                                          = 0x0001,
    kDelegateRespondsTo_textView_doCommandBySelector                                    = 0x0002,
    kDelegateRespondsTo_textView_willChangeSelectionFromCharacterRange_toCharacterRange = 0x0004,
    kDelegateRespondsTo_textView_shouldChangeTextInRange_replacementString              = 0x0008,
    kDelegateRespondsTo_textView_shouldChangeTypingAttributes_toAttributes              = 0x0010;



@implementation CPText : CPControl
{
}

- (void)changeFont:(id)sender
{
    CPLog.error(@"-[CPText " + _cmd + "] subclass responsibility");
}

- (void)copy:(id)sender
{
    var selectedRange = [self selectedRange];

    if (selectedRange.length < 1)
            return;

    var pasteboard = [CPPasteboard generalPasteboard],
        stringForPasting = [[self stringValue] substringWithRange:selectedRange];

    [pasteboard declareTypes:[CPStringPboardType] owner:nil];

    if ([self isRichText])
    {
       // crude hack to make rich pasting possible in chrome and firefox. this requires a RTF roundtrip, unfortunately
        var richData =  [_CPRTFProducer produceRTF:[[self textStorage] attributedSubstringFromRange:selectedRange] documentAttributes:@{}];
        [pasteboard setString:richData forType:CPStringPboardType];
    }
    else
        [pasteboard setString:stringForPasting forType:CPStringPboardType];

}

- (void)paste:(id)sender
{
    if(CPPlatformHasBug(CPJavaScriptPasteRequiresEditableTarget) && ![CPApp currentEvent]._isFake)
        return;

    var pasteboard = [CPPasteboard generalPasteboard],
      //  dataForPasting = [pasteboard dataForType:CPRichStringPboardType],
        stringForPasting = [pasteboard stringForType:CPStringPboardType];


    if ([stringForPasting hasPrefix:"{\\rtf1\\ansi"])
        stringForPasting = [[_CPRTFParser new] parseRTF:stringForPasting];

    if (![self isRichText] && [stringForPasting isKindOfClass:[CPAttributedString class]])
        stringForPasting = stringForPasting._string;

    if (stringForPasting)
        [self insertText:stringForPasting];
}

- (void)copyFont:(id)sender
{
    CPLog.error(@"-[CPText " + _cmd + "] subclass responsibility");
}


- (void)delete:(id)sender
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (CPFont)font:(CPFont)aFont
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return nil;
}

- (BOOL)isHorizontallyResizable
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return NO;
}

- (BOOL)isRichText
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return NO;
}

- (BOOL)isRulerVisible
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return NO;
}

- (BOOL)isVerticallyResizable
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return NO;
}

- (CGSize)maxSize
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return CPMakeSize(0,0);
}

- (CGSize)minSize
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return CPMakeSize(0,0);
}

- (void)pasteFont:(id)sender
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (void)replaceCharactersInRange:(CPRange)aRange withString:(CPString)aString
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (void)scrollRangeToVisible:(CPRange)aRange
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (void)selectedAll:(id)sender
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (CPRange)selectedRange
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return CPMakeRange(CPNotFound, 0);
}

- (void)setFont:(CPFont)aFont
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (void)setFont:(CPFont)aFont rang:(CPRange)aRange
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (void)setHorizontallyResizable:(BOOL)flag
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (void)setMaxSize:(CGSize)aSize
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (void)setMinSize:(CGSize)aSize
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (void)setString:(CPString)aString
{
    [self replaceCharactersInRange:CPMakeRange(0, [[self string] length]) withString:aString];
}

- (void)setUsesFontPanel:(BOOL)flag
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (void)setVerticallyResizable:(BOOL)flag
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (CPString)string
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return nil;
}

- (void)underline:(id)sender
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
}

- (BOOL)usesFontPanel
{
    CPLog.error(@"-[CPText "+_cmd+"] subclass responsibility");
    return NO;
}

@end


/*!
    @ingroup appkit
    @class CPTextView
*/
@implementation CPTextView : CPText
{
    CPTextStorage   _textStorage;
    CPTextContainer _textContainer;
    CPLayoutManager _layoutManager;
    id              _delegate;

    unsigned        _delegateRespondsToSelectorMask;

    CGSize          _textContainerInset;
    CGPoint         _textContainerOrigin;

    int             _startTrackingLocation;
    CPRange         _selectionRange;
    CPDictionary    _selectedTextAttributes;
    int             _selectionGranularity;
    int             _previousSelectionGranularity;
    int             _copySelectionGranularity;

    CPColor         _insertionPointColor;

    CPDictionary    _typingAttributes;

    BOOL            _isFirstResponder;

    BOOL            _drawCaret;
    CPTimer         _caretTimer;
    CPTimer         _scollingTimer;
    CPGect          _caretRect;

    CPFont          _font;
    CPColor         _textColor;

    CGSize          _minSize;
    CGSize          _maxSize;

    BOOL            _scrollingDownward;

    /* use bit mask ? */
    BOOL            _isRichText;
    BOOL            _usesFontPanel;
    BOOL            _allowsUndo;
    BOOL            _isHorizontallyResizable;
    BOOL            _isVerticallyResizable;
    BOOL            _isEditable;
    BOOL            _isSelectable;

    var             _caretDOM;
    int             _stickyXLocation;

    CPArray         _selectionSpans;
}

- (id)initWithFrame:(CGRect)aFrame textContainer:(CPTextContainer)aContainer
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        self._DOMElement.style.cursor = "text";
        _textContainerInset = CGSizeMake(2,0);
        _textContainerOrigin = CGPointMake(_bounds.origin.x, _bounds.origin.y);
        [aContainer setTextView:self];
        _isEditable = YES;
        _isSelectable = YES;

        _isFirstResponder = NO;
        _delegate = nil;
        _delegateRespondsToSelectorMask = 0;
        _selectionRange = CPMakeRange(0, 0);

        _selectionGranularity = CPSelectByCharacter;
        _selectedTextAttributes = [CPDictionary dictionaryWithObject:[CPColor selectedTextBackgroundColor]
                                                forKey:CPBackgroundColorAttributeName];

        _insertionPointColor = [CPColor blackColor];
        _textColor = [CPColor blackColor];
        _font = [CPFont systemFontOfSize:12.0];
        [self setFont:_font];

        _typingAttributes = [[CPDictionary alloc] initWithObjects:[_font, _textColor] forKeys:[CPFontAttributeName, CPForegroundColorAttributeName]];

        _minSize = CGSizeCreateCopy(aFrame.size);
        _maxSize = CGSizeMake(aFrame.size.width, 1e7);

        _isRichText = YES;
        _usesFontPanel = YES;
        _allowsUndo = YES;
        _isVerticallyResizable = YES;
        _isHorizontallyResizable = NO;

        _caretRect = CGRectMake(0,0,1,11);
        [self setBackgroundColor:[CPColor whiteColor]];
    }

    [self registerForDraggedTypes:[CPColorDragType]];

    return self;
}

- (void)copy:(id)sender
{
   _copySelectionGranularity = _previousSelectionGranularity;
   [super copy:sender];
}

- (void)paste:(id)sender
{
    if (_copySelectionGranularity > 0)
    {
        if (![self _isCharacterAtIndex:MAX(0, _selectionRange.location - 1) granularity:_copySelectionGranularity])
        {
            [self insertText:" "];
        }
    }
    [super paste:sender];
    if (_copySelectionGranularity > 0)
    {
        if (![self _isCharacterAtIndex:CPMaxRange(_selectionRange) granularity:_copySelectionGranularity])
        {
            [self insertText:" "];
        }
    }
}

- (BOOL)_isFocused
{
   return [[self window] isKeyWindow] && _isFirstResponder;
}
- (void)becomeKeyWindow
{
    [self setNeedsDisplay:YES];
}

/*!
    @ignore
*/
- (void)resignKeyWindow
{
    [self setNeedsDisplay:YES];
}

- (void)undo:(id)sender
{
    if (_allowsUndo)
        [[[self window] undoManager] undo];
}

- (void)redo:(id)sender
{
    if (_allowsUndo)
        [[[self window] undoManager] redo];
}

- (id)initWithFrame:(CGRect)aFrame
{
    var layoutManager = [[CPLayoutManager alloc] init],
        textStorage = [[CPTextStorage alloc] init],
        container = [[CPTextContainer alloc] initWithContainerSize:CGSizeMake(aFrame.size.width, 1e7)];

    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:container];

    return [self initWithFrame:aFrame textContainer:container];
}

- (void)setDelegate:(id)aDelegate
{
    _delegateRespondsToSelectorMask = 0;

    if (_delegate)
        [[CPNotificationCenter defaultCenter] removeObserver:_delegate name:nil object:self];

    _delegate = aDelegate;

    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(textDidChange:)])
            [[CPNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(textDidChange:) name:CPTextDidChangeNotification object:self];

        if ([_delegate respondsToSelector:@selector(textViewDidChangeSelection:)])
            [[CPNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(textViewDidChangeSelection:) name:CPTextViewDidChangeSelectionNotification object:self];

        if ([_delegate respondsToSelector:@selector(textViewDidChangeTypingAttributes:)])
            [[CPNotificationCenter defaultCenter] addObserver:_delegate selector:@selector(textViewDidChangeTypingAttributes:) name:CPTextViewDidChangeTypingAttributesNotification object:self];

        if ([_delegate respondsToSelector:@selector(textView:doCommandBySelector:)])
            _delegateRespondsToSelectorMask |= kDelegateRespondsTo_textView_doCommandBySelector;

        if ([_delegate respondsToSelector:@selector(textShouldBeginEditing:)])
            _delegateRespondsToSelectorMask |= kDelegateRespondsTo_textShouldBeginEditing;

        if ([_delegate respondsToSelector:@selector(textView:willChangeSelectionFromCharacterRange:toCharacterRange:)])
            _delegateRespondsToSelectorMask |= kDelegateRespondsTo_textView_willChangeSelectionFromCharacterRange_toCharacterRange;

        if ([_delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementString:)])
            _delegateRespondsToSelectorMask |= kDelegateRespondsTo_textView_shouldChangeTextInRange_replacementString;

        if ([_delegate respondsToSelector:@selector(textView:shouldChangeTypingAttributes:toAttributes:)])
            _delegateRespondsToSelectorMask |= kDelegateRespondsTo_textView_shouldChangeTypingAttributes_toAttributes;
    }
}

- (CPString)string
{
    return [_textStorage string];
}

- (void)setString:(CPString)aString
{
    [_textStorage replaceCharactersInRange:CPMakeRange(0, [_layoutManager numberOfCharacters]) withString:aString];
    [self didChangeText];
    [_layoutManager _validateLayoutAndGlyphs];
    [self sizeToFit];
    [self setNeedsDisplay:YES];
}

// KVO support
- (void)setValue:(CPString)aValue
{
    [self setString:[aValue description]]
}

- (id)value
{
    [self string]
}

- (void)setTextContainer:(CPTextContainer)aContainer
{
    _textContainer = aContainer;
    _layoutManager = [_textContainer layoutManager];
    _textStorage = [_layoutManager textStorage];
    [_textStorage setFont:_font];
    [_textStorage setForegroundColor:_textColor];

    [self invalidateTextContainerOrigin];
}

- (CPTextStorage)textStorage
{
    return _textStorage;
}

- (CPTextContainer)textContainer
{
    return _textContainer;
}

- (CPLayoutManager)layoutManager
{
    return _layoutManager;
}

- (void)setTextContainerInset:(CGSize)aSize
{
    _textContainerInset = aSize;
    [self invalidateTextContainerOrigin];
}

- (CGSize)textContainerInset
{
    return _textContainerInset;
}

- (CGPoint)textContainerOrigin
{
    return _textContainerOrigin;
}

- (void)invalidateTextContainerOrigin
{
    _textContainerOrigin.x = _bounds.origin.x;
    _textContainerOrigin.x += _textContainerInset.width;

    _textContainerOrigin.y = _bounds.origin.y;
    _textContainerOrigin.y += _textContainerInset.height;
}

- (BOOL)isEditable
{
    return _isEditable;
}

- (void)setEditable:(BOOL)flag
{
    _isEditable = flag;
    if (flag)
        _isSelectable = flag;
}

- (BOOL)isSelectable
{
    return _isSelectable;
}

- (void)setSelectable:(BOOL)flag
{
    _isSelectable = flag;
    if (flag)
        _isEditable = flag;
}

- (void)doCommandBySelector:(SEL)aSelector
{
    var done = NO;

    if (_delegateRespondsToSelectorMask & kDelegateRespondsTo_textView_doCommandBySelector)
        done = [_delegate textView:self doCommandBySelector:aSelector];

    if (!done)
        [super doCommandBySelector:aSelector];
}

- (void)didChangeText
{
    [[CPNotificationCenter defaultCenter] postNotificationName:CPTextDidChangeNotification object:self];
}

- (BOOL)shouldChangeTextInRange:(CPRange)aRange replacementString:(CPString)aString
{
    if (!_isEditable)
        return NO;

    var shouldChange = YES;

    if (_delegateRespondsToSelectorMask & kDelegateRespondsTo_textShouldBeginEditing)
        shouldChange = [_delegate textShouldBeginEditing:self];

    if (shouldChange && (_delegateRespondsToSelectorMask & kDelegateRespondsTo_textView_shouldChangeTextInRange_replacementString))
        shouldChange = [_delegate textView:self shouldChangeTextInRange:aRange replacementString:aString];

    return shouldChange;
}

- (void)_fixupReplaceForRange:(CPRange)aRange
{
    [self setSelectedRange:aRange];
    [_layoutManager _validateLayoutAndGlyphs];
    [self sizeToFit];
    [self scrollRangeToVisible:_selectionRange];
    [self setNeedsDisplay:YES];
}
- (void)_replaceCharactersInRange:aRange withAttributedString:(CPString)aString
{
    [[[[self window] undoManager] prepareWithInvocationTarget:self]
                _replaceCharactersInRange:CPMakeRange(aRange.location, [aString length])
                withAttributedString:[_textStorage attributedSubstringFromRange:CPMakeRangeCopy(aRange)]];

    [_textStorage replaceCharactersInRange:aRange withAttributedString:aString];
    [self _fixupReplaceForRange:CPMakeRange(aRange.location, [aString length])];
}
- (void)_replaceCharactersInRange:(CPRange)aRange withString:(CPString)aString
{
    [[[[self window] undoManager] prepareWithInvocationTarget:self]
                _replaceCharactersInRange:CPMakeRange(aRange.location, [aString length])
                withString:[[self string] substringWithRange:CPMakeRangeCopy(aRange)]];

    [_textStorage replaceCharactersInRange:CPMakeRangeCopy(aRange) withString:aString];
    [self _fixupReplaceForRange:CPMakeRange(aRange.location, [aString length])];
}

- (void)insertText:(CPString)aString
{
    var isAttributed = [aString isKindOfClass:CPAttributedString],
        string = (isAttributed)?[aString string]:aString;

    if (![self shouldChangeTextInRange:CPMakeRangeCopy(_selectionRange) replacementString:string])
        return;


    if (isAttributed)
    {
        [[[[self window] undoManager] prepareWithInvocationTarget:self]
                _replaceCharactersInRange:CPMakeRange(_selectionRange.location, [aString length])
                withAttributedString:[_textStorage attributedSubstringFromRange:CPMakeRangeCopy(_selectionRange)]];
        [[[self window] undoManager] setActionName:@"Replace rich text"];

        [_textStorage replaceCharactersInRange:CPMakeRangeCopy(_selectionRange) withAttributedString:aString];
    }
    else
    {
        [[[self window] undoManager] setActionName:@"Replace plain text"];
        if (_isRichText)
        {
            aString = [[CPAttributedString alloc] initWithString:aString attributes:_typingAttributes];
            [[[[self window] undoManager] prepareWithInvocationTarget:self]
                _replaceCharactersInRange:CPMakeRange(_selectionRange.location, [aString length])
                withAttributedString:[_textStorage attributedSubstringFromRange:CPMakeRangeCopy(_selectionRange)]];
            [_textStorage replaceCharactersInRange:CPMakeRangeCopy(_selectionRange) withAttributedString:aString];
        }
        else
        {
            [[[[self window] undoManager] prepareWithInvocationTarget:self] _replaceCharactersInRange:CPMakeRange(_selectionRange.location, [aString length])
                                                                                           withString:[[self string] substringWithRange:CPMakeRangeCopy(_selectionRange)]];
            [_textStorage replaceCharactersInRange: CPMakeRangeCopy(_selectionRange) withString:aString];
        }
    }

    [self setSelectedRange:CPMakeRange(_selectionRange.location + [string length], 0)];

    [self didChangeText];
    [_layoutManager _validateLayoutAndGlyphs];
    [self sizeToFit];
    [self scrollRangeToVisible:_selectionRange];
    _stickyXLocation = _caretRect.origin.x;
}

- (void)_blinkCaret:(CPTimer)aTimer
{
    _drawCaret = !_drawCaret;
    [self setNeedsDisplayInRect:_caretRect];
}

- (id) _createSelectionSpanForRect:(CPRect)aRect andColor:(CPColor)aColor
{
    var ret = document.createElement("span");
    ret.style.position = "absolute";
    ret.style.visibility = "visible";
    ret.style.padding = "0px";
    ret.style.margin = "0px";
    ret.style.whiteSpace = "pre";
    ret.style.backgroundColor = [aColor cssString];

    ret.style.width = (aRect.size.width)+"px";
    ret.style.left = (aRect.origin.x) + "px";
    ret.style.top = (aRect.origin.y) + "px";
    ret.style.height = (aRect.size.height) + "px";
    ret.style.zIndex = -1000;
    ret.oncontextmenu = ret.onmousedown = ret.onmouseup = ret.onselectstart = function () { return false; };
    return ret;
}

- (void)drawRect:(CGRect)aRect
{
    var range = [_layoutManager glyphRangeForBoundingRect:aRect inTextContainer:_textContainer];

    if (_selectionSpans)
    {
        for (var i = 0; i < _selectionSpans.length; i++)
        {
            _DOMElement.removeChild(_selectionSpans[i]);
        }
    }
    _selectionSpans = [];

    if (_selectionRange.length)
    {
        var rects = [_layoutManager rectArrayForCharacterRange:_selectionRange
                                    withinSelectedCharacterRange:_selectionRange
                                    inTextContainer:_textContainer
                                    rectCount:nil],
            rectsLength = rects.length;


        var effectiveSelectionColor = [self _isFocused]? [_selectedTextAttributes objectForKey:CPBackgroundColorAttributeName] : [CPColor selectedTextBackgroundColorUnfocussed];

        for (var i = 0; i < rectsLength; i++)
        {
            rects[i].origin.x += _textContainerOrigin.x;
            rects[i].origin.y += _textContainerOrigin.y;
            var newSpan = [self _createSelectionSpanForRect:rects[i] andColor:effectiveSelectionColor];
            _selectionSpans.push(newSpan);
            _DOMElement.appendChild(newSpan);
        }

    }

    if (range.length)
        [_layoutManager drawGlyphsForGlyphRange:range atPoint:_textContainerOrigin];

    if ([self shouldDrawInsertionPoint])
    {
        [self updateInsertionPointStateAndRestartTimer:NO];
        [self drawInsertionPointInRect:_caretRect color:_insertionPointColor turnedOn:_drawCaret];
    }
    else   // <!> FIXME: breaks DOM abstraction, but i did get it working otherwise
        if (_caretDOM)
            _caretDOM.style.visibility = "hidden";
}

- (void)setSelectedRange:(CPRange)range
{
    [self setSelectedRange:range affinity:0 stillSelecting:NO];
    [self setTypingAttributes:[_textStorage attributesAtIndex:MAX(0, range.location -1) effectiveRange:nil]];
}

- (void)setSelectedRange:(CPRange)range affinity:(CPSelectionAffinity /* unused */ )affinity stillSelecting:(BOOL)selecting
{
    var maxRange = CPMakeRange(0, [_layoutManager numberOfCharacters]);
    range = CPIntersectionRange(maxRange, range);

    if (!selecting && (_delegateRespondsToSelectorMask & kDelegateRespondsTo_textView_willChangeSelectionFromCharacterRange_toCharacterRange))
        _selectionRange = [_delegate textView:self willChangeSelectionFromCharacterRange:_selectionRange toCharacterRange:range];
    else
    {
        _selectionRange = CPMakeRangeCopy(range);
        _selectionRange = [self selectionRangeForProposedRange:_selectionRange granularity:[self selectionGranularity]];
    }

    if (_selectionRange.length)
        [_layoutManager invalidateDisplayForGlyphRange:_selectionRange];
    else
        [self setNeedsDisplay:YES];

    if (!selecting)
    {
        if (_isFirstResponder)
            [self updateInsertionPointStateAndRestartTimer:((_selectionRange.length === 0) && ![_caretTimer isValid])];

        [self setTypingAttributes:[_textStorage attributesAtIndex:MAX(0, range.location -1) effectiveRange:nil]];

        [[CPNotificationCenter defaultCenter] postNotificationName:CPTextViewDidChangeSelectionNotification object:self];

        if(CPPlatformHasBug(CPJavaScriptPasteRequiresEditableTarget))
        {
            var domelem = _window._platformWindow._platformPasteboard._DOMPasteboardElement;
            domelem.value=" ";  // make sure we do not get an empty selection
            domelem.focus()
            domelem.select()
        }
    }
}

- (CPArray)selectedRanges
{
    return [_selectionRange];
}

- (void)keyDown:(CPEvent)event
{
    [self interpretKeyEvents:[event]];
}

- (void)mouseDown:(CPEvent)event
{
    var fraction = [],
        point = [self convertPoint:[event locationInWindow] fromView:nil];

    /* stop _caretTimer */
    [_caretTimer invalidate];
    _caretTimer = nil;
    [self _hideCaret];

    // convert to container coordinate
    point.x -= _textContainerOrigin.x;
    point.y -= _textContainerOrigin.y;

    _startTrackingLocation = [_layoutManager glyphIndexForPoint:point inTextContainer:_textContainer fractionOfDistanceThroughGlyph:fraction];

    if (_startTrackingLocation === CPNotFound)
        _startTrackingLocation = [_layoutManager numberOfCharacters];

    var granularities = [-1, CPSelectByCharacter, CPSelectByWord, CPSelectByParagraph];
    [self setSelectionGranularity:granularities[[event clickCount]]];

    var setRange = CPMakeRange(_startTrackingLocation, 0);

    if ([event modifierFlags] & CPShiftKeyMask)
    {
        setRange = _MakeRangeFromAbs(_startTrackingLocation < _MidRange(_selectionRange)?
                                     CPMaxRange(_selectionRange) : _selectionRange.location,
                                     _startTrackingLocation);

    }
    [self setSelectedRange:setRange affinity:0 stillSelecting:YES];
}

- (void)_clearRange:(var)range
{
    var rects = [_layoutManager rectArrayForCharacterRange:nil withinSelectedCharacterRange:range
                                 inTextContainer:_textContainer
                                 rectCount:nil],
        l = rects.length;

    for (var i = 0; i < l ; i++)
    {
        rects[i].origin.x += _textContainerOrigin.x;
        rects[i].origin.y += _textContainerOrigin.y;
        [self setNeedsDisplayInRect:rects[i]];
    }
}

- (void)mouseDragged:(CPEvent)event
{
    var fraction = [],
        point = [self convertPoint:[event locationInWindow] fromView:nil];

    // convert to container coordinate
    point.x -= _textContainerOrigin.x;
    point.y -= _textContainerOrigin.y;

    var oldRange = [self selectedRange],
        index = [_layoutManager glyphIndexForPoint:point
                                inTextContainer:_textContainer
                                fractionOfDistanceThroughGlyph:fraction];

    if (index == CPNotFound)
        index = _scrollingDownward ? CPMaxRange(oldRange) : oldRange.location;

    if (index > oldRange.location)
    {
        [self _clearRange:_MakeRangeFromAbs(oldRange.location,index)];
        _scrollingDownward = YES;
    }

    if (index < CPMaxRange(oldRange))
    {
        [self _clearRange:_MakeRangeFromAbs(index, CPMaxRange(oldRange))];
        _scrollingDownward = NO;
    }

    if (index < _startTrackingLocation)
        [self setSelectedRange:CPMakeRange(index, _startTrackingLocation - index)
              affinity:0
              stillSelecting:YES];
    else
        [self setSelectedRange:CPMakeRange(_startTrackingLocation, index - _startTrackingLocation)
              affinity:0
              stillSelecting:YES];

    [self scrollRangeToVisible:CPMakeRange(index, 0)];
}

// handle all the other methods from CPKeyBinding.j

- (void)mouseUp:(CPEvent)event
{
    /* will post CPTextViewDidChangeSelectionNotification */
    _previousSelectionGranularity = [self selectionGranularity];

    [self setSelectionGranularity:CPSelectByCharacter];
    [self setSelectedRange:[self selectedRange] affinity:0 stillSelecting:NO];
    var point = [_layoutManager locationForGlyphAtIndex:[self selectedRange].location];
    _stickyXLocation= point.x;
    _startTrackingLocation = _selectionRange.location;
}

- (void)moveDown:(id)sender
{
    if (_isSelectable)
    {
        var fraction = [],
            nglyphs= [_layoutManager numberOfCharacters],
            sindex = CPMaxRange([self selectedRange]),
            rectSource = [_layoutManager boundingRectForGlyphRange:CPMakeRange(sindex, 1) inTextContainer:_textContainer],
            rectEnd = nglyphs ? [_layoutManager boundingRectForGlyphRange:CPMakeRange(nglyphs - 1, 1) inTextContainer:_textContainer] : rectSource,
            point = rectSource.origin;

        if (point.y >= rectEnd.origin.y)
            return;

        if (_stickyXLocation)
            point.x = _stickyXLocation;

        // <!> FIXME: Define constants for this magic number
        point.y += 2 + rectSource.size.height;
        point.x += 2;

        var dindex= [_layoutManager glyphIndexForPoint:point inTextContainer:_textContainer fractionOfDistanceThroughGlyph:fraction],
            oldStickyLoc = _stickyXLocation;
        [self _establishSelection:CPMakeRange(dindex,0) byExtending:NO];
        _stickyXLocation = oldStickyLoc;
        [self scrollRangeToVisible:CPMakeRange(dindex, 0)]
    }
}
- (void)moveDownAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
        var oldStartTrackingLocation = _startTrackingLocation;
        [self _performSelectionFixupForRange:CPMakeRange(_selectionRange.location < _startTrackingLocation? _selectionRange.location : CPMaxRange(_selectionRange), 0)];
        [self moveDown:sender];
        _startTrackingLocation = oldStartTrackingLocation;
        [self _performSelectionFixupForRange:_MakeRangeFromAbs(_startTrackingLocation, (_selectionRange.location < _startTrackingLocation? _selectionRange.location : CPMaxRange(_selectionRange)))];
    }
}

- (void)moveUp:(id)sender
{
    if (_isSelectable)
    {
        var fraction = [],
            sindex = [self selectedRange].location,
            rectSource = [_layoutManager boundingRectForGlyphRange:CPMakeRange(sindex, 1) inTextContainer:_textContainer],
            point = rectSource.origin;

        if (point.y <= 0)
            return;

        if (_stickyXLocation)
            point.x = _stickyXLocation;

        point.y -= 2;    // FIXME <!> these should not be constants
        point.x += 2;

        var dindex= [_layoutManager glyphIndexForPoint:point inTextContainer:_textContainer fractionOfDistanceThroughGlyph:fraction],
            oldStickyLoc = _stickyXLocation;
        [self _establishSelection:CPMakeRange(dindex,0) byExtending:NO];
        _stickyXLocation = oldStickyLoc;
        [self scrollRangeToVisible:CPMakeRange(dindex, 0)]
    }
}
- (void)moveUpAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
        var oldStartTrackingLocation = _startTrackingLocation;
        [self _performSelectionFixupForRange:CPMakeRange(_selectionRange.location < _startTrackingLocation? _selectionRange.location : CPMaxRange(_selectionRange), 0)];
        [self moveUp:sender];
        _startTrackingLocation = oldStartTrackingLocation;
        [self _performSelectionFixupForRange:_MakeRangeFromAbs(_startTrackingLocation, (_selectionRange.location < _startTrackingLocation? _selectionRange.location : CPMaxRange(_selectionRange)))];
    }
}
- (void)_performSelectionFixupForRange:(CPRange)aSel
{
    aSel.location = MAX(0, aSel.location);
    if (CPMaxRange(aSel) > [_layoutManager numberOfCharacters])
        aSel = CPMakeRange([_layoutManager numberOfCharacters], 0);
    [self setSelectedRange:aSel];
    var point = [_layoutManager locationForGlyphAtIndex:aSel.location];
    _stickyXLocation = point.x;
}

- (void)_establishSelection:(CPSelection)aSel byExtending:(BOOL)flag
{
    if (flag)
    {
        aSel = CPUnionRange(aSel, _selectionRange);
    }

    [self _performSelectionFixupForRange:aSel];
    _startTrackingLocation = _selectionRange.location;
}
- (unsigned)_calculateMoveSelectionFromRange:(CPRange)aRange intoDirection:(integer)move granularity:(CPSelectionGranularity)granularity
{
    var inWord = ![self _isCharacterAtIndex:(move > 0 ? CPMaxRange(aRange) : aRange.location) + move granularity:granularity],
        aSel = [self selectionRangeForProposedRange:CPMakeRange((move > 0 ? CPMaxRange(aRange) : aRange.location) + move, 0) granularity:granularity],
        bSel = [self selectionRangeForProposedRange:CPMakeRange((move > 0 ? CPMaxRange(aSel) : aSel.location) + move, 0) granularity:granularity];
    return move > 0 ? CPMaxRange(inWord? aSel:bSel) : (inWord? aSel:bSel).location;
}

- (void)_moveSelectionIntoDirection:(integer)move granularity:(CPSelectionGranularity)granularity
{
    var pos = [self _calculateMoveSelectionFromRange:_selectionRange intoDirection:move granularity:granularity];
    [self _performSelectionFixupForRange:CPMakeRange(pos, 0)];
    _startTrackingLocation = _selectionRange.location;
}

- (void)_extendSelectionIntoDirection:(integer)move granularity:(CPSelectionGranularity)granularity
{
    var aSel = CPMakeRangeCopy(_selectionRange);

    if (granularity !== CPSelectByCharacter)
    {   var pos = [self _calculateMoveSelectionFromRange:CPMakeRange(aSel.location < _startTrackingLocation? aSel.location : CPMaxRange(aSel), 0)
                                           intoDirection:move granularity:granularity];
        aSel = CPMakeRange(pos, 0);
    }
    else
        aSel = CPMakeRange((aSel.location < _startTrackingLocation? aSel.location : CPMaxRange(aSel)) + move, 0);

    aSel = _MakeRangeFromAbs(_startTrackingLocation, aSel.location);
    [self _performSelectionFixupForRange:aSel];
}

- (void)moveLeftAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
       [self _extendSelectionIntoDirection:-1 granularity:CPSelectByCharacter];
    }
}
- (void)moveBackward:(id)sender
{
    [self moveLeft:sender];
}

- (void)moveBackwardAndModifySelection:(id)sender
{
    [self moveLeftAndModifySelection:sender];
}

- (void)moveRightAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
       [self _extendSelectionIntoDirection:+1 granularity:CPSelectByCharacter];
    }
}
- (void)moveLeft:(id)sender
{
    if (_isSelectable)
    {
        [self _establishSelection:CPMakeRange(_selectionRange.location - 1, 0) byExtending:NO];
    }
}

- (void)moveToEndOfParagraph:(id)sender
{
    if (_isSelectable)
    {
       [self _moveSelectionIntoDirection:+1 granularity:CPSelectByParagraph];
    }
}
- (void)moveToEndOfParagraphAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
       [self _extendSelectionIntoDirection:+1 granularity:CPSelectByParagraph];
    }
}
- (void)moveParagraphForwardAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
      [self _extendSelectionIntoDirection:+1 granularity:CPSelectByParagraph];
    }
}
- (void)moveParagraphForward:(id)sender
{
    if (_isSelectable)
    {
       [self _moveSelectionIntoDirection:+1 granularity:CPSelectByParagraph]
    }
}
- (void)moveWordBackwardAndModifySelection:(id)sender
{
    [self moveWordLeftAndModifySelection:sender];
}
- (void)moveWordBackward:(id)sender
{
    [self moveWordLeft:sender];
}
- (void)moveWordForwardAndModifySelection:(id)sender
{
    [self moveWordRightAndModifySelection:sender];
}
- (void)moveWordForward:(id)sender
{
    [self moveWordRight:sender];
}

- (void)moveToBeginningOfDocument:(id)sender
{
    if (_isSelectable)
    {
         [self _establishSelection:CPMakeRange(0, 0) byExtending:NO];
    }
}
- (void)moveToBeginningOfDocumentAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
         [self _establishSelection:CPMakeRange(0, 0) byExtending:YES];
    }
}
- (void)moveToEndOfDocument:(id)sender
{
    if (_isSelectable)
    {
         [self _establishSelection:CPMakeRange([_layoutManager numberOfCharacters], 0) byExtending:NO];
    }
}
- (void)moveToEndOfDocumentAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
         [self _establishSelection:CPMakeRange([_layoutManager numberOfCharacters], 0) byExtending:YES];
    }
}

- (void)moveWordRight:(id)sender
{
    if (_isSelectable)
    {
        [self _moveSelectionIntoDirection:+1 granularity:CPSelectByWord]
    }
}

- (void)moveToBeginningOfParagraph:(id)sender
{
    if (_isSelectable)
    {
        [self _moveSelectionIntoDirection:-1 granularity:CPSelectByParagraph]
    }
}
- (void)moveToBeginningOfParagraphAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
       [self _extendSelectionIntoDirection:-1 granularity:CPSelectByParagraph];
    }
}
- (void)moveParagraphBackward:(id)sender
{
    if (_isSelectable)
    {
        [self _moveSelectionIntoDirection:-1 granularity:CPSelectByParagraph]
    }
}
- (void)moveParagraphBackwardAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
       [self _extendSelectionIntoDirection:-1 granularity:CPSelectByParagraph];
    }
}
- (void)moveWordRightAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
         [self _extendSelectionIntoDirection:+1 granularity:CPSelectByWord];

    }
}

- (void)deleteToEndOfParagraph:(id)sender
{
    if (_isSelectable && _isEditable)
    {
        [self moveToEndOfParagraphAndModifySelection:self];
        [self delete:self];
    }
}

- (void)deleteToBeginningOfParagraph:(id)sender
{
    if (_isSelectable && _isEditable)
    {
        [self moveToBeginningOfParagraphAndModifySelection:self];
        [self delete:self];
    }
}
- (void)deleteToBeginningOfLine:(id)sender
{
    if (_isSelectable && _isEditable)
    {
        [self moveToLeftEndOfLineAndModifySelection:self];
        [self delete:self];
    }
}
- (void)deleteToEndOfLine:(id)sender
{
    if (_isSelectable && _isEditable)
    {
        [self moveToRightEndOfLineAndModifySelection:self];
        [self delete:self];
    }
}
- (void)deleteWordBackward:(id)sender
{
    if (_isSelectable && _isEditable)
    {
        [self moveWordLeftAndModifySelection:self];
        [self delete:self];
    }
}
- (void)deleteWordForward:(id)sender
{
    if (_isSelectable && _isEditable)
    {
        [self moveWordRightAndModifySelection:self];
        [self delete:self];
    }
}
- (void)moveToLeftEndOfLine:(id)sender byExtending:(BOOL)flag
{
    if (_isSelectable)
    {
        var fragment = [_layoutManager _lineFragmentForLocation:_selectionRange.location];
        if (!fragment && _selectionRange.location > 0)
            fragment = [_layoutManager _lineFragmentForLocation:_selectionRange.location - 1];
        if (fragment)
            [self _establishSelection:CPMakeRange(fragment._range.location, 0) byExtending:flag];
    }
}
- (void)moveToLeftEndOfLine:(id)sender
{
    [self moveToLeftEndOfLine:sender byExtending:NO];
}
- (void)moveToLeftEndOfLineAndModifySelection:(id)sender
{
    [self moveToLeftEndOfLine:sender byExtending:YES];
}
- (void)moveToRightEndOfLine:(id)sender byExtending:(BOOL)flag
{    if (_isSelectable)
    {
        var fragment = [_layoutManager _lineFragmentForLocation:_selectionRange.location];
        if (fragment)
        {
            var loc = CPMaxRange(fragment._range);
            if (loc > 0 && loc < [_layoutManager numberOfCharacters])
            {
                loc = MAX(0, loc - 1);
            }
            [self _establishSelection:CPMakeRange(loc, 0) byExtending:flag];
        }
    }
}
- (void)moveToRightEndOfLine:(id)sender
{
    [self moveToRightEndOfLine:sender byExtending:NO];
}
- (void)moveToRightEndOfLineAndModifySelection:(id)sender
{
    [self moveToRightEndOfLine:sender byExtending:YES];
}

- (void)moveWordLeftAndModifySelection:(id)sender
{
    if (_isSelectable)
    {
        [self _extendSelectionIntoDirection:-1 granularity:CPSelectByWord];
    }
}
- (void)moveWordLeft:(id)sender
{
    if (_isSelectable)
    {
        [self _moveSelectionIntoDirection:-1 granularity:CPSelectByWord]
    }
}

- (void)moveRight:(id)sender
{
    if (_isSelectable)
    {
        [self _establishSelection:CPMakeRange(CPMaxRange(_selectionRange) + 1, 0) byExtending:NO];
    }
}

- (void)selectAll:(id)sender
{
    if (_isSelectable)
    {
        if (_caretTimer)
        {
            [_caretTimer invalidate];
            _caretTimer = nil;
        }

        [self setSelectedRange:CPMakeRange(0, [_layoutManager numberOfCharacters])];
    }
}

- (void)_deleteForRange:(CPRange)changedRange
{
    if (![self shouldChangeTextInRange:changedRange replacementString:@""])
        return;

    [[[[self window] undoManager] prepareWithInvocationTarget:self] _replaceCharactersInRange:CPMakeRange(_selectionRange.location, 0) withAttributedString:[_textStorage attributedSubstringFromRange:CPMakeRangeCopy(changedRange)]];
    [_textStorage deleteCharactersInRange:CPMakeRangeCopy(changedRange)];

    [self setSelectedRange:CPMakeRange(changedRange.location, 0)];
    [self didChangeText];
    [_layoutManager _validateLayoutAndGlyphs];
    [self sizeToFit];
    _stickyXLocation = _caretRect.origin.x;
}

- (void)deleteBackward:(id)sender
{
    var changedRange;

    if (CPEmptyRange(_selectionRange) && _selectionRange.location > 0)
         changedRange = CPMakeRange(_selectionRange.location - 1, 1);
    else
        changedRange = _selectionRange;

    // smart delete
    if (_copySelectionGranularity > 0 &&
        changedRange.location > 0 && [self _isCharacterAtIndex:changedRange.location-1 granularity:_copySelectionGranularity] &&
        changedRange.location < [[self string] length] && [self _isCharacterAtIndex:CPMaxRange(changedRange) granularity:_copySelectionGranularity])
        changedRange.length++;

    [self _deleteForRange:changedRange];
}

- (void)deleteForward:(id)sender
{
    var changedRange = nil;

    if (CPEmptyRange(_selectionRange) && _selectionRange.location < [_layoutManager numberOfCharacters])
         changedRange = CPMakeRange(_selectionRange.location, 1);
    else
        changedRange = _selectionRange;

    [self _deleteForRange:changedRange];
}

- (void)cut:(id)sender
{
    var selectedRange = [self selectedRange];

    if (selectedRange.length < 1)
            return;

    [self copy:sender];
    [self deleteBackward:sender]
}

- (void)insertLineBreak:(id)sender
{
    [self insertText:@"\n"];
}
- (void)insertTab:(id)sender
{
    [self insertText:@"\t"];
}
- (void)insertTabIgnoringFieldEditor:(id)sender
{
    [self insertTab:sender];
}

- (void)insertNewlineIgnoringFieldEditor:(id)sender
{
    [self insertLineBreak:sender];
}

- (void)insertNewline:(id)sender
{
    [self insertLineBreak:sender];
}

- (BOOL)acceptsFirstResponder
{
    if (_isSelectable)
        return YES;

    return NO;
}

- (BOOL)becomeFirstResponder
{
    _isFirstResponder = YES;
    [self updateInsertionPointStateAndRestartTimer:YES];
    [[CPFontManager sharedFontManager] setSelectedFont:[self font] isMultiple:NO];
    [self setNeedsDisplay:YES];

    if(CPPlatformHasBug(CPJavaScriptPasteRequiresEditableTarget))
    {
        _window._platformWindow._platformPasteboard._DOMPasteboardElement.focus()
    }
    return YES;
}

- (BOOL)resignFirstResponder
{
    [_caretTimer invalidate];
    _caretTimer = nil;
    _isFirstResponder = NO;
    [self setNeedsDisplay:YES];
    return YES;
}

- (void)setTypingAttributes:(CPDictionary)attributes
{
    if (!attributes)
        attributes = [CPDictionary dictionary];

    if (_delegateRespondsToSelectorMask & kDelegateRespondsTo_textView_shouldChangeTypingAttributes_toAttributes)
        _typingAttributes = [_delegate textView:self shouldChangeTypingAttributes:_typingAttributes toAttributes:attributes];
    else
    {
        _typingAttributes = [attributes copy];
        /* check that new attributes contains essentials one's */
        if (![_typingAttributes containsKey:CPFontAttributeName])
            [_typingAttributes setObject:[self font] forKey:CPFontAttributeName];

        if (![_typingAttributes containsKey:CPForegroundColorAttributeName])
            [_typingAttributes setObject:[self textColor] forKey:CPForegroundColorAttributeName];
    }

    [[CPNotificationCenter defaultCenter] postNotificationName:CPTextViewDidChangeTypingAttributesNotification
                                          object:self];
}

- (CPDictionary)typingAttributes
{
    return _typingAttributes;
}

- (void)setSelectedTextAttributes:(CPDictionary)attributes
{
    _selectedTextAttributes = attributes;
}

- (CPDictionary)selectedTextAttributes
{
    return _selectedTextAttributes;
}

- (void)delete:(id)sender
{
    [self deleteBackward:sender];
}

- (CPString)stringValue
{
    return _textStorage._string;
}

// fixme: rich text should return attributed string, shouldn't it?
- (CPString)objectValue
{
    return [self stringValue];
}

- (void)setFont:(CPFont)font
{
    _font = font;
    var length = [_layoutManager numberOfCharacters];
    if (length)
    {   [_textStorage addAttribute:CPFontAttributeName value:_font range:CPMakeRange(0, length)];
        [_textStorage setFont:_font];
        [self scrollRangeToVisible:CPMakeRange(length, 0)];
    }
}

- (void)setFont:(CPFont)font range:(CPRange)range
{
    if (!_isRichText)
    {
        _font = font;
        [_textStorage setFont:_font];
    }

    [_textStorage addAttribute:CPFontAttributeName value:font range:CPMakeRangeCopy(range)];
    [_layoutManager _validateLayoutAndGlyphs];
    [self scrollRangeToVisible:CPMakeRange(CPMaxRange(range), 0)];
}

- (CPFont)font
{
    return _font;
}

- (void)changeColor:(id)sender
{
    [self setTextColor:[sender color] range:_selectionRange];
}

- (void)changeFont:(id)sender
{
    var currRange = CPMakeRange(_selectionRange.location, 0),
        oldFont,
        attributes,
        scrollRange = CPMakeRange(CPMaxRange(_selectionRange), 0);

    if (_isRichText)
    {
        if (!CPEmptyRange(_selectionRange))
        {
            while (CPMaxRange(currRange) < CPMaxRange(_selectionRange))  // iterate all "runs"
            {
                attributes = [_textStorage attributesAtIndex:CPMaxRange(currRange)
                                       longestEffectiveRange:currRange
                                                     inRange:_selectionRange];
                oldFont = [attributes objectForKey:CPFontAttributeName] || [self font];
                [self setFont:[sender convertFont:oldFont] range:currRange];
            }
        }
        else
        {
            [_typingAttributes setObject:[sender selectedFont] forKey:CPFontAttributeName];
        }
    }
    else
    {
        oldFont = [self font];
        var length = [_textStorage length];
        [self setFont:[sender convertFont:oldFont] range:CPMakeRange(0,length)];
        scrollRange = CPMakeRange(length, 0);
    }
    [_layoutManager _validateLayoutAndGlyphs];
    [self sizeToFit];
    [self setNeedsDisplay:YES];
    [self scrollRangeToVisible:scrollRange];
}

- (void)underline:(id)sender
{
    if (![self shouldChangeTextInRange:_selectionRange replacementString:nil])
        return;

    if (!CPEmptyRange(_selectionRange))
    {
        var attrib = [_textStorage attributesAtIndex:_selectionRange.location effectiveRange:nil];
        if ([attrib containsKey:CPUnderlineStyleAttributeName] && [[attrib objectForKey:CPUnderlineStyleAttributeName] intValue])
            [_textStorage removeAttribute:CPUnderlineStyleAttributeName range:_selectionRange];
        else
            [_textStorage addAttribute:CPUnderlineStyleAttributeName value:[CPNumber numberWithInt:1] range:CPMakeRangeCopy(_selectionRange)];
    }
    else
    {
        if ([_typingAttributes containsKey:CPUnderlineStyleAttributeName] && [[_typingAttributes  objectForKey:CPUnderlineStyleAttributeName] intValue])
            [_typingAttributes setObject:[CPNumber numberWithInt:0] forKey:CPUnderlineStyleAttributeName];
        else
            [_typingAttributes setObject:[CPNumber numberWithInt:1] forKey:CPUnderlineStyleAttributeName];
    }
}

- (CPSelectionAffinity)selectionAffinity
{
    return 0;
}

- (void)setUsesFontPanel:(BOOL)flag
{
    _usesFontPanel = flag;
}

- (BOOL)usesFontPanel
{
    return _usesFontPanel;
}

- (void)setTextColor:(CPColor)aColor
{
    _textColor = aColor;

    if (_textColor)
        [_textStorage addAttribute:CPForegroundColorAttributeName value:_textColor range:CPMakeRange(0, [_layoutManager numberOfCharacters])];
    else
        [_textStorage removeAttribute:CPForegroundColorAttributeName range:CPMakeRange(0, [_layoutManager numberOfCharacters])];

    [_layoutManager _validateLayoutAndGlyphs];
    [self scrollRangeToVisible:CPMakeRange([_layoutManager numberOfCharacters], 0)];
}

- (void)setTextColor:(CPColor)aColor range:(CPRange)range
{
    if (!_isRichText)  // FIXME
        return;

    if (!CPEmptyRange(_selectionRange))
    {
        if (aColor)
            [_textStorage addAttribute:CPForegroundColorAttributeName value:aColor range:CPMakeRangeCopy(range)];
        else
            [_textStorage removeAttribute:CPForegroundColorAttributeName range:CPMakeRangeCopy(range)];
    }
    else
    {
        [_typingAttributes setObject:aColor forKey:CPForegroundColorAttributeName];
    }
    [_layoutManager _validateLayoutAndGlyphs];
    [self setNeedsDisplay:YES];
    [self scrollRangeToVisible:CPMakeRange(CPMaxRange(range), 0)];
}

- (CPColor)textColor
{
    return _textColor;
}

- (BOOL)isRichText
{
    return _isRichText;
}

- (BOOL)isRulerVisible
{
    return NO;
}

- (BOOL)allowsUndo
{
    return _allowsUndo;
}

- (CPRange)selectedRange
{
    return _selectionRange;
}

- (void)replaceCharactersInRange:(CPRange)aRange withString:(CPString)aString
{

    [_textStorage replaceCharactersInRange:aRange withString:aString];
}

- (CPString)string
{
    return [_textStorage string];
}

- (BOOL)isHorizontallyResizable
{
    return _isHorizontallyResizable;
}

- (void)setHorizontallyResizable:(BOOL)flag
{
    _isHorizontallyResizable = flag;
}

- (BOOL)isVerticallyResizable
{
    return _isVerticallyResizable;
}

- (void)setVerticallyResizable:(BOOL)flag
{
    _isVerticallyResizable = flag;
}

- (CGSize)maxSize
{
    return _maxSize;
}

- (CGSize)minSize
{
    return _minSize;
}

- (void)setMaxSize:(CGSize)aSize
{
    _maxSize = aSize;
}

- (void)setMinSize:(CGSize)aSize
{
    _minSize = aSize;
}

- (void)setConstrainedFrameSize:(CGSize)desiredSize
{
    [self setFrameSize:desiredSize];
}

- (void)sizeToFit
{
    [self setFrameSize:[self frameSize]]

}

- (void)setFrameSize:(CGSize) aSize
{
    var minSize = [self minSize],
        maxSize = [self maxSize],
        desiredSize = aSize,
        rect = [_layoutManager boundingRectForGlyphRange:CPMakeRange(0, MAX(0, [_layoutManager numberOfCharacters] - 1)) inTextContainer:_textContainer],
        myClipviewSize = nil;

    if ([[self superview] isKindOfClass:[CPClipView class]])
        myClipviewSize = [[self superview] frame].size;

    if ([_layoutManager extraLineFragmentTextContainer] === _textContainer)
        rect = CGRectUnion(rect, [_layoutManager extraLineFragmentRect]);

    if (_isHorizontallyResizable)
    {
        desiredSize.width = rect.size.width + 2 * _textContainerInset.width;

        if (desiredSize.width < minSize.width)
            desiredSize.width = minSize.width;
        else if (desiredSize.width > maxSize.width)
            desiredSize.width = maxSize.width;
    }

    if (_isVerticallyResizable)
    {
        desiredSize.height = rect.size.height + 2 * _textContainerInset.height;

        if (desiredSize.height < minSize.height)
            desiredSize.height = minSize.height;
        else if (desiredSize.height > maxSize.height)
            desiredSize.height = maxSize.height;
    }

    if (myClipviewSize)
    {
        if (desiredSize.width < myClipviewSize.width)
            desiredSize.width = myClipviewSize.width;
        if (desiredSize.height < myClipviewSize.height)
            desiredSize.height = myClipviewSize.height;
    }

    [super setFrameSize:desiredSize];
}

- (void)scrollRangeToVisible:(CPRange)aRange
{
    var rect;

    if (CPEmptyRange(aRange))
    {
        if (aRange.location >= [_layoutManager numberOfCharacters])
            rect = [_layoutManager extraLineFragmentRect];
        else
            rect = [_layoutManager lineFragmentRectForGlyphAtIndex:aRange.location effectiveRange:nil];
    }
    else
        rect = [_layoutManager boundingRectForGlyphRange:aRange inTextContainer:_textContainer];

    rect.origin.x += _textContainerOrigin.x;
    rect.origin.y += _textContainerOrigin.y;

    [self scrollRectToVisible:rect];
}

- (BOOL)_isCharacterAtIndex:(unsigned)index granularity:(CPSelectionGranularity)granularity
{
    var characterSet;

    switch (granularity)
    {
        case CPSelectByWord:
            characterSet = [[self class] _wordBoundaryRegex];
            break;

        case CPSelectByParagraph:
            characterSet = [[self class] _paragraphBoundaryRegex];
            break;
        default:
            // FIXME if (!characterSet) croak!
    }

    return _regexMatchesStringAtIndex(characterSet, [_textStorage string], index);
}

+ (CPArray)_wordBoundaryRegex
{
    return /^(.|[\r\n])\W/m;
}
+ (CPArray)_paragraphBoundaryRegex
{
    return /^(.|[\r\n])[\n\r]/m;
}

- (CPRange)_characterRangeForIndex:(unsigned)index inRange:(CPRange) aRange asDefinedByRegex:(JSObject)regex skip:(BOOL)flag
{
    var wordRange = CPMakeRange(index, 0),
        numberOfCharacters = [_layoutManager numberOfCharacters],
        string = [_textStorage string];

    // do we start on a boundary character?
    if (flag && _regexMatchesStringAtIndex(regex, string, index))
    {
        // -> extend to the left
        for (var searchIndex = index - 1; searchIndex > 0 && _regexMatchesStringAtIndex(regex, string, searchIndex); searchIndex--)
        {
            wordRange.location = searchIndex;
        }
        // -> extend to the right
        searchIndex = index + 1;
        while (searchIndex < numberOfCharacters && _regexMatchesStringAtIndex(regex, string, searchIndex))
        {
            searchIndex++;
        }
        return _MakeRangeFromAbs(wordRange.location, MIN(MAX(0, numberOfCharacters - 1), searchIndex));
    }
    // -> extend to the left
    for (var searchIndex = index - 1; searchIndex >= 0 && !_regexMatchesStringAtIndex (regex, string, searchIndex); searchIndex--)
    {
        wordRange.location = searchIndex;
    }
    // -> extend to the right
    index++;
    while (index < numberOfCharacters && !_regexMatchesStringAtIndex (regex, string, index))
    {
        index++;
    }
    return _MakeRangeFromAbs(wordRange.location, MIN(MAX(0, numberOfCharacters), index));
}

- (CPRange)selectionRangeForProposedRange:(CPRange)proposedRange granularity:(CPSelectionGranularity)granularity
{
    var textStorageLength = [_layoutManager numberOfCharacters];

    if (textStorageLength == 0)
        return CPMakeRange(0, 0);

    if (proposedRange.location >= textStorageLength)
        return CPMakeRange(textStorageLength, 0);

    if (CPMaxRange(proposedRange) > textStorageLength)
        proposedRange.length = textStorageLength - proposedRange.location;

    var string = [_textStorage string];

    switch (granularity)
    {
        case CPSelectByWord:
            var wordRange = [self _characterRangeForIndex:proposedRange.location inRange:proposedRange asDefinedByRegex:[[self class] _wordBoundaryRegex] skip:YES];

            if (proposedRange.length)
                wordRange = CPUnionRange(wordRange, [self _characterRangeForIndex:CPMaxRange(proposedRange) inRange:proposedRange asDefinedByRegex:[[self class] _wordBoundaryRegex] skip:NO]);

            return wordRange;

        case CPSelectByParagraph:
            var parRange = [self _characterRangeForIndex:proposedRange.location inRange:proposedRange asDefinedByRegex:[[self class] _paragraphBoundaryRegex] skip:YES];

            if (proposedRange.length)
                parRange = CPUnionRange(parRange, [self _characterRangeForIndex:CPMaxRange(proposedRange)
                                                                        inRange:proposedRange
                                                               asDefinedByRegex:[[self class] _paragraphBoundaryRegex]
                                                                           skip:NO]);

            if (parRange.length > 0 && [self _isCharacterAtIndex:CPMaxRange(parRange) granularity:CPSelectByParagraph])
                parRange.length++;

            return parRange;

        default:
            return proposedRange;
    }
}

- (void)setSelectionGranularity:(CPSelectionGranularity)granularity
{
    _selectionGranularity = granularity;
}

- (CPSelectionGranularity)selectionGranularity
{
    return _selectionGranularity;
}

- (CPColor)insertionPointColor
{
    return _insertionPointColor;
}

- (void)setInsertionPointColor:(CPColor)aColor
{
    _insertionPointColor = aColor;
}

- (BOOL)shouldDrawInsertionPoint
{
    return (_selectionRange.length === 0 && [self _isFocused])
}

- (void)drawInsertionPointInRect:(CGRect)aRect color:(CPColor)aColor turnedOn:(BOOL)flag
{
    var style;
    if (!_caretDOM)
    {
        _caretDOM = document.createElement("span");
        style = _caretDOM.style;
        style.position = "absolute";
        style.visibility = "visible";
        style.padding = "0px";
        style.margin = "0px";
        style.whiteSpace = "pre";
        style.backgroundColor = "black";
        _caretDOM.style.width = "1px";
        self._DOMElement.appendChild(_caretDOM);
    }

    _caretDOM.style.left = (aRect.origin.x) + "px";
    _caretDOM.style.top = (aRect.origin.y) + "px";
    _caretDOM.style.height = (aRect.size.height) + "px";
    _caretDOM.style.visibility = flag ? "visible" : "hidden";
}

- (void)_hideCaret
{
    if (_caretDOM)
        _caretDOM.style.visibility = "hidden";
}

- (void)updateInsertionPointStateAndRestartTimer:(BOOL)flag
{
    if (_selectionRange.length)
        [self _hideCaret];

    if (_selectionRange.location >= [_layoutManager numberOfCharacters])    // cursor is "behind" the last chacacter
    {
        _caretRect = [_layoutManager boundingRectForGlyphRange:CPMakeRange(MAX(0,_selectionRange.location - 1), 1) inTextContainer:_textContainer];
        _caretRect.origin.x += _caretRect.size.width;

        if (_selectionRange.location > 0 && [[_textStorage string] characterAtIndex:_selectionRange.location - 1] === '\n')
        {
            _caretRect.origin.y += _caretRect.size.height;
            _caretRect.origin.x = 0;
        }
    }
    else
        _caretRect = [_layoutManager boundingRectForGlyphRange:CPMakeRange(_selectionRange.location, 1) inTextContainer:_textContainer];

    _caretRect.origin.x += _textContainerOrigin.x;
    _caretRect.origin.y += _textContainerOrigin.y;
    _caretRect.size.width = 1;

    if (flag)
    {
        _drawCaret = flag;
        _caretTimer = [CPTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(_blinkCaret:) userInfo:nil repeats:YES];
    }
}

- (void)performDragOperation:(CPDraggingInfo)aSender
{
    var location = [self convertPoint:[aSender draggingLocation] fromView:nil],
        pasteboard = [aSender draggingPasteboard];

    if (![pasteboard availableTypeFromArray:[CPColorDragType]])
        return NO;

   [self setTextColor:[CPKeyedUnarchiver unarchiveObjectWithData:[pasteboard dataForType:CPColorDragType]] range:_selectionRange ];
}

@end
