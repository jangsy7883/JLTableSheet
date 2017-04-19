# JLTableSheet
[![Version](https://img.shields.io/cocoapods/v/JLTableSheet.svg?style=flat)](http://cocoadocs.org/docsets/JLTableSheet)
[![License](https://img.shields.io/cocoapods/l/JLTableSheet.svg?style=flat)](http://cocoadocs.org/docsets/JLTableSheet)
[![Platform](https://img.shields.io/cocoapods/p/JLTableSheet.svg?style=flat)](http://cocoadocs.org/docsets/JLTableSheet)
[![Support](https://img.shields.io/badge/support-iOS%208+-blue.svg?style=flat)](https://www.apple.com/nl/ios/)

## Install
**CocoaPods**
```ruby
platform :ios, '8.0'
pod 'JLTableSheet'
```

## Usage
**Import header file**
```objc
#import <JLTableSheet/JLTableSheetViewController.h>
```

**Initialize**
```objc
NSArray* fruitNames = @[@"Apple",@"Grape",@"Watermelon",@"Orange",@"Strawberry",@"Pineapple"];
NSMutableArray <JLTableSheetItem *> *items = [NSMutableArray array];
for (NSString *fruitName in fruitNames) {
    JLTableSheetItem *item = [JLTableSheetItem actionSheetItemTitle:fruitName userInfo:nil];
    [items addObject:item];
}

JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:items];
tableSheetViewController.navigationBar.topItem.title = @"Choose Fruits";
[tableSheetViewController presentInViewController:self];
```

**block handler**
```objc
tableSheetViewController.changedSelectedItems = ^(NSArray<JLTableSheetItem *> *items) {
    NSLog(@"changed selected items");
};
tableSheetViewController.completion = ^(BOOL isCompleteAction, NSArray<JLTableSheetItem *> *items) {
    NSLog(@"completion");
    NSLog(@"%@",items);
};
```

**dismiss view controller**
```objc
[self.tableSheetViewController dismiss];
```

**allows multiple selection**
```objc
@property (nonatomic, assign, getter=isAllowsMultipleSelection) BOOL allowsMultipleSelection;
```

**custom navigation item**
```objc
UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(pressedSaveButton:)];
item.enabled = NO;

tableSheetViewController.hidesCompleteButton = YES;
tableSheetViewController.hidesCancelButton = YES;
tableSheetViewController.navigationBar.topItem.rightBarButtonItem = item;

//Block
__block __weak typeof(JLTableSheetViewController) *weakTableSheetViewController = tableSheetViewController;
tableSheetViewController.changedSelectedItems = ^(NSArray<JLTableSheetItem *> *items) {
    weakTableSheetViewController.navigationBar.topItem.rightBarButtonItem.enabled = items.count > 0;
};
```

**navigationBar Hidden and custom headerView**
```objc
UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage"]];

tableSheetViewController.navigationBarHidden = YES;
tableSheetViewController.headerView = headerView; 
```

## Inspiration

1.[STPopup](https://github.com/kevin0571/STPopup)

## Licence
The MIT License (MIT)

Copyright (c) 2016 jangsy7883

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

