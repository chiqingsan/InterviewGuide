import { tabsStructure } from "../../models/HomeTabsData"

export const tabsSubstance: tabsStructure[] = [
  { name: "首页", icon: $r("app.media.ic_tabbar_home"), selectedIcon: $r("app.media.ic_tabbar_home_select") },
  { name: "项目", icon: $r("app.media.ic_tabbar_project"), selectedIcon: $r("app.media.ic_tabbar_project_select") },
  {
    name: "面经",
    icon: $r("app.media.ic_tabbar_interview"),
    selectedIcon: $r("app.media.ic_tabbar_interview_select")
  },
  { name: "我的", icon: $r("app.media.ic_tabbar_mine"), selectedIcon: $r("app.media.ic_tabbar_mine_select") },
]