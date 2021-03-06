//----------------------------------------------------------------------------------------------------------------------------
//
// "QSoundPanel.m"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
//----------------------------------------------------------------------------------------------------------------------------

#import "QSoundPanel.h"
#import "QShared.h"

#import <FruitzOfDojo/FruitzOfDojo.h>

//----------------------------------------------------------------------------------------------------------------------------

@interface QSoundPanel ()

- (void) buildMenuForPath: (NSString*) path;
- (void) addMenuItem: (NSString*) title image: (NSImage*) image action: (SEL) selector object: (id) object;

- (void) selectAudioCD: (id) sender;
- (void) selectFolder: (id) sender;
- (void) selectOther: (id) sender;

@end

//----------------------------------------------------------------------------------------------------------------------------

@implementation QSoundPanel

- (NSString *) nibName
{
	return @"SoundPanel";
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) awakeFromNib
{
    [self buildMenuForPath: [[FDPreferences sharedPrefs] stringForKey: QUAKE_PREFS_KEY_AUDIO_PATH]];
    self.title = @"Sound";
}

//----------------------------------------------------------------------------------------------------------------------------

- (NSString*) toolbarIdentifier
{
    return @"Quake Sound ToolbarItem";
}

//----------------------------------------------------------------------------------------------------------------------------

- (NSToolbarItem*) toolbarItem
{
    NSToolbarItem* item = [super toolbarItem];
    
    item.label = @"Sound";
    item.paletteLabel = @"Sound";
    item.toolTip = @"Change sound settings.";
    item.image = [NSImage imageNamed: @"Sound"];
    
    return item;
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) buildMenuForPath: (NSString*) path
{
	NSImage	* cdImg	= [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericCDROMIcon)];
    [mAudioPopup removeAllItems];
    
    if (path.length > 0)
    {
        BOOL        isDirectory = NO;
        const BOOL  pathExists  = [[NSFileManager defaultManager] fileExistsAtPath: path isDirectory: &isDirectory];
        
        if ((pathExists == YES) && (isDirectory == YES))
        {
            NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFile: path];
            
            [self addMenuItem: path.lastPathComponent image: icon action: @selector (selectFolder:) object: path];
        }
        else
        {
            [[FDPreferences sharedPrefs] setObject: [NSString string] forKey: QUAKE_PREFS_KEY_AUDIO_PATH];
        }
    }
    
    [self addMenuItem: @"Audio CD" image: cdImg action: @selector (selectAudioCD:) object: nil];
    [self addMenuItem: nil image: nil action: nil object: nil];
    [self addMenuItem: @"Other..." image: nil action: @selector (selectOther:) object: nil];
    
    [mAudioPopup selectItemAtIndex: 0];
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) addMenuItem: (NSString*) title image: (NSImage*) image action: (SEL) selector object: (id) object
{
    NSMenuItem* menuItem = nil;
    
    if (title != nil)
    {
        menuItem = [[[NSMenuItem alloc] initWithTitle: title action: selector keyEquivalent: [NSString string]] autorelease];
        
        if (image != nil)
        {
            image.size = NSMakeSize (16.0f, 16.0f);
            menuItem.image = image;
        }
        
        menuItem.representedObject = object;        
        menuItem.target = self;
    }
    else
    {
        menuItem = [NSMenuItem separatorItem];
    }
    
    [mAudioPopup.menu addItem: menuItem];
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) selectFolder: (id) sender
{
    [[FDPreferences sharedPrefs] setObject: [sender representedObject] forKey: QUAKE_PREFS_KEY_AUDIO_PATH];
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) selectAudioCD: (id) sender
{
    [[FDPreferences sharedPrefs] setObject: [NSString string] forKey: QUAKE_PREFS_KEY_AUDIO_PATH];
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) selectOther: (id) sender
{
    FD_UNUSED (sender);
    
    NSOpenPanel*    openPanel = [[NSOpenPanel alloc] init];
    
    [openPanel setAllowsMultipleSelection: NO];
    [openPanel setCanChooseFiles: NO];
    [openPanel setCanChooseDirectories: YES];
    openPanel.accessoryView = [mOpenPanelView retain];
    openPanel.directoryURL = [NSURL URLWithString: [[FDPreferences sharedPrefs] stringForKey: QUAKE_PREFS_KEY_AUDIO_PATH]];
    openPanel.title = @"Select the folder with the audio files:";
    
    [openPanel beginSheetModalForWindow: self.view.window completionHandler: ^(NSInteger result)
     {
         NSString* path = nil;
         
         if (result == NSFileHandlingPanelOKButton)
         {
             path = openPanel.directoryURL.path;
             
             [[FDPreferences sharedPrefs] setObject: path forKey: QUAKE_PREFS_KEY_AUDIO_PATH];
         }
         else
         {
             path = [[FDPreferences sharedPrefs] stringForKey: QUAKE_PREFS_KEY_AUDIO_PATH];
         }
         
         [self buildMenuForPath: path];
     }];
    
    [openPanel release];
}

@end

//----------------------------------------------------------------------------------------------------------------------------
