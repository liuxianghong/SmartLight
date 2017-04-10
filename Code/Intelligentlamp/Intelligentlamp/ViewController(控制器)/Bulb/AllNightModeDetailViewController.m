//
//  AllNightModeDetailViewController.m
//  Intelligentlamp
//
//  Created by L on 16/9/27.
//  Copyright © 2016年 L. All rights reserved.
//

#import "AllNightModeDetailViewController.h"
#import "AllBulbModel.h"

@interface AllNightModeDetailViewController()

@property (nonatomic ,strong) UIImageView *coloWheelImg;//色盘
@property (nonatomic ,strong) UIImageView *selectImg;

@end

@implementation AllNightModeDetailViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitleViewWithStr:@"灯光控制"];
    
    [self leftBarButtonItem:[UIImage imageNamed:@"BackArrow"] withClickBtnAction:^{
//        [self.navigationController popViewControllerAnimated:YES];
        [self upDataLampMsg];
        
    }];
    
   [self coloWheelImg];
    
    //设置灯泡初始的颜色
    UIImage *theImg                            = [UIImage imageNamed:@"Lightbulb_Off"];
    theImg                                     = [theImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _selectImg.image                             = theImg;
    _selectImg.tintColor = [UIColor colorWithRed:_lampModel.redColor/255.0 green:_lampModel.greenColor/255.0 blue:_lampModel.blueColor/255.0 alpha:1.0];
    
}

- (void)upDataLampMsg{
    
    NSMutableDictionary *dic                   = [NSMutableDictionary dictionary];
    [dic setValue:@"1.0.0" forKey:@"version"];
    [dic setValue:getUserId() forKey:@"userId"];
    [dic setValue:getUserToken() forKey:@"token"];
    [dic setValue:_lampModel.lampId forKey:@"deviceId"];
    [dic setValue:_lampModel.lampName forKey:@"deviceName"];
    [dic setValue:_lampModel.lampImg forKey:@"deviceLogoURL"];
    [dic setValue:@"1" forKey:@"sceneId"];
  
    [dic setValue:_lampModel.lampDescription forKey:@"description"];
    [dic setValue:_lampModel.lampTimingOpenTime forKey:@"timingOpenTime"];
    [dic setValue:_lampModel.lampTimingCloseTime forKey:@"timingCloseTime"];
    
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.blueColor] forKey:@"blueColor"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.redColor] forKey:@"redColor"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.greenColor] forKey:@"greenColor"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lampPower] forKey:@"power"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lampBrightness] forKey:@"brightness"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lampTonal] forKey:@"tonal"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lampShow] forKey:@"ra"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lampColorTemperature] forKey:@"colorTemperature"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lampSaturation] forKey:@"saturation"];
    
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lamDelayOn] forKey:@"delayOn"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lamDelayTime] forKey:@"delayTime"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lampTimingOn] forKey:@"timingOn"];
    [dic setValue:[NSString stringWithFormat:@"%d",_lampModel.lamPrandomOn] forKey:@"randomOn"];
    
    [LXNetworking postWithUrl:Brand_UpdateLampInfo params:dic success:^(id response) {
        [self hideNetWorkView];
        
        [self showRemendSuccessView:@"更新成功" withBlock:^{
            
            
            [self.navigationController popViewControllerAnimated:YES];

            
        }];
        
    } fail:^(NSError *error) {
        
        [self hideNetWorkView];
        
        [self showRemendWarningView:@"更新失败" withBlock:nil];
        
    } showHUD:nil];
    
}

#pragma -mark ViewController 生命周期函数

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (UIImageView *)coloWheelImg{
    if (!_coloWheelImg) {
        _coloWheelImg = [[UIImageView alloc]init];
        _coloWheelImg.image = [UIImage imageNamed:@"ColorWheel"];
        UILongPressGestureRecognizer *longPressPR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        longPressPR.minimumPressDuration = 0.05;
        
        [_coloWheelImg addGestureRecognizer:longPressPR];
        _coloWheelImg.userInteractionEnabled = YES;
        
        [self.view addSubview:_coloWheelImg];
        [_coloWheelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(260);
            make.top.mas_equalTo(self.view.mas_top).offset(40);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _coloWheelImg;
}

- (UIImageView *)clickLocationX:(int)x WithY:(int)y{
    _selectImg = [[UIImageView alloc]init];
    _selectImg.image = [UIImage imageNamed:@"Color-Picker"];
    [_coloWheelImg addSubview:_selectImg];
    [_selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(_coloWheelImg.mas_top).offset(y);
        make.centerX.mas_equalTo(_coloWheelImg.mas_left).offset(x);
    }];
    
    return _selectImg;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [sender locationInView:_coloWheelImg];
        NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
        
        [self clickLocationX:point.x WithY:point.y];
        [self getPixelColorAtLocation:point];
        
        
    }else if (sender.state == UIGestureRecognizerStateEnded){
        
        [_selectImg removeFromSuperview];
        
    }
}


- (UIColor*) getPixelColorAtLocation:(CGPoint)point {
    UIColor* color = nil;
    CGImageRef inImage = self.coloWheelImg.image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            NSLog(@"offset: %d", offset);
            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            
            _lampModel.redColor = red;
            _lampModel.greenColor = green;
            _lampModel.blueColor = blue;
            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }
        
    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}
@end

