//
//  lightmeterViewController.m
//  lightmeter
//
//  Created by Michael Mackowiak on 8/19/2013.
//  Copyright (c) 2013 RUHE PM Pty. Ltd. All rights reserved.
//

#import "lightmeterViewController.h"
#import "HelpViewController.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import <math.h>

@interface lightmeterViewController()

@end

@implementation lightmeterViewController

#pragma mark -
#pragma mark Initialization and teardown

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    //self = [super initWithNibName:@"lightmeterViewController" bundle:nil];
    if (self)
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc;
{
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_MaxBrightness = 0;
    m_LuxLevel = 0;
    m_bShowMax = false;
    m_isPaused = false;
    [lbl_x1000 setHidden:YES];
    [lbl_Max setHidden:YES];
    [lbl_brightness setFont:[UIFont fontWithName:@"Digital dream Fat Skew" size:36]];
    [self setupVideoCameraFilter:AVCaptureDevicePositionBack];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [videoCamera stopCameraCapture];
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupVideoCameraFilter:(AVCaptureDevicePosition)cameraPos
{
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:cameraPos];
    [videoCamera setDelegate:self];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.runBenchmark = NO;
    
    luminosityFilter = [[GPUImageLuminosity alloc] init];
    [videoCamera addTarget:luminosityFilter];
    
    __block lightmeterViewController* weakSelf = self;
    [(GPUImageLuminosity *)luminosityFilter setLuminosityProcessingFinishedBlock:^(CGFloat luminosity, CMTime frameTime)
    {
       weakSelf->m_GPUImagebrightness = luminosity;
//       if (weakSelf->m_MaxBrightness < weakSelf->m_GPUImagebrightness && weakSelf->m_bShowMax)
//           weakSelf->m_MaxBrightness = weakSelf->m_GPUImagebrightness;
    }];
    
    filter = [[GPUImageFilter alloc] init];
    [filter addTarget:cameraView];
    [videoCamera addTarget:filter];
    
    [videoCamera startCameraCapture];
    
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(UpdateScreen) userInfo:nil repeats:YES];
}

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CFDictionaryRef exifAttachments = CMGetAttachment( sampleBuffer, kCGImagePropertyExifDictionary, NULL);
    if (exifAttachments)
    {
        @synchronized(self.dicProperties)
        {
            self.dicProperties = (__bridge NSDictionary*)exifAttachments;
        }
    }
}

float logx(float value, float base)
{
    return log10f(value) / log10f(base);
}

-(void)UpdateScreen
{
    @synchronized(self.dicProperties)
    {
        
        if (self.dicProperties)
        {
            if ([self.dicProperties valueForKey:@"ApertureValue"])
                [lbl_aperture setText:[NSString stringWithFormat:@"%.7f", [[self.dicProperties valueForKey:@"ApertureValue"] doubleValue]]];
            if ([self.dicProperties valueForKey:@"ExposureTime"])
                [lbl_exposure setText:[NSString stringWithFormat:@"%.7f", [[self.dicProperties valueForKey:@"ExposureTime"] doubleValue]]];
            if ([self.dicProperties valueForKey:@"ShutterSpeedValue"])
                [lbl_shutterSpeed setText:[NSString stringWithFormat:@"%.7f", [[self.dicProperties valueForKey:@"ShutterSpeedValue"] doubleValue]]];
            if ([self.dicProperties valueForKey:@"FocalLength"])
                [lbl_focalLength setText:[NSString stringWithFormat:@"%.7f", [[self.dicProperties valueForKey:@"FocalLength"] doubleValue]]];
            
            int isoSpeed = 0;
            if ([self.dicProperties valueForKey:@"ISOSpeedRatings"])
            {
                NSArray* tmpAry = (NSArray*)[self.dicProperties valueForKey:@"ISOSpeedRatings"];
                isoSpeed = [[tmpAry objectAtIndex:0] intValue];
                [lbl_isoSpeed setText:[NSString stringWithFormat:@"%d", isoSpeed]];
            }
            
            double brightnessCompensator = 0;
            brightnessCompensator =(50 * (pow([[self.dicProperties valueForKey:@"ApertureValue"] doubleValue],2)))/(([[self.dicProperties valueForKey:@"ExposureTime"] doubleValue])*isoSpeed);
            
            [lbl_candella setText:[NSString stringWithFormat:@"%.7f", brightnessCompensator]];

            
            m_iOSbrightness = [[self.dicProperties valueForKey:@"BrightnessValue"] doubleValue];

            [lbl_IOSbrightness setText:[NSString stringWithFormat:@"%.7f", m_iOSbrightness * brightnessCompensator]];
            
            [lbl_GPUIMAGEbrightness setText:[NSString stringWithFormat:@"%.7f", m_GPUImagebrightness * brightnessCompensator]];

            if (m_bShowMax)
            {
                if ((m_GPUImagebrightness * brightnessCompensator * 2) > m_MaxBrightness)
                {
                    m_MaxBrightness = (m_GPUImagebrightness * brightnessCompensator) * 2;
                }
                m_LuxLevel= m_MaxBrightness;
            }
            else
            {
                m_LuxLevel  = (m_GPUImagebrightness * brightnessCompensator) * 2;
            }
        }
    }
    if (m_LuxLevel > 1000)
    {
        [lbl_x1000 setHidden:NO];
        m_LuxLevel = m_LuxLevel / 1000;
    }
    else
    {
        [lbl_x1000 setHidden:YES];
    }
    if (!m_isPaused)
        [lbl_brightness setText:[NSString stringWithFormat:@"%.1f", m_LuxLevel]];
}

-(IBAction)OnSwitch:(id)sender
{
    UISwitch* toggle = (UISwitch*)sender;
    if (toggle.on)
    {
        if([videoCamera.inputCamera lockForConfiguration:nil])
        {
            if([videoCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeLocked])
            {
                [videoCamera.inputCamera setExposureMode:AVCaptureExposureModeLocked];
            }
            [videoCamera.inputCamera unlockForConfiguration];
        }
    }
    else
    {
        if([videoCamera.inputCamera lockForConfiguration:nil])
        {
            if([videoCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [videoCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            [videoCamera.inputCamera unlockForConfiguration];
        }
    }
}

-(IBAction)OnHelp:(id)sender
{
    HelpViewController* vw = nil;
    if (IS_IPHONE_4)
        vw = [[HelpViewController alloc] initWithNibName:@"HelpViewController_480h" bundle:nil];
    else
        vw = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    
    [self.navigationController pushViewController:vw animated:YES];
}

-(IBAction)OnMax:(id)sender
{
    m_bShowMax = !m_bShowMax;
    if (m_bShowMax)
    {
        m_MaxBrightness = 0;
        [btn_Max setImage:[UIImage imageNamed:@"max_on_70x2x.png"] forState:UIControlStateNormal];
        [lbl_Max setHidden:NO];
    }
    else
    {
        [btn_Max setImage:[UIImage imageNamed:@"max_off_70x2x.png"] forState:UIControlStateNormal];
        [lbl_Max setHidden:YES];
    }
}

-(IBAction)OnHoldOn:(id)sender
{
    if (!m_isPaused)
    {
        m_isPaused = true;
        [videoCamera removeTarget:filter];        
        [btn_hold setImage:[UIImage imageNamed:@"hold_on_70x2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        m_isPaused = false;
        [videoCamera addTarget:filter];
        [btn_hold setImage:[UIImage imageNamed:@"hold_off_70x2x.png"] forState:UIControlStateNormal];
    }
}
@end
