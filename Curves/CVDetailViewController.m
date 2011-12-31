//
//  CVDetailViewController.m
//  Curves
//
//  Created by Matt Neary on 12/23/11.
//  Copyright (c) 2011 OmniVerse. All rights reserved.
//

#import "CVDetailViewController.h"
#import "CVMasterViewController.h"

@interface CVDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation CVDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize web;
@synthesize currentFunction;
@synthesize functionEval;
@synthesize functionInput;
@synthesize currentxFunction;
@synthesize isPolar;
@synthesize window;

- (void)pushFunction: (NSString *)f polar: (NSString *)polar window: (NSString *)window inColor: (NSString *)color andXFunction: (NSString *)xF {
    NSLog(@"Graphing %@", f);
    NSLog(@"Window: %@", window);
    [self.web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ƒ('%@', '%@', '%@'=='Polar').graph([%@], false, '%@')", f, xF, polar, window, color]];
}

- (void)clearGraph {
    [self.web stringByEvaluatingJavaScriptFromString:@"c = document.getElementsByTagName('canvas')[0]; c.width=c.width;"];
}

- (IBAction)evaluateAtPoint:(id)sender {
    UISlider *slide = (UISlider *)sender;
    if( [currentxFunction isEqualToString:@""] )
        [currentF setText:[NSString stringWithFormat:@"  ƒ = %@", currentFunction]];
    else
        [currentF setText:[NSString stringWithFormat:@"  ƒ = [%@, %@]", currentxFunction, currentFunction]];
    float slideFraction;
    NSString *xF = currentxFunction;
    if( [currentxFunction isEqualToString:@""] ) {
        slideFraction = [slide value]-.5;
        xF = @"x";
    }
    else
        slideFraction = [slide value]; //Account for parametric (no negatives)        
    
    
    //Account for polars
    NSString *functionToEval = [NSString stringWithFormat:@"var a = ƒ('%@','%@','%@'=='Polar')(%@ * %f); a[0]+'|'+a[1]", currentFunction, currentxFunction, self.isPolar, functionInput, slideFraction];
    NSLog(@"Function to Eval: %@", functionToEval);
    NSString *functionEvaluation = [web stringByEvaluatingJavaScriptFromString:functionToEval];
    NSArray *coords = [functionEvaluation componentsSeparatedByString:@"|"];
    NSString *yValue = [coords objectAtIndex:0];
    NSString *xValue = [coords objectAtIndex:1];
    //NSString *xfunctionEvaluation = [NSString stringWithFormat:@"ƒ('%@','x','%@'=='Polar').y(%@ * %f)", xF, self.isPolar, functionInput, slideFraction];
    NSString *stringToParse = [NSString stringWithFormat:@"'(%@,%@)'", [yValue substringToIndex:[yValue length]<5?[yValue length]:5], [xValue substringToIndex:[xValue length]<5?[xValue length]:5]];
    
    //Clear other functions
    //TODO: draw every function
    [self clearGraph];
    
    //Output function
    [self pushFunction:currentFunction 
                 polar:self.isPolar
                window:self.window 
               inColor:@"#f00" 
          andXFunction:currentxFunction];
    
    //Output circle at point

    [self pushFunction:[NSString stringWithFormat:@"%@ + .2 * sin(x)", xValue] 
                 polar:@"Cartesian" 
                window:self.window 
               inColor:@"#000" 
          andXFunction:[NSString stringWithFormat:@"%@ + .2 * cos(x)", yValue]];
    
    NSLog(@"String To Parse: %@", stringToParse);
    [orderPair setText:[web stringByEvaluatingJavaScriptFromString:stringToParse]];    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    
    // Update the user interface for the detail item.
    [web setDelegate:self];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [web loadRequest:request];
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[self pushFunction:@"5 * sin(4 * x)"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Graph", @"Detail");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Functions", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
