//
//  GAAutoscrollTextView.h
//  GoAgentX
//
//  Created by Xu Jiwei on 12-2-13.
//  Copyright (c) 2012年 xujiwei.com. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface GAAutoscrollTextView : NSTextView

- (void)clear;
- (void)appendString:(NSString *)str;
- (void)appendAttributedString:(NSAttributedString *)str;

@property (nonatomic, assign)   NSUInteger  maxLength;

@end
