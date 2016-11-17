
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SVGKit.h"

@interface MapSvgHelper : NSObject

/**
 *  根据实际的点的位置获取界面上对应的点的CGRect
 *
 *  @param point 对应的实际的点
 *  @param zoomScale 当前缩放的级别
 *
 *  @return 返回界面上对应的点的位置
 */
+(CGRect)p_getObsolutePointCGRect:(CGPoint)point scale:(CGSize)zoomScale;

/**
 *  画线段从起始点到结束点
 *
 *  @param sPoint    起始点
 *  @param ePoint    结束点
 *  @param imgView   对应画点的view
 *  @param zoomScale 实际大小和显示的缩放大小
 */
+(void)p_drawLineFrom:(CGPoint)sPoint to:(CGPoint)ePoint withImgView:(UIImageView *)imgView andScale:(CGSize)zoomScale;


/**
 *  获取选中元素所在区域的CGRect
 *
 *  @param element 选中的元素
 *  @param contentView 所在区域
 *
 *  @return 选中元素的CGRect
 */
+(CGRect)p_getCGRectOfSelectedElement:(Element *)element ofContent:(SVGKFastImageView *)contentView;


/**
 *  根据选中的SVGKImage所对应的layer获取相应的元素
 *
 *  @param hitedLayer  选中的SVGKImage所对应的layer
 *  @param contentView svgView
 *
 *  @return 返回对应的layer获取到的相应的元素
 */
+(Element *)getHitedElementOfLayer:(CALayer *)hitedLayer inContent:(SVGKFastImageView *)contentView;


/**
 *  找到最短的一条路径
 *
 *  @param pathArray 所有可能的路径
 *
 *  @return 返回最短的路径
 */
+(NSString *)findShortestFromAllPath:(NSArray *)pathArray;

@end
