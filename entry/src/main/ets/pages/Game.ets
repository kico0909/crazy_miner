import router from '@ohos.router'
import { MainMenu } from '../common/components/MainMenu'
import { Default } from '../common/components/sys/Default'
import { Adventure, TMessage } from '../common/components/sys/Adventure'
import { Meditation } from '../common/components/sys/Meditation'
import { System } from '../common/components/sys/System'

import { WORLD, TArchiveFile } from '../common/game/world'
import { Person } from '../common/game/player'

import { AD } from '../common/components/ad'

// 用户昵称输入弹窗
import { PopCreateUser } from '../common/components/PopCreateUser'
import * as utils from '../common/utils'
import * as conf from '../common/game/config'
import * as core  from '../common/game/core'

// 激活及初始化持久化本地存储
core.initWorldData()

@Entry
@Component
struct Login {
  @State showCtrlBox: string = 'adventure'
  @State AdventureMessages: TMessage[] = []
  @State AdventurePer: number = 0

  @State inputName: string = ''
  @State openInputNamePop: boolean = false
  @State world: WORLD | undefined = undefined
  @State player: Person | undefined = undefined
  @State achiveData?: TArchiveFile = undefined
  @State @Watch('onWorldReset') resetWorld: boolean = false

  onPageHide(): void {
    if (!this.world?.isPause()) {
      console.log('切换至后台,暂停')
      this.world?.pause()
    }
  }

  onPageShow(): void {
    console.log('进入游戏世界界面')
    if (this.world?.isPause()) {
      console.log('切换回前台,启动')
      this.world?.pause()
    }
  }

  onDidBuild(): void {
    console.log('进入游戏世界界面')
    this.worldToCreate()
  }

  onWorldReset() {
    if (this.resetWorld) {
      console.warn('重置整个世界')
      this.worldToCreate()
      this.resetWorld = false
    }
  }

  worldToRun() {
    if (!this.world) {
      console.warn('世界启动失败', '未找到完成初始化的世界')
      return
    }
    this.world.registerActionCall(evt => {
      this.AdventurePer = evt.per
      const messages: TMessage[] = []
      evt.message.forEach(msg => {
        messages.push({
          text: msg,
          date: '',
          time: ''
        })
      })
      this.AdventureMessages.push(...messages);
    })
    this.world.isPause() && this.world.pause()
    this.world.run()
  }

  worldToCreate() {
    const data = this.resetWorld ? core.initWorldData() : core.getWorldData()
    if (!data?.user.name) {
      this.inputUserNamePopController?.open()
    } else {
      this.achiveData = data
      core.initWorld(this.achiveData).then(w => {
        this.world = w
        this.world.pause()
        this.player = this.world.player
        AlertDialog.show({
          title: '提示!',
          message: `欢迎回到${this.world?.map.name}里,亲爱的[${this.achiveData?.user.name}]`
        })
        this.worldToRun()
      })
    }
  }

  inputUserNamePopController: CustomDialogController | null = new CustomDialogController({
    builder: PopCreateUser({
      cancel: () => {
        console.log(`outer click cancel`)
      },
      confirm: () => {
        if (!this.inputName) {
          AlertDialog.show({
            title: '注意',
            message: '旷工名称为必填项'
          })
          return
        }
        this.inputUserNamePopController?.close()
        core.initWorld(this.achiveData, this.inputName).then(w => {
          this.world = w
          this.world.pause()
          this.player = this.world.player
          this.world.saveData() // 完成初始化后, 进行一次保存
          this.worldToRun()
        })
      },
      inputName: $inputName,
    })
  })


  build() {
    Column(){
      // 广告植入
      Column(){
        AD({
          visibilityState: Visibility.Visible
        })
      }.width('100%').height('114lpx')

      // 主要视觉交互区域
      Column(){
        if (this.showCtrlBox === 'adventure' && !!this.world) {
          Adventure({
            per: $AdventurePer,
            messages: $AdventureMessages,
            World: $world
          })
        } else if(this.showCtrlBox === 'meditation' && !!this.world) {
          Meditation({
            w: $world,
          })
        } else if(this.showCtrlBox === 'system') {
          System({
            w: $world,
            resetTag: this.resetWorld
          })
        } else {
          Default()
        }
      }.width('100%').height('calc(100% - 264lpx)')



      // 主菜单区域
      Column(){
        // 主菜单组件
        MainMenu({
          command: $showCtrlBox,
        }).onClick(e => {
          console.log(`event: ${e}`)
        })
      }.width('100%').height('150lpx').backgroundColor('#ff08e500')
    }
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}
