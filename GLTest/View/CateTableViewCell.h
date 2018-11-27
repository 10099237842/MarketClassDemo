//
//  CateTableViewCell.h
//  GLTest
//
//  Created by cendi on 2018/11/7.
//  Copyright © 2018 cendi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

///
@property (nonatomic,assign)BOOL select;
@end

NS_ASSUME_NONNULL_END
