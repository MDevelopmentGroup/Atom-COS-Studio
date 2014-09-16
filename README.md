Atom - studio 0.1.1  package
==============
**[english]** | **[russian]**
# Before you start.
* Download and install:
* latest Atom release from [https://github.com/atom/atom/releases](https://github.com/atom/atom/releases)
* Web Terminal for better experience [https://github.com/intersystems-ru/webterminal](https://github.com/intersystems-ru/webterminal) project [page](http://intersystems-ru.github.io/webterminal)
* import **for_atom.xml** or **for_atom_mklink.xml** (experimental, for Windows only) in *NameSpaceForAtomStudio*
* run in Cache terminal or Web Terminal this commands
```
zn "NameSpaceForAtomStudio"
do ##class(MDG.Request).CreateBroker("/mdg-dev")
```
  * it will create web app for WEB.Broker and temporary directory *c:\temp* (you can change it later in Atom-stuio interface)
* clone this repo in *c:\users\%username%\.atom\packages*
## in Atom
* run Atom
  * in top menu **packages\cache-studio**, choose **NameSpace** or press **ctrl-alt-o**
  * select Namespace to work
  * wait until Atom studio loads all classes and files stored in selected Namespace
* after load
  * you will see tree with classes, routines, web part for default web app and toolbar with available functions (except mouse right clicks for documatic)
  * you can open Web Terminal in separate window (if installed)

##  Attention for current version
* only for local projects on Windows platform
*

## Hot keys
* ctrl-alt-o select NameSpace
* ctrl-alt-0 refresh (Classes and Programms)
* F7 compile current tab
* F8 compile all project
* ctrl-alt-a save all project, use it after update from git repository



# Русский | Russian [](#rulink)
* Скачайте последний Атом https://github.com/atom/atom/releases для Вашей операционной системы
* Для запуска студии в Атоме предварительно экспортируйте for_atom.xml в произвольную область Cache и скомпилируйте
* В терминале выполните do ##class(MDG.Request).CreateBroker("/mdg-dev") или самостоятельно создайте брокер /mdg-dev
  * будет создан брокер и временная папка c:\temp где будут храниться проекты
* клонируйте репозиторий в каталог c:\users\%username%\.atom\packages
* запустите Atom
  * в появившемся пункте меню packages\cache-studio выберите NameSpace
  * укажите область которую планируете открыть
  * произойдёт загрузка файлов в каталог, это займёт время
  * по окончании загрузки будет доступно дерево с двумя разделами
    * classes для классов
    * web для веб части
* после загрузки проекта возможно отправить на компиляцию и открыть Web Terminal в новом окне (Если установлен)

## Сознательные ограничения
* только для локального хоста (как это сделать понятно - работаем над тем что вызывает затруднения)
* файловая система Windows (необходимо определиться что будет вынесено в настройки и где они будут храниться)

## Известные проблемы
* изменения сделанные в студии Cache не отслеживаются (Cache работает быстрее Атома и происходит рассинхронизация)
* проблема Атома при работе с кирилицей (При загрузке классов в файловую систему)
* Web Terminal необходимо настроить для работы со студией Атома (Предположительно Allow Orign)
* Atom, на текущий момент, поддерживает только UTF-8
## Горячие клавиши
* ctrl-alt-o выбрать NameSpace
* ctrl-alt-0 обновить (Классы и программы)
* F7 компиляция текущей вкладки
* F8 компилировать весь проект
* ctrl-alt-a сохранить весь проект, используйте после обновления Вашего проекта из репозитория
