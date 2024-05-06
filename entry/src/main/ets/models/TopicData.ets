/**
 * 报文数据
 */
export interface questionDataStructure {
  /**
   * 总页数
   */
  pageTotal?: number;

  /**
   * 数据集合
   */
  rows?: row[];

  /**
   * 总数
   */
  total?: number;
}


export interface row {
  /**
   * 内容描述-面经有,试题列表没有
   */
  content: string;

  /**
   * 新增时间
   */
  createdAt?: string;

  /**
   * 面经创建者头像
   */
  creatorAvatar: string;

  /**
   * 创建者名称
   */
  creatorName: string;

  /**
   * 难度，难度-面试题需要显示此字段，注：1-2星是简单，3-4星是一般，5星是困难
   */
  difficulty?: number;

  /**
   * 题目id
   */
  id: number;

  /**
   * 点赞数量
   */
  likeCount: number;

  /**
   * 已点赞1 未点赞0
   */
  likeFlag: number;

  /**
   * 场景教案场景，双元教案1、核心提炼2、随堂测试3、随堂练习4、每日作业
   */
  planSceneName?: PlanSceneName;

  /**
   * 题号/面经的标题
   */
  questionNo?: string;

  /**
   * 题型：1单选，2多选，3判断，5简答，6代码，7实操
   */
  questionType?: number;

  /**
   * 是否已读标志，0未读1已读
   */
  readFlag: number;

  /**
   * 题干
   */
  stem: string;

  /**
   * 题干附件-面经列表的图片
   */
  stemAttachmentId?: string;

  /**
   * 学科
   */
  subjectName?: string;

  /**
   * 浏览量
   */
  views: number;
}

/**
 * 场景教案场景，双元教案1、核心提炼2、随堂测试3、随堂练习4、每日作业
 */
export enum PlanSceneName {
  Empty = "",
  其他 = "其他",
  核心提炼 = "核心提炼",
  每日作业 = "每日作业",
  随堂测试 = "随堂测试",
  随堂练习 = "随堂练习",
}