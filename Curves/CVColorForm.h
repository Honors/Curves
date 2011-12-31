//
//  CVColorForm.h
//  Curves
//
//  Created by Matt Neary on 12/24/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVColorForm : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UIPickerView *picky;
    NSMutableArray *arrayColors;
    NSString *hexColor;
}

@property(nonatomic, assign) UIViewController *delegate;

@end
