@Component
export struct HdRichText {
  @Prop richTextContent:string = ""

  build() {
    Scroll() {

      RichText(`
                      <html>
                        <body>
                          <div style="font-size:54px">${this.richTextContent}</div>
                        <body>
                      </html>
                      `)
    }
    .layoutWeight(1)
    .onScroll((xOffset: number, yOffset: number) => {
      console.log('mylog->xOffset', xOffset + ' ' + yOffset)
    })
    .onScrollStop(() => {
      console.log('mylog->Scroll Stop')
    })
  }
}