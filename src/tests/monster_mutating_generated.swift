import Dflat
import SQLiteDflat
import SQLite3
import FlatBuffers

// MARK - SQLiteValue for Enumerations

// MARK - Serializer

extension MyGame.Sample.Equipment {
  func to(flatBufferBuilder: inout FlatBufferBuilder) -> Offset<UOffset> {
    switch self {
    case .weapon(let o):
      return o.to(flatBufferBuilder: &flatBufferBuilder)
    case .orb(let o):
      return o.to(flatBufferBuilder: &flatBufferBuilder)
    }
  }
  var _type: zzz_DflatGen_MyGame_Sample_Equipment {
    switch self {
    case .weapon(_):
      return zzz_DflatGen_MyGame_Sample_Equipment.weapon
    case .orb(_):
      return zzz_DflatGen_MyGame_Sample_Equipment.orb
    }
  }
}

extension Optional where Wrapped == MyGame.Sample.Equipment {
  func to(flatBufferBuilder: inout FlatBufferBuilder) -> Offset<UOffset> {
    self.map { $0.to(flatBufferBuilder: &flatBufferBuilder) } ?? Offset()
  }
  var _type: zzz_DflatGen_MyGame_Sample_Equipment {
    self.map { $0._type } ?? .none_
  }
}

extension MyGame.Sample.Vec3 {
  func toRawMemory() -> UnsafeMutableRawPointer {
    return zzz_DflatGen_MyGame_Sample_Vec3.createVec3(x: self.x, y: self.y, z: self.z)
  }
}

extension Optional where Wrapped == MyGame.Sample.Vec3 {
  func toRawMemory() -> UnsafeMutableRawPointer? {
    self.map { $0.toRawMemory() }
  }
}

extension MyGame.Sample.Monster {
  func to(flatBufferBuilder: inout FlatBufferBuilder) -> Offset<UOffset> {
    let __pos = self.pos.toRawMemory()
    let __name = flatBufferBuilder.create(string: self.name)
    let __color = zzz_DflatGen_MyGame_Sample_Color(rawValue: self.color.rawValue) ?? .blue
    let __inventory = flatBufferBuilder.createVector(self.inventory)
    var __bagType = [zzz_DflatGen_MyGame_Sample_Equipment]()
    for i in self.bag {
      __bagType.append(i._type)
    }
    let __vector_bagType = flatBufferBuilder.createVector(__bagType)
    var __bag = [Offset<UOffset>]()
    for i in self.bag {
      __bag.append(i.to(flatBufferBuilder: &flatBufferBuilder))
    }
    let __vector_bag = flatBufferBuilder.createVector(ofOffsets: __bag)
    var __weapons = [Offset<UOffset>]()
    for i in self.weapons {
      __weapons.append(i.to(flatBufferBuilder: &flatBufferBuilder))
    }
    let __vector_weapons = flatBufferBuilder.createVector(ofOffsets: __weapons)
    let __equippedType = self.equipped._type
    let __equipped = self.equipped.to(flatBufferBuilder: &flatBufferBuilder)
    var __colors = [zzz_DflatGen_MyGame_Sample_Color]()
    for i in self.colors {
      __colors.append(zzz_DflatGen_MyGame_Sample_Color(rawValue: i.rawValue) ?? .red)
    }
    let __vector_colors = flatBufferBuilder.createVector(__colors)
    var __path = [UnsafeMutableRawPointer]()
    for i in self.path {
      __path.append(i.toRawMemory())
    }
    let __vector_path = flatBufferBuilder.createVector(structs: __path, type: zzz_DflatGen_MyGame_Sample_Vec3.self)
    return zzz_DflatGen_MyGame_Sample_Monster.createMonster(&flatBufferBuilder, structOfPos: __pos, mana: self.mana, hp: self.hp, offsetOfName: __name, color: __color, vectorOfInventory: __inventory, vectorOfBagType: __vector_bagType, vectorOfBag: __vector_bag, vectorOfWeapons: __vector_weapons, equippedType: __equippedType, offsetOfEquipped: __equipped, vectorOfColors: __vector_colors, vectorOfPath: __vector_path)
  }
}

