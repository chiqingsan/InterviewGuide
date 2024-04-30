@Entry
@Component
export struct Interview {
  @StorageProp("topHeight") topHeight:number = 0

  build() {
    Column(){
      Text("面经")
    }
    .padding({ top: this.topHeight })
  }
}