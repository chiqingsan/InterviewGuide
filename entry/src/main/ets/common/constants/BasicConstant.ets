// TODO 完成常量的封装

export class BasicConstant {
  static readonly SPACE_SM = 4
  static readonly SPACE_MD = 10
  static readonly SPACE_LG = 16
  static readonly PAGE_INDEX = 'pages/Index'
  static readonly PAGE_ProjectDetailPage = 'pages/ProjectDetailPage'
  static readonly PAGE_InterviewDetailPage = 'pages/InterviewDetailPage'
  static readonly PAGE_QuestionDetailPage = 'pages/QuestionDetailPage'
  static readonly PAGE_LoginPage = 'pages/LoginPage'
  static readonly PAGE_ClockedPage = 'pages/ClockedPage'
  static readonly PAGE_StudyTimePage = 'pages/StudyTimePage'
  static readonly PAGE_PREVIEW = 'pages/PreviewWebPage'
  static readonly PAGE_ProfileEditPage = 'pages/ProfileEditPage'
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