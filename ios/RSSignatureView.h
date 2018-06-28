#import <UIKit/UIKit.h>
#import <React/UIView+React.h>

@class RSSignatureViewManager;

@interface RSSignatureView : UIView
@property (nonatomic, strong) RSSignatureViewManager *manager;
@property (nonatomic, strong) UIColor *strokeColor;
-(void) erase;
@end
