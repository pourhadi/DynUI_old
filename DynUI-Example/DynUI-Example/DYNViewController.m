//
//  DYNViewController.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/10/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNViewController.h"
#import "DPUI.h"
#import "DPUIConstants.h"
@interface DYNViewController ()

@property (nonatomic, weak) IBOutlet UIButton *exampleButton;

@end

@implementation DYNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.navigationController.navigationBar.dpui_style = @"NavBar";
	
    [self.exampleButton setValue:[UIColor greenColor] forStyleParameter:@"ButtonColor"];
	self.exampleButton.dpui_style = @"RedButton";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStyleBordered target:self action:@selector(go:)];
}

- (IBAction)go:(id)sender
{
	DYNViewController *controller = [[DYNViewController alloc] initWithNibName:@"DYNViewController_iPhone" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
