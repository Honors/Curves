//
//  CVColorForm.m
//  Curves
//
//  Created by Matt Neary on 12/24/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import "CVColorForm.h"
#import "CVAddForm.h"

@implementation CVColorForm
@synthesize delegate;

- (void)viewDidLoad {
    arrayColors = [[NSMutableArray alloc] init];
    [arrayColors addObject:@"Red"];
    [arrayColors addObject:@"Orange"];
    [arrayColors addObject:@"Yellow"];
    [arrayColors addObject:@"Green"];
    [arrayColors addObject:@"Blue"];
    [arrayColors addObject:@"Indigo"];
    [arrayColors addObject:@"Violet"];
}
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"The COLOR is: %@", hexColor);
    ((CVAddForm *)delegate).color = hexColor?hexColor:@"#ff0000";
    [((CVAddForm *)delegate) displayColor];
}
- (NSString *)hexForColor: (int)name {
    switch (name) {
        case 0: return @"#ff0000";
        case 1: return @"#ff7700"; //Orange
        case 2: return @"#ffff00"; //Yellow
        case 3: return @"#00ff00";
        case 4: return @"#0000ff";
        case 5: return @"#7700ff"; //Indigo
        case 6: return @"#ff00ff"; //Violet
        default: return @"#e3e3e3";
    }
}
//Datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {    
    return [arrayColors count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arrayColors objectAtIndex:row];
}
//Delegate
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
    hexColor = [self hexForColor:row];
}

@end



















