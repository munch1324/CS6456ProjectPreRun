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
  UIView *_someView;
}

@end

@implementation UIDDrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  _someView = [UIView new];
  _someView.translatesAutoresizingMaskIntoConstraints = NO;
  _someView.frame = CGRectMake(0, 0, 50, 50);
  _someView.backgroundColor = [UIColor blueColor];
  [self.view addSubview:_someView];
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
  NSLog(@"Began");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Moved");
  UITouch *touch = [touches anyObject];
  CGRect oldFrame = _someView.frame;
  oldFrame.origin = [touch locationInView:self.view];
  _someView.frame = oldFrame;
//  [self.view setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   NSLog(@"Ended");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

@end
