//
//  JLTableSheetViewController.m
//  JLTableSheetDemo
//
//  Created by  Studio on 2017. 4. 2..
//  Copyright © 2017년 Jangsy. All rights reserved.
//

#import "JLTableSheetViewController.h"
#import <STPopup/STPopup.h>

@interface JLTableSheetViewController ()<UITableViewDataSource,UITableViewDelegate,STPopupControllerTransitioning,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerContainerView;
@property (nonatomic, strong) UINavigationBar *navigationBar;

@property (nonatomic, assign) CGFloat minSheetHeight;
@property (nonatomic, assign) CGFloat maxSheetHeight;
@property (nonatomic, assign) BOOL isDismiss;

@property (nonatomic, assign) CGFloat preferredNavigationBarHeight;

@property (nonatomic, readonly) CGSize contentSize;
@end

@implementation JLTableSheetViewController

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        CGSize size = [UIScreen mainScreen].bounds.size;

        self.contentSizeInPopup = CGSizeMake(MIN(size.width, size.height),
                                             MAX(size.width, size.height));
        self.landscapeContentSizeInPopup = CGSizeMake(MAX(size.width, size.height),
                                                      MIN(size.width, size.height));
        _isDismiss = NO;
        _rowHegiht = 50;
        _allowsMultipleSelection = NO;
        _hidesCompleteButton = NO;
        _hidesCancelButton = NO;
        _minVisibleRow = 4.5;
        _navigationBarHidden = NO;
        _maxVisibleRow = 0;
    }
    return self;
}

- (instancetype)initWithItems:(NSArray <JLTableSheetItem *> *)items {
    self = [self init];
    if (self) {
        self.items = items;
    }
    return self;
}

#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    UINavigationController *navigationController = [UINavigationController new];
    _preferredNavigationBarHeight = CGRectGetHeight(navigationController.navigationBar.bounds);
    [self updateConfigValues];
    
    self.popupController.transitioning = self;
    self.popupController.containerView.backgroundColor = [UIColor clearColor];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    self.view.backgroundColor = [UIColor clearColor];
    
    //
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = UIColor.whiteColor;
    self.containerView = [[UIView alloc] init];
    self.containerView.maskView = self.maskView;
    [self.view addSubview:self.containerView];
    
    //tableView
    if (self.cellClass) {
        if ([self.cellClass respondsToSelector:@selector(nibForSheetCell)]) {
            [self.tableView registerNib:[self.cellClass performSelector:@selector(nibForSheetCell)] forCellReuseIdentifier:@"Cell"];
        }
        else{
            [self.tableView registerClass:self.cellClass forCellReuseIdentifier:@"Cell"];
        }
    }
    else{
        [self.tableView registerClass:[JLTableSheetCell class] forCellReuseIdentifier:@"Cell"];
    }

    self.tableView.rowHeight = _rowHegiht;
    [self.containerView addSubview:self.tableView];
    
    //headerContentView
    self.headerContainerView = [[UIView alloc] init];
    self.headerContainerView.clipsToBounds = YES;
    self.headerContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headerContainerView];
    
    //headerView
    if (self.headerView) {
        [self.headerContainerView addSubview:self.headerView];
    }
    
    //navigationBar
    [self.headerContainerView addSubview:self.navigationBar];
    
    [self reloadBarButtonItems];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self layoutContainerView];
    [self layoutHeaderContainerView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self layoutContainerView];
    [self layoutHeaderContainerView];
}

#pragma mark - layout

- (void)layoutContainerView {
    UIEdgeInsets contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.view.bounds)-_minSheetHeight, 0, 0, 0);
    if (!UIEdgeInsetsEqualToEdgeInsets(contentInset, self.tableView.contentInset)) {
        self.tableView.contentInset = contentInset;
        [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:NO];
    }
    
    CGFloat width = MIN(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.containerView.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-width)/2,
                                          0,
                                          width,
                                          CGRectGetHeight(self.view.bounds));
    self.tableView.frame = self.containerView.bounds;
}

