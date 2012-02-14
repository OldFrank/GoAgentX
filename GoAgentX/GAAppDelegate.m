//
//  GAAppDelegate.m
//  GoAgentX
//
//  Created by Xu Jiwei on 12-2-13.
//  Copyright (c) 2012年 xujiwei.com. All rights reserved.
//

#import "GAAppDelegate.h"


@implementation GAAppDelegate

@synthesize window = _window;

#pragma mark -
#pragma mark Setup

- (void)setupStatusItem {
    statusBarItem = [[NSStatusBar systemStatusBar] statusItemWithLength:23.0];
    statusBarItem.image = [NSImage imageNamed:@"status_item_icon"];
    statusBarItem.alternateImage = [NSImage imageNamed:@"status_item_icon_alt"];
    statusBarItem.menu = statusBarItemMenu;
    statusBarItem.toolTip = @"GoAgent is NOT Running";
    [statusBarItem setHighlightMode:YES];
}


#pragma mark -
#pragma mark Helper

- (NSString *)pathInApplicationSupportFolder:(NSString *)path {
    NSString *folder = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
                         stringByAppendingPathComponent:@"Application Support"]
                        stringByAppendingPathComponent:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]];
    return [folder stringByAppendingPathComponent:path];
}


- (NSString *)copyFolderToApplicationSupport:(NSString *)folder {
    NSString *serverPath = [[NSBundle mainBundle] pathForResource:folder ofType:nil inDirectory:@"goagent"];
    NSString *copyPath = [self pathInApplicationSupportFolder:folder];
    [[NSFileManager defaultManager] removeItemAtPath:copyPath error:NULL];
    [[NSFileManager defaultManager] createDirectoryAtPath:[copyPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL];
    [[NSFileManager defaultManager] copyItemAtPath:serverPath toPath:copyPath error:NULL];
    return copyPath;
}


- (NSString *)copyServerToApplicationSupport {
    return [self copyFolderToApplicationSupport:@"server"];
}


- (NSString *)copyLocalToApplicationSupport {
    return [self copyFolderToApplicationSupport:@"local"];
}


- (NSDictionary *)defaultSettings {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GoAgentDefaultSettings" ofType:@"plist"]];
    return dict;
}


- (void)setStatusToRunning:(BOOL)running {
    NSInteger port = [[NSUserDefaults standardUserDefaults] integerForKey:@"GoAgent:Local:Port"];
    NSString *statusText = [NSString stringWithFormat:@"正在运行，端口 %ld", port];
    NSImage *statusImage = [NSImage imageNamed:@"status_running"];
    NSString *buttonTitle = @"停止";
    
    if (!running) {
        statusText = @"已停止";
        statusImage = [NSImage imageNamed:@"status_stopped"];
        buttonTitle = @"启动";
    }
    
    statusBarItem.toolTip = statusText;
    statusTextLabel.stringValue = statusText;
    statusImageView.image = statusImage;
    statusMenuItem.title = statusText;
    statusMenuItem.image = statusImage;
    statusToggleButton.title = buttonTitle;
}


#pragma mark -
#pragma mark 菜单事件

- (void)showMainWindow:(id)sender {
    [self.window setLevel:NSFloatingWindowLevel];
    if ([self.window canBecomeMainWindow]) {
        [self.window makeMainWindow];
    }
    [self.window makeKeyAndOrderFront:nil];
    [self.window makeKeyWindow];
}


- (void)exitApplication:(id)sender {
    [NSApp terminate:nil];
}


- (void)showHelp:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/ohdarling88/GoAgentX"]];
}


#pragma mark -
#pragma mark 运行状态

