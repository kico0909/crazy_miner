/*
 * 游戏世界数据库
 * */
import * as utils from '../../utils'
import * as conf from '../config'
import * as t from '../types'

// 云函数等相关引用
import { http } from '@kit.NetworkKit';

function getDBFromCloudFunc<T>(url: string): Promise<T> {
  return new Promise<T>((resolve, reject) => {
    const ajax = http.createHttp()
    ajax.request(url, {
      method: http.RequestMethod.GET,
      header: {
        "Content-Type": 'application/json;'
      }
    }).then((req) => {
      resolve(JSON.parse(req.result as string) as T)
    }).catch((ret: http.HttpResponse) => {
      reject(ret)
    })
  })
}

// 全部基础数据 从云函数获取
function CrazyMinerDB(): Promise<t.TBaseDB>  {
  return new Promise<t.TBaseDB>((resolve, reject) => {
    getDBFromCloudFunc<t.TBaseDB>(utils.ResourceConvertString($r('app.string.cloudFunction_db_path'))).then((req) => {
      setTimeout(() => {
        resolve(req)
      }, 500)
    }).catch((ret: http.HttpResponse) => {
      reject(ret)
    })
  })
}



export class GameDB {

  // 修炼事件
  private _meditations: t.TMeditationEventItem[] = []
  get meditations() {
    return this._meditations
  }

  // 挖矿事件
  private _minerEvents: t.TMinerActionEventItem[] = []
  get minerEvents() {
    return this._minerEvents
  }

  private _maps: t.TMapDataItem[] = []
  get maps() {
    return this._maps
  }

  private _config: t.TSysConfig | undefined = undefined
  get config() {
    return this._config
  }

  private _quality: Map<string, string> = new Map()
  get quality() {
    return this._quality
  }

  constructor(CB?: () => void) {
    this._init(CB, CB)
  }


  private _init(success?: () => void, fail?: (ret?: http.HttpResponse) => void) {
    console.warn('Start: 基础数据初始化:', '疯狂矿工基础数据获取')
    CrazyMinerDB().then(rs => {
      try {
        console.warn('Ing 基础数据初始化:', JSON.stringify(rs, null, 4))

        this._meditations = rs.meditations
        this._minerEvents = rs.minerEvents
        this._maps = rs.maps
        this._config = rs.config
        this._quality = new Map(rs.quality)

        console.warn('End: 基础数据初始化:', '数据初始化完成')
        success ? success() : false
      } catch(e) {
        fail ? fail(e) : false
      }
    }).catch((ret: http.HttpResponse) => {
      fail ? fail(ret) : false
    })
  }
}

let DBO: GameDB | undefined = undefined;

export function getDB(CB?: (ret?: http.HttpResponse) => void): Promise<GameDB>{
  return new Promise<GameDB>((resolve) => {
    if (!DBO) {
      DBO = new GameDB((ret?: http.HttpResponse) => {
        if (!ret) {
          resolve(DBO as GameDB)
        }
        CB?CB(ret):false
      })
    } else {
      resolve(DBO)
      CB?CB():false
    }
  })
}