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

@property (nonatomic, strong) IBOutlet UITableViewCell *sliderCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *buttonCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *iconCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *labelCell;

@property (nonatomic, strong) NSArray *cells;

- (IBAction)buttonHit:(id)sender;

@end

@implementation DYNViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.dyn_style = @"DemoNavBar";

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.cells = @[self.labelCell,
				self.sliderCell,
				self.buttonCell,
				self.iconCell];
	
	self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorForVariable:@"DemoColor"];

	self.navigationItem.title = @"DynUI";
	
	self.navigationController.navigationBar.dyn_style = @"DemoNavBar";
	
	// [self.exampleButton setValue:[UIColor greenColor] forStyleParameter:@"ButtonColor"];
	self.exampleButton.dyn_style = @"RedButton";
	
	self.slider.dyn_style = @"Slider";
	
	self.searchBar.dyn_style = @"SearchBar";

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Grouped Table" style:UIBarButtonItemStyleBordered target:self action:@selector(go:)];
	
	self.testLabel.dyn_textStyle = @"ScrollLabelText";
	self.testLabel.dyn_autoScroll = YES;
	self.testLabel.dyn_scrollDuration = 8;
	self.testLabel.dyn_scrollTextSeparatorWidth = 50;
	self.testLabel.dyn_fadedEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];

	self.customView.dyn_style = @"CustomView";
	
	self.tableView.tableHeaderView = self.searchBar;
		
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  //  return [self.cellTitles[section] count];
    // Return the number of rows in the section.
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.cells[indexPath.row];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.dyn_style = @"IconDemoCell";
   // [tableView dyn_styleGroupedCell:cell forIndexPath:indexPath withStyle:@"GroupedTable"];
}

@end
