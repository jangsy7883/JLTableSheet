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

+ (JLTableSheetItem *)actionSheetItemTitle:(NSString *)title userInfo:(NSDictionary *)userInfo {

    JLTableSheetItem *item = [[JLTableSheetItem alloc] init];
    item.title = title;
    item.userInfo = userInfo;
    
    return item;
}
@end
