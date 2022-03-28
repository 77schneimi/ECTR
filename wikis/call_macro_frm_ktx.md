# Call a Macro form Kontext Menue

Aufruf eines Makros aus dem Context Menü heraus.

## Macro

Vorraussetung ein entsprechendes Macro existiert im Verzeichnis %ECTR_INSTALLATION%\customize\scripts\macros.  
Hier am Macro Beispiel *mat_ref.txt*.

Das Macro soll im Kontext von einem DIS aufgerufen werden können.

## Kontext Menü

### menu_macros

In Datei *%ECTR_INSTALLATION%\customize\config\menu_macros.txt* add the following statements. AM besten irgendwo bei einem DOC Menue.

```sh
# DIS Enhancements
# ---
# Enhancements to Assing MAT to a DIS by calling
# the Macro mat_ref.txt
#------------------------------------------------
? ENHANCED_MENUE_ALLOCATE_MAT_REF = fnc.execute.macro(mat_ref.txt)
```

### Menue Guid

In file *%ECTR_INSTALLATION%\customize\config\menu.guidef* add the following statement .


```sh
+  om.popup.menu.DOC                    = fnc.doc.status.change
                                        = fnc.doc.new.version
                                        = -----------------------------
                                        = mnu.flyout.doc_doc
                                          = fnc.doc.change.multi
                                          = -----------------------------
                                          = fnc.doc.delete
                                          = -----------------------------
                                          = fnc.doc.display
                                          = fnc.doc.change
                                          = -----------------------------
                                          = ? DOC_WUI
                                          = ? DOC_ACC_WUI
                                        = mnu.flyout.doc_mat
                                          = fnc.mat.create.multi
                                          = fnc.doc.allocate.material
                                          = ? ENHANCED_MENUE_ALLOCATE_MAT_REF # <-- this
                                        = mnu.flyout.doc_collab
                                          = fnc.create.url(open)
                                          = fnc.sap.note.send
                                          = fnc.send.to.active.folder
                                        = ? DOC_TEMP
                                        = ? ASSIGN_ECN_DOC
                                        = -----------------------------
                                        = ? DOC_EXTENSIONS
                                        = ? CLPBRD_REFRESH_DOC
```

### dictionary

In file *%ECTR_INSTALLATION%\basis\dictionary\en\ectr.txt* add the following statements after `fnc.api.generic2(ECTR_PRO_CREATE_DIRS) = Prozess erstellen`

```sh
# Process Enhancements
#------------------------------------------------
fnc.execute.macro(mat_ref.txt) = Material Referenz
```

Repeat this for each language you want to maintain (de, etc. ).

