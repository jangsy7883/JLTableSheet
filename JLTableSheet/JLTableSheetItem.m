//
//  JLTableSheetItem.m
//  JLTableSheetDemo
//
//  Created by  Studio on 2017. 4. 2..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import "JLTableSheetItem.h"

@implementation JLTableSheetItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _enabled = YES;
        _selected = NO;
    }
    return self;
}

+ (JLTableSheetItem *)sheetItemWithIdentifier:(NSString *)identifier title:(NSString *)title {
    return [self sheetItemWithIdentifier:identifier title:title userInfo:nil];
}

+ (JLTableSheetItem *)sheetItemWithIdentifier:(NSString *)identifier title:(NSString *)title userInfo:(NSDictionary *)userInfo {    
    if (identifier == nil && title == nil) return nil;
    
    JLTableSheetItem *item = [[JLTableSheetItem alloc] init];
    item.identifier = identifier;
    item.title = title;
    item.userInfo = userInfo;
    return item;
}

@end
