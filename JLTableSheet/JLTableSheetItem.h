//
//  JLTableSheetItem.h
//  JLTableSheetDemo
//
//  Created by  Studio on 2017. 4. 2..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLTableSheetItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, getter=isSelected) BOOL selected;

+ (JLTableSheetItem *)actionSheetItemTitle:(NSString *)title userInfo:(NSDictionary *)userInfo;

@end
