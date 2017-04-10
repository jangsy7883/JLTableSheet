# JLTableSheet
[![Version](https://img.shields.io/cocoapods/v/JLTableSheet.svg?style=flat)](http://cocoadocs.org/docsets/JLTableSheet)
[![License](https://img.shields.io/cocoapods/l/JLTableSheet.svg?style=flat)](http://cocoadocs.org/docsets/JLTableSheet)
[![Platform](https://img.shields.io/cocoapods/p/JLTableSheet.svg?style=flat)](http://cocoadocs.org/docsets/JLTableSheet)

## Get Started
**CocoaPods**
```ruby
platform :ios, '8.0'
pod 'JLTableSheet'
```

**Import header file**
```objc
#import <JLTableSheet/JLTableSheetViewController.h>
```

**Initialize STPopupController**
```objc
NSArray* fruitNames = @[@"Apple",@"Grape",@"Watermelon",@"Orange",@"Strawberry",@"Pineapple"];
NSMutableArray <JLTableSheetItem *> *items = [NSMutableArray array];
for (NSString *fruitName in fruitNames) {
JLTableSheetItem *item = [JLTableSheetItem actionSheetItemTitle:fruitName userInfo:nil];
[items addObject:item];
}

JLTableSheetViewController *sheetViewController = [[JLTableSheetViewController alloc] initWithItems:items];
[sheetViewController presentInViewController:self];
```