- (void)toggleServiceStatus:(id)sender {
    if (proxyRunner == nil) {
        proxyRunner = [GACommandRunner new];
    }
    
    GACommandRunner *runner = proxyRunner;
    
    if ([runner isTaskRunning]) {
        [runner terminateTask];
        [self setStatusToRunning:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GoAgent:LastRunPID"];
        
    } else {
        // 关闭可能的上次运行的 goagent
        NSInteger lastRunPID = [[NSUserDefaults standardUserDefaults] integerForKey:@"GoAgent:LastRunPID"];
        if (lastRunPID > 0) {
            const char *killCmd = [[NSString stringWithFormat:@"kill %ld", lastRunPID] UTF8String];
            system(killCmd);
        }
        
        // 复制一份 local 到 Application Support
        NSString *copyPath = [self copyLocalToApplicationSupport];
        
        // 生成 proxy.ini
        NSDictionary *defaults = [self defaultSettings];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *proxyini = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"proxyinitemplate" ofType:nil] 
                                                       encoding:NSUTF8StringEncoding error:NULL];
        for (NSString *key in [defaults allKeys]) {
            proxyini = [proxyini stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}", key]
                                                           withString:[userDefaults stringForKey:key] ?: @""];
        }
        [proxyini writeToFile:[copyPath stringByAppendingPathComponent:@"proxy.ini"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        
        [statusLogTextView clear];
        [statusLogTextView appendString:@"正在启动...\n"];
        
        // 启动代理
        NSArray *arguments = [NSArray arrayWithObjects:@"python", @"proxy.py", nil];
        [runner runCommand:@"/usr/bin/env"
          currentDirectory:copyPath
                 arguments:arguments
                 inputText:nil
            outputTextView:statusLogTextView 
        terminationHandler:^(NSTask *theTask) {
            [self setStatusToRunning:NO];
        }];
        
        [statusLogTextView appendString:@"启动完成\n"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:[runner processId] forKey:@"GoAgent:LastRunPID"];
        
        [self setStatusToRunning:YES];
    }
}


- (void)clearStatusLog:(id)sender {
    [statusLogTextView clear];
}


#pragma mark -
#pragma mark 客户端设置

- (NSDictionary *)settingsControlMap {
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                         clientPortField,           @"GoAgent:Local:Port",
                         clientAppIdField,          @"GoAgent:Local:AppId",
                         clientServicePasswordField,@"GoAgent:Local:ServicePassword",
                         clientConnectModeSegment,  @"GoAgent:Local:ConnectMode",
                         clientServerSegment,       @"GoAgent:Local:GAEProfile",
                         clientUseProxyButton,      @"GoAgent:Local:ProxyEnabled",
                         clientProxyServerField,    @"GoAgent:Local:ProxyServer",
                         clientProxyUsernameField,  @"GoAgent:Local:ProxyUsername",
                         clientProxyPasswordField,  @"GoAgent:Local:ProxyPassword",
                         nil];
    NSArray *modes = [NSArray arrayWithObjects:@"HTTP", @"HTTPS", nil];
    NSArray *servers = [NSArray arrayWithObjects:@"google_cn", @"google_hk", @"google_ipv6", nil];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            map,    @"controls",
            modes,  @"connectModes",
            servers,@"servers",
            nil];
}


- (void)restoreClientSettings {
    NSDictionary *map = [self settingsControlMap];
    NSDictionary *controls = [map objectForKey:@"controls"];
    NSArray *modes = [map objectForKey:@"connectModes"];
    NSArray *servers = [map objectForKey:@"servers"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in [controls allKeys]) {
        NSTextField *textfield = [controls objectForKey:key];
        NSString *val = [defaults stringForKey:key];
        if ([textfield isKindOfClass:[NSTextField class]]) {
            textfield.stringValue = val ?: @"";
            
        } else if ((id)textfield == (id)clientConnectModeSegment) {
            clientConnectModeSegment.selectedSegment = [modes indexOfObject:val];
            
        } else if ((id)textfield == (id)clientServerSegment) {
            clientServerSegment.selectedSegment = [servers indexOfObject:val];
            
        } else if ((id)textfield == (id)clientUseProxyButton) {
            clientUseProxyButton.state = [val boolValue] ? NSOnState : NSOffState;
        }
    }
}


