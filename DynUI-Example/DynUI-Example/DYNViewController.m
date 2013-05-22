//
//  DYNViewController.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/10/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNViewController.h"
#import "DynUI.h"
#import "DYNDefines.h"
#import "DYNTooltipViewController.h"
#import "DYNTableViewController.h"
#import "DYNContainerTestViewController.h"
@interface DYNViewController ()

@property (nonatomic, weak) IBOutlet UIButton *exampleButton;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, weak) IBOutlet UILabel *testLabel;
- (IBAction)buttonHit:(id)sender;

@end

@implementation DYNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"DynUI";
	
	self.navigationController.navigationBar.dyn_style = @"NavBar";
	
	// [self.exampleButton setValue:[UIColor greenColor] forStyleParameter:@"ButtonColor"];
	self.exampleButton.dyn_style = @"RedButton";
	
	self.slider.dyn_style = @"Slider";
	
	self.searchBar.dyn_style = @"SearchBar";
	
	self.imageView.image = [UIImage imageNamed:@"star.png" withStyle:@"StarStyle"];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStyleBordered target:self action:@selector(go:)];
	
	self.testLabel.dyn_autoScroll = YES;
	self.testLabel.dyn_scrollDuration = 8;
	self.testLabel.dyn_scrollTextSeparatorWidth = 50;
	
}
- (IBAction)go:(id)sender
{
	DYNTableViewController *table = [[DYNTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:table animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonHit:(id)sender
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        DYNContainerTestViewController *vc = [[DYNContainerTestViewController alloc] initWithNibName:@"DYNContainerTestViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } else {
        DYNTooltipViewController *vc = [[DYNTooltipViewController alloc] initWithNibName:@"DYNTooltipViewController" bundle:nil];
        self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        self.popover.dyn_style = @"Tooltip";
        [self.popover presentPopoverFromRect:[sender frame] inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
@end
