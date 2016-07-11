//----------------------------------------------------------------------------------------------------------------------------
//
// "QController.h"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
// Quake™ is copyrighted by id software		[http://www.idsoftware.com].
//
//----------------------------------------------------------------------------------------------------------------------------

#import "QSettingsWindow.h"
#import "QMediaScan.h"

#import <Cocoa/Cocoa.h>

//----------------------------------------------------------------------------------------------------------------------------

@interface QController : NSObject <NSApplicationDelegate>
{
    QSettingsWindow*                mSettingsWindow;
    QMediaScan*                     mMediaScan;
    
    IBOutlet NSMenuItem*            pasteMenuItem;
 
    NSTimer*                        mFrameTimer;
    NSMutableArray*                 mRequestedCommands;
    double							mPrevFrameTime;
    BOOL							mOptionPressed;
    BOOL                            mHostInitialized;
}

+ (void) initialize;
- (instancetype) init;
- (void) dealloc;

- (BOOL) application: (NSApplication *) sender openFile: (NSString *) filePath;
- (NSApplicationTerminateReply) applicationShouldTerminate: (NSApplication*) sender;
- (void) applicationDidFinishLaunching: (NSNotification*) notification;
- (void)applicationWillTerminate: (NSNotification*) notification;
- (void) applicationDidResignActive: (NSNotification*) notification;
- (void) applicationWillHide: (NSNotification *) notification;
- (void) applicationWillUnhide: (NSNotification *) notification;

@property BOOL hostInitialized;

- (BOOL) validateIdDirectory: (NSString*) basePath;
- (void) selectIdDirectory;

- (void) requestCommand: (NSString *) theCommand;

@property (readonly, copy) NSString *mediaFolder;

- (void) connectToServer: (NSPasteboard*) pasteboard userData: (NSString*) data error: (NSString**) error;

- (void) pasteString: (id) sender;
- (IBAction) visitFOD: (id) sender;

- (void) setupDialog: (NSTimer*) timer;
- (IBAction) newGame: (id) sender;
- (void) initGame: (NSNotification*) notification;
- (void) installFrameTimer;
- (void) doFrame: (NSTimer*) timer;

@end

//----------------------------------------------------------------------------------------------------------------------------
