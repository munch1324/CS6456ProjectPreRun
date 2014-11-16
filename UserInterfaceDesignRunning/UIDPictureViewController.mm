//
//  UIDPictureViewController.m
//  UserInterfaceDesignRunning
//
//  Created by Michael Grande on 11/3/14.
//  Copyright (c) 2014 MLConsulting. All rights reserved.
//

#import "UIDPictureViewController.h"

#import "UIDOpenCVUtilities.h"

// OpenCV Imports
#ifdef __cplusplus
#import <opencv2/highgui/cap_ios.h>
#import <opencv2/core/core_c.h>
#import <opencv2/opencv.hpp>
using namespace cv;
#endif

#import "UIDDrawingViewController.h"

@interface UIDPictureViewController ()<CvVideoCameraDelegate>

@property (nonatomic)CvVideoCamera *videoCamera;
@property (nonatomic)BOOL isCapturing;
@property (nonatomic)UIImage *capturedImage;

@end

@implementation UIDPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
  self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.capturingImageView];
  self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
  self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
  self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
  self.videoCamera.defaultFPS = 30;
  self.videoCamera.grayscaleMode = NO;
  self.videoCamera.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.videoCamera start];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   UIDDrawingViewController *pushedVC = [segue destinationViewController];
   pushedVC.baseImage = [self.capturedImage copy];
 }
 

#pragma mark - OpenCV image Processing
#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
  // Do some OpenCV stuff with the image
  Mat image_copy;
  
  if (self.isCapturing) {
    Mat myCopy(image);
    cvtColor(myCopy, myCopy, CV_BGR2BGRA);
    [self.videoCamera stop];
    self.capturedImage = [UIDOpenCVUtilities UIImageFromCVMat:myCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
      self.capturingImageView.image = self.capturedImage;
    });
    self.isCapturing = NO;
  }
}
#endif


#pragma mark - Action Handlers
- (IBAction)capturePressed:(id)sender {
  if (!self.isCapturing) {
    self.isCapturing = YES;
    [UIView animateWithDuration:0.6 animations:^{
      self.bottomConstraint.constant = 100;
      [self.view layoutIfNeeded];
    }];
  }
  self.confirmationPrompt.hidden = NO;
  self.captureButton.hidden = YES;
}

- (IBAction)retakePressed:(id)sender {
    [self.videoCamera start];
  [UIView animateWithDuration:0.6 animations:^{
    self.bottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
  }];
  self.confirmationPrompt.hidden = YES;
  self.captureButton.hidden = NO;
}

- (IBAction)usePressed:(id)sender {

}
@end
