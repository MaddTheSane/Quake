//----------------------------------------------------------------------------------------------------------------------------
//
// "QAboutPanel.h"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
//----------------------------------------------------------------------------------------------------------------------------

#import "QSettingsPanel.h"
#import <FruitzOfDojo/FDLinkView.h>
#import <Cocoa/Cocoa.h>

//----------------------------------------------------------------------------------------------------------------------------

@interface QAboutPanel : QSettingsPanel
{
@private
    IBOutlet NSTextField*   mTitle;
    IBOutlet FDLinkView*    mLinkView;
    IBOutlet NSButton*      mOptionCheckBox;
}

@property (readonly, copy) NSString *nibName;
- (void) awakeFromNib;

@property (readonly, copy) NSString *toolbarIdentifier;
@property (readonly, copy) NSToolbarItem *toolbarItem;

- (IBAction) toggleOptionCheckbox: (id) sender;

@end

//----------------------------------------------------------------------------------------------------------------------------
