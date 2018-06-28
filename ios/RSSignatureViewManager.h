#import "RSSignatureView.h"
#import <React/RCTViewManager.h>

@interface RSSignatureViewManager : RCTViewManager
@property (nonatomic, strong) RSSignatureView *signView;
-(void) resetImage:(nonnull NSNumber *)reactTag;
-(void) publishDraggedEvent;
@end
