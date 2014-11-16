//
//  UIDOpenCVUtilities.m
//  UserInterfaceDesignRunning
//
//  Created by Michael Grande on 11/3/14.
//  Copyright (c) 2014 MLConsulting. All rights reserved.
//

#import "UIDOpenCVUtilities.h"
#import <opencv2/imgproc/imgproc_c.h>

@implementation UIDOpenCVUtilities

+ (Mat)cvMatFromUIImage:(UIImage *)image
{
  CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
  CGFloat cols = image.size.width;
  CGFloat rows = image.size.height;
  
  Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
  
  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                  cols,                       // Width of bitmap
                                                  rows,                       // Height of bitmap
                                                  8,                          // Bits per component
                                                  cvMat.step[0],              // Bytes per row
                                                  colorSpace,                 // Colorspace
                                                  kCGImageAlphaNoneSkipLast |
                                                  kCGBitmapByteOrderDefault); // Bitmap info flags
  
  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
  CGContextRelease(contextRef);
  
  return cvMat;
}

+ (UIImage *)UIImageFromCVMat:(Mat)cvMat
{
  NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
  CGColorSpaceRef colorSpace;
  
  if (cvMat.elemSize() == 1) {
    colorSpace = CGColorSpaceCreateDeviceGray();
  } else {
    colorSpace = CGColorSpaceCreateDeviceRGB();
  }
  
  CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
  
  // Creating CGImage from cv::Mat
  CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                      cvMat.rows,                                 //height
                                      8,                                          //bits per component
                                      8 * cvMat.elemSize(),                       //bits per pixel
                                      cvMat.step[0],                            //bytesPerRow
                                      colorSpace,                                 //colorspace
                                      kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                      provider,                                   //CGDataProviderRef
                                      NULL,                                       //decode
                                      false,                                      //should interpolate
                                      kCGRenderingIntentDefault                   //intent
                                      );
  
  
  // Getting UIImage from CGImage
  UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);
  
  return finalImage;
}

+ (UIImage *)segmentImage:(UIImage *)image
                 withMask:(UIImage *)mask {
  
  Mat cv_image = [self cvMatFromUIImage:image];
  cv::cvtColor(cv_image , cv_image , CV_RGBA2RGB);
  Mat cv_mask = [self cvMatFromUIImage:mask];

  cv::Mat1b markers(cv_mask.rows, cv_mask.cols);
  Mat img(cv_mask);
  
  markers.setTo(cv::GC_PR_BGD);
  
  Mat fgd_mask;
  inRange(cv_mask, Scalar(245,245,245,245), Scalar(256,256,256,256), fgd_mask);
  markers.setTo(GC_FGD, fgd_mask);

  
  Mat bgd_mask;
  inRange(cv_mask, Scalar(0,0,0,245), Scalar(20,20,20,256), bgd_mask);
  markers.setTo(GC_BGD, bgd_mask);
  
  Mat cv_outputImage(cv_image);
  cv::Rect cv_boundRect(0,0,cv_image.rows,cv_image.cols);
  cv::Mat result; // segmentation result (4 possible values)
  cv::Mat bgModel,fgModel; // the models (internally used)
  
  try {
    grabCut(cv_image,
            markers,
            cv_boundRect,
            bgModel,
            fgModel,
            1,
            GC_INIT_WITH_MASK);
  }
  catch (NSException *exception) {
    NSLog(@"ze ze ze");
  }
  
  
//  tmp = cv_image & fgModel;
  // let's get all foreground and possible foreground pixels
  cv::Mat1b mask_fgpf = ( markers == cv::GC_FGD) | ( markers == cv::GC_PR_FGD);// | (markers == cv::GC_BGD);
  // and copy all the foreground-pixels to a temporary image
  cv::Mat3b tmp = cv::Mat3b::zeros(cv_image.rows, cv_image.cols);
  cv_image.copyTo(tmp, mask_fgpf);
  
  
  return [self UIImageFromCVMat:tmp];
}

+ (UIImage *)outlinedImageFromImage:(UIImage *)sourceImage {
  Mat cv_image = [self cvMatFromUIImage:sourceImage];
  // Since MORPH_X : 2,3,4,5 and 6
  
  int morph_size = 1;
  
  int filterSize = 5;
//  IplConvKernel *convKernel = cvCreateStructuringElementEx(filterSize, filterSize, (filterSize - 1) / 2, (filterSize - 1) / 2, CV_SHAPE_RECT, NULL);

//  cv::morphologyEx( cv_image, cv_image, cv::MORPH_CLOSE, cv::Mat(), cv::Point(-1,-1), CV_MOP_GRADIENT );
  threshold(cv_image, cv_image, 50, 255, CV_THRESH_TOZERO);
  Canny(cv_image, cv_image, 140, 40);
  
//  cv::cvtColor(cv_image , cv_image , CV_RGB2BGRA);
  
  
  return [self UIImageFromCVMat:cv_image];
}

@end
