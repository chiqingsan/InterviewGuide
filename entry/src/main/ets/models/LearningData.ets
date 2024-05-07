/**
 * 返回数据
 */
export interface learningData {
  /**
   * 学习数据，学习数据集合
   */
  studyData: studyData[];

  /**
   * 累计时长，暂时以s为单位返回
   */
  totalTime: number;
}

/**
 * 学习数据
 */
export interface studyData {
  list: learningLists[];

  /**
   * 类型，值为：
   * 知识点学习进度和项目常问学习进度
   */
  type: string;
}

export interface learningLists {
  /**
   * 已完成的数量
   */
  done: number;

  /**
   * id
   */
  id: string;

  /**
   * 知识点分类名称/项目分类名称
   */
  name: string;

  /**
   * 总条数
   */
  total: number;

  /**
   * 未完成的数量
   */
  undone: number;
}