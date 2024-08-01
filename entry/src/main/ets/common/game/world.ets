import * as t from './types'
import { Person } from './player'
import { playerActionOnce } from './core'
import { Item } from './item'
import * as utils from '../utils'
import * as conf from './config'
import * as core from './core'

export * from './types'

let timeout: number = 0

export class WORLD {
  private _personal: Person // 矿工
  private _per: number = 0 // 一次的挖掘进度
  private _mapIndex: number = 0 // 矿坑地图编号
  private _deep: number = 0 // 挖掘深度
  private _events: t.TTypeEventBox[] = []
  private _maps: t.TMapDataItem[] = []
  private _pause = false // 世界暂停
  private _status = 'none' // 世界的状态
  private _actionCB: ((evt: t.TWordEventShow) => void) | undefined // 世界运行的回调钩子

  constructor(archiveFile: t.TArchiveFile | undefined, nickname: string = '') {
    this._status = 'none'
    if (!nickname && archiveFile) { // 正常基于用户存档恢复创建游戏(不存在昵称, 存在存档数据)
      console.log(`Start: 已有用户信息还原...`)
      this._personal = new Person(
        archiveFile.user.name,
        archiveFile.user.attrs,
        [],
        archiveFile.user.mapIndex,
        archiveFile.user.exp,
        archiveFile.user.level,
        archiveFile.user.meditationPoint
      )
      this._per = archiveFile.game.per ? archiveFile.game.per : 0
      this._mapIndex = archiveFile.game.mapIndex ? archiveFile.game.mapIndex : 0
      this._deep = archiveFile.game.deep ? archiveFile.game.deep : 0
      console.log(`End: 已有用户信息还原...`)
    } else {
      // 新建游戏 初始化用户状态, 其他数据使用默认值即可
      console.log(`Start: 用户信息初始化...`)
      this._personal = new Person(nickname, utils.createPlayerAttrs())
      console.log(`End: 用户信息初始化...`)
    }

    core.getDB().then(db => {
      // 初始化事件数据
      console.log(`Start: 世界事件数据初始化...`)
      const events = core.handlerEvents(db.minerEvents)
      this._events = events
      console.log(`End: 世界事件数据初始化...`)

      // 初始化地图
      console.log(`Start: 地图数据初始化...`)
      this._maps = db.maps
      console.log(`End: 地图数据初始化...`)
      this._status = 'inited'
      console.log(`世界初始化结束`)
    })
  }

  private _autoSaveCount = 1
  private _run(cb: () => void) {
    if (this._pause) {
      cb ? cb() : false
      return
    }
    let result: t.TWorldAction | null = null
    if (this._per >= 100) {
      this._per = 0
    } else {
      // 世界运动一次
      result = playerActionOnce(this)

      // 矿坑挖深一点
      this._per = utils.formatToDecimal(this._per + result.perStep >= 100 ? 100 : this._per + result.perStep)

      // 挖矿进度前进1米
      if(this._per >= 100) {
        this._deep += 1
      }

      // 角色升级, 保存一次存档
      if (result.levelUp) {
        this.saveData()
      }
    }

    // 回调数据
    let CBData: t.TWordEventShow = {
      message: [],
      per: 0
    }
    if (result) {
      CBData = {
        per: this._per,
        message: result ? result.message : []
      }
    }
    // 集中调用
    this._actionCB ? this._actionCB(CBData) :false;

    // 执行回调
    cb ? cb() : false;

    // auto save
    if ((this._autoSaveCount++ % utils.ResourceConvertInt($r('app.string.AutoSaveStep'))) === 0) {
      this.saveData()
    }
  }

  get status() {
    return this._status
  }

  pause() {
    this._pause = !this._pause
  }

  isPause() {
    return this._pause
  }

  perFull() {
    this._deep += 1
    this._per = 0
  }

  get map() {
    return this._maps[this._mapIndex]
  }

  get player() {
    return this._personal
  }
  get per() {
    return this._per
  }
  get mapIndex() {
    return this._mapIndex
  }
  get deep() {
    return this._deep
  }
  set deep(val: number) {
    this._deep += val
  }

  get events() {
    return this._events
  }

  // 世界有动作时的响应钩子
  registerActionCall(cb?: (per: t.TWordEventShow) => void) {
    if (cb) this._actionCB = cb
  }

  // 世界继续启动
  run() {
    this._run(() => {
      if (timeout) clearTimeout(timeout)
      timeout = setTimeout(() => {
        this.run()
      }, utils.getRandomInt(950,2500))
    })

  }

  private _getWorldFile(): t.TGameState {
    return {
      per: this._per,
      mapIndex: this._mapIndex,
      deep: this._deep
    }
  }

  saveData() {
    const gameState: t.TArchiveFile = {
      user: this._personal.getUserFile(),
      game: this._getWorldFile()
    }
    if (core.saveWorldData(gameState)) {
      console.log(`保存数据成功![step:${JSON.stringify(gameState)}]`)
    } else {
      console.log(`数据保存失败!`)
    }
  }
}