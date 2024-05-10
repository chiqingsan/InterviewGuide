import { router } from '@kit.ArkUI'
import { BasicConstant } from '../constants/BasicConstant'
import { Logger } from '../utils/Logger'

@Component
export struct HdSearch {
  @State
  readonlyMode: boolean = true
  @StorageProp("categoryTitle") categoryTitle: string[] = []
  @State ph: string = ''
  bg: string = ''
  color: string = ''
  index: number = 0

  aboutToAppear(): void {
    setInterval(() => {
      if (this.categoryTitle.length !== 0) {
        this.ph = this.categoryTitle[this.index]
        this.index >= this.categoryTitle.length - 1 ? this.index = 0 : this.index++
      }
    }, 3000)
  }

  build() {
    Row() {
      Row({ space: 6 }) {
        Image($r("app.media.ic_common_search"))
          .width($r('app.float.hd_search_icon_size'))
          .aspectRatio(1)
          .fillColor(this.color || $r('app.color.common_gray_02'))
        Text(this.ph || $r('app.string.hd_search_placeholder'))
          .fontColor(this.color || $r('app.color.common_gray_02'))
          .fontSize($r('app.float.common_font14'))
      }
      .layoutWeight(1)
      .height($r('app.float.hd_search_height'))
      .backgroundColor(this.bg || $r('app.color.common_gray_border'))
      .borderRadius($r('app.float.hd_search_radius'))
      .justifyContent(FlexAlign.Center)
    }.onClick(() => {
      router.pushUrl({
        url: BasicConstant.PAGE_SearchPage,
        params: {
          title: this.ph
        }
      })
    })
  }
}