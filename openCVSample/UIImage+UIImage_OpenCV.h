//
//  UIImage+UIImage_OpenCV.h
//  openCVSample
//
//  Created by Twitter:@suzumura_ss on 12/08/03.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_OpenCV)

+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;
- (id)initWithCVMat:(const cv::Mat&)cvMat;

@property(nonatomic, readonly) cv::Mat CVMat;

@end
