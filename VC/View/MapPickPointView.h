//
//  MapPickPointView.h
//  svgDemo
//
//  Created by GB on 16/9/27.
//  Copyright © 2016年 hhys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGPointObj.h"

@interface MapPickPointView : UIView

@property(nonatomic,assign)BOOL isSaved;//标志选择的点是否保存
@property(nonatomic,strong)NSString *indexTitle;//标定的点的index
@property(nonatomic,strong)CGPointObj *cgpointObj;

-(instancetype)initWithFrame:(CGRect)frame isSaved:(BOOL)isSaved title:(NSString *)title;

@end