extension Optional where Wrapped == MyGame.Sample.Monster {
  func to(flatBufferBuilder: inout FlatBufferBuilder) -> Offset<UOffset> {
    self.map { $0.to(flatBufferBuilder: &flatBufferBuilder) } ?? Offset()
  }
}

// MARK - ChangeRequest

extension MyGame.Sample.Monster: SQLiteDflat.SQLiteAtom {
  public static var table: String { "mygame__sample__monster" }
  public static var indexFields: [String] { ["f6", "f26__type", "f26__u2__f4"] }
  public static func setUpSchema(_ toolbox: PersistenceToolbox) {
    guard let sqlite = ((toolbox as? SQLitePersistenceToolbox).map { $0.connection }) else { return }
    sqlite3_exec(sqlite.sqlite, "CREATE TABLE IF NOT EXISTS mygame__sample__monster (rowid INTEGER PRIMARY KEY AUTOINCREMENT, __pk0 TEXT, __pk1 INTEGER, p BLOB, UNIQUE(__pk0, __pk1))", nil, nil, nil)
    sqlite3_exec(sqlite.sqlite, "CREATE TABLE IF NOT EXISTS mygame__sample__monster__f6 (rowid INTEGER PRIMARY KEY, f6 INTEGER)", nil, nil, nil)
    sqlite3_exec(sqlite.sqlite, "CREATE INDEX IF NOT EXISTS index__mygame__sample__monster__f6 ON mygame__sample__monster__f6 (f6)", nil, nil, nil)
    sqlite3_exec(sqlite.sqlite, "CREATE TABLE IF NOT EXISTS mygame__sample__monster__f26__type (rowid INTEGER PRIMARY KEY, f26__type INTEGER)", nil, nil, nil)
    sqlite3_exec(sqlite.sqlite, "CREATE INDEX IF NOT EXISTS index__mygame__sample__monster__f26__type ON mygame__sample__monster__f26__type (f26__type)", nil, nil, nil)
    sqlite3_exec(sqlite.sqlite, "CREATE TABLE IF NOT EXISTS mygame__sample__monster__f26__u2__f4 (rowid INTEGER PRIMARY KEY, f26__u2__f4 TEXT)", nil, nil, nil)
    sqlite3_exec(sqlite.sqlite, "CREATE UNIQUE INDEX IF NOT EXISTS index__mygame__sample__monster__f26__u2__f4 ON mygame__sample__monster__f26__u2__f4 (f26__u2__f4)", nil, nil, nil)
    sqlite.clearIndexStatus(for: Self.table)
  }
  public static func insertIndex(_ toolbox: PersistenceToolbox, field: String, rowid: Int64, table: ByteBuffer) -> Bool {
    guard let sqlite = ((toolbox as? SQLitePersistenceToolbox).map { $0.connection }) else { return false }
    switch field {
    case "f6":
      guard let insert = sqlite.prepareStaticStatement("INSERT INTO mygame__sample__monster__f6 (rowid, f6) VALUES (?1, ?2)") else { return false }
      rowid.bindSQLite(insert, parameterId: 1)
      if let retval = MyGame.Sample.Monster.mana.evaluate(object: .table(table)) {
        retval.bindSQLite(insert, parameterId: 2)
      } else {
        sqlite3_bind_null(insert, 2)
      }
      guard SQLITE_DONE == sqlite3_step(insert) else { return false }
    case "f26__type":
      guard let insert = sqlite.prepareStaticStatement("INSERT INTO mygame__sample__monster__f26__type (rowid, f26__type) VALUES (?1, ?2)") else { return false }
      rowid.bindSQLite(insert, parameterId: 1)
      if let retval = MyGame.Sample.Monster.equipped._type.evaluate(object: .table(table)) {
        retval.bindSQLite(insert, parameterId: 2)
      } else {
        sqlite3_bind_null(insert, 2)
      }
      guard SQLITE_DONE == sqlite3_step(insert) else { return false }
    case "f26__u2__f4":
      guard let insert = sqlite.prepareStaticStatement("INSERT INTO mygame__sample__monster__f26__u2__f4 (rowid, f26__u2__f4) VALUES (?1, ?2)") else { return false }
      rowid.bindSQLite(insert, parameterId: 1)
      if let retval = MyGame.Sample.Monster.equipped.as(MyGame.Sample.Orb.self).name.evaluate(object: .table(table)) {
        retval.bindSQLite(insert, parameterId: 2)
      } else {
        sqlite3_bind_null(insert, 2)
      }
      guard SQLITE_DONE == sqlite3_step(insert) else { return false }
    default:
      break
    }
    return true
  }
}

