//
//  UIDDrawingViewController.m
//  UserInterfaceDesignRunning
//
//  Created by Michael Grande on 11/1/14.
//  Copyright (c) 2014 MLConsulting. All rights reserved.
//

#import "UIDDrawingViewController.h"

@interface UIDDrawingViewController () {
  __weak UITouch *_trackedTouch;
  NSMutableArray *_touchedAreas;
}

@end

@implementation UIDDrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Handlers

#pragma mark - Drawing Methods

#pragma mark - UIResponder Touch Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

@end
