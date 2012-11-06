monad = require '../monad.coffee'

describe 'let', () ->
  it 'retuns null with no return funciton', () ->
    expect(monad.let []).toEqual null

  it 'returns result of return function', () ->
    expect(monad.let [], () -> 1).toEqual 1

  it 'uses results of let functions in return funciton', () ->
    expect(monad.let [['a', () -> 2]], () -> @a + 1).toEqual 3

  it 'uses results of previous let assignments in subsequent calls', () ->
    expect(monad.let [
      ['a', () -> 1 + 2],
      ['b', () -> @a + 1]
      ['c', () -> @a * @b]
    ], () -> @a * @b * @c ).toEqual 144

  it 'uses results of previous let assignments in parameters to subsequent calls', () ->
    inc = (val) -> val + 1
    expect(monad.let [
      ['a', () -> 1 + 2],
      ['b', () -> inc @a]
      ['c', () -> @a * @b]
    ], () -> @a * @b * @c ).toEqual 144

  it 'cannot change an assigned value', () ->
    expect(monad.let [
      ['a', () -> 1 + 2],
      ['b', () -> @a = 9]
    ], () -> @a).toEqual 3

  it 'assigns a value based on the return value even when assignment fails', () ->
    expect(monad.let [
      ['a', () -> 1 + 2],
      ['b', () -> @a = 9]
    ], () -> @b).toEqual 9
