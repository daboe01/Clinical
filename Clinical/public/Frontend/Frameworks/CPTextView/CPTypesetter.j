
/*
 *  CPTypesetter.j
 *  AppKit
 *
 *  Created by Daniel Boehringer on 27/12/2013.
 *  All modifications copyright Daniel Boehringer 2013.
 *  Based on original work by
 *  Emmanuel Maillard on 27/02/2010.
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

@import <Foundation/CPObject.j>
@import "CPParagraphStyle.j"
@import "CPTextStorage.j"

@global _isNewlineCharacter

/*
    CPTypesetterControlCharacterAction
*/
CPTypesetterZeroAdvancementAction = 1 << 0;
CPTypesetterWhitespaceAction      = 1 << 1;
CPSTypesetterHorizontalTabAction  = 1 << 2;
CPTypesetterLineBreakAction       = 1 << 3;
CPTypesetterParagraphBreakAction  = 1 << 4;
CPTypesetterContainerBreakAction  = 1 << 5;

var _measuringContext,
    _measuringContextFont,
    _isCanvasSizingInvalid,
    _didTestCanvasSizingValid,
    _sharedSimpleTypesetter,
    _sizingCache;

function _widthOfStringForFont(aString, aFont)
{
    var peek,
        cssString = [aFont cssString];

    if (!_measuringContext)
        _measuringContext = CGBitmapGraphicsContextCreate();

    if (!_didTestCanvasSizingValid && CPFeatureIsCompatible(CPHTMLCanvasFeature))
    {
        var teststring = "0123456879abcdefghiklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,.-()";
        _didTestCanvasSizingValid = YES;
        _measuringContext.font = cssString;
        _isCanvasSizingInvalid = ABS([teststring sizeWithFont:aFont].width -_measuringContext.measureText(teststring).width) > 2;
    }

    if (!_sizingCache)
        _sizingCache = [];

    if (_sizingCache[cssString] !== undefined && (peek = _sizingCache[cssString][aString]) !== undefined)
        return peek;

    if (_sizingCache[cssString] === undefined)
        _sizingCache[cssString] = [];

    if (!CPFeatureIsCompatible(CPHTMLCanvasFeature) || _isCanvasSizingInvalid)  // measuring with canvas is _much_ faster on chrome
        return _sizingCache[cssString][aString] = [aString sizeWithFont:aFont];

    if (_measuringContextFont !== aFont)
    {
        _measuringContextFont = aFont;
        _measuringContext.font = cssString;
    }

    return _sizingCache[cssString][aString] = _measuringContext.measureText(aString);
}

var CPSystemTypesetterFactory;

@implementation CPTypesetter : CPObject


#pragma mark -
#pragma mark Class methods

+ (void)initialize
{
    [CPTypesetter _setSystemTypesetterFactory:[CPSimpleTypesetter class]];
}

+ (id)sharedSystemTypesetter
{
    return [CPSystemTypesetterFactory sharedInstance];
}

+ (void)_setSystemTypesetterFactory:(Class)aClass
{
    CPSystemTypesetterFactory = aClass;
}

- (CPTypesetterControlCharacterAction)actionForControlCharacterAtIndex:(unsigned)charIndex
{
    return CPTypesetterZeroAdvancementAction;
}

- (CPLayoutManager)layoutManager
{
    return nil;
}

- (CPTextContainer)currentTextContainer
{
    return nil;
}

- (CPArray)textContainers
{
    return nil;
}

- (void)layoutGlyphsInLayoutManager:(CPLayoutManager)layoutManager
        startingAtGlyphIndex:(unsigned)startGlyphIndex
        maxNumberOfLineFragments:(unsigned)maxNumLines
        nextGlyphIndex:(UIntegerReference)nextGlyph
{
   _CPRaiseInvalidAbstractInvocation(self, _cmd);
}

@end

@implementation CPSimpleTypesetter : CPTypesetter
{
    CPLayoutManager     _layoutManager          @accessors(property=layoutManager);
    CPTextContainer     _currentTextContainer   @accessors(property=currentTextContainer);
    CPTextStorage       _textStorage;

    CPRange             _attributesRange;
    CPDictionary        _currentAttributes;
    CPFont              _currentFont;
    CPParagraphStyle    _currentParagraph;

    float               _lineHeight;
    float               _lineBase;
    float               _lineWidth;

    unsigned            _indexOfCurrentContainer;

    CPArray             _lineFragments;
}


#pragma mark -
#pragma mark Class methods

+ (id)sharedInstance
{
    if (!_sharedSimpleTypesetter)
        _sharedSimpleTypesetter = [[CPSimpleTypesetter alloc] init];

    return _sharedSimpleTypesetter;
}

- (CPArray)textContainers
{
    return [_layoutManager textContainers];
}

