//----------------------------------------------------------------------------------------------------------------------------
//
// "QApplication.m" - required for event and AppleScript handling.
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
// Quake™ is copyrighted by id software		[http://www.idsoftware.com].
//
//----------------------------------------------------------------------------------------------------------------------------

#import "QApplication.h"
#import "QArguments.h"
#import "QController.h"

//----------------------------------------------------------------------------------------------------------------------------

@implementation QApplication : NSApplication

//----------------------------------------------------------------------------------------------------------------------------

- (void) handleRunCommand: (NSScriptCommand*) command
{
    QArguments* arguments = [QArguments sharedArguments];
    
    if (arguments.editable == YES)
    {
        NSDictionary*   args = command.evaluatedArguments;
    
        if (args != nil)
        {
            NSString*   params = args[@"QuakeParameters"];
            
            if (params == nil)
            {
                params = [NSString string];
            }

            [[QArguments sharedArguments] setArgumentsFromString: args[@"QuakeParameters"]];
        }
        
        [[QArguments sharedArguments] setEditable: NO];
    }
}

//----------------------------------------------------------------------------------------------------------------------------

- (void) handleConsoleCommand: (NSScriptCommand*) command
{
    NSDictionary*   args = command.evaluatedArguments;

    if (args != nil)
    {
        NSString*   commandList= args[@"QuakeCommandlist"];
        
        if (commandList != nil && [commandList isEqualToString:@""] == NO)
        {
            QController*    controller = self.delegate;
            
            [controller requestCommand: commandList];
        }
    }
}

@end

//----------------------------------------------------------------------------------------------------------------------------
