//
//  ERDThumbnailHelper.h
//
//  Created by Cecil Edens on 3/26/14.
//  Copyright (c) 2014 Edens R&D. All rights reserved.
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

#import <Foundation/Foundation.h>
@import UIKit;

/**
 *  The block that is executed after the thumbnail call is completed.
 *
 *  @param thumbnail The thumbnail image if successful otherwise nil
 *  @param error     nil if no error otherwise it will ba valid error object.
 */
typedef void(^thumbnailCompletionBlock)(UIImage *thumbnail, NSError *error);


@interface ERDThumbnailHelper : NSObject

/**
 The default value is 60, 60
 */
@property (assign, nonatomic) CGSize maxThumbnailSize;

/**
 sharedInstance
 @param This method returns the singleton instance for this class
 @return An initialized instance of the object
 */
+ (instancetype)sharedInstance;

- (void)createVideoThumbnailWithFilePath:(NSURL *)videoPath completionBlock:(thumbnailCompletionBlock)completion;

@end
