assert      = require 'assert'
should      = require 'should'
Table       = require 'cli-table'
CleverBufferReader   = require "#{SRC}/clever-buffer-reader"

BIG_BUFFER = new Buffer [
    0x45,0x58,0x50,0x45,0x43,0x54,0x45,0x44,0x20,0x52,0x45,0x54,0x55,0x52,0x4e,0x21,
    0x52,0x45,0x54,0x55,0x52,0x4e,0x20,0x4f,0x46,0x20,0x24,0x32,0x2e,0x30,0x30,0x21,
    0x45,0x58,0x50,0x45,0x43,0x54,0x45,0x44,0x20,0x52,0x45,0x54,0x55,0x52,0x4e,0x21,
    0x52,0x45,0x54,0x55,0x52,0x4e,0x20,0x4f,0x46,0x20,0x24,0x32,0x2e,0x30,0x30,0x21,
    0x45,0x58,0x50,0x45,0x43,0x54,0x45,0x44,0x20,0x52,0x45,0x54,0x55,0x52,0x4e,0x21,
    0x52,0x45,0x54,0x55,0x52,0x4e,0x20,0x4f,0x46,0x20,0x24,0x32,0x2e,0x30,0x30,0x21
]

describe 'Performance', ->

  table = new Table
    head: ['Operation', 'time (ms)']
    colWidths: [30, 20]

  run = (name, op, count) ->
    start = new Date()
    op() for n in [0..count]
    end = new Date()
    table.push ["#{name} * #{count}", end - start]

  it 'prints some performance figures', ->
    run 'Read UInt8', readUnit8, 50000
    run 'Read UInt64', readUInt64, 50000
    run 'Read String', readString, 50000
    console.log ''
    console.log table.toString()


readUnit8 = ->
  buf = new Buffer [0x52,0x45,0x54,0x55,0x52,0x4e,0x20,0x4f,0x46]
  cleverBuffer = new CleverBufferReader buf
  for i in [0..(buf.length - 1)]
    assert.equal cleverBuffer.getUInt8(), buf.readUInt8(i)

readUInt64 = ->
  buf = new Buffer [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
  cleverBuffer = new CleverBufferReader buf
  assert.equal cleverBuffer.getUInt64(), '18446744073709551615'

readString = ->
  buf = new Buffer [0x48, 0x45, 0x4C, 0x4C, 0x4F]
  cleverBuffer = new CleverBufferReader buf
  assert.equal cleverBuffer.getString(length: 5), 'HELLO'
