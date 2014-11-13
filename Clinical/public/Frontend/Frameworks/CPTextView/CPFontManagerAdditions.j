/*
 * CPFontManagerAdditions.j
 * AppKit
 *
 */

@import <Foundation/CPObject.j>

@import <AppKit/CPFont.j>
@import "CPFontPanel.j"
@import "CPFontDescriptor.j"


@implementation CPFont(DescriptorAdditions)

- (id)_initWithFontDescriptor:(CPFontDescriptor)fontDescriptor
{
    var aName = [fontDescriptor objectForKey: CPFontNameAttribute] ,
        aSize = [fontDescriptor pointSize],
        isBold = [fontDescriptor symbolicTraits] & CPFontBoldTrait,
        isItalic = [fontDescriptor symbolicTraits] & CPFontItalicTrait;

    return [self _initWithName:aName size:aSize bold:isBold italic:isItalic system:NO];
}

+ (CPFont)fontWithDescriptor:(CPFontDescriptor)fontDescriptor size:(float)aSize
{
    var aName = [fontDescriptor objectForKey: CPFontNameAttribute],
        isBold = [fontDescriptor symbolicTraits] & CPFontBoldTrait,
        isItalic = [fontDescriptor symbolicTraits] & CPFontItalicTrait;

    return [self _fontWithName:aName size:aSize || [fontDescriptor pointSize] bold:isBold italic:isItalic];
}

- (CPFontDescriptor)fontDescriptor
{
    var traits = 0;

    if ([self isBold])
        traits |= CPFontBoldTrait;

    if ([self isItalic])
        traits |= CPFontItalicTrait;

    var descriptor = [[CPFontDescriptor fontDescriptorWithName:_name size:_size] fontDescriptorWithSymbolicTraits:traits];

    return descriptor;
}

@end


var CPSharedFontManager     = nil,
    CPFontManagerFactory    = Nil,
    CPFontPanelFactory      = Nil;

/*
    modifyFont: sender's tag
*/
CPNoFontChangeAction    = 0;
CPViaPanelFontAction    = 1;
CPAddTraitFontAction    = 2;
CPSizeUpFontAction      = 3;
CPSizeDownFontAction    = 4;
CPHeavierFontAction     = 5;
CPLighterFontAction     = 6;
CPRemoveTraitFontAction = 7;

@implementation CPFontManager(FontPanel)


/*!
    Sets the class that will be used to create the application's
    Font panel.
*/
+ (void)setFontPanelFactory:(Class)aClass
{
    CPFontPanelFactory = aClass;
}

/*
    @ignore
*/
- (id)init
{
    self = [super init];

    if (self)
        _action = @selector(changeFont:);

    return self;
}

/*!
    This method open the font panel, create it if necessary.
    @param sender The object that sent the message.
*/
- (CPFontPanel)fontPanel:(BOOL)createIt
{
    var panel = nil,
        panelExists = [CPFontPanelFactory sharedFontPanelExists];

    if ((panelExists) || (!panelExists && createIt))
        panel = [CPFontPanelFactory sharedFontPanel];

    return panel;
}

/*!
    Convert a font to have the specified Font traits. The font is unchanged expect for the specified Font traits.
    Using CPUnboldFontMask or CPUnitalicFontMask will respectively remove Bold and Italic traits.
    @param aFont The font to convert.
    @param fontTrait The new font traits mask.
    @result The converted font or \c aFont if the conversion failed.
*/
- (CPFont)convertFont:(CPFont)aFont toHaveTrait:(CPFontTraitMask)fontTrait
{
    var attributes = [[[aFont fontDescriptor] fontAttributes] copy],
        symbolicTrait = [[aFont fontDescriptor] symbolicTraits];

    if (fontTrait & CPBoldFontMask)
        symbolicTrait |= CPFontBoldTrait;

    if (fontTrait & CPItalicFontMask)
        symbolicTrait |= CPFontItalicTrait;

    if (fontTrait & CPUnboldFontMask) /* FIXME: this only change CPFontSymbolicTrait what about CPFontWeightTrait */
        symbolicTrait &= ~CPFontBoldTrait;

    if (fontTrait & CPUnitalicFontMask)
        symbolicTrait &= ~CPFontItalicTrait;

    if (fontTrait & CPExpandedFontMask)
        symbolicTrait |= CPFontExpandedTrait;

    if (fontTrait & CPSmallCapsFontMask)
        symbolicTrait |= CPFontSmallCapsTrait;

    if (![attributes containsKey:CPFontTraitsAttribute])
        [attributes setObject:[CPDictionary dictionaryWithObject:[CPNumber numberWithUnsignedInt:symbolicTrait]
                    forKey:CPFontSymbolicTrait] forKey:CPFontTraitsAttribute];
    else
        [[attributes objectForKey:CPFontTraitsAttribute] setObject:[CPNumber numberWithUnsignedInt:symbolicTrait]
                     forKey:CPFontSymbolicTrait];

    return [[aFont class] fontWithDescriptor:[CPFontDescriptor fontDescriptorWithFontAttributes:attributes] size:0.0];
}

