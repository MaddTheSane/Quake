//----------------------------------------------------------------------------------------------------------------------------
//
// "QSettingsWindow.m"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
//----------------------------------------------------------------------------------------------------------------------------

#import "QSettingsWindow.h"
#import "QAboutPanel.h"
#import "QArgumentsPanel.h"
#import "QDisplaysPanel.h"
#import "QGLDisplaysPanel.h"
#import "QSoundPanel.h"

#import <FruitzOfDojo/FruitzOfDojo.h>

//----------------------------------------------------------------------------------------------------------------------------

#if defined (GLQUAKE)

#define Q_DISPLAYS_PANEL                    QGLDisplaysPanel

#else

#define Q_DISPLAYS_PANEL                    QDisplaysPanel

#endif // GLQUAKE

//----------------------------------------------------------------------------------------------------------------------------

static NSString*    sQSettingsNewGameToolbarItem = @"Quake Start ToolbarItem";

//----------------------------------------------------------------------------------------------------------------------------

@interface QSettingsWindow ()

@property (readonly, copy) NSString *windowNibName;
- (void) awakeFromNib;
- (BOOL) validateToolbarItem: (NSToolbarItem *) theItem;
- (NSToolbarItem *) toolbar: (NSToolbar *) theToolbar
      itemForItemIdentifier: (NSString *) theIdentifier
  willBeInsertedIntoToolbar: (BOOL) theFlag;
- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar*) theToolbar;
- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar*) theToolbar;
- (void) showPanel: (id) panel;
- (void) newGame: (id) sender;

@end

//----------------------------------------------------------------------------------------------------------------------------

@implementation QSettingsWindow

- (NSString*) windowNibName
{
	return @"SettingsWindow";
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{    
    [self close];
    [mPanels release];
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) awakeFromNib
{
    mPanels = [[NSArray alloc] initWithObjects: [[[QAboutPanel alloc] init] autorelease],
                                                [[[Q_DISPLAYS_PANEL alloc] init] autorelease],
                                                [[[QSoundPanel alloc] init] autorelease],
                                                [[[QArgumentsPanel alloc] init] autorelease],
                                                nil];
    
    mEmptyView      = [self.window.contentView retain];
    mToolbarItems   = [[NSMutableDictionary dictionary] retain];
  
    for (QSettingsPanel* panel in mPanels)
    {
        panel.delegate = self;
        mToolbarItems[panel.toolbarIdentifier] = panel.toolbarItem;
    }

    NSToolbarItem* item = [[[NSToolbarItem alloc] initWithItemIdentifier: sQSettingsNewGameToolbarItem] autorelease];
    
    item.label = @"Play";
    item.paletteLabel = @"Play";
    item.toolTip = @"Start the game.";
    item.target = self;
    item.image = [NSImage imageNamed: @"Start"];
    item.action = @selector (newGame:);
    
    mToolbarItems[sQSettingsNewGameToolbarItem] = item;
    
    NSToolbar*  toolbar = [[[NSToolbar alloc] initWithIdentifier: @"Quake Toolbar"] autorelease];
    
    toolbar.delegate = self;    
    [toolbar setAllowsUserCustomization: NO];
    [toolbar setAutosavesConfiguration: NO];
    toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
    
    self.window.toolbar = toolbar;
    [self showPanel: mPanels[0]];
    [self.window center];
}

//----------------------------------------------------------------------------------------------------------------------------

- (BOOL) validateToolbarItem: (NSToolbarItem*) toolbarItem
{
    FD_UNUSED (toolbarItem);
    
    return YES;
}

//----------------------------------------------------------------------------------------------------------------------------

- (NSToolbarItem*) toolbar: (NSToolbar*) toolbar
     itemForItemIdentifier: (NSString*) identifier
 willBeInsertedIntoToolbar: (BOOL) flag
{
    FD_UNUSED (toolbar, flag);
    
    return [[mToolbarItems[identifier] copy] autorelease];
}

//----------------------------------------------------------------------------------------------------------------------------

- (NSArray*) toolbarDefaultItemIdentifiers: (NSToolbar*) toolbar
{
    FD_UNUSED (toolbar);
    
    NSMutableArray* identifiers = [[NSMutableArray alloc] initWithCapacity: mPanels.count + 2];
    
    for (QSettingsPanel* panel in mPanels)
    {
        [identifiers addObject: panel.toolbarIdentifier];
    }
    
    [identifiers addObject: NSToolbarFlexibleSpaceItemIdentifier];
    [identifiers addObject: sQSettingsNewGameToolbarItem];
    
    return identifiers;
}

//----------------------------------------------------------------------------------------------------------------------------

- (NSArray*) toolbarAllowedItemIdentifiers: (NSToolbar*) toolbar
{
    return [self toolbarDefaultItemIdentifiers: toolbar];
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) showPanel: (id) panel
{
    NSString*   appName = [NSRunningApplication currentApplication].localizedName;
    NSWindow*   window  = self.window;
    NSView*     view    = [panel view];
    
    if (view != nil && view != self.window.contentView)
    {
        NSRect  windowFrame = [NSWindow contentRectForFrameRect: window.frame styleMask:window.styleMask];
        NSSize  newSize     = view.frame.size;
        
        if (window.toolbar.visible)
        {
            const float toolbarHeight = NSHeight (windowFrame) - NSHeight (window.contentView.frame);
            
            newSize.height += toolbarHeight;
        }
        
        mEmptyView.frame = windowFrame;
        window.contentView = mEmptyView;
        window.title = [NSString stringWithFormat: @"%@ (%@)", appName, [panel title]];
        
        windowFrame.origin.y    += NSHeight (windowFrame) - newSize.height;
        windowFrame.size         = newSize;
        
        windowFrame = [NSWindow frameRectForContentRect: windowFrame styleMask: window.styleMask];
        
        [window setFrame: windowFrame display: YES animate: window.visible];
        window.contentView = view;
    }
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) newGame: (id) sender
{
    [sender setTarget: nil];
    [sender setAction: nil];

    if ([mStartGameTarget respondsToSelector: mStartGameSelector] == YES)
    {
        [self close];
        [self synchronize];
        
        [mStartGameTarget performSelector: mStartGameSelector withObject: nil];
        
        [self autorelease];
    }
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) setNewGameAction: (SEL) selector target: (id) target
{
    mStartGameTarget    = target;
    mStartGameSelector  = selector;
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) synchronize
{
    [mPanels makeObjectsPerformSelector: @selector (synchronize)];
    
    [[FDPreferences sharedPrefs] synchronize];
}

@end

//----------------------------------------------------------------------------------------------------------------------------
