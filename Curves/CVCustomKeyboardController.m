//
//  CVCustomKeyboardController.m
//  Curves
//
//  Created by Matt Neary on 12/30/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import "CVCustomKeyboardController.h"

@implementation CVCustomKeyboardController

@synthesize textfield;

- (IBAction)keyboardDown {
    [self.textfield becomeFirstResponder];
    [self.textfield resignFirstResponder];
}
- (IBAction)keyPress:(id)sender {
    NSLog(@"%@",[[(UIButton *)sender titleLabel] text]);
    [self.textfield setText:[[self.textfield text] stringByAppendingString:[[(UIButton *)sender titleLabel] text]]];
}
- (IBAction)backspace {
    [self.textfield setText:[[self.textfield text] substringToIndex:[[self.textfield text] length]>1?[[self.textfield text] length]-1:0]];
}
- (IBAction)space {
     [self.textfield setText:[[self.textfield text] stringByAppendingString:@" "]];
}

@end
