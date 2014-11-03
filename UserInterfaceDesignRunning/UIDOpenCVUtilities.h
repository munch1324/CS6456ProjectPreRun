//
//  UIDOpenCVUtilities.h
//  UserInterfaceDesignRunning
//
//  Created by Michael Grande on 11/3/14.
//  Copyright (c) 2014 MLConsulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/highgui/cap_ios.h>
#import <opencv2/core/core_c.h>
#import <opencv2/opencv.hpp>
using namespace cv;

@interface UIDOpenCVUtilities : NSObject

+ (Mat)cvMatFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(Mat)cvMat;

+ (UIImage *)segmentImage:(UIImage *)image
                 withMask:(UIImage *)mask;

@end
