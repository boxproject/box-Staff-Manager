//
//  SearchCurrencyTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchCurrencyTableViewCell.h"

@interface SearchCurrencyTableViewCell()

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIImageView *rightIcon;

@end

@implementation SearchCurrencyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

-(void)createView
{
    _titleLab = [[UILabel alloc]init];
    _titleLab.font = Font(14);
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.right.offset(-80);
        make.bottom.offset(0);
    }];
    
    _rightIcon = [[UIImageView alloc] init];
    _rightIcon.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLab);
        make.right.offset(-15);
        make.height.offset(13);
        make.width.offset(18);
    }];
    _rightIcon.hidden = YES;
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
}

- (void)setDataWithModel:(CurrencyModel *)model
{
    _titleLab.text = model.currency;
    if (model.select) {
        if (model.state == 1) {
            _rightIcon.image = [UIImage imageNamed:@"icon_check after"];
             _rightIcon.hidden = NO;
        }else if (model.state == 2){
            _rightIcon.image = [UIImage imageNamed:@"icon_check before"];
            _rightIcon.hidden = NO;
        }else{
            _rightIcon.hidden = YES;
        }
    }else{
        _rightIcon.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
