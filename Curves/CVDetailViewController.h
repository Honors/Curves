//
//  CVDetailViewController.h
//  Curves
//
//  Created by Matt Neary on 12/23/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVDetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate> {
    IBOutlet UIScrollView *scroll;
    IBOutlet UILabel *orderPair;
    IBOutlet UILabel *currentF;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIWebView *web;
@property (strong, nonatomic) IBOutlet UISlider *functionEval;
@property (strong, nonatomic) NSString *currentFunction;
@property (strong, nonatomic) NSString *currentxFunction;
@property (strong, nonatomic) NSString *functionInput;
@property (strong, nonatomic) NSString *isPolar;
@property (strong, nonatomic) NSString *window;

- (void)pushFunction: (NSString *)f polar: (NSString *)polar window: (NSString *)window inColor: (NSString *)color andXFunction: (NSString *)xF;
- (void)clearGraph;

- (IBAction)evaluateAtPoint: (id)sender;

@end
