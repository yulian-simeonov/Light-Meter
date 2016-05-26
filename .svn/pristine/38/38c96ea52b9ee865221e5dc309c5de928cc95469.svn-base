//
//  lightmeterViewController.h
//  lightmeter
//
//  Created by Michael Mackowiak on 8/19/2013.
//  Copyright (c) 2013 RUHE PM Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface lightmeterViewController : UIViewController <GPUImageVideoCameraDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    GPUImageVideoCamera *videoCamera;
    GPUImageStillCamera* photoCamera;
    GPUImageOutput<GPUImageInput> *luminosityFilter;
    
    IBOutlet UILabel *lbl_IOSbrightness;
    IBOutlet UILabel *lbl_GPUIMAGEbrightness;
    IBOutlet UILabel *lbl_brightness;
    IBOutlet UILabel *lbl_Max;
    IBOutlet UILabel *lbl_x1000;
    IBOutlet UILabel *lbl_exposure;
    IBOutlet UILabel *lbl_aperture;
    IBOutlet UILabel *lbl_shutterSpeed;
    IBOutlet UILabel *lbl_focalLength;
    IBOutlet UILabel *lbl_candella;
    IBOutlet UIButton *btn_Max;
    IBOutlet UIButton *btn_hold;
    IBOutlet UILabel *lbl_isoSpeed;
    IBOutlet GPUImageView* cameraView;
    GPUImageFilter *filter;
    
    UIImage *capturedImage;
    
@public
    double m_LuxLevel;
    float m_MaxBrightness;
    float m_iOSbrightness;
    float m_GPUImagebrightness;
    BOOL m_bShowMax;
    BOOL m_isPaused;
}

@property (nonatomic, retain) NSDictionary* dicProperties;

@end
