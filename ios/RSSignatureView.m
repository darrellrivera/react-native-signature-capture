#import "RSSignatureView.h"
#import "RSSignatureViewManager.h"
#import <React/RCTView.h>
#import <React/UIView+React.h>

@implementation RSSignatureView {
  // Internal
  UIBezierPath *_dot;
  UIBezierPath *_path;
  UIImage *_image;
  CGPoint _points[5];
  uint _counter;
}

@synthesize manager;

#pragma mark - UIViewHierarchy methods

- (instancetype)initWithFrame:(CGRect) frame
{
  if ((self = [super initWithFrame:frame])) {
    // Internal setup
    self.multipleTouchEnabled = NO;

    // For borderRadius property to work (CALayer's cornerRadius).
    self.layer.masksToBounds = YES;

    self.backgroundColor = [UIColor clearColor];

    _dot = [UIBezierPath bezierPath];
    _path = [UIBezierPath bezierPath];
    _path.lineWidth = 5;
  }

  return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)initWithCoder:(NSCoder *)aDecoder)

#pragma mark - UIResponder methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  _counter = 0;
  UITouch *touch = [touches anyObject];
  _points[0] = [touch locationInView:self];

  [self drawDot];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  _counter++;
  UITouch *touch = [touches anyObject];
  _points[_counter] = [touch locationInView:self];

  if (_counter == 4) [self drawCurve];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self drawBitmap];
  [self setNeedsDisplay];

  [_dot removeAllPoints];
  [_path removeAllPoints];
  _counter = 0;

  // Send event
  [self.manager publishDraggedEvent];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self touchesEnded:touches withEvent:event];
}

#pragma mark - UIViewRendering methods

- (void)drawRect:(CGRect)rect
{
  [_image drawInRect:rect];
  [_strokeColor setFill];
  [_dot fill];
  [_strokeColor setStroke];
  [_path stroke];
}

#pragma mark - Drawing methods

- (void)drawDot
{
  [_dot addArcWithCenter:_points[0] radius:(_path.lineWidth / 2) startAngle:0 endAngle:2 * M_PI clockwise:YES];
  [self setNeedsDisplay];
}

- (void)drawCurve
{
  // Move the endpoint to the middle of the line
  _points[3] = CGPointMake((_points[2].x + _points[4].x) / 2, (_points[2].y + _points[4].y) / 2);

  [_path moveToPoint:_points[0]];
  [_path addCurveToPoint:_points[3] controlPoint1:_points[1] controlPoint2:_points[2]];

  [self setNeedsDisplay];

  // Replace points and get ready to handle the next segment
  _points[0] = _points[3];
  _points[1] = _points[4];
  _counter = 1;
}

- (void)drawBitmap
{
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);

  // Draw with context
  [_image drawAtPoint:CGPointZero];
  [_strokeColor setFill];
  [_dot fill];
  [_strokeColor setStroke];
  [_path stroke];
  _image = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();
}

#pragma mark - Clear drawing

- (void)erase
{
  _image = nil;

  [self drawBitmap];
  [self setNeedsDisplay];
}

#pragma mark - Setters

- (void)setStrokeColor:(UIColor *)strokeColor
{
  _strokeColor = strokeColor;
}

@end
