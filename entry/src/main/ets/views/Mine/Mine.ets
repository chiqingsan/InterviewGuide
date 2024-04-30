import { window } from '@kit.ArkUI'
import { windowManager } from '../../common/utils/windowManager'

@Entry
@Component
export struct Mine {
  // 进入我的页面后, 把状态栏字体颜色设置为白色
  aboutToAppear(): void {
    // 调用封装好的方法吗, 设置状态栏的字体颜色, true为白色, false为黑色, 默认为false
    windowManager.settingStatusBar(true)

  }

  // 离开我的页面后, 把状态栏字体颜色设置为黑色
  aboutToDisappear(): void {
    windowManager.settingStatusBar()
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