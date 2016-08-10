#<center>Thumbnail Assist</center>

ThumbnailAssist was developed to fullfil a need to display thumbnails for viewable videos. The videos can be embeded in the App or they can exist as streaming videos.  So, there are two methods on the helper class, one for embeded videos and another for streaming videos.

*Note* This method does not work on Youtube videos.

####API
Objective-c

```
**
 *  The completion block declaration which, is implemented as a callback to be executed
 *  after the thumbnail call has completed.
 *
 *  @param thumbnail The thumbnail image if successful otherwise nil
 *  @param error     nil if no error otherwise it will ba valid error object.
 */
typedef void(^thumbnailCompletionBlock)(UIImage *thumbnail, NSError *error);

_______________________________________________________________________________________

/**
 *  @breif Creates a thumbnail for the video referenced by the file URL.
 *
 *  @param videoPath  The file path url to the video
 *  @param completion The completion block that is called when all work is done.
 */
- (void)createVideoThumbnailWithFilePath:(NSURL *)videoPath completionBlock:(thumbnailCompletionBlock)completion;
_______________________________________________________________________________________

/**
 *  @breif Creates a thumbnail for the video referenced by the URL.
 *
 *  @param videoURL   The URL to the video
 *  @param completion The completion block that is called upon creation of the thumbnail
 */
- (void)createVideoThumbnailWithUrl:(NSURL *)videoURL completionBlock:(thumbnailCompletionBlock)completion;
```

####Usage
**Define the completion block** as it will be used from more than one location in the file.
Objective-c

```
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

```

Objective-c

```
  // Step 1: Create the thumbnail helper
  ERDThumbnailHelper *thumbnailHelper = [ERDThumbnailHelper sharedInstance];
  // Step 2: [Optional] Set the desired size of the thumbnail
  thumbnailHelper.maxThumbnailSize = CGSizeMake(120.f, 120.f);

  // Step 3: Create the NSURL for the video
  NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"A-B" withExtension:@"mp4"];

  // Step 4: Send message to the thumbnail helper to have it create the thumbnail.
  [thumbnailHelper createVideoThumbnailWithFilePath:fileUrl
                                    completionBlock:[self completionBlock]];
```

####Sample Code


