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
#import "DYNIconDemoViewController.h"
#import "DYNCustomView.h"
@interface DYNViewController ()

@property (nonatomic, weak) IBOutlet UIButton *exampleButton;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, weak) IBOutlet UILabel *testLabel;

@property (nonatomic, weak) IBOutlet DYNCustomView *customView;

- (IBAction)buttonHit:(id)sender;

@end

@implementation DYNViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.dyn_style = @"NavBar";

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"DynUI";
	
	self.navigationController.navigationBar.dyn_style = @"NavBar";
	
	// [self.exampleButton setValue:[UIColor greenColor] forStyleParameter:@"ButtonColor"];
	self.exampleButton.dyn_style = @"RedButton";
	
	self.slider.dyn_style = @"Slider";
	
	self.searchBar.dyn_style = @"SearchBar";
	
	self.imageView.image = [UIImage iconImage:kDYNIconStarKey constrainedToSize:self.imageView.frame.size withStyle:@"StarStyle"];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Grouped Table" style:UIBarButtonItemStyleBordered target:self action:@selector(go:)];
	
	self.testLabel.dyn_autoScroll = YES;
	self.testLabel.dyn_scrollDuration = 8;
	self.testLabel.dyn_scrollTextSeparatorWidth = 50;
	
	self.customView.dyn_style = @"CustomView";
		
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

- (IBAction)showIconsHit:(id)sender
{
	DYNIconDemoViewController *vc = [[DYNIconDemoViewController alloc] initWithNibName:@"DYNIconDemoViewController" bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	
	[self presentViewController:nav animated:YES completion:nil];
}
@end
