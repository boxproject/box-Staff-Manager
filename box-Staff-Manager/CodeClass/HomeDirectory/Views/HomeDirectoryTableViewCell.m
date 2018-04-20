//
//  HomeDirectoryTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeDirectoryTableViewCell.h"

@interface HomeDirectoryTableViewCell()

@property (nonatomic,strong) UIImageView *backgdView;
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *nameTitleLab;
@property (nonatomic,strong) UILabel *addressLab;
@property (nonatomic,strong) UILabel *remarkLab;

@end
 
@implementation HomeDirectoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

-(void)createView
{
    _backgdView = [[UIImageView alloc] init];
    _backgdView.layer.cornerRadius = 3.0f;
    _backgdView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backgdView];
    [_backgdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.top.offset(5);
        make.bottom.offset(-5);
    }];
    
    _img = [[UIImageView alloc] init];
    _img.layer.cornerRadius = 35.0/2.0;
    _img.layer.masksToBounds = YES;
    _img.image = [UIImage imageNamed:@"icon_headimage"];
    [_backgdView addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.width.offset(35);
        make.top.offset(21);
        make.height.offset(35);
    }];
    
    _nameTitleLab = [[UILabel alloc]init];
    _nameTitleLab.font = Font(15);
    //_nameTitleLab.textAlignment = NSTextAlignmentLeft;
    _nameTitleLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [_backgdView addSubview:_nameTitleLab];
    [_nameTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(27);
        make.height.offset(21);
        make.left.equalTo(_img.mas_right).offset(12);

    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [_backgdView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameTitleLab);
        make.left.equalTo(_nameTitleLab.mas_right).offset(8);
        make.height.offset(12);
        make.width.offset(1);
    }];
    
    _remarkLab = [[UILabel alloc]init];
    _remarkLab.font = Font(12);
    _remarkLab.textAlignment = NSTextAlignmentLeft;
    _remarkLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [_backgdView addSubview:_remarkLab];
    [_remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right).offset(7);
        make.height.offset(17);
    }];
    
    _addressLab = [[UILabel alloc]init];
    _addressLab.font = Font(11);
    _addressLab.textAlignment = NSTextAlignmentLeft;
    _addressLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [_backgdView addSubview:_addressLab];
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_img.mas_bottom).offset(9);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(16);
    }];
}

- (void)setDataWithModel:(HomeDirectoryModel *)model integer:(NSInteger)integer
{
    _nameTitleLab.text = model.nameTitle;
    _remarkLab.text = model.remark;
    _addressLab.text = model.address;
    NSInteger remainder = (integer+1) % 3;
    switch (remainder) {
        case 1:
        {
            _backgdView.image = [UIImage imageNamed:@"image_adress bg3"];
            break;
        }
        case 2:
        {
            _backgdView.image = [UIImage imageNamed:@"image_adress bg2"];
            break;
        }
        case 0:
        {
            _backgdView.image = [UIImage imageNamed:@"image_adress bg1"];
            break;
        }
        default:
            break;
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
