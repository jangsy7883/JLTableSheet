//
//  CustomSheetCell.m
//  JLTableSheetDemo
//
//  Created by Woody on 2017. 4. 7..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import "CustomSheetCell.h"
#import "JLTableSheetCell.h"

@interface CustomSheetCell ()<JLTableSheetCellRendering>

@end
@implementation CustomSheetCell

#pragma mark - nib

- (void)awakeFromNib {
    [super awakeFromNib];    
    self.tintColor = [UIColor colorWithRed:0.09 green:0.47 blue:0.78 alpha:1.00];
}

#pragma mark - JLTableSheetCellRendering

+ (UINib *)nibForSheetCell {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)renderingSheetCellWithItem:(JLTableSheetItem *)item {
    self.textLabel.text = item.title;
    
    if (item.enabled) {
        self.textLabel.textColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.00];
        if (item.selected) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else{
        self.textLabel.textColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00];
    }
}

#pragma mark - setters

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
