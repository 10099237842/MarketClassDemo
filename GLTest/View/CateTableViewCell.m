//
//  CateTableViewCell.m
//  GLTest
//
//  Created by cendi on 2018/11/7.
//  Copyright © 2018 cendi. All rights reserved.
//

#import "CateTableViewCell.h"

@implementation CateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelect:(BOOL)select
{
    _select = select;
    if (select) {
        _titleLabel.textColor = [UIColor colorWithRed:(52/255.0f) green:(162/255.0f) blue:(252/255.0f) alpha:1.0f];
        _selectView.hidden = NO;
        return;
    }
    _titleLabel.textColor = [UIColor blackColor];
    _selectView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
