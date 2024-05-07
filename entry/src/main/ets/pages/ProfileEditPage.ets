import { promptAction } from '@kit.ArkUI'
import { iLoginDataModel } from '../models/UserData'
import { picker } from '@kit.CoreFileKit'
import { Logger } from '../common/utils/Logger'
import fs from '@ohos.file.fs';
import { request, UploadResponse } from '@kit.BasicServicesKit'
import { http } from '@kit.NetworkKit'

@Entry
@Component
struct ProfileEditPage {
  @StorageProp("user") user: iLoginDataModel = {} as iLoginDataModel
  @StorageProp("topHeight") topHeight: number = 0

  // 选择图片,返回选择图片的地址
  async pickerAvatar() {
    // 1. 实例化选择参数的对象
    const options = new picker.PhotoSelectOptions()
    // 1.1 设定需要选择的文件类型, 这里只选择图片
    options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
    // 1.2 设定选择的数量, 这里只需要选择一张
    options.maxSelectNumber = 1

    // 2. 实例化选择器, 然后选入设定好的对象
    const pickerView = new picker.PhotoViewPicker
    // 3. 调用选择器, 并且接受返回的结果
    const res = await pickerView.select(options)
    Logger.info("头像选择:", JSON.stringify(res))

    if (res.photoUris.length > 0) {
      return res.photoUris[0]
    } else {
      Logger.warn("用户取消了选择照片")
      return
    }
  }

  // 拿到地址, 拷贝到应用的缓存目录. 然后上传图片
  fileCopies(ImagePath: string) {
    const file = fs.openSync(ImagePath, fs.OpenMode.READ_ONLY)

    const filename = Date.now().toString()
    const extension = ImagePath.slice(ImagePath.lastIndexOf(".") + 1)

    console.log(`${getContext().cacheDir}/${filename}.${extension}`)
    fs.copyFileSync(file.fd, `${getContext().cacheDir}/${filename}.${extension}`)

    //
    // const files: Array<request.File> = [
    //   {
    //     filename: `${filename}.${extension}`,
    //     type: extension,
    //     name: "file",
    //     uri: `internal://cache/${filename}.${extension}`
    //   }
    // ]
    //
    // request.uploadFile(getContext(), {
    //   url: "https://api-harmony-teach.itheima.net/hm/userInfo/avatar",
    //   method: http.RequestMethod.POST,
    //   header: {
    //     "Content-Type": 'multipart/form-data',
    //     "Authorization": `Bearer ${this.user.token}`
    //   },
    //   files,
    //   data: []
    // }).then((res) => {
    //   res.on("complete", (val) => {
    //
    //     // promptAction.showToast({
    //     //   message: "上传图片成功"
    //     // })
    //     AlertDialog.show({
    //       message: JSON.stringify(val)
    //     })
    //   })
    // })

    return [`internal://cache/${filename}.${extension}`, `${filename}.${extension}`, extension]
  }

  // 上传图片
  async uploadAnImage(arr: string[]) {
    // const files: Array<request.File> = [
    //   { filename: `${filename}.${extension}`, type: extension, name: "file", uri: cachePath }
    // ]

    const files: Array<request.File> = [
      {
        filename: arr[1],
        type: arr[2],
        name: "file",
        uri: arr[0]
      }
    ]

    const res = await request.uploadFile(getContext(), {
      url: "https://api-harmony-teach.itheima.net/hm/userInfo/avatar",
      method: http.RequestMethod.POST,
      header: {
        "Content-Type": 'multipart/form-data',
        "Authorization": `Bearer ${this.user.token}`
      },
      files,
      data: []
    })

    res.on("progress", (val, size) => {

      if (val === size) {
        promptAction.showToast({
          message: "头像上传成功"
        })
      }
    })
  }

  build() {
    Navigation() {
      Stack() {
        List() {
          ListItem() {
            Row() {
              Text('头像')
              Image(this.user.avatar || $rawfile('avatar.png'))
                .width(45)
                .aspectRatio(1)
                .borderRadius((40))
                .border({ width: 0.5, color: '#e4e4e4' })
                .onClick(async () => {
                  // 选择头像并上传this.pickerAvatar()
                  const ImagePath = await this.pickerAvatar()
                  if (!ImagePath) {
                    promptAction.showToast({
                      message: "取消了图片选择"
                    })
                    return
                  }
                  // const cachePath = this.fileCopies(ImagePath)
                  // 拿到地址数据
                  const pathArr = this.fileCopies(ImagePath)

                  // 开始准备上传图片
                  this.uploadAnImage(pathArr)

                })
            }.width('100%').height((60)).justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Text('昵称')
              TextInput({ text: this.user.nickName || '昵称' })
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
    .padding({ top: this.topHeight + 10 })
  }
}