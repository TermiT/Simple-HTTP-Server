//
//  shttpsAppDelegate.h
//  shttps
//
//  Created by Gennadiy Potapov on 4/27/11.
//  Copyright 2011 General Arcade. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	HTTPStateRunning,
	HTTPStateNotStarted,
} HTTPState;

@interface shttpsAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSStatusItem *trayItem;
    NSTask * httpTask;
    NSMenuItem *stopItem;
    NSMenuItem *startItem;
    NSMenuItem *quitItem;
    HTTPState state;
    NSPasteboard * pasteBoard;
}

@property(nonatomic, assign) HTTPState state;

- (void) showAlert:(NSString *)url;
- (void) startTask:(NSString *)dir;
- (void) stopTask;

@end
