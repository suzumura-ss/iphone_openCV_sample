//
//  UIImage+UIImage_Blur.mm
//  openCVSample
//
//  Created by Twitter:@suzumura_ss on 12/08/03.
//

#import "UIImage+UIImage_Blur.h"
#import "UIImage+UIImage_OpenCV.h"

@implementation UIImage (UIImage_Blur)

- (UIImage*)gaussian:(int)size
{
    if ((size%2)==0) size+=1;
    cv::Mat src = [self CVMat];
    cv::Mat dst;
    cv::GaussianBlur(src, dst, cv::Size(size, size), size/2);
    
    return [UIImage imageWithCVMat:dst];
}

- (UIImage*)median:(int)size
{
    if ((size%2)==0) size+=1;
    cv::Mat src = [self CVMat];
    cv::Mat dst;
    cv::medianBlur(src, dst, size);
    
    return [UIImage imageWithCVMat:dst];
}


@end
