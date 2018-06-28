#import "RSSignatureView.h"
#import <React/RCTConvert.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PPSSignatureView.h"
#import "RSSignatureViewManager.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@implementation RSSignatureView {
	CAShapeLayer *_border;
	BOOL _loaded;
	EAGLContext *_context;
}

@synthesize sign;
@synthesize manager;

- (instancetype)init
{
	self = [super init];
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (!_loaded) {

		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

		CGSize screen = self.bounds.size;

		sign = [[PPSSignatureView alloc]
						initWithFrame: CGRectMake(0, 0, screen.width, screen.height)
						context: _context];
		sign.backgroundColor = self.backgroundColor;
        sign.strokeColor = self.strokeColor;
		sign.manager = manager;

		[self addSubview:sign];
	}
	_loaded = true;
}

-(void) saveImage {
	UIImage *signImage = [self.sign signatureImage];

	NSError *error;

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths firstObject];
	NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/signature.png"];

	//remove if file already exists
	if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
		if (error) {
			NSLog(@"Error: %@", error.debugDescription);
		}
	}

	// Convert UIImage object into NSData (a wrapper for a stream of bytes) formatted according to PNG spec
	NSData *imageData = UIImagePNGRepresentation(signImage);
	BOOL isSuccess = [imageData writeToFile:tempPath atomically:YES];
	if (isSuccess) {
		NSFileManager *man = [NSFileManager defaultManager];
		NSDictionary *attrs = [man attributesOfItemAtPath:tempPath error: NULL];
		//UInt32 result = [attrs fileSize];

		NSString *base64Encoded = [imageData base64EncodedStringWithOptions:0];
		[self.manager publishSaveImageEvent: tempPath withEncoded:base64Encoded];
	}
}

-(void) erase {
	[self.sign erase];
}

@end
