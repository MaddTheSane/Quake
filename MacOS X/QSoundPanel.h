//----------------------------------------------------------------------------------------------------------------------------
//
// "QSoundPanel.h"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
//----------------------------------------------------------------------------------------------------------------------------

#import "QSettingsPanel.h"
#import <Cocoa/Cocoa.h>

//----------------------------------------------------------------------------------------------------------------------------

@interface QSoundPanel : QSettingsPanel
{
@private
    IBOutlet NSView*        mOpenPanelView;
    IBOutlet NSPopUpButton* mAudioPopup;
}

@property (readonly, copy) NSString *nibName;
- (void) awakeFromNib;

@property (readonly, copy) NSString *toolbarIdentifier;
@property (readonly, copy) NSToolbarItem *toolbarItem;

@end

//----------------------------------------------------------------------------------------------------------------------------
