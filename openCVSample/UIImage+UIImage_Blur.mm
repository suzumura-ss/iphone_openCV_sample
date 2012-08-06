//
//  UIImage+UIImage_Blur.mm
//  openCVSample
//
//  Created by Twitter:@suzumura_ss on 12/08/03.
//

#import "UIImage+UIImage_Blur.h"
#import "UIImage+UIImage_OpenCV.h"

using namespace cv;

@implementation UIImage (UIImage_Blur)

- (Mat)wrappedImageSetup:(int)size
{
    Mat src = [self CVMat], wrap;
    int width = src.size().width;
    int height = src.size().height;
    
    // 幅 size[px] を左右両端につける
    wrap.create(height, width + size*2, src.type());
    for(int y=0; y<height; y++) {
        for(int x=0; x<size; x++) {
            Vec4b v = src.at<Vec4b>(y, width - size + x);
            wrap.at<Vec4b>(y, x) = v;
        }
        for(int x=size; x<size+width; x++) {
            Vec4b v = src.at<Vec4b>(y, x - size);
            wrap.at<Vec4b>(y, x) = v;
        }
        for(int x=size+width; x<size+width+size; x++) {
            Vec4b v = src.at<Vec4b>(y, x - (size + width));
            wrap.at<Vec4b>(y, x) = v;
        }
    }
    
    return wrap;    
}

- (UIImage*)clipResult:(Mat)src size:(int)size
{
    int width = src.size().width - size*2;
    int height = src.size().height;
    Mat dst;
    dst.create(height, width, src.type());
    
    // 真ん中の (width, height) を切り抜く
    for(int y=0; y<height; y++) {
        for(int x=0; x<width; x++) {
            dst.at<Vec4b>(y, x) = src.at<Vec4b>(y, size + x);
        }
    }
    return [UIImage imageWithCVMat:dst];
}


- (UIImage*)gaussian:(int)size
{
    if ((size%2)==0) size+=1;
    
    Mat src = [self wrappedImageSetup:size], dst;
    
    cv::GaussianBlur(src, dst, cv::Size(size, size), size/2);
    
    return [self clipResult:dst size:size];
}

- (UIImage*)median:(int)size
{
    if ((size%2)==0) size+=1;
    
    Mat src = [self wrappedImageSetup:size], dst;
    
    medianBlur(src, dst, size);
    
    return [self clipResult:dst size:size];
}

- (UIImage*)box:(int)size
{
    if ((size%2)==0) size+=1;
    
    Mat src = [self wrappedImageSetup:size], dst;
    
    boxFilter(src, dst, src.type(), cv::Size(size, size));
    
    return [self clipResult:dst size:size];
}

@end
