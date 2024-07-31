/*
 * 游戏 相关 初始化
 * */

import * as DB from './db'
import * as utils from '../../utils'
import * as conf from '../config'
import { WORLD, TArchiveFile } from '../world'
import { EPlayerAttrs, TAchiveItem, TAchiveUser, Person, TPersonAttr } from '../player'
import { JSON } from '@kit.ArkTS'

// 游戏存档状态声明
export interface TGameState {
  per: number
  mapIndex: number
  deep: number
}

// 游戏世界数据初始化
export function initWorldData(): TArchiveFile {
  const defaultUserData: TAchiveUser = {
    name: '',
    attrs: {
      strength: 0, strong: 0, intellect: 0, luck: 0
    },
    items: [],
    mapIndex: 0,
    exp: 0,
    level: 1,
    meditationPoint: 0,
  }
  const defaultGameState: TGameState = {
    per: 0,
    mapIndex: 0,
    deep: 0,
  }
  const avhieveDefaultData: TArchiveFile = {
    user: defaultUserData,
    game: defaultGameState
  }
  const str = JSON.stringify(avhieveDefaultData)
  PersistentStorage.persistProp(conf.PersistentStoragePath, utils.encodeStr(str))
  return avhieveDefaultData
}

// 游戏基础数据库初始化
export function initDB(cb: () => void) {
  DB.getDB(cb)
}
