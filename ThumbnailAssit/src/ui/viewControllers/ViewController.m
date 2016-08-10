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
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (IBAction)fetchThumbnailForEmbededVideo:(UIButton *)sender {

  [self.activityIndicator startAnimating];

  ERDThumbnailHelper *thumbnailHelper = [ERDThumbnailHelper sharedInstance];
  thumbnailHelper.maxThumbnailSize = CGSizeMake(120.f, 120.f);

  __weak __typeof (self) weakSelf = self;
  
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"A-B" ofType:@"mp4"];
  NSURL *fileUrl = [NSURL fileURLWithPath:filePath];

  [thumbnailHelper createVideoThumbnailWithFilePath:fileUrl
                                    completionBlock:^(UIImage *thumbnail, NSError *error) {

                                      dispatch_async(dispatch_get_main_queue(), ^{

                                        if (thumbnail) {

                                          weakSelf.thumbnailView.image = thumbnail;

                                        } else {

                                          weakSelf.thumbnailView.image = nil;
                                          weakSelf.statusMessage.text = [error localizedDescription];
                                          NSLog(@"%s[%d] %@", __PRETTY_FUNCTION__, __LINE__, [error localizedDescription]);
                                        }
                                        
                                        [weakSelf.activityIndicator stopAnimating];
                                        });
                                    }];
}

- (IBAction)fetchThumbnailForStreamingVideo:(UIButton *)sender {
  
  [self.actionButton resignFirstResponder];
  [self.activityIndicator startAnimating];

  ERDThumbnailHelper *thumbnailHelper = [ERDThumbnailHelper sharedInstance];
  thumbnailHelper.maxThumbnailSize = CGSizeMake(120.f, 120.f);

  __weak __typeof (self) weakSelf = self;

  NSURL *videoURL = [NSURL URLWithString:@"http://embed.wistia.com/deliveries/5413caeac5fdf4064a2f9eab5c10a0848e42f19f.bin"];

  [thumbnailHelper createVideoThumbnailWithUrl:videoURL
                                    completionBlock:^(UIImage *thumbnail, NSError *error) {
                                      
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
                                    }];
}

@end
