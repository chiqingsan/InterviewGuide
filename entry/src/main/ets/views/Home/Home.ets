import { HdClockIn } from '../../common/components/HdClockIn'
import { HdSearch } from '../../common/components/HdSearch'
import { test } from '../../pages/test'

@Entry
@Component
export struct Home {
  @StorageProp("topHeight") topHeight: number = 0

  build() {
    Column() {
      Row({ space: 10 }) {
        HdSearch()
          .layoutWeight(1)
        HdClockIn()
      }
      .height(52)

      Swiper() {
        Image($r('app.media.banner_qa'))
          .objectFit(ImageFit.Contain)

        Image($r('app.media.banner_pj'))
          .objectFit(ImageFit.Contain)

        Image($r('app.media.banner_ai'))
          .objectFit(ImageFit.Contain)
      }
      .height(130)
      .autoPlay(true)
      .indicator(false)


      Tabs() {
        ForEach(
          Array.from(({ length: 10 })),
          (item: string, index) => {
            TabContent() {
              Column() {
                Text("首页")
                test()
                Text(index.toString())
                Text(Math.random().toString())
              }
            }.tabBar(this.tabsItem())
          }
        )
      }
      .barHeight(50)
      .scrollable(false)
      .barMode(BarMode.Scrollable)

    }
    .width("100%")
    .height("100%")
    .padding({ top: this.topHeight, left: 15, right: 15 })
  }

  @Builder
  tabsItem() {
    Row() {
      Column() {
        Text("全部")
          .fontSize(14)
          .fontColor("#979797")
          .padding({ top: 15, bottom: 13 })
        // .fontColor("#ccc")
        Divider()
          .width(25)
          .strokeWidth(2)
      }

      if (true) {
        Image($r("app.media.ic_home_new"))
          .height(14)
          .margin({ left: 4 })
      }
    }
    .justifyContent(FlexAlign.Center)
    .padding({ right: 15 })

  }
}