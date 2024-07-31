import { initWorldData, initDB, TGameState} from './init'
import { getWorldData, saveWorldData, handlerEvents, playerActionOnce, TTypeEventBox, TWorldAction} from './world'
import { getDB, TMeditationEventItem, TMinerActionEventItem, GameDB, TActionEvent} from './db'
import { actionPlayerMeditation, meditationPointsMaxByLevel, TMeditationResult } from './meditation'

// 方法
export {
  initWorldData, initDB,
  getWorldData, saveWorldData, handlerEvents, playerActionOnce,
  getDB,
  actionPlayerMeditation, meditationPointsMaxByLevel
}

// interface
export {
  TGameState,
  TTypeEventBox, TWorldAction,
  TMeditationEventItem, TMinerActionEventItem, TActionEvent,
  TMeditationResult
}

// class
export {
  GameDB
}
