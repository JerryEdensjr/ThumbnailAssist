//
//  ERDThumbnailHelper.m
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

#import "ERDThumbnailHelper.h"
#import <AVFoundation/AVFoundation.h>
@import MediaPlayer;


@interface ERDThumbnailHelper() {

  NSCache *_cache;
}

@property (copy, nonatomic) thumbnailCompletionBlock completion;

@end


@implementation ERDThumbnailHelper

- (void)createVideoThumbnailWithFilePath:(NSURL *)videoPath
                     completionBlock:(thumbnailCompletionBlock)completion {

  @synchronized(self) {
    
    if (!_cache) {
      
      _cache = [[NSCache alloc] init];
    }
    
    if ([_cache objectForKey:[videoPath absoluteString]]) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        completion([_cache objectForKey:[videoPath absoluteString]], nil);
      });
      return;
    }
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoPath];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    CMTime thumbTime = CMTimeMakeWithSeconds(0, 15);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime,
                                                       CGImageRef imgRef,
                                                       CMTime actualTime,
                                                       AVAssetImageGeneratorResult result,
                                                       NSError *error) {
      
      if (result != AVAssetImageGeneratorSucceeded) {
        
        if (completion) {
          
          // on Error pass nil for image and initialized error object
          dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(nil, error);
          });
        }
        
      } else if (completion) {
        
        UIImage *image = [UIImage imageWithCGImage:imgRef];
        [_cache setObject:image forKey:[videoPath absoluteString]];
        // on success pass in the image and nil for the error object
        dispatch_async(dispatch_get_main_queue(), ^{
          
          completion(image, nil);
        });
      }
    };
    
    CGSize maxSize = CGSizeZero;
    if (self.maxThumbnailSize.width == 0 || self.maxThumbnailSize.height == 0) {
      
      maxSize = CGSizeMake(60.f, 60.f);
      
    } else {

      maxSize = self.maxThumbnailSize;
    }
    
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]]
                                    completionHandler:handler];
  }
}

- (void)createVideoThumbnailWithUrl:(NSURL *)videoURL completionBlock:(thumbnailCompletionBlock)completion {

  @synchronized(self) {

    if (!_cache) {

      _cache = [[NSCache alloc] init];
    }

    if ([_cache objectForKey:[videoURL absoluteString]]) {

      dispatch_async(dispatch_get_main_queue(), ^{

        completion([_cache objectForKey:[videoURL absoluteString]], nil);
      });
      return;
    }
  }

  AVURLAsset *asset=[AVURLAsset URLAssetWithURL:videoURL options:nil];
  AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  generator.appliesPreferredTrackTransform = YES;

  CMTime thumbTime = CMTimeMakeWithSeconds(0,1.0);
  
  AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime,
                                                     CGImageRef im,
                                                     CMTime actualTime,
                                                     AVAssetImageGeneratorResult result,
                                                     NSError *error){
    if (result != AVAssetImageGeneratorSucceeded) {

      NSLog(@"couldn't generate thumbnail, error:%@", error);
      completion(nil, error);

    } else {

      UIImage *thumbImg= [UIImage imageWithCGImage:im];
      [_cache setObject:thumbImg forKey:[videoURL absoluteString]];
      completion(thumbImg, nil);
    }
  };
  
  [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:thumbTime]]
                                  completionHandler:handler];

}

#pragma mark - Life Cycle

+ (instancetype)sharedInstance {
  
  static id this = nil;
  
  if (this == nil) {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      
      this = [[ERDThumbnailHelper alloc] init];
    });
  }
  
  return this;
}

@end
