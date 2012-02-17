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
    [self setString:@""];
}


- (void)appendString:(NSString *)str {
    if (str && str.length > 0) {
        [self appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
    }
}


- (void)appendAttributedString:(NSAttributedString *)str {
    if (maxLength > 0 && self.string.length > maxLength) {
        [self clear];
    }
    
    [[self textStorage] appendAttributedString:str];
    [self scrollToEndOfDocument:nil];
}

@end
