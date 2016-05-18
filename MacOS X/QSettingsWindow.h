//----------------------------------------------------------------------------------------------------------------------------
//
// "QSettingsWindow.h"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
//----------------------------------------------------------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

//----------------------------------------------------------------------------------------------------------------------------

@class QSettingsPanel;

@interface QSettingsWindow : NSWindowController <NSToolbarDelegate>
{
@private
    NSArray<__kindof QSettingsPanel*>*              mPanels;
    NSMutableDictionary<NSString*,NSToolbarItem*>*  mToolbarItems;
    NSView*                                         mEmptyView;
    
    id      mStartGameTarget;
    SEL     mStartGameSelector;
}

- (void) setNewGameAction: (SEL) selector target: (id) target;
- (void) synchronize;

@end

//----------------------------------------------------------------------------------------------------------------------------
