local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local nl = t{'', ''}

ls.add_snippets('cpp', {

  -- PREPROCESSOR
  snip{
    name='#include', trig='^#i', regTrig=true,
    t'#include ',
  },

  snip{
    name='#include angle brackets', trig='^#<', regTrig=true,
    t'#include <', i(1, 'iostream>'), i(0),
  },

  snip{
    name='#include double quotes', trig='^#"', regTrig=true,
    t'#include "', d(1, function()
      local fname = vim.fn.expand('%<')
      if fname then fname = fname..'.hpp' end
      return i(1, fname..'"')
    end, {}), i(0),
  },

  snip{
    name='#pragma once', trig='^#p', regTrig=true,
    t{'#pragma once', ''},
  },

  snip{
    name='#define', trig='^#d', regTrig=true,
    t'#define ',
  },

  snip{
    name='#if', trig='^#if', regTrig=true,
    t'#if ', i(1, '1'), nl,
    i(0), nl,
    t'#endif // ', copy(1),
  },

  -- MAIN
  snip{
    name='main function', trig='^main', regTrig=true,
    t{'int main(int argc, char* argv[])', '{', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='main function with no arguments', trig='^mainn', regTrig=true,
    t{'int main()', '{', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='main function with QCoreApplication', trig='^qmain', regTrig=true,
    t{
      '#include <QCoreApplication>',
      '',
      'int main(int argc, char* argv[])',
      '{',
      '\tQCoreApplication app(argc, argv);',
      '\t'}, i(0), t{'',
      '\treturn app.exec();',
      '}',
    },
  },

  snip{
    name='main function with QML', trig='^qmlmain', regTrig=true,
    t{
      '#include <QGuiApplication>',
      '#include <QQmlApplicationEngine>',
      '',
      'int main(int argc, char* argv[])',
      '{',
      '\tQGuiApplication app(argc, argv);',
      '',
      '\tQQmlApplicationEngine engine;',
      '\tQQmlContext* ctx = engine.rootContext();',
      '',
      '\tconst QUrl url(QStringLiteral("qrc:/main.qml"));',
      '\tQObject::connect(&engine, &QQmlApplicationEngine::objectCreated,',
      '\t\t&app, [url](QObject *obj, const QUrl &objUrl) {',
      '\t\t\tif (!obj && url == objUrl)',
      '\t\t\t\tQCoreApplication::exit(-1);',
      '\t\t}, Qt::QueuedConnection);',
      '\tengine.load(url);',
      '',
      '\treturn app.exec();',
      '}',
    },
  },

  -- TYPES
  snip{
    name='struct definition', trig='^s', regTrig=true,
    t'struct ', i(1), t{'', '{', '\t'}, i(0), t{'', '};'},
  },

  snip{
    name='class definition', trig='^c', regTrig=true,
    t'class ', i(1), t{'', '{', '\t'}, i(0), t{'', '};'},
  },

  snip{
    name='QObject definition', trig='^q', regTrig=true,
    t'class ', i(1), t{' : public QObject', '{', '\tQ_OBJECT', '\t'}, i(0), t{'', '};'},
  },

  snip{
    name='namespace', trig='^ns', regTrig=true,
    t'namespace ', i(1, '1'), t{' {', ''},
    i(0), nl,
    t'} // namespace ', copy(1),
  },

  snip{
    name='function', trig='fn',
    i(1, 'void'), t' ', i(2, 'function_name'), t'(', i(3), t{')', '{', '\t'}, i(0), t{'', '}'}
  },

  -- CONTROL FLOW
  snip{
    name='if', trig='if',
    t'if (', i(1, 'true'), t{') {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='else if', trig='ei',
    t'else if (', i(1, 'true'), t{') {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='else', trig='el',
    t{'else {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='if null', trig='in',
    t'if (', i(1), t{' == nullptr) {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='for loop', trig='for',
    t'for (int ', i(2, 'i'), t' = 0; ', copy(2), t' < ', i(1, 'count'), t'; ++',
    copy(2), t{') {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='for loop iterator', trig='it',
    t'for (auto ', i(2, 'it'), t' = ', i(1, 'container'), t'.begin(); ', copy(2),
    t' != ', copy(1), t'.end(); ++', copy(2), t{') {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='for each', trig='fore',
    t'for (const auto& ', i(2, 'it'), t' : ', i(1, 'container'), t{') {', '\t'},
    i(0), t{'', '}'},
  },

  snip{
    name='try/catch', trig='try',
    t{
      'try {',
      '\t'}, i(0), t{'',
      '} catch (const '}, i(1, 'std::exception'), t{'& err) {',
      '}',
    },
  },

  -- SMART POINTERS
  snip{
    name='std::shared_ptr', trig='sp',
    t'std::shared_ptr<', i(1, 'int'), t'>',
  },

  snip{
    name='std::make_shared', trig='ms',
    t'std::make_unique<', i(1, 'int'), t'>(', i(2), t')',
  },

  snip{
    name='std::unique_ptr', trig='up',
    t'std::unique_ptr<', i(1, 'int'), t'>',
  },

  snip{
    name='std::make_unique', trig='mu',
    t'std::make_unique<', i(1, 'int'), t'>(', i(2), t')',
  },

  -- COMMON TYPES
  snip{
    name='std::vector', trig='vec',
    t'std::vector<', i(1, 'int'), t'>',
  },

  snip{
    name='const std::vector&', trig='cvec',
    t'const std::vector<', i(1, 'int'), t'>&',
  },

  snip{name='char*', trig='cs', t('char*')},
  snip{name='const char*', trig='cc', t('const char*')},
  snip{name='std::string', trig='str', t'std::string'},
  snip{name='const std::string&', trig='cstr', t'const std::string&'},
  snip{name='QString', trig='qs', t'QString'},
  snip{name='const QString&', trig='cqs', t'const QString&'},

  snip{
    name='std::unique_lock', trig='ul',
    t'std::unique_lock<', i(2, 'std::mutex'), t'> ',
    i(3, 'lock'), t'(', i(1, 'mutex'), t');',
  },

  snip{
    name='const reference', trig='cr',
    t'const ', i(1), t'&',
  },

  -- CASTS
  snip{
    name='static cast', trig='sc',
    t'static_cast<', i(1, 'int'), t'>(', i(2, 'expr'), t')',
  },

  snip{
    name='reinterpret cast', trig='rc',
    t'reinterpret_cast<', i(1, 'int'), t'>(', i(2, 'expr'), t')',
  },

  snip{
    name='dynamic cast', trig='dc',
    t'dynamic_cast<', i(1, 'int'), t'>(', i(2, 'expr'), t')',
  },

  snip{
    name='qobject cast', trig='qc',
    t'qobject_cast<', i(1, 'QObject'), t'*>(', i(2, 'expr'), t')',
  },

  -- MISC
  snip{name='assert', trig='as', t'assert(', i(1), t');'},
  snip{name='printf', trig='pf', t'printf("', i(1), t'"', i(2), t');'},
  snip{name='fprintf', trig='fp', t'printf(stderr, "', i(1), t'"', i(2), t');'},

})
