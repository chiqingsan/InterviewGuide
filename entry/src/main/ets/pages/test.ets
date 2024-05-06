// 首选项api测试
import { preferences } from '@kit.ArkData'

const pre = preferences.getPreferencesSync(getContext(), { name: "store" })

@Entry
@Component
export struct test {
  @State message: string = ""
  keys: string[] = []

  build() {

    Column({ space: 20 }) {
      Scroll() {
        Text(this.message)
      }.layoutWeight(1)

      Button("增加数据持久化内容")
        .onClick(() => {
          pre.putSync(`keyword - ${Date.now()}`, `首选项-数据持久化测试 现在时间是 ${new Date().toLocaleString()}`)
          pre.flush()
        })
      Button("提取数据")
        .onClick(() => {
          try {
            pre.getAll((err, value) => {
              if (err) {
                console.error("Failed to get all key-values. code =" + err.code + ", message =" + err.message);
                return;
              }
              this.keys = Object.keys(value);
              console.info("getAll keys = " + this.keys);
              console.info("getAll object = " + JSON.stringify(value));
              this.message = JSON.stringify(value)
            })
          } catch (err) {
            console.error("Failed to get all key-values. code =" + err.code + ", message =" + err.message);
          }
        })

      Button("删除一条数据")
        .onClick(() => {
          pre.deleteSync(this.keys.pop())
        })
    }
  }
}