
//
//  JLTableSheetCell.m
//  JLTableSheetDemo
//
//  Created by  Studio on 2017. 4. 9..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import "JLTableSheetCell.h"

@interface JLTableSheetCell () <JLTableSheetCellRendering>

@end
@implementation JLTableSheetCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font = [UIFont systemFontOfSize:14];
}

#pragma mark - rendering

- (void)renderingSheetCellWithItem:(JLTableSheetItem *)item {
    self.textLabel.text = item.title;
    
    if (item.enabled) {
        self.textLabel.textColor = [UIColor darkGrayColor];
        if (item.selected) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else{
        self.textLabel.textColor = [UIColor lightGrayColor];
    }
}

@end
