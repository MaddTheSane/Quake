//----------------------------------------------------------------------------------------------------------------------------
//
// "QArgumentsPanel.m"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
//----------------------------------------------------------------------------------------------------------------------------

#import "QArgumentsPanel.h"
#import "QArguments.h"
#import "QShared.h"

#import <FruitzOfDojo/FDPreferences.h>

//----------------------------------------------------------------------------------------------------------------------------

@interface QArgumentsPanel ()

- (NSMutableDictionary*) argumentWithState: (NSCellStateValue) state value: (NSString*) value;

@end

//----------------------------------------------------------------------------------------------------------------------------

@implementation QArgumentsPanel

- (NSString *) nibName
{
	return @"ArgumentsPanel";
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [self synchronize];
    
    [mArgumentEdit release];
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) awakeFromNib
{
    const BOOL isEditable = [QArguments sharedArguments].editable;
    
    for (NSDictionary* argument in [[QArguments sharedArguments] arguments])
    {
       [mArguments addObject: [[argument mutableCopy] autorelease]];
    }
    
    mArgumentEdit = [[QArgumentEdit alloc] init];
    
    mTableView.delegate = self;
    [mTableView deselectAll: nil];
    
    mTableView.enabled = isEditable;
    mAddButton.enabled = isEditable;
    mRemoveButton.enabled = isEditable;
    
    [self tableViewSelectionDidChange: (id)self];
    self.title = @"CLI";
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) synchronize
{
    if (mArguments != nil)
    {
        [[QArguments sharedArguments]  setArguments: mArguments.arrangedObjects];

        if (mTableView.enabled == YES)
        {
            [[FDPreferences sharedPrefs] setObject: mArguments.arrangedObjects forKey: QUAKE_PREFS_KEY_ARGUMENTS];
        }
    }
    
    [super synchronize];
}

//----------------------------------------------------------------------------------------------------------------------------

- (NSString*) toolbarIdentifier
{
    return @"Quake Arguments ToolbarItem";
}

//----------------------------------------------------------------------------------------------------------------------------

- (NSToolbarItem*) toolbarItem
{
    NSToolbarItem* item = [super toolbarItem];
    
    item.label = @"CLI";
    item.paletteLabel = @"CLI";
    item.toolTip = @"Set command-line parameters.";
    item.image = [NSImage imageNamed: @"Arguments"];
    
    return item;
}

//----------------------------------------------------------------------------------------------------------------------------

- (NSMutableDictionary*) argumentWithState: (NSCellStateValue) state value: (NSString*) value
{
    NSNumber*   enabled = @( (BOOL)(state == NSOnState));
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys: enabled, @"state", value, @"value", nil];
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) tableViewSelectionDidChange: (NSNotification*) notification
{
    mRemoveButton.enabled = (mTableView.selectedRow != -1);
}

//----------------------------------------------------------------------------------------------------------------------------

- (IBAction) insertArgument: (id) sender
{
    const NSUInteger        idx = mArguments.selectionIndex;
	NSMutableDictionary*    arg = [self argumentWithState: NSOnState value: [NSString string]];

    if ([mArgumentEdit edit: arg modalForWindow: self.view.window] == NSOKButton)
    {
        if (idx == NSNotFound)
        {
            [mArguments addObject: arg];
        }
        else
        {
            [mArguments insertObject: arg atArrangedObjectIndex: idx];
        }
    }
}

@end

//----------------------------------------------------------------------------------------------------------------------------
