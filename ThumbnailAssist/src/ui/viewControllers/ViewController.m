//
//  ViewController.m
//  ThumbnailAssit
//
//  Created by Cecil Edens on 3/26/14.
//  Copyright (c) 2014-2016 Edens R&D. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ViewController.h"
#import "ERDThumbnailHelper.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UITextField *statusMessage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

#pragma mark - Helpers

- (thumbnailCompletionBlock)completionBlock {

  __weak __typeof (self) weakSelf = self;
  return ^(UIImage *thumbnail, NSError *error) {

    dispatch_async(dispatch_get_main_queue(), ^{

      if (thumbnail) {

        weakSelf.thumbnailView.image = thumbnail;
        weakSelf.statusMessage.text = @"Success";

      } else {

        weakSelf.thumbnailView.image = nil;
        weakSelf.statusMessage.text = [error localizedDescription];
        NSLog(@"%s[%d] %@", __PRETTY_FUNCTION__, __LINE__, [error localizedDescription]);
      }

      [weakSelf.activityIndicator stopAnimating];
    });
  };
}

#pragma mark - Button Event Handlers

- (IBAction)fetchThumbnailForEmbededVideo:(UIButton *)sender {

  [self.activityIndicator startAnimating];

  // Step 1: Create the thumbnail helper
  ERDThumbnailHelper *thumbnailHelper = [ERDThumbnailHelper sharedInstance];
  // Step 2: [Optional] Set the desired size of the thumbnail
  thumbnailHelper.maxThumbnailSize = CGSizeMake(120.f, 120.f);

  // Step 3: Create the NSURL for the video
  NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"A-B" withExtension:@"mp4"];

  // Step 4: Send message to the thumbnail helper to have it create the thumbnail.
  [thumbnailHelper createVideoThumbnailWithFilePath:fileUrl
                                    completionBlock:[self completionBlock]];
}

- (IBAction)fetchThumbnailForStreamingVideo:(UIButton *)sender {
  
  [self.activityIndicator startAnimating];

  // Step 1: Create the thumbnail helper
  ERDThumbnailHelper *thumbnailHelper = [ERDThumbnailHelper sharedInstance];
  // Step 2: [Optional] Set the desired size of the thumbnail
  thumbnailHelper.maxThumbnailSize = CGSizeMake(120.f, 120.f);

  // Step 3: Create the NSURL for the video
  NSURL *videoURL = [NSURL URLWithString:@"http://embed.wistia.com/deliveries/5413caeac5fdf4064a2f9eab5c10a0848e42f19f.bin"];

  // Step 4: Send message to the thumbnail helper to have it create the thumbnail.
  [thumbnailHelper createVideoThumbnailWithUrl:videoURL
                                    completionBlock:[self completionBlock]];
}

@end