- (CPTextTab)textTabForWidth:(double)aWidth writingDirection:(CPWritingDirection)direction
{
    var tabStops = [_currentParagraph tabStops];

    if (!tabStops)
        tabStops = [CPParagraphStyle _defaultTabStops];

    var l = tabStops.length;

    if (aWidth > tabStops[l - 1]._location)
        return nil;

    for (var i = l - 1; i >= 0; i--)
    {
        if (aWidth > tabStops[i]._location)
        {
            if (i + 1 < l)
                return tabStops[i + 1];
        }
    }

    return nil;
}

- (BOOL)_flushRange:(CPRange)lineRange
        lineOrigin:(CGPoint)lineOrigin
        currentContainer:(CPTextContainer)aContainer
        advancements:(CPArray)advancements
        lineCount:(unsigned)lineCount
        sameLine:(BOOL)sameLine
{
    var myX = 0,
        rect = CGRectMake(lineOrigin.x, lineOrigin.y, _lineWidth, _lineHeight),
        containerSize=aContainer._size;

    [_layoutManager setTextContainer:_currentTextContainer forGlyphRange:lineRange];  // creates a new lineFragment

    var fragment = [_layoutManager._lineFragments lastObject];
    fragment._isLast = !sameLine;
    _lineFragments.push(fragment);
    [_layoutManager setLineFragmentRect:rect forGlyphRange:lineRange usedRect:rect];

    switch ([_currentParagraph alignment])
    {
        case CPLeftTextAlignment:
            myX = 0;
            break;

        case CPCenterTextAlignment:
            myX = (containerSize.width - _lineWidth) / 2;
            break;

        case CPRightTextAlignment:
            myX = containerSize.width - _lineWidth;
            break;
    }

    [_layoutManager setLocation:CPMakePoint(myX, _lineBase) forStartOfGlyphRange:lineRange];
    [_layoutManager _setAdvancements:advancements forGlyphRange:lineRange];

    if (!sameLine) //fix the _lineFragments when fontsizes differ
    {
        var l = _lineFragments.length;

        for (var i = 0 ; i < l ; i++)
            [_lineFragments[i] _adjustForHeight:_lineHeight];
    }

    if (!lineCount)  // do not rescue on first line
        return NO;

    if (aContainer._inResizing)
        return NO;

    return ([_layoutManager _rescuingInvalidFragmentsWasPossibleForGlyphRange:lineRange]);
}

