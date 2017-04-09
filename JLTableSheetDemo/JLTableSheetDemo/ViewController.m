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
@interface ViewController ()

@property (nonatomic, strong) NSArray<NSString *> *fruits;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
 * Multiple Selection Sheet
 */
- (IBAction)pressedMultipleSelectionSheetButton:(id)sender{
    NSMutableArray <JLTableSheetItem *> *items = [NSMutableArray array];
    for (NSString *fruit in self.fruits) {
        JLTableSheetItem *item = [JLTableSheetItem actionSheetItemTitle:fruit userInfo:nil];
        [items addObject:item];
    }
    
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:items];
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
    NSMutableArray <JLTableSheetItem *> *items = [NSMutableArray array];
    for (NSString *fruit in self.fruits) {
        JLTableSheetItem *item = [JLTableSheetItem actionSheetItemTitle:fruit userInfo:nil];
        [items addObject:item];
    }
    
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:items];
    tableSheetViewController.navigationBar.topItem.title = @"Choose Fruits";
    
    //
    tableSheetViewController.allowsMultipleSelection = NO;

    //Block
    tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *items) {
        NSLog(@"isCompleteAction : %@",isCompleteAction ? @"YES":@"NO");
        NSLog(@"%@",items);
    };
    
    [tableSheetViewController presentInViewController:self];
}

/*
 * Custom NavigationBarItem Sheet
 */
- (IBAction)pressedCustomNavigationBarItemSheetButton:(id)sender {
    NSMutableArray <JLTableSheetItem *> *items = [NSMutableArray array];
    for (NSString *fruit in self.fruits) {
        JLTableSheetItem *item = [JLTableSheetItem actionSheetItemTitle:fruit userInfo:nil];
        [items addObject:item];
    }
    
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:items];
    tableSheetViewController.navigationBar.topItem.title = @"Choose Fruits";
    
    //
    tableSheetViewController.allowsMultipleSelection = YES;
    tableSheetViewController.hidesCompleteButton = YES;
    tableSheetViewController.hidesCancelButton = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(pressedSaveButton:)];
    item.enabled = NO;
    tableSheetViewController.navigationBar.topItem.rightBarButtonItem = item;
    
    //Block
    __block __weak typeof(JLTableSheetViewController) *weakTableSheetViewController = tableSheetViewController;
    tableSheetViewController.changedSelectedItems = ^(NSArray<JLTableSheetItem *> *items) {
        //reload BarButtonItem
        weakTableSheetViewController.navigationBar.topItem.rightBarButtonItem.enabled = items.count > 0;
    };
    tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *items) {
        NSLog(@"isCompleteAction : %@",isCompleteAction ? @"YES":@"NO");
        NSLog(@"%@",items);
    };
    
    //
    [tableSheetViewController presentInViewController:self];
}

- (IBAction)pressedSaveButton:(id)sender {
    [self.tableSheetViewController dismiss];
}

/*
 * Custom
 */
- (IBAction)pressedSheetButton:(id)sender {
    
    //Item
    NSMutableArray <JLTableSheetItem *> *items = [NSMutableArray array];
    for (NSString *name in self.fruits) {
        JLTableSheetItem *item = [JLTableSheetItem actionSheetItemTitle:name userInfo:nil];
        [items addObject:item];
    }
    
    //CustomTitleView
    
    CustomTitleView *titleView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomTitleView class]) owner:self options:nil].firstObject;
    titleView.titleLabel.text = @"Choose Fruits";

    CGRect rect = CGRectMake(0, 0, 0, 42);
    rect.size.width = [titleView systemLayoutSizeFittingSize:CGSizeMake(UILayoutFittingCompressedSize.width, rect.size.height)].width;
    titleView.frame = rect;

    
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:items];
    tableSheetViewController.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    tableSheetViewController.allowsMultipleSelection = YES;
    tableSheetViewController.navigationBar.translucent = NO;
    tableSheetViewController.navigationBar.topItem.titleView = titleView;
    tableSheetViewController.navigationHegiht = 50;
    tableSheetViewController.cellClass = [CustomSheetCell class];
    tableSheetViewController.hidesCompleteButton = YES;
    tableSheetViewController.hidesCancelButton = YES;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"]
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(pressedSaveButton:)];
    item.tintColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00];
    tableSheetViewController.navigationBar.topItem.rightBarButtonItem = item;
    
    //Block
    tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *items) {
        NSLog(@"isCompleteAction : %@",isCompleteAction ? @"YES":@"NO");
        NSLog(@"%@",items);
    };
    
    //
    [tableSheetViewController presentInViewController:self];
}

#pragma mark - getters 

- (NSArray <NSString *> *)fruits {
    if (!_fruits) {
        _fruits = @[
                    
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
    }
    return _fruits;
}
@end
