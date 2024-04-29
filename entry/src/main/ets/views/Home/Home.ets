@Entry
@Component
export struct Home {
  build() {
    Column(){
      Text("首页")
      Text(Math.random().toString())
    }
  }
}