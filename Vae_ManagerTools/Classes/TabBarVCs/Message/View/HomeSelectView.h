//
//  HomeSelectView.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2017/10/10.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeSelectModel;
typedef void (^SelectBlock)(NSInteger index);
@interface HomeSelectView : UITableViewHeaderFooterView
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) SelectBlock selectBlock;
@end
@interface HomeSelectModel: NSObject
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,copy) NSString * name;
@end
@interface HomeSelectCell: UICollectionViewCell
@property (nonatomic,strong) HomeSelectModel * model;
@end
