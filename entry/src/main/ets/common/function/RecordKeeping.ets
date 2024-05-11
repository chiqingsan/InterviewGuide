import { collectionStructure, QuestionDetail } from '../../models/TopicData'
import { iResponseModel } from '../../models/UserData'
import { Logger } from '../utils/Logger'
import { PreferencesManager } from '../utils/Preference'

export async function RecordKeeping<T extends collectionStructure>(res: iResponseModel<T>, name: string) {
  // 使用数据持久化来保存浏览过的题目,用来提供给浏览记录页面显示
  const myQuestions = await PreferencesManager.getData("store", name, "")
  const myQuestionsObj: collectionStructure[] = myQuestions ? JSON.parse(myQuestions) : []

  const findIndex = myQuestionsObj.findIndex(val => val.id === res.data.id)

  if (findIndex === -1) {
    myQuestionsObj.unshift({
      difficulty: res.data.difficulty,
      id: res.data.id,
      likeCount: res.data.likeCount,
      stem: res.data.stem,
      views: res.data.views
    } as collectionStructure)
    if (myQuestionsObj.length > 15) {
      myQuestionsObj.splice(0, 15)
    }
    PreferencesManager.savaData("store", name, JSON.stringify(myQuestionsObj))

  } else {
    myQuestionsObj.unshift(myQuestionsObj.splice(findIndex, 1)[0])
    PreferencesManager.savaData("store", name, JSON.stringify(myQuestionsObj))
  }
}