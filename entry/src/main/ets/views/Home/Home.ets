@Entry
@Component
export struct Home {
  @StorageProp("topHeight") topHeight:number = 0
  build() {
    Column(){
      Text("首页")
      Text(Math.random().toString())
    }
    .padding({ top: this.topHeight })
  }
}