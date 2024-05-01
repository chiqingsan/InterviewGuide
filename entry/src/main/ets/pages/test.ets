import { Logger } from '../common/utils/Logger'
import { HdHttp } from '../common/utils/request'

interface testint {
  questionBankType: string
}

const test11: testint = {
  questionBankType: "9"
}

export interface ApifoxModel {
  /**
   * code,10000正常，其他为失败
   */
  code?: number;

  /**
   * 报文数据
   */
  data?: Data;

  /**
   * 消息
   */
  message?: string;

  /**
   * 成功标识
   */
  success?: boolean;
}

/**
 * 报文数据
 */
export interface Data {
  /**
   * 总页数
   */
  pageTotal?: number;

  /**
   * 数据集合
   */
  rows?: Row[];

  /**
   * 总数
   */
  total?: number;
}

export interface Row {
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
  id: string;

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


@Entry
@Component
export struct test {
  @State mytest: Data = {} as Data

  build() {
    Column() {
      Button("test")
        .onClick(async () => {
          console.log("123")
          // HdHttp.get<object>("question/type")
          // Logger.info("index", JSON.stringify(HdHttp.get<object>("question/type")))
          const res = await HdHttp.get<object>("question/list", test11)
          console.log("123", JSON.stringify(res.data))
          this.mytest = res.data

        })

      if (this.mytest.pageTotal) {
        ForEach(
          this.mytest.rows,
          (item: Row) => {
            Text(JSON.stringify(item.content))
          }
        )
      }
    }

  }
}