//----------------------------------------------------------------------------------------------------------------------------
//
// "QSettingsPanel.h"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
//----------------------------------------------------------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

//----------------------------------------------------------------------------------------------------------------------------

@interface QSettingsPanel : NSViewController
{
    id      mDelegate;
}

@property (readonly, copy) NSString *toolbarIdentifier;
@property (readonly, copy) NSToolbarItem *toolbarItem;

@property (assign) id delegate;

- (void) synchronize;

@end

//----------------------------------------------------------------------------------------------------------------------------
