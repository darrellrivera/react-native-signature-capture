#import "RSSignatureViewManager.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>

@implementation RSSignatureViewManager

@synthesize bridge = _bridge;
@synthesize signView;

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(strokeColor, UIColor)


-(dispatch_queue_t) methodQueue
{
	return dispatch_get_main_queue();
}

-(UIView *)view
{
  if (!self.signView) {
  	self.signView = [[RSSignatureView alloc] initWithFrame:CGRectZero];
    self.signView.manager = self;
  }

  return self.signView;
}

// This methods needs to be called from the main thread so the
// UI can clear out the signature.
RCT_EXPORT_METHOD(resetImage:(nonnull NSNumber *)reactTag) {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.signView erase];
	});
}

-(void) publishDraggedEvent {
	[self.bridge.eventDispatcher
	 sendDeviceEventWithName:@"onDragEvent"
	 body:@{@"dragged": @YES}];
}

@end
