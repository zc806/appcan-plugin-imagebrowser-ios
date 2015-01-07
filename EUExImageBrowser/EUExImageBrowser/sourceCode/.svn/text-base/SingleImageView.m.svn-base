//
//  SingleImageView.m
//  AppCan
//
//  Created by AppCan on 11-12-14.
//  Copyright 2011 AppCan. All rights reserved.
//

#import "SingleImageView.h"
#import "Three20.h" 

@implementation SingleImageView
@synthesize imageURL;
-(void)viewDidLoad{
	[super viewDidLoad];

	MockPhoto *mphoto = [[MockPhoto alloc] initWithURL:imageURL smallURL:imageURL size:CGSizeMake(320, 480)];
	self.photoSource = [[[MockPhotoSource alloc] initWithType:MockPhotoSourceNormal
												  startIndex:0
													   title:@"图片"
													  photos:[NSArray arrayWithObject:mphoto]
													 photos2:nil] autorelease];
	[mphoto release]; 
}

-(void)dealloc{
	[imageURL release];
	[super dealloc];
}
@end
