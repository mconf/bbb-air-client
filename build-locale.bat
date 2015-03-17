if defined ProgramFiles(x86) (
    set pf=%ProgramFiles(x86)%
)
else (
    set pf=%ProgramFiles%
)

PATH=%PATH%;%pf%\Adobe\Adobe Flash Builder 4.6\sdks\4.6.0\bin

mxmlc -locale=en_US -source-path=src/locale/{locale} -include-resource-bundles=collections,components,controls,core,effects,layout,resources,skins,styles,textLayout -output src/locale/en_US/resources.swf

mxmlc -locale=pt_BR -source-path=src/locale/{locale} -include-resource-bundles=collections,components,controls,core,effects,layout,resources,skins,styles,textLayout -output src/locale/pt_BR/resources.swf