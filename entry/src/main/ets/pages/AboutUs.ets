import { TopBar } from '../common/components/TopBar';

@Entry
@Component
struct AboutUs {
  @StorageProp("topHeight") topHeight: number = 0

  build() {
    Column() {
      TopBar({ barTitle: "关于我们" })
        .backgroundColor("#fff")
      Column() {
        Image($r("app.media.startIcon"))
          .width(55)
          .borderRadius(99)
        Text($r("app.string.EntryAbility_label"))
          .fontSize(19)
          .fontColor("#121826")
          .fontWeight(500)
          .margin(12)
        Text($r("app.string.Subheading"))
          .fontColor("#6F6F6F")
          .fontSize(14)
        Text("版本号：V1.0")
          .margin(18)
          .fontSize(14)
          .fontColor("#979797")
      }.padding({ top: 65 }).backgroundColor("#F6F7F9").layoutWeight(1).width("100%")
    }
    .width("100%")
    .height("100%")
    .padding({ top: this.topHeight })
  }
}