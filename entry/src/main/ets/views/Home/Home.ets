import { HdClockIn } from '../../common/components/HdClockIn'
import { HdSearch } from '../../common/components/HdSearch'
import { test } from '../../pages/test'
import { router } from '@kit.ArkUI'

@Entry
@Component
export struct Home {
  @StorageProp("topHeight") topHeight: number = 0
  @State tabsIndex: number = 0

  // @State tabsTitle:
  build() {
    Column() {
      Row({ space: 10 }) {
        // 搜索框组件
        HdSearch()
          .layoutWeight(1)
        // 打卡组件
        HdClockIn()
          .onClick(() => {
            router.pushUrl({
              url: "pages/ClockPage"
            })
          })
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
            }.tabBar(this.tabsItem("全部", index))
          }
        )
      }
      .barHeight(50)
      .scrollable(false)
      .barMode(BarMode.Scrollable)
      .onTabBarClick((index) => {
        this.tabsIndex = index
      })

    }
    .width("100%")
    .height("100%")
    .padding({ top: this.topHeight, left: 15, right: 15 })
  }

  @Builder
  tabsItem(substance: string, index: number) {
    Row() {
      Column() {
        Text(substance)
          .fontSize(14)
          .fontColor(this.tabsIndex === index ? "#121826" : "#979797")
          .padding({ top: 15, bottom: 13 })
        // .fontColor("#ccc")
        Divider()
          .width(25)
          .strokeWidth(2)
          .color("#121826")
          .opacity(this.tabsIndex === index ? 1 : 0)
          .animation({
            duration: 200,
            curve: Curve.EaseInOut
          })
      }

      if (true) {
        Image($r("app.media.ic_home_new"))
          .height(14)
          .margin({ left: 4 })
      }
    }
    .justifyContent(FlexAlign.Center)
    .padding({ left: index && 15, right: 15 })

  }
}