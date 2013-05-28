//
//  DYNBigIconViewController.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/26/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNBigIconViewController.h"
#import "DynUI.h"
@interface DYNBigIconViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSString *iconKey;

@end

@implementation DYNBigIconViewController

- (id)initWithIconKey:(NSString*)iconKey
{
	self = [super initWithNibName:@"DYNBigIconViewController" bundle:nil];
	if (self) {
		self.iconKey = iconKey;
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = self.iconKey;
	
	self.view.backgroundColor = [UIColor colorForVariable:@"DemoColor"];

	UIImage *iconImage = [UIImage iconImage:self.iconKey constrainedToSize:self.imageView.frame.size withStyle:@"Demo"];
	self.imageView.image = iconImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