- (void)saveClientSettings:(id)sender {
    NSDictionary *map = [self settingsControlMap];
    NSDictionary *controls = [map objectForKey:@"controls"];
    NSArray *modes = [map objectForKey:@"connectModes"];
    NSArray *servers = [map objectForKey:@"servers"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in [controls allKeys]) {
        NSTextField *textfield = [controls objectForKey:key];
        if ([textfield isKindOfClass:[NSTextField class]]) {
            [defaults setObject:textfield.stringValue ?: @"" forKey:key];
            
        } else if ((id)textfield == (id)clientConnectModeSegment) {
            [defaults setObject:[modes objectAtIndex:clientConnectModeSegment.selectedSegment] forKey:key];
            
        } else if ((id)textfield == (id)clientServerSegment) {
            [defaults setObject:[servers objectAtIndex:clientServerSegment.selectedSegment] forKey:key];
            
        } else if ((id)textfield == (id)clientUseProxyButton) {
            [defaults setBool:clientUseProxyButton.state == NSOnState ? YES : NO forKey:key];
        }
    }
    
    [defaults synchronize];
    
    [[NSAlert alertWithMessageText:@"客户端设置" 
                     defaultButton:nil 
                   alternateButton:nil
                       otherButton:nil
         informativeTextWithFormat:@"保存成功，您需要停止并重新启动连接才能使用修改后的配置"] runModal];
}


#pragma mark 服务端部署

- (void)clearDeployLog:(id)sender {
    [[deployLogTextView textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
}


- (void)deployButtonClicked:(id)sender {
    static GACommandRunner *runner = nil;
    if (runner == nil) {
        runner = [GACommandRunner new];
    }
    
    if ([runner isTaskRunning]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"部署服务端"
                                         defaultButton:@"确定"
                                       alternateButton:@"取消"
                                           otherButton:@"仅停止部署"
                             informativeTextWithFormat:@"正在部署服务端，是否取消当前的进程，重新开始进行部署？"];
        NSInteger ret = [alert runModal];
        if (ret == NSAlertAlternateReturn) {
            return;
        } else if (ret == NSAlertOtherReturn) {
            [runner terminateTask];
            return;
        }
    }
    
    
    // 复制一份 server 到 Application Support
    NSString *copyPath = [self copyServerToApplicationSupport];
    
    // 如果有服务密码，修改 fetch.py
    NSString *servicePassword = deployServicePasswordField.stringValue;
    if (servicePassword.length > 0) {
        NSString *fetchpyPath = [[copyPath stringByAppendingPathComponent:@"python"] stringByAppendingPathComponent:@"fetch.py"];
        NSString *content = [[NSString alloc] initWithContentsOfFile:fetchpyPath encoding:NSUTF8StringEncoding error:NULL];
        content = [content stringByReplacingOccurrencesOfString:@"__password__ = ''"
                                                     withString:[NSString stringWithFormat:@"__password__ = '%@'", servicePassword]
                                                        options:NSLiteralSearch
                                                          range:NSMakeRange(0, 300)];
        [content writeToFile:fetchpyPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
    
    // 启动部署进程
    NSArray *arguments = [NSArray arrayWithObjects:@"uploaddir=python", @"python", @"uploader.zip", nil];
    NSArray *input = [NSArray arrayWithObjects:
                      deployAppIdField.stringValue ?: @"",
                      deployUsernameField.stringValue ?: @"",
                      deployPasswordField.stringValue ?: @"",
                      @"",
                      nil];
    [deployLogTextView clear];
    [deployLogTextView appendString:@"开始部署...\n"];
    [runner runCommand:@"/usr/bin/env"
      currentDirectory:copyPath
             arguments:arguments
             inputText:[input componentsJoinedByString:@"\n"]
        outputTextView:deployLogTextView
    terminationHandler:^(NSTask *theTask) {
        if ([theTask terminationStatus] == 0) {
            [deployLogTextView appendString:@"部署成功"];
        } else {
            [deployLogTextView appendString:@"部署失败，请查看日志并检查设置是否正确"];
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:copyPath error:NULL];
    }];
}


#pragma mark -
#pragma mark Window delegate

- (BOOL)windowShouldClose:(id)sender {
    [self.window orderOut:nil];
    return NO;
}


#pragma mark -
#pragma mark App delegate

- (void)applicationWillTerminate:(NSNotification *)notification {
    [proxyRunner terminateTask];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserDefaults standardUserDefaults] registerDefaults:[self defaultSettings]];
    [self restoreClientSettings];
    [self setupStatusItem];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"GoAgent:Local:AppId"] length] > 0) {
        [self toggleServiceStatus:nil];
    } else {
        [self showMainWindow:nil];
    }
}


@end
