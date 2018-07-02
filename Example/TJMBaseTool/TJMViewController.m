//
//  TJMViewController.m
//  TJMBaseTool
//
//  Created by JiamingTu on 06/20/2018.
//  Copyright (c) 2018 JiamingTu. All rights reserved.
//

#import "TJMViewController.h"
#import <TJMBaseTool.h>
@interface TJMViewController ()

@end

@implementation TJMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [TJMHUDHandle showRequestHUDAtView:self.view message:@"哈哈哈"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
