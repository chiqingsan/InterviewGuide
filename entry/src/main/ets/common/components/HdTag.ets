import { DIFFICULTY_MAP } from '../constants/BasicConstant'

export interface Tag {
  text: ResourceStr
  color: ResourceColor
}

@Preview
@Component
export struct HdTag {
  substance: number | string = 1 // 源于服务器返回 1-2星是简单，3-4星是一般，5星是困难

  build() {
    Text(typeof this.substance === "number" ? DIFFICULTY_MAP[this.substance-1].text : this.substance)
      .fontColor(typeof this.substance === "number" ? DIFFICULTY_MAP[this.substance-1].color : "#000")
      .fontSize($r('app.float.common_font10'))
      .padding({ left: $r('app.float.common_space4'), right: $r('app.float.common_space4') })
      .constraintSize({ minWidth: $r('app.float.hd_tag_width') })
      .height($r('app.float.hd_tag_height'))
      .backgroundColor($r('app.color.common_gray_bg'))
      .borderRadius($r('app.float.hd_tag_radius'))
      .textAlign(TextAlign.Center)
  }
}