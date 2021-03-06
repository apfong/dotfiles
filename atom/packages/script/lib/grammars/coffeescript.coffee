path = require 'path'
GrammarUtils = require '../grammar-utils'

bin = path.join __dirname, '../..', 'node_modules', '.bin'
coffee = path.join bin, 'coffee'
babel = path.join bin, 'babel'

args = ({filepath}) -> ['-c', "'#{coffee}' -p '#{filepath}'|'#{babel}' --filename '#{bin}'| node"]

exports.CoffeeScript =
  'Selection Based':
    command: 'bash'
    args: (context) ->
      {scopeName} = atom.workspace.getActiveTextEditor()?.getGrammar()
      lit = if scopeName?.includes 'lit' then 'lit' else ''
      code = context.getCode()
      filepath = GrammarUtils.createTempFileWithCode(code, ".#{lit}coffee")
      return args({filepath})

  'File Based': { command: 'bash', args }

exports['CoffeeScript (Literate)'] = exports.CoffeeScript

exports.IcedCoffeeScript =
  'Selection Based':
    command: 'iced'
    args: (context) -> ['-e', context.getCode()]

  'File Based':
    command: 'iced'
    args: ({filepath}) -> [filepath]
