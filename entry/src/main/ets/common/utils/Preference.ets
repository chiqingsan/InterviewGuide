import { preferences } from '@kit.ArkData'

export class PreferencesManager {
  // 泛型方法- 负责保存数据到首选项
  static async savaData<T extends keyof number | number | string | boolean | Array<number> | Array<string> | Array<boolean>>(pname: string, key: string, value: T) {
    const pre = preferences.getPreferencesSync(getContext(), { name: pname })
    pre.putSync(key, value as preferences.ValueType)
    await pre.flush()
  }

  //   获取数据
  static async getData<T extends keyof number | number | string | boolean | Array<number> | Array<string> | Array<boolean>>(pname: string, key: string, defaultvalue: T) {
    const pre = preferences.getPreferencesSync(getContext(), { name: pname })
    return pre.getSync(key, defaultvalue as preferences.ValueType) as T
  }

  //   删除数据
  static async delAllData(pname: string, key: string) {
    const pre = preferences.getPreferencesSync(getContext(), { name: pname })
    pre.deleteSync(key)
    await pre.flush()
  }

  //  用法测试：
  private static async test(){
    // PreferencesManager.savaData('store','keyword',['html'])  // 保存字符串数组
    // PreferencesManager.savaData('store','keyword',[1])  // 保存数字数组
    // PreferencesManager.savaData('store','keyword',[true])  // 保存boolen数组
    // PreferencesManager.savaData('store','keyword',"css3")  // 保存字符串
    // PreferencesManager.savaData('store','keyword',1)  // 保存数字
    // PreferencesManager.savaData('store','keyword',true)  // 保存boolen
  }
}