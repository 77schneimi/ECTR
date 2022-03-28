# Macros

## Allgemein

## Speicherort

Um Makros in Addons oder application in das ECTR Menü einzubinden müssen diese wie folgt aufgerufen werden:

`fnc.execute.macro(name_des_addons\:macro.txt)`  
`fnc.execute.macro(name_der_application\:macro.txt)`

Sollten wir also ein macro in unserer CAT integration ausliefern, lässt sich dieses über `fnc.execute.macro(cat\:macro.txt)` aufrufen.

Der Vorteil hier ist, Makros müssen nicht alle zwingend in _customize/config_ angelegt werden, sondern können Adapter oder addonabhängig ausgeliefert werden, ohne diese beim Kunden weiter verschieben zu müssen. 

## Aufrufer

Makros im ECTR können an verschiedener Stelle aufgerufen werden. Häufig findet sich in bestehenden Makros eine Abfrage in welchem Kontext diese ausgeführt wird:

```js

if ($execution_environment == "SMARTCONTAINER") {
      alert("This macro cannot be used for a SmartContainer")
      return
}
```

Über die Variable `$execution_environment` kann man abfragen und sicherstellen das mein Makro nur in bestimmten Kontexten ausgeführt werden darf.

Mögliche Environments:
+ SMARTLIST
+ SMARTCONTAINER
+ SMARTFOLDER
+ EDITOR
+ OMF
+ CONNECTOR
+ QUICK_SEARCH
+ UNKNOWN


> (aus plm.utils.macro.ExecutionEnvironment der ECTR Java Klassen)