//
//  JLTableSheetViewController.h
//  JLTableSheetDemo
//
//  Created by  Studio on 2017. 4. 2..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLTableSheetCell.h"
#import "JLTableSheetItem.h"

@interface JLTableSheetViewController : UIViewController

@property (nonatomic, assign, getter=isAllowsMultipleSelection) BOOL allowsMultipleSelection; // default is NO

/**
 Hidden status of navigation bar of sheet. default is NO
 */
@property (nonatomic, assign, getter=isNavigationBarHidden) BOOL navigationBarHidden; 

/**
 hides close button on the navigation bar. default is NO
 */
@property (nonatomic, assign, getter=isHidesCloseButton) BOOL hidesCancelButton;

/**
 hides complete button on the navigation bar. default is NO
 */
@property (nonatomic, assign, getter=isHidesCompleteButton) BOOL hidesCompleteButton;

@property (nonatomic, strong, nonnull) NSArray <JLTableSheetItem *> *items;
@property (nonatomic, readonly, nonnull) NSArray <JLTableSheetItem *> *selectedItems;

@property (nonatomic, strong, nullable) UIView *headerView;
@property (nonatomic, readonly, nonnull) UIView * backgroundView;

/**
 Navigation bar of sheet.
 */
@property (nonatomic, readonly, nonnull) UINavigationBar *navigationBar;

@property (nonatomic, assign, nullable) Class cellClass;

/**
 The height of each row in the table view. default is 50
 */
@property (nonatomic, assign) CGFloat rowHegiht;
@property (nonatomic, assign) CGFloat minVisibleRow; // default is 4.5
@property (nonatomic, assign) CGFloat maxVisibleRow; // default is 0

@property (nonatomic, strong, nonnull) UIColor *separatorColor;
@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;
@property (nonatomic, assign) UIEdgeInsets separatorInset;

@property (nonatomic, copy, nullable) void (^changedSelectedItems)(NSArray <JLTableSheetItem *> * _Nullable selectedItems);
@property (nonatomic, copy, nullable) void (^willCompletion)(BOOL isCompleteAction,NSArray <JLTableSheetItem *> * _Nullable selectedItems);
@property (nonatomic, copy, nullable) void (^completion)(BOOL isCompleteAction,NSArray <JLTableSheetItem *> * _Nullable selectedItems);

/**
 Init the sheet with sheet Items.
 @see JLTableSheetItem
 */
- (instancetype _Nullable)initWithItems:(NSArray <JLTableSheetItem *> * _Nullable)items;

/**
 Present the sheet on a given view controller.
 */
- (void)presentInViewController:(nonnull UIViewController*)viewController;

/**
 Dismiss the sheet.
 Completion block will be called after dismissing transition is finished.
 */
- (void)dismissWithCompletion:(void (^_Nullable)(void))completion;

@end

@interface UIViewController (JLTableSheetViewController)

- (nullable JLTableSheetViewController *)tableSheetViewController;

@end
