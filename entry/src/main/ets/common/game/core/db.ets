/*
 * 游戏世界数据库
 * */
import * as DB from '../db'
import * as utils from '../../utils'
import * as conf from '../config'

// 云函数等相关引用
import { http } from '@kit.NetworkKit';

// 修炼事件
export interface TMeditationEventItem {
  msg: string
  effect: string
  probability: number
  quality: number
}

// 挖矿事件
export interface TMinerActionEventItem {
  type: string // 事件分类
  textTemplate: string // 文字模版
  level: number // 事件等级
  condition: Function // 执行成功率
  effect?: string // 执行效果
  probability: number //
}

export interface TActionEvent {
  type: string // 事件分类
  textTemplate: string // 文字模版
  level: number // 事件等级
  condition: Function // 执行成功率
  effect?: string // 执行效果
  probability: number //
}

function getDBFromCloudFunc<T>(url: string): Promise<T> {
  return new Promise<T>(resolve => {
    const ajax = http.createHttp()
    ajax.request(url, {
      method: http.RequestMethod.GET,
      header: {
        "Content-Type": 'application/json;'
      }
    }).then((req) => {
      resolve(JSON.parse(req.result as string) as T)
    })
  })
}
//https://6ak5hs5y8rcf4mj7u6.api-drcn.agconnect.link/muddb/meditation
//https://6ak5hs5y8rcf4mj7u6.api-drcn.agconnect.link/muddb/minerEvents

// 修炼事件数据 从云函数获取
function Meditations(): Promise<TMeditationEventItem[]>  {
  return new Promise<TMeditationEventItem[]>((resolve, reject) => {
    getDBFromCloudFunc<TMeditationEventItem[]>('https://6ak5hs5y8rcf4mj7u6.api-drcn.agconnect.link/muddb/meditation').then((req) => {
      resolve(req)
    })
  })
}

// 挖矿事件数据 从云函数获取
function MinerEvents(): Promise<TMinerActionEventItem[]>  {
  return new Promise<TMinerActionEventItem[]>((resolve, reject) => {
    getDBFromCloudFunc<TMinerActionEventItem[]>('https://6ak5hs5y8rcf4mj7u6.api-drcn.agconnect.link/muddb/minerEvents').then((req) => {
      resolve(req)
    })
  })
}

export class GameDB {

  // 修炼事件
  private _meditations: TMeditationEventItem[] = []
  get meditations() {
    return this._meditations
  }

  // 挖矿事件
  private _minerEvents: TMinerActionEventItem[] = []
  get minerEvents() {
    return this._minerEvents
  }

  constructor(CB?: () => void) {
    this._init(CB)
  }

  private _init(final?: () => void) {
    console.warn('基础数据初始化:', '修炼事件数据')
    Meditations().then(rs => {
      this._meditations = rs
      console.warn('基础数据初始化:', '挖矿事件数据')
      MinerEvents().then(rs => {
        this._minerEvents = rs
        final ? final() : false
      })
    })
  }
}

let DBO: GameDB | undefined = undefined;

export function getDB(CB?: () => void): Promise<GameDB>{
  return new Promise<GameDB>((resolve) => {
    if (!DBO) {
      DBO = new GameDB(() => {
        resolve(DBO as GameDB)
        CB?CB():false
      })
    } else {
      resolve(DBO)
      CB?CB():false
    }
  })
}