# verilog to netlist
Конвертирует verilog в netlist из которого можно сделать pcb в KiCad 6.

## Установка
Установка зависимостей
```:bash
pip install pipenv
pipenv shell
pipenv install
```
Зависимости: Python 3.8 или выше

## Использование

Входной верилог файл лежит в папке `verilog_inputs` по умолчанию это файл `adder_synth.v` из него будет сгенерирован netlist для заранее созданного Kicad проекта

В папке `FA` содержится пример пустого проекта Kicad со всеми библиотеками добавленными в проект. Эти библиотеки используются при создании netlist.

`FA_result` уже готовый что будет после работы скрипты. 

Конфигурационный файл config.py 

Для каждого модуля создаются свои правила по ключу в словаре. Каждый объект правил содержит ключи:
- `verilog_type` — имя элемента в верилог файле обязательно должны быть элементы для `input` и для `output` остальные например `NOT` опциональны если правила нет элемент в netlist не добавляется
- `kicad_schematic_lib` — имя кикад библиотеки схем так как его назвали при экспортировании в диалоге проекта Kicad 6 `Preferences → Manage Symbol Libraries... → **Project** Specific Libraries`
- `kicad_scheamtic_element` — Имя элемента как назван в библиотеке схем экспортированной выше
`kicad_footprint` — футпринт элемента в формате `{имя библиотеки}:{имя элемента}` в диалоге проекта Kicad 6 `Preferences → Manage Footprint Libraries... → Project Specific Libraries`
- `pins` — правила замены имен пинов из верилог файла в пины элемента Kicad. Пины в кикад могут быть названия как по `name` так и по `number`. В shematic элемента у пина могут быть указаны как `name` так и `number` оба параметра могут быть текстом. У footprint у пинов есть только `number`

Пример:

```
...
"FA": [{
    "verilog_type": "input",
    "kicad_schematic_lib": "FA",
    "kicad_schematic_element": "HOLE",
    "kicad_footprint": "FA:HOLE",
    "pins": {},
},
    {
    "verilog_type": "output",
        "kicad_schematic_lib": "FA",
        "kicad_schematic_element": "HOLE",
        "kicad_footprint": "FA:HOLE",
        "pins": {},
},{
    "verilog_type": "NOR",
        "kicad_schematic_lib": "FA",
        "kicad_schematic_element": "NOR",
        "kicad_footprint": "FA:NOR",
        "pins": {
            ".A": {
                "number": "4"
            },
            ".B": {
                "number": "5"
            },
            ".Y": {
                "number": "7"
            }},
},]
...
```
Элементы верилог файла
```
...
  input ci;
...
  output co;
...
  NOR _12_ (
    .A(_05_),
    .B(_06_),
    .Y(_08_)
  );
...
```

## Командная строка 
```
> python main.py
```

```
> python main.py --help
usage: main.py [-h] [-i [INPUT]] [-l [LIB]]
               [-o [OUTPUT]]

Convert verilog file to netlist

optional arguments:
  -h, --help            show this help
                        message and exit
  -i [INPUT], --input [INPUT]
                        Input verilog file.
                        default is verilog_in
                        puts/adder_synth.v
  -l [LIB], --lib [LIB]
                        Add kicad library
                        path. Multiple path
                        is allowed. default
                        is FA
  -o [OUTPUT], --output [OUTPUT]
                        Output folder.
                        default is
                        netlists_outputs
```
Необязательные параметры
- `-i` — имя входного верилог файла
- `-l` — путь до библиотеки Kicad 6 можно использовать не только проектную, но и глобальную библиотеку. Пути можно найти в документации по Kicad 6, можно добавить несколько путей для библиотек искать будет во всех.
- `-o` — имя папки куда попадут netlist от каждого модуля. Имя файла будет имя модуля с расширением `*.net`. Так же сюда попадет файл для библиотеки skidl оканчивающийся на `*_skidl.py`, который может сам сгенерировать netlist файл. При этом его удобно редактировать и в нем подробно указаны связи элементов. 

## Что делать с netlist

Можно создать новый проект добавив в него все библиотеки из исходного проект `*.kicad_sym`, папки `*.pretty` с файлами с расширением `*.kicad_mod`

В файле проект открыть `PCB editor`

Нажать `File → Import → Netlist` в Диалоге нажать `Update PCB` закрыть `Close`

К курсору прилипнут все элементы из netlist расположить их в удобном месте. Все соединенные пины будут соединены прямой линией

Расставить элементы так как будет удобно.

После этого можно будет сделать автотрассировку

## Автотрассировка

Скачать и установить LayoutEditor https://layouteditor.com/download если нет java то её тоже установить https://www.java.com/

Нажать в Kicad PCD Editor `File → Export → Spectra DSN...` сохранить.

В установленном приложении LayoutEditor найти файл `freeRouting.jar` в Windows в папке программ `LayoutEditor\bin\freeRouting.jar`

Запустить в диалоге выбрать `*.dsn` файл созданные ранее. 

В открывшемся приложении выбрать `Routing → Autorouting` Когда процесс завершится нажать `File → Export → Export Spectra Session File` Файл сохранится в той же папке и с тем же названием только расширение будет `*.ses` на вопрос нажать `Yes`

В `PCB Editor` из Kicad открыв тот же файл куда импортировался netlist нажать `File → Import → Spectra Session...` выбрать созданный `*.ses` файл. Все элементы соединятся проводниками.

Теперь можно выбрать один или несколько выходов и нажать апостроф "`" пути соединений будут подсвечены.

Удалить путь чтобы разметить заново `Edit → Global Deletions...` выбрать `Tracks & vias` → `OK` → `Yes`. Теперь можно переставить элементы и сделать автотрассировку заново.