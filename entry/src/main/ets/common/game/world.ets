import { TAchiveUser, Person } from './player'
import { TGameState, playerActionOnce } from './core'
import { Item } from './item'
import * as utils from '../utils'
import * as conf from './config'
import * as core from './core'

// DB
import * as DB from './db'

export interface TArchiveFile {
  user: TAchiveUser
  game: TGameState
}

interface TWordEventShow {
  per: number
  message: string[]
}

let timeout: number = 0

export class WORLD {
  private _personal: Person // 矿工
  private _per: number = 0 // 一次的挖掘进度
  private _mapIndex: number = 0 // 矿坑地图编号
  private _deep: number = 0 // 挖掘深度
  private _events: core.TTypeEventBox[] = []
  private _maps: DB.TMapData[] = []
  private _pause = false // 世界暂停

  private _actionCB: ((evt: TWordEventShow) => void) | undefined

  constructor(archiveFile: TArchiveFile | undefined, nickname: string = '') {

    core.getDB().then(db => {
      // 初始化事件数据
      console.log(`Start: 世界事件数据初始化...`)
      const events = core.handlerEvents(db.minerEvents)
      this._events = events
      console.log(`End: 世界事件数据初始化...`)

    })

    // 初始化地图
    console.log(`Start: 地图数据初始化...`)
    this._maps = DB.maps
    console.log(`End: 地图数据初始化...`)

    // 初始化用户信息
    console.log(`Start: 用户信息初始化...`)
    const items: Item[] = []
    if (!nickname && archiveFile) { // 正常基于用户存档恢复创建游戏
      console.log(`Runing: 已有用户信息还原...`)
      if (archiveFile.user.items.length > 0) {
        archiveFile.user.items.forEach(v => {
          items.push(utils.createUsetItem(v))
        })
      }
      this._personal = new Person(
        archiveFile.user.name,
        archiveFile.user.attrs,
        items,
        archiveFile.user.mapIndex,
        archiveFile.user.exp,
        archiveFile.user.level,
        archiveFile.user.meditationPoint
      )
      this._per = archiveFile.game.per ? archiveFile.game.per : 0
      this._mapIndex = archiveFile.game.mapIndex ? archiveFile.game.mapIndex : 0
      this._deep = archiveFile.game.deep ? archiveFile.game.deep : 0
      console.log(`End: 用户信息初始化...`)
      return
    }
    // 新建游戏 初始化用户状态, 其他数据使用默认值即可
    this._personal = new Person(nickname, utils.createPlayerAttrs())
    console.log(`End: 用户信息初始化...`)
  }

  private _autoSaveCount = 1
  private _run(cb: () => void) {
    if (this._pause) {
      cb ? cb() : false
      return
    }
    let result: core.TWorldAction | null = null
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
    let CBData: TWordEventShow = {
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
    if (this._autoSaveCount++ % conf.AutoSaveStep == 0) {
      this.saveData()
    }
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
  registerActionCall(cb?: (per: TWordEventShow) => void) {
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

  private _getWorldFile(): TGameState {
    return {
      per: this._per,
      mapIndex: this._mapIndex,
      deep: this._deep
    }
  }

  saveData() {
    const gameState: TArchiveFile = {
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