export class BasicConstant {
  static readonly SPACE_SM = 4
  static readonly SPACE_MD = 10
  static readonly SPACE_LG = 16
  // 首页
  static readonly PAGE_INDEX = 'pages/Index'
  // 项目详情
  static readonly PAGE_ProjectDetailPage = 'pages/ProjectDetailPage'
  // 面经详情
  static readonly PAGE_InterviewDetailPage = 'pages/InterviewDetailComp'
  // 试题详情
  static readonly PAGE_QuestionDetailPage = 'pages/QuestionDetailPage'
  // 登录
  static readonly PAGE_LoginPage = 'pages/LoginPage'
  // 签到
  static readonly PAGE_ClockedPage = 'pages/ClockPage'
  // 学习统计
  static readonly PAGE_StudyTimePage = 'pages/StudyTimePage'
  // 编辑资料
  static readonly PAGE_ProfileEditPage = 'pages/ProfileEditPage'
  // 隐私协议
  static readonly PAGE_PrivacyPolicy = 'pages/PrivacyPolicy'
  // 用户协议
  static readonly PAGE_UserAgreement = 'pages/UserAgreement'
  // 搜索
  static readonly PAGE_SearchPage = 'pages/SearchPage'
  // 单词页
  static readonly PAGE_WordPage = 'pages/WordPage'
  // 问题反馈页面
  static readonly PAGE_Feedback = 'pages/Feedback'
  // 关于我们
  static readonly PAGE_AboutUs = 'pages/AboutUs'
  // 收藏页面
  static readonly PAGE_BrowsingHistory = 'pages/BrowsingHistory'

}

interface IEVENT_MAP {
  clock: number
  update_question_list: number
}


export const EVENT_MAP: IEVENT_MAP = {
  clock: 10000,
  update_question_list: 10000
}

export class DataList {
  text: string = ''
  color: string = ''

  constructor(text: string, color: string) {
    this.text = text
    this.color = color
  }
}

export const DIFFICULTY_MAP: DataList[] = [
  new DataList('简单', '#27AE60'),
  new DataList('简单', '#27AE60'),
  new DataList('一般', '#3266EE'),
  new DataList('一般', '#3266EE'),
  new DataList('困难', '#F2994A')
]