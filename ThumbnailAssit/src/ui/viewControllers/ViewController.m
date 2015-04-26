//
//  ViewController.m
//  ThumbnailAssit
//
//  Created by Jerry Edens on 4/22/15.
//  Copyright (c) 2015 Jerry Edens. All rights reserved.
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

- (IBAction)fetchThumbnail:(id)sender {
  
  [self.actionButton resignFirstResponder];
  [self.activityIndicator startAnimating];
  
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"A-B" ofType:@"mp4"];
  // Make sure you pass in a fileURL
  NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
  
  ERDThumbnailHelper *thumbnailHelper = [ERDThumbnailHelper sharedInstance];
  thumbnailHelper.maxThumbnailSize = CGSizeMake(120.f, 120.f);
  
  __weak __typeof (self) weakSelf = self;
  [thumbnailHelper createVideoThumbnailWithFilePath:fileUrl
                                    completionBlock:^(UIImage *thumbnail, NSError *error) {
                                      
                                      if (thumbnail) {
                                        
                                        weakSelf.thumbnailView.image = thumbnail;
                                        
                                      } else {
                                        
                                        weakSelf.thumbnailView.image = nil;
                                        weakSelf.statusMessage.text = [error localizedDescription];
                                        NSLog(@"%s[%d] %@", __PRETTY_FUNCTION__, __LINE__, [error localizedDescription]);
                                      }
                                      
                                      [weakSelf.activityIndicator stopAnimating];
                                    }];
}

@end
