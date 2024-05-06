@Component
export struct FilterButton {
  @Prop
  isActive: boolean = false
  @Prop
  sortValue: number = 0
  @State
  positionX: number = 0
  text: string = ''
  isNew: boolean = false
  isSort: Boolean = false

  build() {
    Button({ type: ButtonType.Normal }) {
      Row({ space: 6 }) {
        Text(this.text)
          .fontSize(12)
          .fontColor(this.isActive ? $r('app.color.common_main_color') : Color.Black)
        if (this.isNew) {
          Image($r('app.media.ic_home_new'))
            .width(32)
            .height(14)
            .alignSelf(ItemAlign.Start)
            .position({ x: this.positionX, y: -5 })
        }
        if (this.isSort) {
          Column() {
            Image($r('sys.media.ohos_ic_public_arrow_up'))
              .size({ width: 12, height: 6 })
              .fillColor(this.sortValue === 20 ? $r('app.color.common_main_color') : Color.Black)
            Image($r('sys.media.ohos_ic_public_arrow_down'))
              .size({ width: 12, height: 6 })
              .fillColor(this.sortValue === 21 ? $r('app.color.common_main_color') : Color.Black)
          }
        }
      }
      .height(30)
      .padding({ left: 10, right: 10 })
      .onAreaChange((_old, now) => {
        this.positionX = Number(now.width) - 24
      })
    }
    .borderRadius(4)
    .padding(0)
    .margin({ right: this.isNew ? 20 : 10, bottom: 10 })
    .backgroundColor($r('app.color.common_gray_bg'))
  }
}