- (void)layoutHeaderContainerView {
    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat navigationBarHeight = _navigationBarHidden ? 0 : _preferredNavigationBarHeight;
    CGFloat headerContentHeight = (navigationBarHeight+statusBarHeight)+CGRectGetHeight(self.headerView.frame);
    
    CGFloat y = MAX(0, -(self.tableView.contentOffset.y + headerContentHeight));
    if (_maxSheetHeight > 0) {
        y = MAX(y, CGRectGetHeight(self.view.bounds) - (_maxSheetHeight + headerContentHeight));
    }
    CGFloat navigationBarY = _navigationBarHidden ? statusBarHeight : MAX(0, MIN(statusBarHeight, y));

    self.headerContainerView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame),
                                                y,
                                                CGRectGetWidth(self.containerView.bounds),
                                                headerContentHeight);
    
    self.navigationBar.frame = CGRectMake(0,
                                          navigationBarY,
                                          CGRectGetWidth(self.headerContainerView.bounds),
                                          navigationBarHeight+(statusBarHeight-navigationBarY));
    
    if (self.headerView) {
        self.headerView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.navigationBar.frame),
                                           CGRectGetWidth(self.headerContainerView.bounds),
                                           CGRectGetHeight(self.headerView.frame));
    }

    self.maskView.frame = CGRectMake(0,
                                     CGRectGetMinY(self.headerContainerView.frame)+navigationBarY,
                                     CGRectGetWidth(self.containerView.bounds),
                                     CGRectGetHeight(self.containerView.bounds));
    
    self.backgroundView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame),
                                           CGRectGetMinY(self.headerContainerView.frame)+statusBarHeight,
                                           CGRectGetWidth(self.containerView.bounds),
                                           CGRectGetHeight(self.containerView.bounds)-CGRectGetMinY(self.navigationBar.frame));
}

#pragma mark -

- (void)presentInViewController:(UIViewController*)viewController {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self];
    popupController.navigationBarHidden = YES;
    popupController.style = STPopupStyleBottomSheet;
    popupController.transitionStyle = STPopupTransitionStyleCustom;
    [popupController presentInViewController:viewController];
}

#pragma mark - dismiss

- (void)dismiss {
    [self dismissIsComplete:NO completion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [self dismissIsComplete:NO completion:completion];
}

- (void)dismissIsComplete:(BOOL)isComplete completion:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.willCompletion) {
            self.willCompletion(isComplete,self.selectedItems);
        }

        [self.popupController dismissWithCompletion:^{
            if (completion) {
                completion();
            }
            if (self.completion) {
                self.completion(isComplete, self.selectedItems);
                self.completion = nil;
            }
            
            self.changedSelectedItems = nil;
        }];
    });
}

#pragma mark - reload

- (void)reloadBarButtonItems {
    if (!_hidesCompleteButton && _allowsMultipleSelection) {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(pressedCompleteButton:)];
        barButtonItem.enabled = (self.selectedItems.count > 0);
        self.navigationBar.topItem.rightBarButtonItem = barButtonItem;
    }
    
    if (!_hidesCancelButton) {
        self.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(pressedCancelButton:)];
    }
}

#pragma mark - update

- (void)updateConfigValues {
    _maxSheetHeight = _rowHegiht*_maxVisibleRow;;
    _minSheetHeight = MIN(_rowHegiht*_minVisibleRow, _rowHegiht * self.items.count);
}

#pragma mark - EVNET

- (IBAction)backgroundViewDidTap:(id)sender {
    [self dismiss];
}

- (IBAction)pressedCancelButton:(id)sender {
    [self dismissIsComplete:NO completion:nil];
}

- (IBAction)pressedCompleteButton:(id)sender {
    [self dismissIsComplete:YES completion:nil];
}

#pragma mark - UIContentContainer

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    UINavigationController *navigationController = [UINavigationController new];
    _preferredNavigationBarHeight = CGRectGetHeight(navigationController.navigationBar.bounds);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
    JLTableSheetItem *item = [self itemAtIndex:indexPath.row];
    
    if ([cell respondsToSelector:@selector(renderingSheetCellWithItem:)]) {
        [cell performSelector:@selector(renderingSheetCellWithItem:) withObject:item];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JLTableSheetItem *item = [self itemAtIndex:indexPath.row];
    if (item && item.enabled) {
        item.selected = !item.selected;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(renderingSheetCellWithItem:)]) {
            [cell performSelector:@selector(renderingSheetCellWithItem:) withObject:item];
        }
        
        if (_allowsMultipleSelection == YES) {
            if (self.changedSelectedItems) {
                self.changedSelectedItems(self.selectedItems);
            }            
            [self reloadBarButtonItems];
        }
        else {
            [self pressedCompleteButton:nil];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutHeaderContainerView];
    
    CGFloat offset = scrollView.contentInset.top + scrollView.contentOffset.y;
    CGFloat height = (CGRectGetHeight(self.headerContainerView.frame)+_minSheetHeight)*0.2;

    if (offset < -height && !_isDismiss) {
        _isDismiss = YES;
        [self pressedCancelButton:nil];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    
    if ((point.x >= 0 && point.x <= CGRectGetWidth(self.tableView.bounds)) &&
        (point.y >= -CGRectGetHeight(self.headerContainerView.frame))) {
        return NO;
    }
    
    return YES;
}

#pragma mark - STPopupControllerTransitioning

- (NSTimeInterval)popupControllerTransitionDuration:(STPopupControllerTransitioningContext *)context {
    return context.action == STPopupControllerTransitioningActionPresent ? 0.35 : 0.5;
}

