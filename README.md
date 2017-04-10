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

**Initialize**
```objc
NSArray* fruitNames = @[@"Apple",@"Grape",@"Watermelon",@"Orange",@"Strawberry",@"Pineapple"];
NSMutableArray <JLTableSheetItem *> *items = [NSMutableArray array];
for (NSString *fruitName in fruitNames) {
    JLTableSheetItem *item = [JLTableSheetItem actionSheetItemTitle:fruitName userInfo:nil];
    [items addObject:item];
}

JLTableSheetViewController *tableSheetViewController = [[JLTableSheetViewController alloc] initWithItems:items];
[tableSheetViewController presentInViewController:self];
```

**dismiss view controllers**
```objc
[self.tableSheetViewController dismiss];
```

**Multiple selection sheet**
```objc
tableSheetViewController.allowsMultipleSelection = YES;
```

**Single selection sheet**
```objc
tableSheetViewController.allowsMultipleSelection = NO;
```

**NavigationBar Hidden and custom headerView**
```objc
UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage"]];

tableSheetViewController.navigationBarHidden = YES;
tableSheetViewController.headerView = headerView; 
```

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

