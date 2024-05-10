import { Logger } from '../utils/Logger';
import { HdHttp } from '../utils/Request';

export interface iTimeItem {
  /**
   * 结束时间（毫秒）
   */
  endTime: number;

  /**
   * 试题id
   */
  questionId: string;

  /**
   * 开始时间(毫秒)
   */
  startTime: number;
}


export interface learningDurationStructure {
  /**
   * 入参
   */
  timeList: iTimeItem[];
}


/**
 * empty object
 */
export interface lengthOfTheInterview {
  /**
   * 是否阅读到底部
   */
  exp: boolean;

  /**
   * 面经编号
   */
  questionNo: string;

  /**
   * 停留时长
   */
  stayTime: number;
}


class TrackingService {
  // 类的实例属性
  timelist: iTimeItem = {} as iTimeItem

  // 初始化-重置数据
  constructor() {
    this.timelist = {
      questionId: "0",
      startTime: 0,
      endTime: 0
    }
  }

  //  1. 收集用户进入页面的时间
  setStartTime() {
    this.timelist.startTime = Date.now()
    Logger.info("阅读时长埋点开始", Date.now().toString())
  }

  //  2. 收集用户离开页面的时间
  setEndTime() {
    this.timelist.endTime = Date.now()
  }

  // 3. 设置用户阅读的题目id
  setQuestionId(questid: string) {
    this.timelist.questionId = questid
  }

  // 4. 把收集好的数据请求服务器接口提交时长数据
  async save() {
    Logger.info("timelist", JSON.stringify(this.timelist))
    await HdHttp.post<string>('time/tracking', { timeList: [this.timelist] } as learningDurationStructure)
    Logger.info("阅读时长埋点结束, 学习时长已收集上传", Date.now().toString())
  }
}

class InterviewTracking {
  endTime: number
  startTime: number
  // 类的实例属性
  timelist: lengthOfTheInterview

  // 初始化-重置数据
  constructor() {

    this.endTime = 0
    this.startTime = 0
    this.timelist = {
      exp: false,
      questionNo: "0",
      stayTime: 0
    } as lengthOfTheInterview
  }

  //  1. 收集用户进入页面的时间
  setStartTime() {
    Logger.info(JSON.stringify(this.timelist))
    this.startTime = Date.now()
    Logger.info("阅读面经时长埋点开始", Date.now().toString())
  }

  //  2. 收集用户离开页面的时间
  setEndTime() {
    this.endTime = Date.now()
  }

  // 3. 设置用户阅读的题目id
  setId(questid: string) {
    Logger.info("开始:", JSON.stringify(this), questid)
    this.timelist.questionNo = questid
  }

  // 4. 把收集好的数据请求服务器接口提交时长数据
  async save(exp: boolean = false) {
    this.timelist.stayTime = this.endTime - this.startTime
    this.timelist.exp = exp
    Logger.info("timelist", JSON.stringify(this.timelist))
    await HdHttp.post<string>('interview/tracking', this.timelist)
    Logger.info("阅读面经时长埋点结束, 学习时长已收集上传", Date.now().toString())
  }
}


// 导出类的实例化对象
export const trackingService = new TrackingService()

// 导出阅读面经的实例化对象
export const interviewTracking = new InterviewTracking()