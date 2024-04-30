import { tabsStructure } from '../models/tabs'
import { Home } from '../views/Home/Home'
import { Interview } from '../views/Interview/Interview'
import { Mine } from '../views/Mine/Mine'
import { Project } from '../views/Project/Project'
import { window } from '@kit.ArkUI'
import { tabsSubstance } from "../common/constants/tabsdata"
import { Logger } from '../common/utils/Logger'

@Entry
@Component
struct Index {
  @State tabsIndex: number = 0

  aboutToAppear(): void {
    // 拿到当前的窗口
    window.getLastWindow(getContext()).then((win) => {
      // 设置当前窗口为全屏
      win.setWindowLayoutFullScreen(true)
      Logger.info(JSON.stringify(win))
      const area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      // 顶部安全区的高度
      const hvp = px2vp(area.topRect.height)
      AppStorage.setOrCreate("topHeight", hvp)
    })
  }

  build() {
    Column() {
      Column() {
        Tabs() {
          ForEach(
            tabsSubstance,
            (item: tabsStructure, index) => {
              TabContent() {
                if (this.tabsIndex === 0) {
                  Home()
                } else if (this.tabsIndex === 1) {
                  Project()
                } else if (this.tabsIndex === 2) {
                  Interview()
                } else if (this.tabsIndex === 3) {
                  Mine()
                }
              }.tabBar(this.tabBar(item.name, item.icon, item.selectedIcon, index))
            }
          )
        }
        .scrollable(false)
        .barHeight(55)
        .padding({ bottom: 15 })
        .barPosition(BarPosition.End)
        .onTabBarClick((index) => {
          this.tabsIndex = index
        })
      }
    }
  }

  @Builder
  tabBar(name: string, icon: ResourceStr, selectedIcon: ResourceStr, index: number) {
    Column({ space: 3 }) {
      Image(this.tabsIndex === index ? selectedIcon : icon)
        .width(20)
        .aspectRatio(1)
      Text(name)
        .fontSize(12)
        .fontWeight(500)
        .fontColor(this.tabsIndex === index ? "#3C3E42" : "#979797")
    }
  }
}

