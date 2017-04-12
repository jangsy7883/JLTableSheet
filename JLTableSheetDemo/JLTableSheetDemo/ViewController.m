//
//  ViewController.m
//  JLTableSheetDemo
//
//  Created by  Studio on 2017. 4. 2..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import "ViewController.h"
#import "JLTableSheetViewController.h"

#import "CustomSheetCell.h"
#import "CustomTitleView.h"
#import "CustomHeaderView.h"

@interface ViewController ()

@property (nonatomic, readonly) NSArray<JLTableSheetItem *> *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
 * Multiple Selection Sheet
 */
- (IBAction)pressedMultipleSelectionSheetButton:(id)sender{
    
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:self.items];
    tableSheetViewController.navigationBar.topItem.title = @"Choose Fruits";
    
    //
    tableSheetViewController.allowsMultipleSelection = YES;
    
    //Block
    tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *items) {
        NSLog(@"isCompleteAction : %@",isCompleteAction ? @"YES":@"NO");
        NSLog(@"%@",items);
    };
    
    [tableSheetViewController presentInViewController:self];
}

/*
 * Single Selection Sheet
 */
- (IBAction)pressedSingleSelectionSheetButton:(id)sender{

    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:self.items];
    tableSheetViewController.navigationBar.topItem.title = @"Choose Fruits";
    
    //
    tableSheetViewController.allowsMultipleSelection = NO;

    //Block
    tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *items) {
        NSLog(@"%@",items);
    };
    
    [tableSheetViewController presentInViewController:self];
}

/*
 * Custom NavigationBarItem Sheet
 */
- (IBAction)pressedCustomNavigationBarItemSheetButton:(id)sender {

    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:self.items];
    tableSheetViewController.navigationBar.topItem.title = @"Choose Fruits";
    
    tableSheetViewController.allowsMultipleSelection = YES;
    
    //
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(pressedSaveButton:)];
    item.enabled = NO;
    tableSheetViewController.navigationBar.topItem.rightBarButtonItem = item;
    tableSheetViewController.hidesCompleteButton = YES;
    tableSheetViewController.hidesCancelButton = YES;
    
    //Block
    __block __weak typeof(JLTableSheetViewController) *weakTableSheetViewController = tableSheetViewController;
    tableSheetViewController.changedSelectedItems = ^(NSArray<JLTableSheetItem *> *items) {
        //reload BarButtonItem
        weakTableSheetViewController.navigationBar.topItem.rightBarButtonItem.enabled = items.count > 0;
        NSLog(@"changed selected items");
    };
    tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *items) {
        NSLog(@"completion");
        NSLog(@"%@",items);
    };
    
    //
    [tableSheetViewController presentInViewController:self];
}

/*
 * Custom headerView Sheet
 */
- (IBAction)pressedCustomHeaderSheetButton:(id)sender {
  
    //CustomHeaderView
    CustomHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomHeaderView class]) owner:self options:nil].firstObject;
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50);
    headerView.titleLabl.text = @"Choose Fruits";
    [headerView.closeButton addTarget:self action:@selector(pressedSaveButton:) forControlEvents:UIControlEventTouchUpInside];

    //
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:self.items];
    tableSheetViewController.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    tableSheetViewController.allowsMultipleSelection = YES;
    tableSheetViewController.navigationBarHidden = YES;
    tableSheetViewController.headerView = headerView;
    tableSheetViewController.cellClass = [CustomSheetCell class];
    
    //Block
    tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *items) {
        NSLog(@"%@",items);
    };
    
    //
    [tableSheetViewController presentInViewController:self];
}

#pragma mark - event

- (IBAction)pressedSaveButton:(id)sender {
    [self.tableSheetViewController dismiss];
}

#pragma mark - getters 

- (NSArray <JLTableSheetItem *> *)items {
    NSArray* fruitNames = @[
                            @"Apple",
                            @"Grape",
                            @"Watermelon",
                            @"Orange",
                            @"Strawberry",
                            @"Pineapple",
                            @"Mango",
                            @"Peach",
                            @"Kiwi",
                            @"Apple",
                            @"Blueberries",
                            @"Plum",
                            @"Banana",
                            @"Chestnut",
                            @"Cherry",
                            ];
    
    NSMutableArray <JLTableSheetItem *> *items = [NSMutableArray array];
    for (NSString *fruitName in fruitNames) {
        JLTableSheetItem *item = [JLTableSheetItem actionSheetItemTitle:fruitName userInfo:nil];
        [items addObject:item];
    }
    
    return [NSArray arrayWithArray:items];
}

@end
