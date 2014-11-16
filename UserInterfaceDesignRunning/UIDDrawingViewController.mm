//
//  UIDDrawingViewController.m
//  UserInterfaceDesignRunning
//
//  Created by Michael Grande on 11/1/14.
//  Copyright (c) 2014 MLConsulting. All rights reserved.
//

#import "UIDDrawingViewController.h"

#import "UIDOpenCVUtilities.h"

@interface UIDDrawingViewController () {
  __weak UITouch *_trackedTouch;
  NSMutableArray *_touchedAreas;
  CGPoint lastPoint;
}

@property (nonatomic)BOOL isDrawing;
@property (nonatomic)BOOL isForeground;

@end

@implementation UIDDrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor greenColor];
  self.isDrawing = YES;
  self.isForeground = YES;
  self.backgroundImageView.image = self.baseImage;
  self.mainImage.image = [UIImage imageNamed:@"grayBaseMask.png"];
  self.mainImage.alpha = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  NSLog(@"Background %@", NSStringFromCGRect(self.backgroundImageView.frame));
  NSLog(@"Main %@", NSStringFromCGRect(self.mainImage.frame));
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
  UITouch *touch = [touches anyObject];
  lastPoint = [touch locationInView:self.drawingCanvasImageView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currentPoint = [touch locationInView:self.drawingCanvasImageView];
  
  UIGraphicsBeginImageContext(self.drawingCanvasImageView.frame.size);
  [self.drawingCanvasImageView.image drawInRect:CGRectMake(0, 0, self.drawingCanvasImageView.frame.size.width, self.drawingCanvasImageView.frame.size.height)];
  CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
  CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
  CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
  CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0f);
  CGFloat color = self.isForeground ? 1.0 : 0.0;
  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),
                             color,
                             color,
                             color,
                             1.0);
  CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
  
  CGContextStrokePath(UIGraphicsGetCurrentContext());
  self.drawingCanvasImageView.image = UIGraphicsGetImageFromCurrentImageContext();
  [self.drawingCanvasImageView setAlpha:0.5];
  UIGraphicsEndImageContext();
  
  lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
  UIGraphicsBeginImageContext(self.mainImage.frame.size);
  CGRect targetFrame = self.mainImage.frame;
  targetFrame.origin = CGPointZero;
  [self.mainImage.image drawInRect:targetFrame
                         blendMode:kCGBlendModeNormal
                             alpha:1.0];
  
  [self.drawingCanvasImageView.image drawInRect:targetFrame
                                      blendMode:self.isDrawing ? kCGBlendModeNormal : kCGBlendModeDestinationOut
                                          alpha:1.0];
  
  self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
  self.drawingCanvasImageView.image = nil;
  UIGraphicsEndImageContext();
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (IBAction)erasePressed:(id)sender {
  self.isDrawing = !self.isDrawing;
}

- (IBAction)drawPressed:(id)sender {
  self.isForeground = !self.isForeground;
}

- (IBAction)segmentImagePressed:(id)sender {
  UIImage *rendered;
  UIGraphicsBeginImageContext(self.backgroundImageView.bounds.size);
  
  [self.backgroundImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
  
  rendered = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  UIImage *segmentedResult = [UIDOpenCVUtilities segmentImage:rendered
                                                     withMask:self.mainImage.image];
  self.backgroundImageView.image = segmentedResult;
  self.mainImage.hidden = YES;
  
  UIImage *segmentedImage = [UIDOpenCVUtilities outlinedImageFromImage:self.backgroundImageView.image];
  self.backgroundImageView.image = segmentedImage;
  int iii = 1001;
}
@end
