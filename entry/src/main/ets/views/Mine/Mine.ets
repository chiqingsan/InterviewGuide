import { window } from '@kit.ArkUI'

@Entry
@Component
export struct Mine {
  // 进入我的页面后, 把状态栏字体颜色设置为白色
  aboutToAppear(): void {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({
          statusBarContentColor: "#ffffff"
        })
      })
  }

  // 离开我的页面后, 把状态栏字体颜色设置为黑色
  aboutToDisappear(): void {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({
          statusBarContentColor: "#000000"
        })
      })
  }

  build() {
    Column() {
      Text("我的")
    }
    .width("100%")
    .height("100%")
    .backgroundColor(Color.Pink)
  }
}