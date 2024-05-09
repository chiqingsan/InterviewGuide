@Entry
@Component
export struct IvSkeleton {
  heightValue: number = 20
  widthValue: number | string = 100
  @State transitionX: string = "-100%"

  build() {
    Stack() {
      Text()
        .backgroundColor($r("app.color.common_gray_bg"))
        .width("100%")
        .height("100%")


      Text()
        .width("100%")
        .height("100%")
        .linearGradient({
          angle: 90,
          colors: [
            ['rgba(255,255,255,0)', 0], // 0%的位置透明
            ['rgba(255,255,255,0.5)', 0.5], // 50%的位置透明度不透明，则translate在移动此Text的时候会看到闪光
            ['rgba(255,255,255,0)', 1]// 100%的位置透明
          ]
        })
        .translate({ x: this.transitionX })
        .onAppear(() => {
          animateTo({
            duration: 1500,
            curve: Curve.EaseInOut,
            iterations: -1
          }, () => {
            this.transitionX = "100%"
          })
        })

    }
    .width(this.widthValue)
    .height(this.heightValue)
    .borderRadius(this.heightValue / 6)
    .clip(true)
  }
}