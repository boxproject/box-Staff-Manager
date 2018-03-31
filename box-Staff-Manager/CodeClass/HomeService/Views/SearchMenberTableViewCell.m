//
//  SearchMenberTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchMenberTableViewCell.h"

@interface SearchMenberTableViewCell()

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *subTitleLab;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation SearchMenberTableViewCell

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
        make.top.offset(11);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    _subTitleLab = [[UILabel alloc]init];
    _subTitleLab.font = Font(12);
    _subTitleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_subTitleLab];
    [_subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.mas_bottom).offset(4);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(17);
    }];
    
    
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

- (void)setDataWithModel:(SearchMenberModel *)model;
{
    _titleLab.text = model.titleName;
    _subTitleLab.text = model.subTitle;
    
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
