import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct ProfileEditPage {

  build() {
    Navigation() {
      Stack() {
        List() {
          ListItem() {
            Row() {
              Text('头像')
              Image($rawfile('avatar.png'))
                .width((40))
                .width((40))
                .borderRadius((40))
                .border({ width: 0.5, color: '#e4e4e4' })
                .onClick(() => {
                  // 选择头像并上传this.pickerAvatar()

                })
            }.width('100%').height((60)).justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Text('昵称')
              TextInput({ text:'昵称' })
                .textAlign(TextAlign.End)
                .layoutWeight(1)
                .padding(0)
                .height((60))
                .backgroundColor(Color.Transparent)
                .borderRadius(0)
                .onSubmit(() => {
                  // 修改昵称 this.updateNickName()

                })
            }.width('100%').height(60).justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .height('100%')
        .padding({ left: (45), right: (45), top: (15), bottom: (15) })
        .divider({ strokeWidth: 0.5, color: '#f5f5f5' })

      }.width('100%')
      .height('100%')
    }
    .title('完善个人信息')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .linearGradient({
      colors: [['#FFB071', 0], ['#f3f4f5', 0.3], ['#f3f4f5', 1]]
    })
  }
}