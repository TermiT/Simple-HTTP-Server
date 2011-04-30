//
//  shttpsAppDelegate.m
//  shttps
//
//  Created by Gennadiy Potapov on 4/27/11.
//  Copyright 2011 General Arcade. All rights reserved.
//

#import "shttpsAppDelegate.h"

@implementation shttpsAppDelegate

@synthesize state;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    NSZone *zone = [NSMenu menuZone];
	NSMenu *menu = [[[NSMenu allocWithZone:zone] init] autorelease];
    
    pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    
	startItem = [menu addItemWithTitle:@"Start server" action:@selector(startServerAction:) keyEquivalent:@""];
	[startItem setTarget:self];

    stopItem = [menu addItemWithTitle:@"Stop server" action:@selector(stopServerAction:) keyEquivalent:@""];
	[stopItem setTarget:self];
    [stopItem setHidden:YES];
    
    [menu addItem:[NSMenuItem separatorItem]];
    
	quitItem = [menu addItemWithTitle:@"Quit" action:@selector(quitAction:) keyEquivalent:@""];
	[quitItem setTarget:self];
    
	trayItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	[trayItem setMenu:menu];
	[trayItem setHighlightMode:YES];
    [trayItem setImage:[NSImage imageNamed:@"tray-off.png"]];
    
    self.state = HTTPStateNotStarted;
}

- (IBAction)startServerAction:(id)sender {
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setCanChooseDirectories:YES];    
    if ([openDlg runModalForDirectory:nil file:nil] == NSOKButton) {
        [self startTask:[[openDlg filenames] objectAtIndex:0]];
        NSString * url = [NSString stringWithFormat:@"http://%@:8000/", [[NSHost currentHost] name]];
        [self showAlert:url];
        [pasteBoard setString:url forType:NSStringPboardType];
    }
}

- (IBAction)quitAction:(id)sender {
    if (self.state == HTTPStateRunning) {
        [self stopTask];
    }
	[NSApp terminate:sender];
}

- (IBAction)stopServerAction:(id)sender {
    if (self.state == HTTPStateRunning) {
        [self stopTask];
    }
}

- (void) showAlert:(NSString *)url {
    NSAlert * alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert setMessageText:@"Simple HTTP Server started"];
    [alert setInformativeText:[NSString stringWithFormat:@"You can use this url %@ to access choosen folder. The url copied to clipboard.", url]];
    [alert runModal];
}

- (void) startTask:(NSString *)dir {
    httpTask = [[NSTask alloc] init];
    [httpTask setCurrentDirectoryPath:dir];
    [httpTask setLaunchPath:@"/usr/bin/python"];
    [httpTask setArguments:[NSArray arrayWithObjects: @"-m", @"SimpleHTTPServer", nil]];
    [httpTask launch];
    
    self.state = HTTPStateRunning;   
    [startItem setHidden:YES];
    [stopItem setHidden:NO];
    [trayItem setImage:[NSImage imageNamed:@"tray-on.png"]];
}

- (void) stopTask {
    [httpTask interrupt];
    httpTask = nil;
    [httpTask release];
    
    self.state = HTTPStateNotStarted;   
    [startItem setHidden:NO];
    [stopItem setHidden:YES];
    [trayItem setImage:[NSImage imageNamed:@"tray-off.png"]];
}

- (void) dealloc {
    [stopItem release];
    [startItem release];
    [quitItem release];
    [httpTask release];
	[trayItem release];
	[super dealloc];
}

@end
