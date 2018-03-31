//
//  TBView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TBView.h"
 

@implementation TBView

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title;
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *img = [[UIImageView alloc] init];
        img.image = image;
        [self addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.centerX.equalTo(self);
            make.width.offset(27);
            make.height.offset(27);
        }];
        
        UILabel *laber = [[UILabel alloc] init];
        laber.text = title;
        laber.font= Font(14);
        laber.textAlignment = NSTextAlignmentCenter;
        laber.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:laber];
        [laber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img.mas_bottom).offset(7);
            make.left.offset(0);
            make.right.offset(0);
            make.height.offset(20);
        }];
    }
    return self;
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
