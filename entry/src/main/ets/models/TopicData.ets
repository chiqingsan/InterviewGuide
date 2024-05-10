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


// 面经详情结构
export interface InterviewItem {
  id: string
  stem: string
  content: string
  likeCount: number
  views: number
  creatorName: string
  creatorAvatar: ResourceStr
  createdAt: string
  tags: string[]
  likeFlag: 0 | 1
  collectFlag: 0 | 1
}


// 标签结构
export interface ProjectTag {
  tagName: string
}

// 项目详情返回的数据结构
export interface ProjectItem {
  id: number
  name: string
  icon: ResourceStr
  describeInfo: string | null
  tags: ProjectTag[]
}


// 试题返回的数据结构
export interface QuestionDetail {
  /**
   * 题目答案
   */
  answer: string;

  /**
   * 0未收藏1收藏
   */
  collectFlag: number;

  /**
   * 面经的内容，为面经时才有自豪
   */
  content: null | string;

  /**
   * 创建时间
   */
  createdAt: string;

  /**
   * 创建者头像-面经
   */
  creatorAvatar: string;

  /**
   * 创建者名称-面经
   */
  creatorName: string;

  /**
   * 题目难度，难度-面试题需要显示此字段，注：1-2星是简单，3-4星是一般，5星是困难
   */
  difficulty: number;

  /**
   * 主键id-试题id
   */
  id: string;

  /**
   * 点赞数-面经
   */
  likeCount: number;

  /**
   * 是否点赞0未点赞1已点赞
   */
  likeFlag: number;

  /**
   * 阶段待定-知识点
   */
  stage?: string[];

  /**
   * 题目的题干/面经的标题
   */
  stem: string;

  /**
   * 浏览量
   */
  views: number;
}

//接收参数的实体
export interface ParamsType {
  id: number
}

// 点赞的数据结构
export interface iBodyParms {
  id: string,
  type: number,
  optType: string
}

// 面经列表的查询上传结构
export interface TopicData {
  /**
   * 搜索关键词,(定位题目，传题号)
   */
  keyword?: string;

  /**
   * 当前页数，为空默认是1
   */
  page: string;

  /**
   * 每页大小，为空默认是10
   */
  pageSize?: string;

  /**
   * 9面经10小程序面试题
   */
  questionBankType: string;

  /**
   * 排序，默认0,可以不传，难易-10从易到难11从难道易，浏览量：20从低到高21从高到底,30推荐数据（按照权重倒序）
   * 面经默认是按照更新时间
   */
  sort: string;

  /**
   * 0或者不传，查询全部 或者类型id
   */
  type: string;
}


export interface collectionStructure {
  /**
   * 内容描述-面经有,试题列表没有
   */
  // content: null|string;

  /**
   * 难度，难度-面试题需要显示此字段，注：1-2星是简单，3-4星是一般，5星是困难
   */
  difficulty?: number;

  /**
   * 题目id
   */
  id: string;

  /**
   * 点赞数量
   */
  likeCount: number;

  /**
   * 是否已读标志，0未读1已读
   */
  readFlag?: number;

  /**
   * 题干
   */
  stem: string;

  /**
   * 浏览量
   */
  views: number;
}

