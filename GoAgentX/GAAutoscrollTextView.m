//
//  GAAutoscrollTextView.m
//  GoAgentX
//
//  Created by Xu Jiwei on 12-2-13.
//  Copyright (c) 2012年 xujiwei.com. All rights reserved.
//

#import "GAAutoscrollTextView.h"

@implementation GAAutoscrollTextView

- (void)clear {
    [[self textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
}


- (void)appendString:(NSString *)str {
    if (str && str.length > 0) {
        [self appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
    }
}


- (void)appendAttributedString:(NSAttributedString *)str {
    [[self textStorage] appendAttributedString:str];
    [self scrollToEndOfDocument:nil];
}

@end
