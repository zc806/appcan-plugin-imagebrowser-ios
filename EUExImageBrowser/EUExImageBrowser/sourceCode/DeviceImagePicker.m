//
//  DeviceImagePicker.m
//  AppCan
//
//  Created by AppCan on 11-11-24.
//  Copyright 2011 AppCan. All rights reserved.
//

#import "DeviceImagePicker.h"
#import "EUExImageBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "EUtility.h"

@implementation DeviceImagePicker
@synthesize popController;

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

-(id)initWithEuex:(EUExImageBrowser *)euexObj_{
    euexObj = euexObj_;
	return self;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSNumber *statusBarStyleIOS7 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"StatusBarStyleIOS7"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0&&[statusBarStyleIOS7 boolValue] == YES )
    {
        [[UIApplication sharedApplication] setStatusBarStyle:euexObj.myStatusBarStyle];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

 	if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]){
		UIImage *checkImg = [info objectForKey:UIImagePickerControllerOriginalImage];
		if (checkImg) {
			NSData *imageData = UIImageJPEGRepresentation(checkImg,0);
			NSFileManager *fmanager = [NSFileManager defaultManager];
            //获取程序的根目录
            NSString *homeDirectory = NSHomeDirectory();
            //获取Documents/apps目录的地址
            NSString *tempPath = [homeDirectory stringByAppendingPathComponent:@"Documents/apps"];
			NSString *curAppId = [EUtility brwViewWidgetId:euexObj.meBrwView];
			NSString *wgtTempPath = [tempPath stringByAppendingPathComponent:curAppId];
            
			if (![fmanager fileExistsAtPath:wgtTempPath]) {
				[fmanager createDirectoryAtPath:wgtTempPath withIntermediateDirectories:YES attributes:nil error:nil];
			}
			//picture name
			NSString *timeStr = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
			
			NSString *imgName = [NSString stringWithFormat:@"%@.jpg",[timeStr substringFromIndex:([timeStr length]-6)]];
			NSString *imgTmpPath = [wgtTempPath stringByAppendingPathComponent:imgName];
			if ([fmanager fileExistsAtPath:imgTmpPath]) {
				[fmanager removeItemAtPath:imgTmpPath error:nil];
			}
            BOOL succ = [imageData writeToFile:imgTmpPath atomically:YES];
            
            if (320 != SCREEN_WIDTH && [EUtility isIpad]) {
                [popController dismissPopoverAnimated:YES];
                if (succ) {
                    [euexObj uexImageBrowserPickerWithOpId:0 dataType:IB_CALLBACK_DATATYPE_TEXT data:imgTmpPath];
                }
            }else {
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
                    [picker dismissViewControllerAnimated:YES completion:^{
                        if (succ) {
                            [euexObj uexImageBrowserPickerWithOpId:0 dataType:IB_CALLBACK_DATATYPE_TEXT data:imgTmpPath];
                        }
                    }];
                }else{
                    [picker dismissModalViewControllerAnimated:NO];
                    if (succ) {
                        [euexObj uexImageBrowserPickerWithOpId:0 dataType:IB_CALLBACK_DATATYPE_TEXT data:imgTmpPath];
                    }
                }
            }
		}
	}
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissModalViewControllerAnimated:YES];
}

-(void)openDicm{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		[picker setDelegate:self];
		[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		picker.mediaTypes = [NSArray arrayWithObjects:@"public.image",nil];
		if (320 == SCREEN_WIDTH || ![EUtility isIpad]) {
			[EUtility brwView:euexObj.meBrwView presentModalViewController:picker animated:YES];
		}else {
			UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
			self.popController = popover;
 			[EUtility brwView:euexObj.meBrwView presentPopover:popController FromRect:CGRectMake(0, 0, 300, 300) permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
			[popover release];
		}
		[picker release];
	}else {
		[euexObj jsFailedWithOpId:0 errorCode:1100108 errorDes:ERROR_IB_DEVICE_SUPPORT];
	}
}

-(void)dealloc{
	[popController release];
	[super dealloc];
}

@end
