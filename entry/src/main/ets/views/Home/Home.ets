import { HdClockIn } from '../../common/components/HdClockIn'
import { HdSearch } from '../../common/components/HdSearch'
import { HomeCategoryComp } from './HomeCategoryComp'
import { BasicConstant } from '../../common/constants/BasicConstant'

@Entry
@Component
export struct Home {
  @StorageProp("topHeight") topHeight: number = 0

  build() {
    Column() {
      Row({ space: 12 }) {
        // 搜索框组件
        HdSearch()
          .layoutWeight(1)

        // 打卡组件
        HdClockIn()

      }
      .height(52)
      .justifyContent(FlexAlign.Center)

      Swiper() {
        Image($r('app.media.banner_qa'))
          .objectFit(ImageFit.Contain)

        Image($r('app.media.banner_pj'))
          .objectFit(ImageFit.Contain)

        Image($r('app.media.banner_ai'))
          .objectFit(ImageFit.Contain)
      }
      .height(140)
      .autoPlay(true)
      .indicator(false)
      .indicator(DotIndicator.dot()
        .selectedColor(Color.White)
        .bottom(BasicConstant.SPACE_SM)
        .itemHeight(BasicConstant.SPACE_SM)
        .selectedItemHeight(BasicConstant.SPACE_SM)
        .itemWidth(BasicConstant.SPACE_MD)
        .selectedItemWidth(BasicConstant.SPACE_MD))

      // 题目列表tabs
      HomeCategoryComp()

    }
    .width("100%")
    .height("100%")
    .padding({ top: this.topHeight, left: 15, right: 15 })
  }
}