/*!
    Convert a font to not have the specified Font traits. The font is unchanged expect for the specified Font traits.
    @param aFont The font to convert.
    @param fontTrait The font traits mask to remove.
    @result The converted font or \c aFont if the conversion failed.
*/
- (CPFont)convertFont:(CPFont)aFont toNotHaveTrait:(CPFontTraitMask)fontTrait
{
    var attributes = [[[aFont fontDescriptor] fontAttributes] copy],
        symbolicTrait = [[aFont fontDescriptor] symbolicTraits];

    if ((fontTrait & CPBoldFontMask) || (fontTrait & CPUnboldFontMask)) /* FIXME: see convertFont:toHaveTrait: about CPFontWeightTrait */
        symbolicTrait &= ~CPFontBoldTrait;

    if ((fontTrait & CPItalicFontMask) || (fontTrait & CPUnitalicFontMask))
        symbolicTrait &= ~CPFontItalicTrait;

    if (fontTrait & CPExpandedFontMask)
        symbolicTrait &= ~CPFontExpandedTrait;

    if (fontTrait & CPSmallCapsFontMask)
        symbolicTrait &= ~CPFontSmallCapsTrait;

    if (![attributes containsKey:CPFontTraitsAttribute])
        [attributes setObject:[CPDictionary dictionaryWithObject:[CPNumber numberWithUnsignedInt:symbolicTrait] forKey:CPFontSymbolicTrait] forKey:CPFontTraitsAttribute];
    else
        [[attributes objectForKey:CPFontTraitsAttribute] setObject:[CPNumber numberWithUnsignedInt:symbolicTrait] forKey:CPFontSymbolicTrait];

    return [[aFont class] fontWithDescriptor:[CPFontDescriptor fontDescriptorWithFontAttributes:attributes] size:0.0];
}

/*!
    Convert a font to have specified size. The font is unchanged expect for the specified size.
    @param aFont The font to convert.
    @param aSize The new font size.
    @result The converted font or \c aFont if the conversion failed.
*/
- (CPFont)convertFont:(CPFont)aFont toSize:(float)aSize
{
    var descriptor = [aFont fontDescriptor];

    return [[aFont class] fontWithDescriptor: descriptor size:aSize]
}

- (void)orderFrontFontPanel:(id)sender
{
    [[self fontPanel:YES] orderFront:sender];
}

- (void)modifyFont:(id)sender
{
    _fontAction = [sender tag];
    [self sendAction];

    if (_selectedFont)
        [self setSelectedFont:[self convertFont:_selectedFont] isMultiple:NO];
}

/*!
    This method causes the receiver to send its action message.
    @param sender The object that sent the message. (a Font panel)
*/
- (void)modifyFontViaPanel:(id)sender
{
    _fontAction = CPViaPanelFontAction;
    if (_selectedFont)
        [self setSelectedFont:[self convertFont:_selectedFont] isMultiple:NO];

    [self sendAction];
}

/*!
    Convert a font according to current font changes, provided by the object that initiated the font change.
    @param aFont The font to convert.
    @result The converted font or \c aFont if the conversion failed.
*/
- (CPFont)convertFont:(CPFont)aFont
{
    var newFont = nil;
    switch (_fontAction)
    {
        case CPNoFontChangeAction:
            newFont = aFont;
            break;

        case CPViaPanelFontAction:
            newFont = [[self fontPanel:NO] panelConvertFont:aFont];
            break;

        case CPAddTraitFontAction:
            newFont = [self convertFont:aFont toHaveTrait:_currentFontTrait];
            break;

        case CPSizeUpFontAction:
            newFont = [self convertFont:aFont toSize:[aFont size] + 1.0]; /* any limit ? */
            break;

        case CPSizeDownFontAction:
            if ([aFont size] > 1)
                newFont = [self convertFont:aFont toSize:[aFont size] - 1.0];
            /* else CPBeep() :-p */
            break;

        default:
            CPLog.trace(@"-[" + [self className] + " " + _cmd + "] unsupported font action: " + _fontAction + " aFont unchanged");
            newFont = aFont;
            break;
    }

    return newFont;
}

@end

[CPFontManager setFontManagerFactory:[CPFontManager class]];
[CPFontManager setFontPanelFactory:CPFontPanel];
