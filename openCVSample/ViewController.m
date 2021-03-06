//
//  ViewController.m
//  openCVSample
//
//  Created by Twitter:@suzumura_ss on 12/08/03.
//

#import "ViewController.h"
#import "UIImage+UIImage_Blur.h"

@interface ViewController ()
{
    UIImage* _image;
    NSOperationQueue* _queue;
    NSInteger _filterSize;
}
@end


@implementation ViewController

@synthesize imageView = _imageView;
@synthesize textView = _textView;
@synthesize toolbar = _toolbar;
@synthesize prosessing = _prosessing;
@synthesize indicator = _indicator;
@synthesize stepper = _stepper;
@synthesize doBenchmark = _doBenchmark;

#pragma mark - Indicator

- (void)displayIndicator:(BOOL)show
{
    for (UIBarButtonItem* btn in _toolbar.items) {
        btn.enabled = !show;
    }
    _prosessing.hidden = !show;
    if(show) {
        [_indicator startAnimating];
    } else {
        [_indicator stopAnimating];
    }
    _indicator.hidden = !show;
}


#pragma mark - process image

- (IBAction)imageInfo:(id)sender
{
    if (!_image) return;
    
    CGImageRef cg = [_image CGImage];
    CGColorSpaceModel colorModel = CGColorSpaceGetModel(CGImageGetColorSpace(cg));
    size_t bitPerPixel = CGImageGetBitsPerPixel(cg);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(cg);
    const char* formatName = "";
    switch (bitPerPixel) {
        case 32:
            switch (bitmapInfo & kCGBitmapAlphaInfoMask) {
                case kCGImageAlphaPremultipliedFirst:
                case kCGImageAlphaFirst:
                case kCGImageAlphaNoneSkipFirst:
                    formatName = "BGRA";
                    break;
                default:
                    formatName = "RGBA";
                    break;
            }
            break;
        case 24:
            formatName = "RGB";
            break;
    }
    size_t width = CGImageGetWidth(cg);
    size_t height = CGImageGetHeight(cg);
    [self.textView setText:[NSString stringWithFormat:@"colorModel: %d, bitPerPixel: %zu, bitmapInfo: 0x%x, format=%s, %dx%dpx, filter=%d",
                            colorModel, bitPerPixel, bitmapInfo, formatName, width, height, _filterSize]];

    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(cg));
    CFMutableDataRef bitmap = CFDataCreateMutableCopy(kCFAllocatorDefault, 0, data);
    UInt8* pixels = (UInt8*)CFDataGetMutableBytePtr(bitmap);
    size_t bytesPerRow = CGImageGetBytesPerRow(cg);
    
    // Do somethings.
    NSLog(@"image bitmap address: %p", pixels);
    
    size_t bitPerComponent = CGImageGetBitsPerComponent(cg);
    CGColorSpaceRef space = CGImageGetColorSpace(cg);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(bitmap);
    const CGFloat* decode = CGImageGetDecode(cg);
    bool shouldInterpolate = CGImageGetShouldInterpolate(cg);
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(cg);
    
    CGImageRef newcg = CGImageCreate(width, height, bitPerComponent, bitPerPixel, bytesPerRow, space, bitmapInfo, provider, decode, shouldInterpolate, intent);
    UIImage* img = [UIImage imageWithCGImage:newcg];
    [_imageView setImage:img];
    
    CGImageRelease(newcg);
    CFRelease(provider);
    CFRelease(bitmap);
    CFRelease(data);
}

- (IBAction)processCvImage:(id)sender
{
    if (!_image) return;
    UIBarButtonItem* btn = (UIBarButtonItem*)sender;

    [self displayIndicator:YES];

    __weak ViewController* _self = self;
    UIImage* src = _image;
    NSInteger size = _filterSize;
    int count = [_doBenchmark isOn] ? 5: 1;
    [_queue addOperationWithBlock:^{
        const char* type = "";
        NSDate* sd = [NSDate dateWithTimeIntervalSinceNow:0];
        UIImage* image = nil;
        for (int i=0; i<count; i++) {
            switch ([btn tag]) {
                default:
                case 0:
                    type = "gaussian";
                    image = [src gaussian:size];
                    break;
                case 1:
                    type = "median";
                    image = [src median:size];
                    break;
                case 2:
                    type = "box";
                    image = [src box:size];
            }
        }
        NSTimeInterval lap = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceDate:sd] / (NSTimeInterval)count;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_self.imageView setImage:image];
            [_self displayIndicator:NO];
            [_self.textView setText:[NSString stringWithFormat:@"%s(%d), Lap: %0.3f [sec]", type, size, lap]];
        });
    }];
}

#pragma mark - select image

- (IBAction)loadImage:(id)sender
{
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (IBAction)saveImage:(id)sender
{
    UIImageWriteToSavedPhotosAlbum([_imageView image], nil, nil, nil);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_imageView setImage:image];
    _image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _queue = [[NSOperationQueue alloc] init];
    [self stepperClicked:_stepper];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)stepperClicked:(id)sender
{
    UIStepper* s = (UIStepper*)sender;
    NSInteger v = [s value];
    _filterSize = v*v;
    if((_filterSize%2)==0) _filterSize+=1;
    [_textView setText:[NSString stringWithFormat:@"filterSize=%d", _filterSize]];
}

@end
