@Entry
@Component
export struct Project {
  @StorageProp("topHeight") topHeight:number = 0

  build() {
    Column(){
      Text("项目")
    }
    .padding({ top: this.topHeight })
  }
}