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
	UILabel *titleLabel;
	BOOL _rotateClockwise;
	BOOL _square;
	BOOL _showTitleLabel;
}

@synthesize sign;
@synthesize manager;

- (instancetype)init
{
	_showTitleLabel = YES;
	self = [super init];
	return self;
}

- (void) didRotate:(NSNotification *)notification {
	int ori=1;
	UIDeviceOrientation currOri = [[UIDevice currentDevice] orientation];
	if ((currOri == UIDeviceOrientationLandscapeLeft) || (currOri == UIDeviceOrientationLandscapeRight)) {
		ori=0;
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (!_loaded) {

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:)
																								 name:UIDeviceOrientationDidChangeNotification object:nil];

		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

		CGSize screen = self.bounds.size;

		sign = [[PPSSignatureView alloc]
						initWithFrame: CGRectMake(0, 0, screen.width, screen.height)
						context: _context];
		sign.backgroundColor = self.backgroundColor;
        sign.strokeColor = self.strokeColor;
		sign.manager = manager;

		[self addSubview:sign];

		if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {

			if (_showTitleLabel) {
				titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 24)];
				[titleLabel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 120)];

				[titleLabel setText:@"x_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _"];
				[titleLabel setLineBreakMode:NSLineBreakByClipping];
				[titleLabel setTextAlignment: NSTextAlignmentCenter];
				[titleLabel setTextColor:[UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f]];
				//[titleLabel setBackgroundColor:[UIColor greenColor]];
				[sign addSubview:titleLabel];
			}
		}
		else {

			if (_showTitleLabel) {
				titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height - 80, 24)];
				[titleLabel setCenter:CGPointMake(40, self.bounds.size.height/2)];
				[titleLabel setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90))];
				[titleLabel setText:@"x_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _"];
				[titleLabel setLineBreakMode:NSLineBreakByClipping];
				[titleLabel setTextAlignment: NSTextAlignmentLeft];
				[titleLabel setTextColor:[UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f]];
				//[titleLabel setBackgroundColor:[UIColor greenColor]];
				[sign addSubview:titleLabel];
			}
		}

	}
	_loaded = true;
}

- (void)setRotateClockwise:(BOOL)rotateClockwise {
	_rotateClockwise = rotateClockwise;
}

- (void)setSquare:(BOOL)square {
	_square = square;
}

- (void)setShowTitleLabel:(BOOL)showTitleLabel {
	_showTitleLabel = showTitleLabel;
}

-(void) saveImage {
	UIImage *signImage = [self.sign signatureImage: _rotateClockwise withSquare:_square];

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
