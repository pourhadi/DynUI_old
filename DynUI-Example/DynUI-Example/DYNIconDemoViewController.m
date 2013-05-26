//
//  DYNIconDemoViewController.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/26/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNIconDemoViewController.h"
#import "SVProgressHUD.h"
#import "DynUI.h"
#import "DYNBigIconViewController.h"
@interface DYNIconDemoViewController ()

@property (nonatomic, strong) NSArray *images;
@property (nonatomic) BOOL loading;
@end

@implementation DYNIconDemoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)dismiss:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"Icons";
	
	self.view.backgroundColor = [UIColor colorForVariable:@"IconDemoColor"];
	self.navigationController.navigationBar.dyn_style = @"DemoNavBar";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];

	self.loading = YES;
	[SVProgressHUD show];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		dispatch_async(dispatch_get_main_queue(), ^{


		});
		
		NSMutableArray *tmp = [NSMutableArray new];
		
		for (NSString *key in [DYNIcons availableIconKeys]) {
			
			UIImage *image = [UIImage iconImage:key constrainedToSize:CGSizeMake(40, 40) withStyle:@"Demo"];
			[tmp addObject:image];
		}
		self.images = tmp;
		self.loading = NO;
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[SVProgressHUD dismiss];
			[self.tableView reloadData];
			
		});
		
	});
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (self.loading) return 0;
	
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	NSString *key = [DYNIcons availableIconKeys][indexPath.row];
	UIImage *image = self.images[indexPath.row];
    
	cell.textLabel.text = key;
	cell.imageView.image = image;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.imageView.contentMode = UIViewContentModeCenter;
	cell.dyn_style = @"IconDemoCell";

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DYNBigIconViewController *vc = [[DYNBigIconViewController alloc] initWithIconKey:[DYNIcons availableIconKeys][indexPath.row]];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
