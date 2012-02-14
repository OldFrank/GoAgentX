//
//  GACommandRunner.m
//  GoAgentX
//
//  Created by Xu Jiwei on 12-2-13.
//  Copyright (c) 2012年 xujiwei.com. All rights reserved.
//

#import "GACommandRunner.h"

#define GACommandRunnerTaskTerminatedNotification @"GACommandRunnerTaskTerminatedNotification"

@implementation GACommandRunner

- (id)init {
    if (self = [super init]) {
    }
    
    return self;
}


- (BOOL)isTaskRunning {
    return [task isRunning];
}


- (void)terminateTask {
    if (task && [task isRunning]) {
        [task terminate];
    }
}


- (int)processId {
    return [task processIdentifier];
}


- (void)waitTaskUntilDone:(id)sender {
    [task waitUntilExit];
    [[NSNotificationCenter defaultCenter] postNotificationName:GACommandRunnerTaskTerminatedNotification object:sender];
}


- (void)runCommand:(NSString *)path
  currentDirectory:(NSString *)curDir
         arguments:(NSArray *)arguments
         inputText:(NSString *)inputText
    outputTextView:(GAAutoscrollTextView *)textView
terminationHandler:(void (^)(NSTask *))terminationHandler {
    
    [self terminateTask];
    
    task = [NSTask new];
    [task setCurrentDirectoryPath:curDir];
    [task setLaunchPath:path];
    [task setArguments:arguments];
    
    if (inputText) {
        NSPipe *pipe = [NSPipe new];
        [[pipe fileHandleForWriting] writeData:[inputText dataUsingEncoding:NSUTF8StringEncoding]];
        NSFileHandle *inputHandle = [pipe fileHandleForReading];
        [task setStandardInput:inputHandle];
    }
    
    NSPipe *outputPipe = [NSPipe pipe];
    [task setStandardOutput:outputPipe];
    [task setStandardError:outputPipe];
    
    NSFileHandle *outputReadHandle = [outputPipe fileHandleForReading];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleReadCompletionNotification
                                                      object:outputReadHandle
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSData *data = [note.userInfo objectForKey:NSFileHandleNotificationDataItem];
                                                      if ([data length] > 0) {
                                                          NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                          [textView appendString:str];
                                                          [outputReadHandle readInBackgroundAndNotify];
                                                      }
                                                  }];
    
    [outputReadHandle readInBackgroundAndNotify];
    
    __block id _self = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:GACommandRunnerTaskTerminatedNotification
                                                      object:self
                                                       queue:[NSOperationQueue new]
                                                  usingBlock:^(NSNotification *note) {
                                                      [outputReadHandle closeFile];
                                                      [[NSNotificationCenter defaultCenter] removeObserver:_self];
                                                      [textView appendString:@"\n"];
                                                      
                                                      terminationHandler(task);
                                                  }];
    
    [task launch];
    
    // 新启线程来等待进程结束
    [NSThread detachNewThreadSelector:@selector(waitTaskUntilDone:) toTarget:self withObject:self];
}


@end
