//
//  JLTableSheetItem.h
//  JLTableSheetDemo
//
//  Created by  Studio on 2017. 4. 2..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLTableSheetItem : NSObject

@property (nonatomic, strong, nullable) NSString *identifier;
@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSDictionary *userInfo;

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, getter=isSelected) BOOL selected;

+ (nullable JLTableSheetItem *)sheetItemWithIdentifier:(nullable NSString *)identifier title:(nullable NSString *)title;
+ (nullable JLTableSheetItem *)sheetItemWithIdentifier:(nullable NSString *)identifier title:(nullable NSString *)title userInfo:(nullable NSDictionary *)userInfo;

@end
