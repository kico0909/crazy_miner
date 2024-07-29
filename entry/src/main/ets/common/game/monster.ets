export class TMonster {
  name: string = ''
  attack: number = 0
  defense: number= 0
  description: string = ''

}
export class Monster {
  private _type: string; // 怪物类型
  constructor(monsterData: TMonster, type: string = 'normal') {
    this._type = type
  }
}