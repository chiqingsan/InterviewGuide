import { tabsStructure } from '../models/tabs'
import { Home } from '../views/Home/Home'
import { Interview } from '../views/Interview/Interview'
import { Mine } from '../views/Mine/Mine'
import { Project } from '../views/Project/Project'
import { tabsSubstance } from "../common/constants/tabsdata"
import { windowManager } from '../common/utils/windowManager'

@Entry
@Component
struct Index {
  @State tabsIndex: number = 0

  aboutToAppear(): void {
    // 调用封装好的方法, 设置窗口为沉浸式模式
    windowManager.enableFullScreen(true)
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
                  // 首页
                  Home()
                } else if (this.tabsIndex === 1) {
                  // 项目
                  Project()
                } else if (this.tabsIndex === 2) {
                  // 面经
                  Interview()
                } else if (this.tabsIndex === 3) {
                  // 我的
                  Mine()
                  // test()
                }
              }.tabBar(this.tabBar(item.name, item.icon, item.selectedIcon, index))
            }
          )
        }
        .scrollable(false)
        .animationDuration(0)
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