- (void)layoutGlyphsInLayoutManager:(CPLayoutManager)layoutManager
        startingAtGlyphIndex:(unsigned)glyphIndex
        maxNumberOfLineFragments:(unsigned)maxNumLines
        nextGlyphIndex:(UIntegerReference)nextGlyph
{
    _layoutManager = layoutManager;
    _textStorage = [_layoutManager textStorage];
    _indexOfCurrentContainer = MAX(0, [[_layoutManager textContainers]
                                   indexOfObject:[_layoutManager textContainerForGlyphAtIndex:glyphIndex effectiveRange:nil withoutAdditionalLayout:YES]
                                   inRange:CPMakeRange(0, [[_layoutManager textContainers] count])]);
    _currentTextContainer = [[_layoutManager textContainers] objectAtIndex:_indexOfCurrentContainer];
    _attributesRange = CPMakeRange(0, 0);
    _lineHeight = 0;
    _lineBase = 0;
    _lineWidth = 0;

    var containerSize = [_currentTextContainer containerSize],
        lineRange = CPMakeRange(glyphIndex, 0),
        wrapRange = CPMakeRange(0, 0),
        wrapWidth = 0,
        isNewline = NO,
        isTabStop = NO,
        isWordWrapped = NO,
        numberOfGlyphs= [_textStorage length],
        leading,
        numLines = 0,
        theString = [_textStorage string],
        lineOrigin,
        ascent,
        descent,
        advancements = [],
        prevRangeWidth = 0,
        measuringRange = CPMakeRange(glyphIndex, 0),
        currentAnchor = 0,
        previousFont;

    if (glyphIndex > 0)
        lineOrigin = CGPointCreateCopy([_layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange:nil].origin);
    else if ([_layoutManager extraLineFragmentTextContainer])
        lineOrigin = CGPointMake(0, [_layoutManager extraLineFragmentUsedRect].origin.y);
    else
        lineOrigin = CGPointMake(0, 0);

    [_layoutManager _removeInvalidLineFragments];

    if (![_textStorage length])
        return;

    _lineFragments = [];

    for (; numLines != maxNumLines && glyphIndex < numberOfGlyphs; glyphIndex++)
    {
        if (!CPLocationInRange(glyphIndex, _attributesRange))
        {
            _currentAttributes = [_textStorage attributesAtIndex:glyphIndex effectiveRange:_attributesRange];
            _currentFont = [_currentAttributes objectForKey:CPFontAttributeName];
            _currentParagraph = [_currentAttributes objectForKey:CPParagraphStyleAttributeName] || [CPParagraphStyle defaultParagraphStyle];

            if (!_currentFont)
                _currentFont = [_textStorage font] || [CPFont systemFontOfSize:12.0];

            ascent = [_currentFont ascender]
            descent = [_currentFont descender]
            leading = (ascent - descent) * 0.2; // FAKE<!>
        }

        if (previousFont !== _currentFont)
        {
            measuringRange = CPMakeRange(glyphIndex, 0);
            currentAnchor = prevRangeWidth;
            previousFont = _currentFont;
        }

        lineRange.length++;
        measuringRange.length++;

        _lineHeight = MAX(_lineHeight, ascent - descent + leading);
        _lineBase = MAX(_lineBase, ascent);

        var currentChar = theString[glyphIndex],  // use pure javascript methods for performance reasons
            rangeWidth = _widthOfStringForFont(theString.substr(measuringRange.location, measuringRange.length), _currentFont).width + currentAnchor;

        switch (currentChar)    // faster than sending actionForControlCharacterAtIndex: called for each char.
        {
            case '\t':
            {
                var nextTab = [self textTabForWidth:rangeWidth + lineOrigin.x writingDirection:0];

                isTabStop = YES;

                if (nextTab)
                    rangeWidth = nextTab._location - lineOrigin.x;
                else
                    rangeWidth += 28;   //FIXME
            }  // fallthrough intentional
            case  ' ':
                wrapRange = CPMakeRangeCopy(lineRange);
                wrapRange._height = _lineHeight;
                wrapRange._base = _lineBase;
                wrapWidth = rangeWidth;
                break;
            default:
                if (_isNewlineCharacter(currentChar))
                {
                    isNewline = YES;
                }
        }

        var advancement = CPMakeSize(rangeWidth - prevRangeWidth, ascent);
        advancement.descent=descent;
        advancements.push(advancement);

        prevRangeWidth = _lineWidth = rangeWidth;

        if (lineOrigin.x + rangeWidth > containerSize.width)
        {
            if (wrapWidth)
            {
                lineRange = wrapRange;
               _lineWidth = wrapWidth;
               _lineHeight = wrapRange._height;
               _lineBase = wrapRange._base;
            }

            isNewline = YES;
            isWordWrapped = YES;
            glyphIndex = CPMaxRange(lineRange) - 1;  // start the line starts directly at current character
        }

        if (isNewline || isTabStop)
        {
            if ([self _flushRange:lineRange lineOrigin:lineOrigin currentContainer:_currentTextContainer advancements:advancements lineCount:numLines sameLine:!isNewline])
                return;

            if (isTabStop)
            {
               lineOrigin.x += rangeWidth;
               isTabStop = NO;
            }

            if (isNewline)
            {
                if ([_currentParagraph minimumLineHeight])
                    _lineHeight = MAX(_lineHeight, [_currentParagraph minimumLineHeight]);

                if ([_currentParagraph maximumLineHeight])
                    _lineHeight = MIN(_lineHeight, [_currentParagraph maximumLineHeight]);

                lineOrigin.y += _lineHeight;

                if ([_currentParagraph lineSpacing])
                    lineOrigin.y += [_currentParagraph lineSpacing];

                if (lineOrigin.y > [_currentTextContainer containerSize].height)
                {
                    _indexOfCurrentContainer++;
                    _indexOfCurrentContainer = MAX(_indexOfCurrentContainer, [[_layoutManager textContainers] count] - 1);
                    _currentTextContainer = [[_layoutManager textContainers] objectAtIndex:_indexOfCurrentContainer];
                }

                lineOrigin.x = 0;
                numLines++;
                isNewline = NO;
                _lineFragments = [];
            }

            _lineWidth      = 0;
            advancements    = [];
            currentAnchor   = 0;
            prevRangeWidth  = 0;
            _lineHeight     = 0;
            _lineBase       = 0;
            lineRange       = CPMakeRange(glyphIndex + 1, 0);
            measuringRange  = CPMakeRange(glyphIndex + 1, 0);
            wrapRange       = CPMakeRange(0, 0);
            wrapWidth       = 0;
            isWordWrapped   = NO;
        }
    }

    // this is to "flush" the remaining characters
    if (lineRange.length)
    {
        [self _flushRange:lineRange lineOrigin:lineOrigin currentContainer:_currentTextContainer advancements:advancements lineCount:numLines sameLine:NO];
    }

    var rect = CGRectMake(0, lineOrigin.y, containerSize.width, [_layoutManager._lineFragments lastObject]._usedRect.size.height - descent);
    [_layoutManager setExtraLineFragmentRect:rect usedRect:rect textContainer:_currentTextContainer];
}

@end
