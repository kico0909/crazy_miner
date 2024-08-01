import { initWorldData, initDB, initWorld } from './init'
import { getWorldData, saveWorldData, handlerEvents, playerActionOnce} from './world'
import { getDB, GameDB } from './db'
import { actionPlayerMeditation, meditationPointsMaxByLevel } from './meditation'

// 方法
export {
  initWorldData, initDB, initWorld,
  getWorldData, saveWorldData, handlerEvents, playerActionOnce,
  getDB,
  actionPlayerMeditation, meditationPointsMaxByLevel
}

// class
export {
  GameDB
}
