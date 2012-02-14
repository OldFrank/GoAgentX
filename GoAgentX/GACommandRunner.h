//
//  GACommandRunner.h
//  GoAgentX
//
//  Created by Xu Jiwei on 12-2-13.
//  Copyright (c) 2012年 xujiwei.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GAAutoscrollTextView.h"

@interface GACommandRunner : NSObject {
    NSTask      *task;
}

- (BOOL)isTaskRunning;
- (void)terminateTask;
- (int)processId;

- (void)runCommand:(NSString *)path
  currentDirectory:(NSString *)curDir
         arguments:(NSArray *)arguments
         inputText:(NSString *)text
    outputTextView:(GAAutoscrollTextView *)textView
terminationHandler:(void (^)(NSTask *))terminationHandler;

@end
