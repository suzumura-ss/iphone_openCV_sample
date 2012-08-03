//
//  UIImage+UIImage_Blur.h
//  openCVSample
//
//  Created by Twitter:@suzumura_ss on 12/08/03.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Blur)

- (UIImage*)gaussian:(int)size;
- (UIImage*)median:(int)size;

@end