- (void)popupControllerAnimateTransition:(STPopupControllerTransitioningContext *)context completion:(void (^)())completion {
    UIView *containerView = context.containerView;
    if (context.action == STPopupControllerTransitioningActionPresent) {
        containerView.transform = CGAffineTransformMakeTranslation(0, containerView.superview.bounds.size.height - containerView.frame.origin.y);
        
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            context.containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            completion();
        }];
    }
    else {
        CGAffineTransform lastTransform = containerView.transform;
        containerView.transform = CGAffineTransformIdentity;
        CGFloat originY = containerView.frame.origin.y;
        containerView.transform = lastTransform;
        
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            containerView.transform = CGAffineTransformMakeTranslation(0, containerView.superview.bounds.size.height - originY + containerView.frame.size.height);
        } completion:^(BOOL finished) {
            containerView.transform = CGAffineTransformIdentity;
            completion();
        }];
    }
}

#pragma mark - item

- (JLTableSheetItem *)itemAtIndex:(NSInteger)index {
    if (self.items.count > index) {
        return [self.items objectAtIndex:index];
    }
    return nil;
}

#pragma mark - setters

- (void)setHidesCompleteButton:(BOOL)hidesCompleteButton {
    if (_hidesCompleteButton != hidesCompleteButton) {
        _hidesCompleteButton = hidesCompleteButton;
        
        if ([self isViewLoaded]) {
            [self reloadBarButtonItems];
        }
    }
}

- (void)setHidesCancelButton:(BOOL)hidesCancelButton {
    if (_hidesCancelButton != hidesCancelButton) {
        _hidesCancelButton = hidesCancelButton;
        
        if ([self isViewLoaded]) {
            [self reloadBarButtonItems];
        }
    }
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    if(_allowsMultipleSelection != allowsMultipleSelection) {
        _allowsMultipleSelection = allowsMultipleSelection;
    }
}

- (void)setRowHegiht:(CGFloat)rowHegiht {
    if (_rowHegiht != rowHegiht) {
        _rowHegiht = rowHegiht;
        
        _maxSheetHeight = _rowHegiht*_maxVisibleRow;;
        _minSheetHeight = MIN(_rowHegiht*_minVisibleRow, _rowHegiht * self.items.count);
        
        if ([self isViewLoaded]) {
            [self layoutHeaderContainerView];
        }
    }
}

- (void)setMaxVisibleRow:(CGFloat)maxVisibleRow {
    if (_maxVisibleRow != maxVisibleRow) {
        _maxVisibleRow = maxVisibleRow;
        
        [self updateConfigValues];
        
        if ([self isViewLoaded]) {
            [self layoutHeaderContainerView];
        }
    }
}

- (void)setMinVisibleRow:(CGFloat)minVisibleRow {
    if (_minVisibleRow != minVisibleRow) {
        _minVisibleRow = minVisibleRow;
        
        [self updateConfigValues];
        
        if ([self isViewLoaded]) {
            [self layoutHeaderContainerView];
        }
    }
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    if (_navigationBarHidden != navigationBarHidden) {
        _navigationBarHidden = navigationBarHidden;
        
        self.navigationBar.hidden = _navigationBarHidden;
        if ([self isViewLoaded]) {
            [self layoutHeaderContainerView];
        }
    }
}

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle {
    self.tableView.separatorStyle = separatorStyle;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    self.tableView.separatorColor = separatorColor;
}

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
    self.tableView.separatorInset = separatorInset;
}

#pragma mark - getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.allowsMultipleSelection = _allowsMultipleSelection;
    }
    return _tableView;
}

- (UINavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] init];
        UINavigationItem *item = [[UINavigationItem alloc] init];
        _navigationBar.items = @[item];
    }
    return _navigationBar;
}

- (UITableViewCellSeparatorStyle)separatorStyle {
    return self.tableView.separatorStyle;
}

- (UIColor *)separatorColor {
    return self.tableView.separatorColor;
}

- (UIEdgeInsets)separatorInset {
    return self.tableView.separatorInset;
}

- (NSArray <JLTableSheetItem *> *)selectedItems {
    NSMutableArray *selectedItems = [NSMutableArray array];
    
    for (JLTableSheetItem *item in self.items) {
        if (item.selected) {
            [selectedItems addObject:item];
        }
    }
    return [NSArray arrayWithArray:selectedItems];
}

@end

@implementation UIViewController (JLTableSheetViewController)

- (nullable JLTableSheetViewController *)tableSheetViewController {
    for (JLTableSheetViewController *viewController in self.presentedViewController.childViewControllers) {
        if ([viewController isKindOfClass:[JLTableSheetViewController class]]) {
            return (JLTableSheetViewController*)viewController;
        }
    }
    return nil;
}

@end
