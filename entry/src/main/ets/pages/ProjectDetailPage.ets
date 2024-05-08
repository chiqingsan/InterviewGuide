import { ProjectDetailComp } from '../views/project/ProjectDetailComp'
import { window } from '@kit.ArkUI'

@Entry
@Component
struct ProjectDetailPage {
  // 开启安全区域
  enableFullScreen() {
    window.getLastWindow(getContext()).then((windowStage: window.Window) => {
      // 获取到顶部bar的区域信息
      const area = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      // 获取到高度
      const topHeight = px2vp(area.topRect.height)
      if (topHeight > 0) {
        // 开启全屏
        windowStage.setWindowLayoutFullScreen(true)
        // 把高度保存起来
        AppStorage.setOrCreate('topHeight', topHeight)
      }
    })
  }

  // 取消安全区域
  disableFullScreen() {
    window.getLastWindow(getContext()).then((windowStage: window.Window) => {
      windowStage.setWindowLayoutFullScreen(false)
      AppStorage.setOrCreate('topHeight', 0)
    })
  }

  // 页面显示的时候，设置顶部状态栏的内容为白色（本页面文字显示被色）
  onPageShow(): void {
    this.enableFullScreen()
    window.getLastWindow(getContext(this)).then((windowStage: window.Window) => {
      windowStage.setWindowSystemBarProperties({
        statusBarContentColor: '#ffffff',
      })
    })
  }

  // 页面隐藏的时候，设置顶部状态栏的内容为黑色（其他页面文字显示黑色）
  onPageHide(): void {
    this.disableFullScreen()
    window.getLastWindow(getContext(this)).then((windowStage: window.Window) => {
      windowStage.setWindowSystemBarProperties({
        statusBarContentColor: '#000000',
      })
    })
  }

  build() {
    Column() {
      ProjectDetailComp()
    }
  }
}