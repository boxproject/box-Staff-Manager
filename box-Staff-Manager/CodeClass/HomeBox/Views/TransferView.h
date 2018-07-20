//
//  TransferView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline UIViewAnimationOptions UIViewAnimationCurveToAnimationOptions(UIViewAnimationCurve curve)
{
    return curve << 16;
}

@protocol TransferViewDelegate <NSObject>

@optional
- (void)transferViewDelegate:(NSDictionary *)dic password:(NSString *)password;
- (void)transferDidAchieve;
@end

@interface TransferView : UIView

@property (nonatomic,weak) id <TransferViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic flowName:(NSString *)flowName;
-(void)createAchieveView;

@end
