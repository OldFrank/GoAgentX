//
//  GAAppDelegate.h
//  GoAgentX
//
//  Created by Xu Jiwei on 12-2-13.
//  Copyright (c) 2012年 xujiwei.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GAAutoscrollTextView.h"
#import "GACommandRunner.h"

@interface GAAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    NSStatusItem        *statusBarItem;
    
    GACommandRunner     *proxyRunner;
    GACommandRunner     *deployRunner;
    
    IBOutlet NSMenu     *statusBarItemMenu;
    IBOutlet NSMenuItem *statusMenuItem;
    
    // 状态
    IBOutlet NSTextField            *statusTextLabel;
    IBOutlet NSImageView            *statusImageView;
    IBOutlet NSButton               *statusToggleButton;
    IBOutlet GAAutoscrollTextView   *statusLogTextView;
    
    // 客户端设置
    IBOutlet NSTextField            *clientPortField;
    IBOutlet NSTextField            *clientAppIdField;
    IBOutlet NSTextField            *clientServicePasswordField;
    IBOutlet NSSegmentedControl     *clientConnectModeSegment;
    IBOutlet NSSegmentedControl     *clientServerSegment;
    IBOutlet NSButton               *clientUseProxyButton;
    IBOutlet NSTextField            *clientProxyServerField;
    IBOutlet NSTextField            *clientProxyUsernameField;
    IBOutlet NSTextField            *clientProxyPasswordField;
    
    // 服务端部署
    IBOutlet NSTextField            *deployAppIdField;
    IBOutlet NSTextField            *deployUsernameField;
    IBOutlet NSSecureTextField      *deployPasswordField;
    IBOutlet NSTextField            *deployServicePasswordField;
    IBOutlet GAAutoscrollTextView   *deployLogTextView;
}

- (IBAction)showMainWindow:(id)sender;
- (IBAction)exitApplication:(id)sender;
- (IBAction)showHelp:(id)sender;

- (IBAction)toggleServiceStatus:(id)sender;
- (IBAction)clearStatusLog:(id)sender;

- (IBAction)applyClientSettings:(id)sender;
- (IBAction)showInstallPanel:(id)sender;

- (IBAction)clearDeployLog:(id)sender;
- (IBAction)deployButtonClicked:(id)sender;


@property (assign) IBOutlet NSWindow *window;

@end
