//
//  organizationListTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "organizationListTableViewCell.h"

@interface organizationListTableViewCell()

@property (nonatomic,strong) UILabel *nameTitleLab;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation organizationListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}


-(void)createView
{
    _nameTitleLab = [[UILabel alloc]init];
    _nameTitleLab.font = Font(15);
    _nameTitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_nameTitleLab];
    [_nameTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(0);
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

- (void)setDataWithModel:(OrganizationListModel *)model
{
    if ([model.subTitle integerValue] == 0) {
        _nameTitleLab.text = model.titleName;
    }else{
        NSString *subTitle = [NSString stringWithFormat:@" (%@)",model.subTitle];
        NSString *titleStr = [NSString stringWithFormat:@"%@%@", model.titleName, subTitle];
        _nameTitleLab.text = titleStr;
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