extension MyGame.Sample {

public final class MonsterChangeRequest: Dflat.ChangeRequest {
  private var _o: Monster?
  public static var atomType: Any.Type { Monster.self }
  public var _type: ChangeRequestType
  public var _rowid: Int64
  public var pos: Vec3?
  public var mana: Int16
  public var hp: Int16
  public var name: String
  public var color: Color
  public var inventory: [UInt8]
  public var bag: [Equipment]
  public var weapons: [Weapon]
  public var equipped: Equipment?
  public var colors: [Color]
  public var path: [Vec3]
  public init(type: ChangeRequestType) {
    _o = nil
    _type = type
    _rowid = -1
    pos = nil
    mana = 150
    hp = 100
    name = ""
    color = .blue
    inventory = []
    bag = []
    weapons = []
    equipped = nil
    colors = []
    path = []
  }
  public init(type: ChangeRequestType, _ o: Monster) {
    _o = o
    _type = type
    _rowid = o._rowid
    pos = o.pos
    mana = o.mana
    hp = o.hp
    name = o.name
    color = o.color
    inventory = o.inventory
    bag = o.bag
    weapons = o.weapons
    equipped = o.equipped
    colors = o.colors
    path = o.path
  }
  public static func changeRequest(_ o: Monster) -> MonsterChangeRequest? {
    let transactionContext = SQLiteTransactionContext.current!
    let key: SQLiteObjectKey = o._rowid >= 0 ? .rowid(o._rowid) : .primaryKey([o.name, o.color])
    let u = transactionContext.objectRepository.object(transactionContext.connection, ofType: Monster.self, for: key)
    return u.map { MonsterChangeRequest(type: .update, $0) }
  }
  public static func creationRequest(_ o: Monster) -> MonsterChangeRequest {
    let creationRequest = MonsterChangeRequest(type: .creation, o)
    creationRequest._rowid = -1
    return creationRequest
  }
  public static func creationRequest() -> MonsterChangeRequest {
    return MonsterChangeRequest(type: .creation)
  }
  public static func upsertRequest(_ o: Monster) -> MonsterChangeRequest {
    guard let changeRequest = Self.changeRequest(o) else {
      return Self.creationRequest(o)
    }
    return changeRequest
  }
  public static func deletionRequest(_ o: Monster) -> MonsterChangeRequest? {
    let transactionContext = SQLiteTransactionContext.current!
    let key: SQLiteObjectKey = o._rowid >= 0 ? .rowid(o._rowid) : .primaryKey([o.name, o.color])
    let u = transactionContext.objectRepository.object(transactionContext.connection, ofType: Monster.self, for: key)
    return u.map { MonsterChangeRequest(type: .deletion, $0) }
  }
  var _atom: Monster {
    let atom = Monster(name: name, color: color, pos: pos, mana: mana, hp: hp, inventory: inventory, bag: bag, weapons: weapons, equipped: equipped, colors: colors, path: path)
    atom._rowid = _rowid
    return atom
  }
  public func commit(_ toolbox: PersistenceToolbox) -> UpdatedObject? {
    guard let toolbox = toolbox as? SQLitePersistenceToolbox else { return nil }
    switch _type {
    case .creation:
      let indexSurvey = toolbox.connection.indexSurvey(Monster.indexFields, table: Monster.table)
      guard let insert = toolbox.connection.prepareStaticStatement("INSERT INTO mygame__sample__monster (__pk0, __pk1, p) VALUES (?1, ?2, ?3)") else { return nil }
      name.bindSQLite(insert, parameterId: 1)
      color.bindSQLite(insert, parameterId: 2)
      let atom = self._atom
      toolbox.flatBufferBuilder.clear()
      let offset = atom.to(flatBufferBuilder: &toolbox.flatBufferBuilder)
      toolbox.flatBufferBuilder.finish(offset: offset)
      let byteBuffer = toolbox.flatBufferBuilder.buffer
      let memory = byteBuffer.memory.advanced(by: byteBuffer.reader)
      let SQLITE_STATIC = unsafeBitCast(OpaquePointer(bitPattern: 0), to: sqlite3_destructor_type.self)
      sqlite3_bind_blob(insert, 3, memory, Int32(byteBuffer.size), SQLITE_STATIC)
      guard SQLITE_DONE == sqlite3_step(insert) else { return nil }
      _rowid = sqlite3_last_insert_rowid(toolbox.connection.sqlite)
      if indexSurvey.full.contains("f6") {
        guard let i0 = toolbox.connection.prepareStaticStatement("INSERT INTO mygame__sample__monster__f6 (rowid, f6) VALUES (?1, ?2)") else { return nil }
        _rowid.bindSQLite(i0, parameterId: 1)
        if let r0 = MyGame.Sample.Monster.mana.evaluate(object: .object(atom)) {
          r0.bindSQLite(i0, parameterId: 2)
        } else {
          sqlite3_bind_null(i0, 2)
        }
        guard SQLITE_DONE == sqlite3_step(i0) else { return nil }
      }
      if indexSurvey.full.contains("f26__type") {
        guard let i1 = toolbox.connection.prepareStaticStatement("INSERT INTO mygame__sample__monster__f26__type (rowid, f26__type) VALUES (?1, ?2)") else { return nil }
        _rowid.bindSQLite(i1, parameterId: 1)
        if let r1 = MyGame.Sample.Monster.equipped._type.evaluate(object: .object(atom)) {
          r1.bindSQLite(i1, parameterId: 2)
        } else {
          sqlite3_bind_null(i1, 2)
        }
        guard SQLITE_DONE == sqlite3_step(i1) else { return nil }
      }
      if indexSurvey.full.contains("f26__u2__f4") {
        guard let i2 = toolbox.connection.prepareStaticStatement("INSERT INTO mygame__sample__monster__f26__u2__f4 (rowid, f26__u2__f4) VALUES (?1, ?2)") else { return nil }
        _rowid.bindSQLite(i2, parameterId: 1)
        if let r2 = MyGame.Sample.Monster.equipped.as(MyGame.Sample.Orb.self).name.evaluate(object: .object(atom)) {
          r2.bindSQLite(i2, parameterId: 2)
        } else {
          sqlite3_bind_null(i2, 2)
        }
        guard SQLITE_DONE == sqlite3_step(i2) else { return nil }
      }
      _type = .none
      atom._rowid = _rowid
      return .inserted(atom)
    case .update:
      guard let o = _o else { return nil }
      let atom = self._atom
      guard atom != o else {
        _type = .none
        return .identity(atom)
      }
      let indexSurvey = toolbox.connection.indexSurvey(Monster.indexFields, table: Monster.table)
      guard let update = toolbox.connection.prepareStaticStatement("REPLACE INTO mygame__sample__monster (__pk0, __pk1, p, rowid) VALUES (?1, ?2, ?3, ?4)") else { return nil }
      name.bindSQLite(update, parameterId: 1)
      color.bindSQLite(update, parameterId: 2)
      toolbox.flatBufferBuilder.clear()
      let offset = atom.to(flatBufferBuilder: &toolbox.flatBufferBuilder)
      toolbox.flatBufferBuilder.finish(offset: offset)
      let byteBuffer = toolbox.flatBufferBuilder.buffer
      let memory = byteBuffer.memory.advanced(by: byteBuffer.reader)
      let SQLITE_STATIC = unsafeBitCast(OpaquePointer(bitPattern: 0), to: sqlite3_destructor_type.self)
      sqlite3_bind_blob(update, 3, memory, Int32(byteBuffer.size), SQLITE_STATIC)
      _rowid.bindSQLite(update, parameterId: 4)
      guard SQLITE_DONE == sqlite3_step(update) else { return nil }
      if indexSurvey.full.contains("f6") {
        let or0 = MyGame.Sample.Monster.mana.evaluate(object: .object(o))
        let r0 = MyGame.Sample.Monster.mana.evaluate(object: .object(atom))
        if or0 != r0 {
          guard let u0 = toolbox.connection.prepareStaticStatement("REPLACE INTO mygame__sample__monster__f6 (rowid, f6) VALUES (?1, ?2)") else { return nil }
          _rowid.bindSQLite(u0, parameterId: 1)
          if let ur0 = r0 {
            ur0.bindSQLite(u0, parameterId: 2)
          } else {
            sqlite3_bind_null(u0, 2)
          }
          guard SQLITE_DONE == sqlite3_step(u0) else { return nil }
        }
      }
      if indexSurvey.full.contains("f26__type") {
        let or1 = MyGame.Sample.Monster.equipped._type.evaluate(object: .object(o))
        let r1 = MyGame.Sample.Monster.equipped._type.evaluate(object: .object(atom))
        if or1 != r1 {
          guard let u1 = toolbox.connection.prepareStaticStatement("REPLACE INTO mygame__sample__monster__f26__type (rowid, f26__type) VALUES (?1, ?2)") else { return nil }
          _rowid.bindSQLite(u1, parameterId: 1)
          if let ur1 = r1 {
            ur1.bindSQLite(u1, parameterId: 2)
          } else {
            sqlite3_bind_null(u1, 2)
          }
          guard SQLITE_DONE == sqlite3_step(u1) else { return nil }
        }
      }
      if indexSurvey.full.contains("f26__u2__f4") {
        let or2 = MyGame.Sample.Monster.equipped.as(MyGame.Sample.Orb.self).name.evaluate(object: .object(o))
        let r2 = MyGame.Sample.Monster.equipped.as(MyGame.Sample.Orb.self).name.evaluate(object: .object(atom))
        if or2 != r2 {
          guard let u2 = toolbox.connection.prepareStaticStatement("REPLACE INTO mygame__sample__monster__f26__u2__f4 (rowid, f26__u2__f4) VALUES (?1, ?2)") else { return nil }
          _rowid.bindSQLite(u2, parameterId: 1)
          if let ur2 = r2 {
            ur2.bindSQLite(u2, parameterId: 2)
          } else {
            sqlite3_bind_null(u2, 2)
          }
          guard SQLITE_DONE == sqlite3_step(u2) else { return nil }
        }
      }
      _type = .none
      return .updated(atom)
    case .deletion:
      guard let deletion = toolbox.connection.prepareStaticStatement("DELETE FROM mygame__sample__monster WHERE rowid=?1") else { return nil }
      _rowid.bindSQLite(deletion, parameterId: 1)
      guard SQLITE_DONE == sqlite3_step(deletion) else { return nil }
      if let d0 = toolbox.connection.prepareStaticStatement("DELETE FROM mygame__sample__monster__f6 WHERE rowid=?1") {
        _rowid.bindSQLite(d0, parameterId: 1)
        sqlite3_step(d0)
      }
      if let d1 = toolbox.connection.prepareStaticStatement("DELETE FROM mygame__sample__monster__f26__type WHERE rowid=?1") {
        _rowid.bindSQLite(d1, parameterId: 1)
        sqlite3_step(d1)
      }
      if let d2 = toolbox.connection.prepareStaticStatement("DELETE FROM mygame__sample__monster__f26__u2__f4 WHERE rowid=?1") {
        _rowid.bindSQLite(d2, parameterId: 1)
        sqlite3_step(d2)
      }
      _type = .none
      return .deleted(_rowid)
    case .none:
      preconditionFailure()
    }
  }
}

}

// MARK - MyGame.Sample
