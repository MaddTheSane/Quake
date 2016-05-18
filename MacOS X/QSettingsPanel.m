//----------------------------------------------------------------------------------------------------------------------------
//
// "QSettingsPanel.m"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
//----------------------------------------------------------------------------------------------------------------------------

#import "QSettingsPanel.h"

#import "FDFramework/FDFramework.h"

#import <Cocoa/Cocoa.h>

//----------------------------------------------------------------------------------------------------------------------------

@interface QSettingsPanel ()

- (void) showPanel: (id) sender;

@end

//----------------------------------------------------------------------------------------------------------------------------

@implementation QSettingsPanel
@synthesize delegate = mDelegate;

- (NSString*) toolbarIdentifier
{
    [self doesNotRecognizeSelector: _cmd];
    
    return nil;    
}

//----------------------------------------------------------------------------------------------------------------------------

- (NSToolbarItem*) toolbarItem
{
    NSToolbarItem* item = [[[NSToolbarItem alloc] initWithItemIdentifier: [self toolbarIdentifier]] autorelease];
    
    item.target = self;
    item.action = @selector (showPanel:);

    return item;
}


//----------------------------------------------------------------------------------------------------------------------------

- (void) showPanel: (id) sender
{
    FD_UNUSED (sender);
    
    if ([mDelegate respondsToSelector: @selector (showPanel:)] == YES)
    {
        [mDelegate performSelector: @selector (showPanel:) withObject: self];
    }
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) synchronize
{    
}

@end

//----------------------------------------------------------------------------------------------------------------------------
