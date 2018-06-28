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

-(void) erase {
	[self.sign erase];
}

@end
