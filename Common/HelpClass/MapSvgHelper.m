

#import "MapSvgHelper.h"

@implementation MapSvgHelper

+(CGRect)p_getObsolutePointCGRect:(CGPoint)point scale:(CGSize)zoomScale{
    CGRect pCGRect=CGRectMake(point.x, point.y, 1, 1);
    CGSize scaleConvertImageToView = zoomScale;
    pCGRect=CGRectApplyAffineTransform(pCGRect, CGAffineTransformMakeScale(scaleConvertImageToView.width, scaleConvertImageToView.height));
    return pCGRect;
}


+(void)p_drawLineFrom:(CGPoint)sPoint to:(CGPoint)ePoint withImgView:(UIImageView *)imgView andScale:(CGSize)zoomScale{
    CGRect startPCGRect=[MapSvgHelper p_getObsolutePointCGRect:sPoint scale:zoomScale];
    CGRect endPCGRect=[MapSvgHelper p_getObsolutePointCGRect:ePoint scale:zoomScale];
    UIGraphicsBeginImageContext(imgView.frame.size);
    [imgView.image drawInRect:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.5);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 68/255.0, 52/255.0, 24/255.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startPCGRect.origin.x, startPCGRect.origin.y);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),endPCGRect.origin.x, endPCGRect.origin.y);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imgView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


+(CGRect)p_getCGRectOfSelectedElement:(Element *)element ofContent:(SVGKFastImageView *)contentView{
    NSString *identity=[element getAttribute:@"id"];
    SVGKImage *svgImage=((SVGKFastImageView*)contentView).image;
    CALayer *cloneLayer = [svgImage newCopyPositionedAbsoluteLayerWithIdentifier:identity];
    return cloneLayer.frame;
}

/**
 *  根据选中的SVGKImage所对应的layer获取相应的元素
 *
 *  @param hitedLayer 选中的SVGKImage所对应的layer
 *  @return 返回对应的layer获取到的相应的元素
 */
+(Element *)getHitedElementOfLayer:(CALayer *)hitedLayer inContent:(SVGKFastImageView *)contentView{
    SVGKImage *svgImage=((SVGKFastImageView*)contentView).image;//获取到svg图片
    //获取SVGDocument
    SVGDocument *domDocument=svgImage.DOMDocument;
    NSString *xmlTagID = [hitedLayer valueForKey:kSVGElementIdentifier];
    Element *svgElement = [domDocument getElementById:xmlTagID];
    //    if([svgElement isKindOfClass:[SVGPathElement class]]){
    //        svgPathElement=(SVGPathElement *)svgElement;
    //    }
    return svgElement;
}

+(NSString *)findShortestFromAllPath:(NSArray *)pathArray{
    NSString *shortestPath=pathArray.firstObject;
    for(NSString *singlePath in pathArray){
        if([shortestPath componentsSeparatedByString:@","].count>[singlePath componentsSeparatedByString:@","].count){
            shortestPath=singlePath;
        };
    }
    return shortestPath;
}

@end
