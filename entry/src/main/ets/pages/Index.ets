import { tabsStructure } from '../models/tabs'
import { Home } from '../views/Home/Home'
import { Interview } from '../views/Interview/Interview'
import { Mine } from '../views/Mine/Mine'
import { Project } from '../views/Project/Project'

@Entry
@Component
struct Index {
  @State tabsIndex: number = 0
  @State tabsSubstance: tabsStructure[] = [
    { name: "首页", icon: $r("app.media.ic_tabbar_home"), selectedIcon: $r("app.media.ic_tabbar_home_select") },
    { name: "项目", icon: $r("app.media.ic_tabbar_project"), selectedIcon: $r("app.media.ic_tabbar_project_select") },
    {
      name: "面经",
      icon: $r("app.media.ic_tabbar_interview"),
      selectedIcon: $r("app.media.ic_tabbar_interview_select")
    },
    { name: "我的", icon: $r("app.media.ic_tabbar_mine"), selectedIcon: $r("app.media.ic_tabbar_mine_select") },
  ]

  build() {
    Column() {
      Tabs() {
        ForEach(
          this.tabsSubstance,
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
      .barHeight(60)
      .barPosition(BarPosition.End)
      .onTabBarClick((index) => {
        this.tabsIndex = index
      })
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

