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

@property (nonatomic, assign, getter=isAllowsMultipleSelection) BOOL allowsMultipleSelection;
@property (nonatomic, assign, getter=isNavigationBarHidden) BOOL navigationBarHidden;
@property (nonatomic, assign, getter=isHidesCloseButton) BOOL hidesCancelButton;
@property (nonatomic, assign, getter=isHidesCompleteButton) BOOL hidesCompleteButton;

@property (nonatomic, strong, nonnull) NSArray <JLTableSheetItem *> *items;
@property (nonatomic, readonly, nonnull) NSArray <JLTableSheetItem *> *selectedItems;

@property (nonatomic, strong, nullable) UIView *headerView;
@property (nonatomic, readonly, nonnull) UIView * backgroundView;
@property (nonatomic, readonly, nonnull) UINavigationBar *navigationBar;

//
@property (nonatomic, assign, nullable) Class cellClass;
@property (nonatomic, assign) CGFloat rowHegiht;
@property (nonatomic, assign) CGFloat minVisibleRow;
@property (nonatomic, assign) CGFloat navigationHegiht;

//
@property (nonatomic, strong, nonnull) UIColor *separatorColor;
@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;
@property (nonatomic, assign) UIEdgeInsets separatorInset;

@property (nonatomic, copy, nullable) void (^changedSelectedItems)(NSArray <JLTableSheetItem *> * _Nullable items);
@property (nonatomic, copy, nullable) void (^completion)(BOOL isCompleteAction,NSArray <JLTableSheetItem *> * _Nullable items);

- (instancetype _Nullable)initWithItems:(NSArray <JLTableSheetItem *> * _Nullable)items;

- (void)presentInViewController:(nonnull UIViewController*)viewController;
- (void)dismiss;
- (void)dismissWithCompletion:(void (^_Nullable)(void))completion;

@end

@interface UIViewController (JLTableSheetViewController)

- (nonnull JLTableSheetViewController *)tableSheetViewController;

@end
