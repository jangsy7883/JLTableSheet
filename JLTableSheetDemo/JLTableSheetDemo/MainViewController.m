//
//  MainViewController.m
//  JLTableSheetDemo
//
//  Created by Woody on 2017. 4. 12..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import "MainViewController.h"
#import "JLTableSheetViewController.h"

#import "CustomSheetCell.h"
#import "CustomTitleView.h"
#import "CustomHeaderView.h"

@interface MainViewController ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, readonly) NSArray<JLTableSheetItem *> *sheetItems;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"JLTableSheet demo";
}

#pragma mark - demo

/*
 * Multiple Selection Sheet
 */
- (IBAction)pressedMultipleSelectionSheetButton:(id)sender{
    
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:self.sheetItems];
    tableSheetViewController.navigationBar.topItem.title = @"Choose Fruits";
    tableSheetViewController.maxVisibleRow = 4.5;
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
    
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:self.sheetItems];
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
    
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:self.sheetItems];
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
    tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *selectedItems) {
        NSLog(@"completion");
        NSLog(@"%@",selectedItems);
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
    JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:self.sheetItems];
    tableSheetViewController.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    tableSheetViewController.allowsMultipleSelection = YES;
    tableSheetViewController.navigationBarHidden = YES;
    tableSheetViewController.headerView = headerView;
    tableSheetViewController.cellClass = [CustomSheetCell class];
    
    //Block
    tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *selectedItems) {
        NSLog(@"%@",selectedItems);
    };
    
    //
    [tableSheetViewController presentInViewController:self];
}

#pragma mark - event

- (IBAction)pressedSaveButton:(id)sender {
    [self.tableSheetViewController dismissWithCompletion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"title"];
    
    return cell;
}

#pragma mark - UITableViewDelegatge

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    SEL selecter = NSSelectorFromString(item[@"selector"]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:selecter]) {
        [self performSelector:selecter withObject:nil];
    }
#pragma clang diagnostic pop    
}

#pragma mark - setters 

- (NSArray *)items {
    if (!_items) {
        _items = @[
                   @{
                       @"title":@"Multiple Selection Sheet",
                       @"selector":NSStringFromSelector(@selector(pressedMultipleSelectionSheetButton:)),
                       },
                   @{
                       @"title":@"Single Selection Sheet",
                       @"selector":NSStringFromSelector(@selector(pressedSingleSelectionSheetButton:)),
                       },
                   @{
                       @"title":@"Custom NavigationBarItem Sheet",
                       @"selector":NSStringFromSelector(@selector(pressedCustomNavigationBarItemSheetButton:)),
                       },
                   @{
                       @"title":@"Custom headerView Sheet",
                       @"selector":NSStringFromSelector(@selector(pressedCustomHeaderSheetButton:)),
                       },
                   ];
    }
    return _items;
}

#pragma mark - getters

- (NSArray <JLTableSheetItem *> *)sheetItems {
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
        JLTableSheetItem *item = [JLTableSheetItem sheetItemTitle:fruitName userInfo:nil];
        [items addObject:item];
    }
    
    return [NSArray arrayWithArray:items];
}

@end
