import { window } from '@kit.ArkUI'


export class windowManager {
  // 是否开启沉浸式状态栏
  static enableFullScreen(ison: boolean) {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowLayoutFullScreen(ison)

        if (ison) {
          // 如果开启,则获取安全区的高度, 转换为vp
          const area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
          // 顶部安全区的高度
          const hvp = px2vp(area.topRect.height)
          AppStorage.setOrCreate("topHeight", hvp)
        }else {
          // 如果关闭这设置top为0
          AppStorage.setOrCreate("topHeight", 0)
        }

      })
  }

  // 设定状态栏的颜色
  // true = 白 false = 黑
  static settingStatusBar(LorD: boolean = false) {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({
          statusBarContentColor: LorD ? "#ffffff" : "#000000"
        })
      })
  }
}