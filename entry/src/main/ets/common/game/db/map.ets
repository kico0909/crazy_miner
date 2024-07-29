export interface TMapData {
  name: string // 矿坑名称
  description: string // 矿坑简述
  finished: number // 矿坑达成深度
}

export const maps: TMapData[] = [
  {
    name: '土拨鼠不小心挖出的大坑',
    description: '',
    finished: 1000
  },
  {
    name: '被遗弃的蚂蚁巢穴',
    description: '',
    finished: 1200
  }
]