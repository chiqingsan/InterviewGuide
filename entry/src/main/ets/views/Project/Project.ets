import { HdTag } from '../../common/components/HdTag'
import { BasicConstant } from '../../common/constants/BasicConstant'
import { router } from '@kit.ArkUI'
import { HdHttp } from '../../common/utils/request'

export interface ProjectTag {
  tagName: string
}

export interface ProjectItem {
  id: number
  name: string
  icon: ResourceStr
  describeInfo: string | null
  tags: ProjectTag[]
}

export class ProjectItemModel implements ProjectItem {
  id: number
  name: string
  icon: ResourceStr
  describeInfo: string | null
  tags: ProjectTag[]

  constructor(model: ProjectItem) {
    this.id = model.id
    this.name = model.name
    this.icon = model.icon
    this.describeInfo = model.describeInfo
    this.tags = model.tags
  }
}

export const ProjectItemData: ProjectItem[] = [
  {
    id: 1,
    name: '后台管理系统',
    icon: $r('app.media.project02'),
    describeInfo: '以Vue技理后台后台管理系统面试题面试整理',
    tags: [{ tagName: '后台系统' }]
  },
  {
    id: 2,
    name: '在线问医生平台（医疗类）',
    icon: $r('app.media.project01'),
    describeInfo: '通过vue3+ts实现的在线医疗问诊相关技术整理',
    tags: [{ tagName: 'H5项目' }]
  },
  {
    id: 3,
    name: '鸿蒙知识点',
    icon: $r('app.media.project03'),
    describeInfo: '以 ArkTS 与 ArkUI 为主的鸿蒙基础知识点讲解',
    tags: [{ tagName: '鸿蒙应用' }]
  }
]

@Entry
@Component
export struct Project {
  @State
  list: ProjectItemModel[] = ProjectItemData

  @Builder
  ProjectItemBuilder(item: ProjectItemModel) {
    Row({ space: BasicConstant.SPACE_MD }) {
      Image(item.icon)
        .size({ width: 60, height: 80 })
        .sharedTransition(item.id.toString(), { duration: 300 })
      Column({ space: BasicConstant.SPACE_SM }) {
        Text(item.name)
          .fontWeight(500)
        Text(item.describeInfo)
          .fontSize($r('app.float.common_font12'))
          .fontColor($r('app.color.common_gray_02'))
        Blank()
        Row({ space: 4 }) {
          ForEach(item.tags, (tag: ProjectTag) => {
            HdTag({ substance: tag.tagName })
          })
        }
      }
      .layoutWeight(1)
      .height(80)
      .alignItems(HorizontalAlign.Start)
    }
    .padding({
      top: $r('app.float.common_gutter'),
      bottom: $r('app.float.common_gutter')
    })
    .alignItems(VerticalAlign.Top)
    .onClick(() => {
      router.pushUrl({
        url: 'pages/ProjectDetailPage',
        params: item
      })
    })
  }

  aboutToAppear(): void {
    HdHttp.get<ProjectItemModel[]>('question/type', new Object({ type: 'items' }))
      .then(res => {
        console.log("item", JSON.stringify(res))
        this.list = [...res.data, ...ProjectItemData]
      })
  }

  build() {
    Column() {
      Text('项目')
        .height(44)
        .width('100%')
        .fontWeight(500)
        .textAlign(TextAlign.Center)
        .border({
          width: { bottom: $r('app.float.common_border_width') },
          color: $r('app.color.common_gray_border')
        })

      List() {
        ForEach(this.list, (item: ProjectItemModel) => {
          ListItem() {
            this.ProjectItemBuilder(item)
          }
        })
      }
      .divider({
        strokeWidth: $r('app.float.common_border_width'),
        color: $r('app.color.common_gray_border')
      })
      .padding({
        left: $r('app.float.common_gutter'),
        right: $r('app.float.common_gutter')
      })

      Blank()

      Stack() {
        Text()
          .width('100%')
          .height($r('app.float.common_border_width'))
          .backgroundColor($r('app.color.common_gray_01'))
        Text('其他项目正在赶来的路上…')
          .padding($r('app.float.common_space10'))
          .backgroundColor(Color.White)
          .fontColor($r('app.color.common_gray_01'))
          .fontSize($r('app.float.common_font12'))
      }
      .width('80%')
      .padding($r('app.float.common_gutter'))
    }
    .width('100%')
    .height('100%')
    .padding({ top: 30 })
  }
}