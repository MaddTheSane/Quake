//----------------------------------------------------------------------------------------------------------------------------
//
// "QArguments.h"
//
// Written by:	Axel 'awe' Wefers			[mailto:awe@fruitz-of-dojo.de].
//				©2001-2012 Fruitz Of Dojo 	[http://www.fruitz-of-dojo.de].
//
//----------------------------------------------------------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

//----------------------------------------------------------------------------------------------------------------------------

@interface QArguments : NSObject
{
    NSMutableArray<NSDictionary<NSString*,NSString*>*>* mArguments;
    BOOL            mIsEditable;
}

+ (QArguments*) sharedArguments;

@property (getter=isEditable) BOOL editable;

- (void) setArgumentsFromString: (NSString*) string;
- (void) setArgumentsFromArray: (NSArray<NSString*>*) array;
- (void) setArgumentsFromProccessInfo;

@property (copy) NSArray<NSDictionary<NSString*,NSString*>*> *arguments;

- (BOOL) validateWithBasePath: (NSString*) basePath;

- (char**) cArguments: (int*) count;

@end

//----------------------------------------------------------------------------------------------------------------------------
