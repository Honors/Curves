//
//  CVAddForm.h
//  Curves
//
//  Created by Matt Neary on 12/23/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVCustomKeyboardController.h"

@interface CVAddForm : UIViewController {
    IBOutlet UISegmentedControl *polCart; 
    IBOutlet UIButton *colorButton;
    //Window
    IBOutlet UITextField *xMin;
    IBOutlet UITextField *yMin;
    IBOutlet UITextField *xMax;
    IBOutlet UITextField *yMax;
    //Functions
    IBOutlet UITextField *yFunction;
    IBOutlet UITextField *xFunction;
    IBOutlet UILabel *xLabel;
    IBOutlet UILabel *yLabel;
    
    IBOutlet UIWebView *webColor;
}

- (IBAction)dismissAdd;
- (IBAction)cancelAdd;
- (IBAction)colorPick;

- (IBAction)showPara: (id)sender;
- (IBAction)showPolar: (id)sender;

- (void)displayColor;

@property(nonatomic, assign) UIViewController *delegate;
@property(nonatomic, assign) NSString *color;
@property(retain, nonatomic) UIPopoverController *pc;
@property(strong, atomic) CVCustomKeyboardController *ckc;
@property(strong, atomic) CVCustomKeyboardController *ckc2;
@end
