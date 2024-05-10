import { router } from '@kit.ArkUI'

@Component
export struct TopBar {
  barTitle:string = ""
  build() {
    Stack() {
      Row() {
        Image($r("app.media.icon_left"))
          .width(18)
          .fillColor("#121826")
      }.width("100%")
      .onClick(() => {
        router.back()
      })

      Text(this.barTitle)
        .fontWeight(500)
        .fontSize(18)
        .fontColor("#121826")
    }.height(44).margin({ left: 20, right: 20 })
  }
}