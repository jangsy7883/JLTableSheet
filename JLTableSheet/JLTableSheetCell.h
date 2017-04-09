//
//  JLTableSheetCell.h
//  JLTableSheetDemo
//
//  Created by  Studio on 2017. 4. 9..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLTableSheetItem.h"
@protocol JLTableSheetCellRendering <NSObject>

@optional
+ (UINib *)nibForSheetCell;
- (void)renderingSheetCellWithItem:(JLTableSheetItem*)item;

@end

@interface JLTableSheetCell : UITableViewCell

@end
