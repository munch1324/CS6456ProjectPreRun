//
//  ViewController.m
//  UserInterfaceDesignRunning
//
//  Created by Michael Grande on 10/25/14.
//  Copyright (c) 2014 MLConsulting. All rights reserved.
//

#import "ViewController.hh"

#import <opencv2/highgui/cap_ios.h>
#import <opencv2/core/core_c.h>
#import <opencv2/opencv.hpp>

using namespace cv;

@interface ViewController () <UIImagePickerControllerDelegate, CvVideoCameraDelegate> {
}
@property (nonatomic)CvVideoCamera *videoCamera;
@property (nonatomic)UIImagePickerController *imageController;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
  self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
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

- (IBAction)buttonPressed:(id)sender {
//  if (self.imageController) {
//    [self dismissViewControllerAnimated:self.imageController
//                             completion:nil];
//    self.imageController = nil;
//  }
//  self.imageController = [UIImagePickerController new];
//  self.imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
////  self.imageController.delegate = self;
//  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//    [self presentViewController:self.imageController
//                       animated:YES
//                     completion:nil];
//  }
  [self.videoCamera start];
  
}
#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
  // Do some OpenCV stuff with the image
  // Do some OpenCV stuff with the image
  Mat image_copy;
  cvtColor(image, image_copy, CV_BGRA2BGR);
  
  // invert image
  bitwise_not(image_copy, image_copy);
  cvtColor(image_copy, image, CV_BGR2BGRA);
}
#endif

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSLog(@"Took a picture with info: %@", info);
  [self dismissViewControllerAnimated:self.imageController
                           completion:nil];
  UIImage *takenImage = info[UIImagePickerControllerOriginalImage];
  if (takenImage) {
    self.imageView.image = takenImage;
  }
}
@end
