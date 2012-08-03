//
//  ViewController.h
//  openCVSample
//
//  Created by Twitter:@suzumura_ss on 12/08/03.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UITextView* textView;
@property (nonatomic, strong) IBOutlet UISlider* slider;
@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic, strong) IBOutlet UIButton* prosessing;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* indicator;

- (IBAction)loadImage:(id)sender;
- (IBAction)imageInfo:(id)sender;
- (IBAction)processCvImage:(id)sender;

@end
