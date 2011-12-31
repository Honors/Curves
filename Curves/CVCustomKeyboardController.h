//
//  CVCustomKeyboardController.h
//  Curves
//
//  Created by Matt Neary on 12/30/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVCustomKeyboardController : UIViewController

@property (atomic, strong) UITextField *textfield;

- (IBAction)keyboardDown;
- (IBAction)keyPress:(id)sender;
- (IBAction)backspace;
- (IBAction)space;

@end
