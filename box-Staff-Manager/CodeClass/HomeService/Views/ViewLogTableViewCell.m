//
//  ViewLogTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ViewLogTableViewCell.h"

@interface ViewLogTableViewCell()

@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *rightLab;
@property (nonatomic,strong) UILabel *bottomLab;

@end

@implementation ViewLogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

-(void)createView
{
    _leftLab = [[UILabel alloc]init];
    _leftLab.font = Font(13);
    _leftLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_leftLab];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(15);
        make.height.offset(18);
    }];
    
    _rightLab = [[UILabel alloc]init];
    _rightLab.font = Font(13);
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.right.offset(-15);
        make.height.offset(18);
    }];
    
    _bottomLab = [[UILabel alloc]init];
    _bottomLab.font = Font(13);
    _bottomLab.textAlignment = NSTextAlignmentLeft;
    _bottomLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_bottomLab];
    [_bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftLab.mas_bottom).offset(5);
        make.right.offset(-15);
        make.left.offset(15);
        make.height.offset(18);
    }];
}

- (void)setDataWithModel:(ViewLogModel *)model
{
    if (model.FinalProgress == ApprovalAwait) {
        _leftLab.text = [NSString stringWithFormat:@"%@%@", model.Operator, InitiateApplication];
        _rightLab.text = [self getElapseTimeToString:model.OpTime];
    }else if (model.FinalProgress == ApprovalFail){
        if ([model.Operator isEqualToString:@""]) {
            _leftLab.text = SystemApprovalFail;
            _rightLab.text = [self getElapseTimeToString:model.OpTime];
        }else{
            [self handleProgress:model];
        }
        
    }else if (model.FinalProgress == ApprovalSucceed){
        if ([model.Operator isEqualToString:@""]) {
            _leftLab.text = SystemApprovalSucceed;
            _rightLab.text = [self getElapseTimeToString:model.OpTime];
        }else{
            [self handleProgress:model];
        }
    }else if (model.FinalProgress == ApprovalTransferCancel){
        if ([model.Operator isEqualToString:@""]) {
            _leftLab.text = SystemTransferCancel;
            _rightLab.text = [self getElapseTimeToString:model.OpTime];
        }
    }else if (model.FinalProgress == ApprovalCancel){
        if (![model.Operator isEqualToString:@""]) {
            [self handleProgress:model];
        }
    }
    else if (model.FinalProgress == Approvaling){
        [self handleProgress:model];
    }
}

-(void)handleProgress:(ViewLogModel *)model
{
    switch (model.Progress) {
        case ApprovalFail:
        {
            NSString *str = [NSString stringWithFormat:@"%@%@", model.Operator, ApprovalBusinessFail];
            NSMutableAttributedString *strHolder = [[NSMutableAttributedString alloc] initWithString:str];
            [strHolder addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor]
                              range:NSMakeRange(model.Operator.length, str.length - model.Operator.length)];
            _leftLab.attributedText = strHolder;
            _bottomLab.text = [NSString stringWithFormat:@"%@：%@", Reason, model.ReasonStr];
            _rightLab.text = [self getElapseTimeToString:model.OpTime];
            break;
        }
        case ApprovalSucceed:
        {
            _leftLab.text = [NSString stringWithFormat:@"%@%@", model.Operator, ApprovalBusinessSucceed];
            _rightLab.text = [self getElapseTimeToString:model.OpTime];
            break;
        }
        case ApprovalCancel:
        {
            if (![model.Operator isEqualToString:@""]) {
                NSString *str = [NSString stringWithFormat:@"%@%@", model.Operator, TransferCancel];
                NSMutableAttributedString *strHolder = [[NSMutableAttributedString alloc] initWithString:str];
                [strHolder addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor redColor]
                                  range:NSMakeRange(model.Operator.length, str.length - model.Operator.length)];
                _leftLab.attributedText = strHolder;
                _bottomLab.text = [NSString stringWithFormat:@"%@：%@", Reason, model.ReasonStr];
                _rightLab.text = [self getElapseTimeToString:model.OpTime];
            }
            break;
        }
        default:
            break;
    }
}

+ (CGFloat)defaultHeight:(ViewLogModel *)model
{
    if (model.Progress == ApprovalFail || model.Progress == ApprovalCancel) {
        return 51;
    }else if(model.Progress == ApprovalSucceed){
        return 28;
    }
    return 28;
}

- (NSString *)getElapseTimeToString:(NSInteger)second{
    NSDateFormatter  *dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterval1 = second;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval1];
    NSString *dateStr1=[dateformatter1 stringFromDate:date1];
    return dateStr1;
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
