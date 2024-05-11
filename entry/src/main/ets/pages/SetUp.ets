import { TopBar } from '../common/components/TopBar'
import { iLoginDataModel } from '../models/UserData'

interface Tool {
  icon: ResourceStr
  name: string
  value?: string
  onClick?: () => void
}


@Entry
@Component
struct SetUp {
  @StorageProp('topHeight') topHeight: number = 0
  @StorageProp("user") user: iLoginDataModel = {} as iLoginDataModel

  @Builder
  setUpNav(tool: Tool, fn?: () => void) {
    Row() {
      Image(tool.icon)
        .width(16)
        .aspectRatio(1)
        .margin({ right: 12 })
        .fillColor("#101010")
      Text(tool.name)
        .fontSize(14)
        .fontWeight(600)
      Blank()
      if (tool.value) {
        if (tool.value.includes("http")) {
          Image(tool.value)
            .width(32)
            .aspectRatio(1)
            .borderRadius(99)
        } else {
          Text(tool.value)
            .fontSize(11)
            .fontColor($r('app.color.common_gray_01'))
        }
      }
      Image($r('app.media.icon_right'))
        .width(14)
        .aspectRatio(1)
        .fillColor($r('app.color.common_gray_01'))
        .margin({ left: 8 })
    }
    .height(50)
    .width('100%')
    .padding({ left: 16, right: 10 })
    .onClick(() => {
      fn && fn()
    })
  }

  build() {
    Column() {
      TopBar({ barTitle: "设置" })

      Column() {
        Column() {
          this.setUpNav({ icon: $r("app.media.ic_tabbar_mine"), name: "账号管理", value: this.user.avatar })
          this.setUpNav({ icon: $r("app.media.shouji"), name: "手机号码", value: "176******00" })
          this.setUpNav({ icon: $r("app.media.anquan"), name: "账号安全" })
        }
        .backgroundColor(Color.White)
        .borderRadius(5)
        .margin({ left: 15, right: 15, top: 15 })

        Column() {
          this.setUpNav({ icon: $r("app.media.xiaoxizhongxin"), name: "消息通知" })
          this.setUpNav({ icon: $r("app.media.huakuai"), name: "通用" })
          this.setUpNav({ icon: $r("app.media.gongnengkaiguan"), name: "应用功能" })
        }
        .backgroundColor(Color.White)
        .borderRadius(5)
        .margin({ left: 15, right: 15, top: 15 })

        Column() {
          this.setUpNav({ icon: $r("app.media.wjxg"), name: "个人信息收集清单" })
          this.setUpNav({ icon: $r("app.media.jinggao"), name: "关于面试宝典与帮助" })
        }
        .backgroundColor(Color.White)
        .borderRadius(5)
        .margin({ left: 15, right: 15, top: 15 })

      }.backgroundColor("#F5F5F5").height("100%").width("100%")
    }.padding({ top: this.topHeight + 5 })
  }
}