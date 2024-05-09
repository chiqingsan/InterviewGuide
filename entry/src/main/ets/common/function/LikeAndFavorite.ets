// 点赞收藏
import { iBodyParms } from '../../pages/QuestionDetailPage'
import { HdHttp } from '../utils/request'
import { promptAction } from '@kit.ArkUI'

export async function opt(id:string,isOn: boolean, optType: string) {
  if (isOn) {
    await HdHttp.post<object>("question/opt", {
      id: id,
      type: 0,
      optType: optType
    } as iBodyParms)
    promptAction.showToast({
      message: `${optType === "1" ? "点赞" : "收藏"}成功`
    })
  } else {
    await HdHttp.post<object>("question/unOpt", {
      id: id,
      type: 0,
      optType: optType
    } as iBodyParms)
    promptAction.showToast({
      message: `取消${optType === "1" ? "点赞" : "收藏"}`
    })
  }
}