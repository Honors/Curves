//
//  CVAddForm.m
//  Curves
//
//  Created by Matt Neary on 12/23/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import "CVAddForm.h"
#import "CVMasterViewController.h"
#import "CVColorForm.h"
#import "CVCustomKeyboardController.h"

@implementation CVAddForm

@synthesize delegate;
@synthesize pc;
@synthesize color;
@synthesize ckc;
@synthesize ckc2;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (void)displayColor {
    [webColor loadHTMLString:[NSString stringWithFormat:@"<body style='background: %@;'></body>", color] baseURL:[NSURL URLWithString:@"/"]];
}
- (IBAction)dismissAdd {
    NSLog(@"Exit code TRUE with Color: %@", self.color); 
    BOOL cartes = [polCart selectedSegmentIndex]==0;
    NSString *yF = [[yFunction text] stringByReplacingOccurrencesOfString:@"θ" withString:@"x"];
    NSDictionary *outDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                             cartes?@"Cartesian":@"Polar", @"Polar", 
                             yF, @"Function", 
                             self.color?self.color:@"#ff0000", @"Color", 
                             [NSArray arrayWithObjects:[xMin text], [xMax text], [yMin text], [yMax text], nil], @"Window", 
                             @"Yes", @"On",
                             [xFunction text]?[xFunction text]:@"x", @"xFunction", nil];
    [(CVMasterViewController *)delegate dismissContinue:outDict];
}
- (IBAction)cancelAdd {
    NSLog(@"Exit code FALSE");
    [(CVMasterViewController *)delegate dismissStop];
}
- (IBAction)colorPick {
    CVColorForm *cvcf = [[CVColorForm alloc] initWithNibName:@"CVColorForm" bundle:nil];
    cvcf.delegate = self;
    UIPopoverController *pcl = [[UIPopoverController alloc] initWithContentViewController:cvcf];
    [pcl setPopoverContentSize:CGSizeMake(383, 216)];
    
    self.pc = pcl;  //Retain it
    [self.pc presentPopoverFromRect:[colorButton frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)showPara: (id)sender {
    [xFunction setHidden:![(UISwitch *)sender isOn]];
    [xLabel setHidden:![(UISwitch *)sender isOn]];    
}
- (IBAction)showPolar:(id)sender {
    BOOL isOn = [(UISegmentedControl *)sender selectedSegmentIndex]==0;
    [yLabel setText:isOn?@"y = ":@"r = "];
    [xLabel setText:isOn?@"x = ":@"θ = "];
}
- (void)viewDidLoad {
    ckc = [[CVCustomKeyboardController alloc] initWithNibName:@"CVCustomKeyboard" bundle:nil];
    ckc.textfield = yFunction;
    [yFunction setInputView:ckc.view];
    
    ckc2 = [[CVCustomKeyboardController alloc] initWithNibName:@"CVCustomKeyboard" bundle:nil];
    ckc2.textfield = xFunction;
    [xFunction setInputView:ckc2.view];
}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
@end
