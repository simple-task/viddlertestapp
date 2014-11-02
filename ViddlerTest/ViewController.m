//
//  ViewController.m
//  ViddlerTest
//
//  Created by Milan Miletic on 10/27/14.
//  Copyright (c) 2014 simple-task. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViddlerManager.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>
{
    AVAsset *curentAsset;
    NSString *assetUrl;
    MFMailComposeViewController *controller;
}

- (IBAction)chooseVideoTouched:(id)sender;
- (IBAction)postToViddlerTouched:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *postToViddlerButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.postToViddlerButton.enabled = NO;
    self.statusLabel.text = @"";
    [[ViddlerManager instance] login];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseVideoTouched:(id)sender
{
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    imagePicker.mediaTypes = @[(NSString *) kUTTypeMovie];
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSURL *url = [info objectForKey:@"UIImagePickerControllerMediaURL"];
    curentAsset = [AVAsset assetWithURL:url];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:curentAsset presetName:AVAssetExportPresetHighestQuality];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputURL = paths[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];

    [manager removeItemAtPath:outputURL error:nil];
    
    exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         assetUrl = outputURL;
         curentAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:assetUrl]];
         [self performSelectorOnMainThread:@selector(presentPostOptions) withObject:nil waitUntilDone:NO];
     }];
}

- (void)presentPostOptions
{
    [self presentVideoThumbnail:0.0];
    self.postToViddlerButton.enabled = YES;
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:assetUrl error:nil];
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    self.sizeLabel.text = [NSString stringWithFormat:@"%lld KB", fileSize / 1000];
    self.durationLabel.text = [NSString stringWithFormat:@"%lld sec", (curentAsset.duration.value / curentAsset.duration.timescale)];
}

- (void)presentVideoThumbnail:(CGFloat)position
{
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:curentAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime midpoint = CMTimeMakeWithSeconds(position, 600);
    NSError *error;
    CMTime actualTime;
    
    CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
    
    if (halfWayImage != NULL)
    {
        self.thumbnailView.image = [UIImage imageWithCGImage:halfWayImage];
        CGImageRelease(halfWayImage);
    }
}

- (IBAction)postToViddlerTouched:(id)sender
{
    self.postToViddlerButton.enabled = NO;
    NSDate *start = [NSDate date];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ViddlerManager instance] postVideo:[NSURL fileURLWithPath:assetUrl] withSuccess:^(NSString *message) {
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
        NSString *finalMessage = [NSString stringWithFormat:@"%@ Execution time: %f. Video file size: %@. Video length: %@", message, executionTime, self.sizeLabel.text, self.durationLabel.text];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.postToViddlerButton.enabled = YES;
        [self performSelectorOnMainThread:@selector(sendMail:) withObject:finalMessage waitUntilDone:NO];
    }];
}

- (void)sendMail:(NSString*)message
{
    if ([MFMailComposeViewController canSendMail])
    {
         controller = [[MFMailComposeViewController alloc] init];
        
        [controller setSubject:@"Viddler test"];
        controller.mailComposeDelegate = self;
        [controller setMessageBody:message isHTML:NO];
        [controller setToRecipients:[NSArray arrayWithObjects:@"niksa@simple-task.com",nil]];
        if (controller)
        {
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please confugure your mail client" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultSent)
    {
        NSLog(@"Email sent OK");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
