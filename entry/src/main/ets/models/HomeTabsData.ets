export interface tabsStructure {
  name: string
  icon: ResourceStr
  selectedIcon: ResourceStr
}

// 分类/项目结构
export interface questionStructure {

  /**
   * 是否展示最新图标标识0不展示1展示
   */
  displayNewestFlag: number;

  /**
   * 主键id
   */
  id: number;

  /**
   * 分类名称
   */
  name: string;

}
