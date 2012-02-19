//
//  GAAutoscrollTextView.m
//  GoAgentX
//
//  Created by Xu Jiwei on 12-2-13.
//  Copyright (c) 2012年 xujiwei.com. All rights reserved.
//

#import "GAAutoscrollTextView.h"

@implementation GAAutoscrollTextView

@synthesize maxLength;

- (void)clear {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(clear) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [[self textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
}


- (void)appendString:(NSString *)str {
    if (str && str.length > 0) {
        [self appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
    }
}


- (void)appendAttributedString:(NSAttributedString *)str {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(appendAttributedString:) withObject:str waitUntilDone:NO];
        return;
    }
    
    if (maxLength > 0 && self.string.length > maxLength) {
        [self clear];
    }
    
    [[self textStorage] appendAttributedString:str];
    [self scrollToEndOfDocument:nil];
}

@end
