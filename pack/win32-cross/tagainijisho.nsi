Name "Tagaini Jisho ${VERSION}"
OutFile "install.exe"
SetCompressor /SOLID "lzma"

InstallDir "$PROGRAMFILES\Tagaini Jisho"
RequestExecutionLevel admin
LicenseData "${SRCDIR}/COPYING.txt"
Page license
Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

Section "Tagaini Jisho"
IfFileExists "$LOCALAPPDATA\VirtualStore\Program Files\Tagaini Jisho\kanjidic2.db" VSTOREKANJIDICEXISTS VSTOREKANJIDICEND
VSTOREKANJIDICEXISTS:
Delete "$LOCALAPPDATA\VirtualStore\Program Files\Tagaini Jisho\jmdict.db"
Delete "$LOCALAPPDATA\VirtualStore\Program Files\Tagaini Jisho\kanjidic2.db"
RMDir "$LOCALAPPDATA\VirtualStore\Program Files\Tagaini Jisho"
VSTOREKANJIDICEND:

SetOutPath "$INSTDIR"
File "${BUILDDIR}/src/gui/tagainijisho.exe"
File "${BUILDDIR}/jmdict.db"
SetFileAttributes "jmdict.db" READONLY
File "${BUILDDIR}/kanjidic2.db"
SetFileAttributes "kanjidic2.db" READONLY
File "${BUILDDIR}/jmdict-en.db"
SetFileAttributes "jmdict-en.db" READONLY
File "${BUILDDIR}/kanjidic2-en.db"
SetFileAttributes "kanjidic2-en.db" READONLY
File "${BUILDDIR}/jmdict-fr.db"
SetFileAttributes "jmdict-fr.db" READONLY
File "${BUILDDIR}/kanjidic2-fr.db"
SetFileAttributes "kanjidic2-fr.db" READONLY
File "${BUILDDIR}/jmdict-de.db"
SetFileAttributes "jmdict-de.db" READONLY
File "${BUILDDIR}/kanjidic2-de.db"
SetFileAttributes "kanjidic2-de.db" READONLY
File "${BUILDDIR}/jmdict-es.db"
SetFileAttributes "jmdict-es.db" READONLY
File "${BUILDDIR}/kanjidic2-es.db"
SetFileAttributes "kanjidic2-es.db" READONLY
File "${BUILDDIR}/jmdict-ru.db"
SetFileAttributes "jmdict-ru.db" READONLY
File "${BUILDDIR}/kanjidic2-ru.db"
SetFileAttributes "kanjidic2-ru.db" READONLY
File "${SRCDIR}/src/gui/export_template.html"
File "${SRCDIR}/src/gui/detailed_default.html"
File "${SRCDIR}/src/gui/detailed_default.css"
File "${SRCDIR}/src/gui/jmdict/detailed_jmdict.html"
File "${SRCDIR}/src/gui/jmdict/detailed_jmdict.css"
File "${SRCDIR}/src/gui/kanjidic2/detailed_kanjidic2.html"
File "${SRCDIR}/src/gui/kanjidic2/detailed_kanjidic2.css"
File "${QTPATH}/bin/QtCore4.dll"
File "${QTPATH}/bin/QtGui4.dll"
File "${QTPATH}/bin/QtSql4.dll"
File "${QTPATH}/bin/QtNetWork4.dll"
File "${QTPATH}/bin/libgcc_s_dw2-1.dll"
File "${MINGWDLLPATH}/mingwm10.dll"
File "qt.conf"
SetOutPath "$INSTDIR\i18n"
File "${BUILDDIR}/i18n/qt_fr.qm"
File "${BUILDDIR}/i18n/qt_de.qm"
File "${BUILDDIR}/i18n/qt_es.qm"
File "${BUILDDIR}/i18n/qt_ru.qm"
File "${BUILDDIR}/i18n/qt_nl.qm"
File "${BUILDDIR}/i18n/qt_cs.qm"
File "${BUILDDIR}/i18n/tagainijisho_fr.qm"
File "${BUILDDIR}/i18n/tagainijisho_de.qm"
File "${BUILDDIR}/i18n/tagainijisho_es.qm"
File "${BUILDDIR}/i18n/tagainijisho_ru.qm"
File "${BUILDDIR}/i18n/tagainijisho_nl.qm"
File "${BUILDDIR}/i18n/tagainijisho_cs.qm"
SetOutPath "$INSTDIR\doc"
File "${SRCDIR}/doc/manual.html"
File /r "${SRCDIR}/doc/images"
WriteUninstaller "$INSTDIR\uninstall.exe"
CreateDirectory "$SMPROGRAMS\Tagaini Jisho"
CreateShortCut "$SMPROGRAMS\Tagaini Jisho\Tagaini Jisho.lnk" "$INSTDIR\tagainijisho.exe"
CreateShortCut "$SMPROGRAMS\Tagaini Jisho\Uninstall.lnk" "$INSTDIR\uninstall.exe"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Tagaini Jisho" "DisplayName" "Tagaini Jisho"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Tagaini Jisho" "UninstallString" "$INSTDIR/uninstall.exe"
SectionEnd

Section "uninstall"
Delete "$SMPROGRAMS\Tagaini Jisho\Tagaini Jisho.lnk"
Delete "$SMPROGRAMS\Tagaini Jisho\Uninstall.lnk"
RMDir "$SMPROGRAMS\Tagaini Jisho"
RMDir /r "$INSTDIR\doc\images"
Delete "$INSTDIR\doc\manual.html"
RMDir "$INSTDIR\doc"
Delete "$INSTDIR\i18n\qt_cs.qm"
Delete "$INSTDIR\i18n\qt_nl.qm"
Delete "$INSTDIR\i18n\qt_ru.qm"
Delete "$INSTDIR\i18n\qt_es.qm"
Delete "$INSTDIR\i18n\qt_de.qm"
Delete "$INSTDIR\i18n\qt_fr.qm"
Delete "$INSTDIR\i18n\tagainijisho_fr.qm"
Delete "$INSTDIR\i18n\tagainijisho_de.qm"
Delete "$INSTDIR\i18n\tagainijisho_es.qm"
Delete "$INSTDIR\i18n\tagainijisho_ru.qm"
Delete "$INSTDIR\i18n\tagainijisho_nl.qm"
Delete "$INSTDIR\i18n\tagainijisho_cs.qm"
RMDir "$INSTDIR\i18n"
Delete "$INSTDIR\export_template.html"
Delete "$INSTDIR\detailed_default.html"
Delete "$INSTDIR\detailed_default.css"
Delete "$INSTDIR\detailed_jmdict.html"
Delete "$INSTDIR\detailed_jmdict.css"
Delete "$INSTDIR\detailed_kanjidic2.html"
Delete "$INSTDIR\detailed_kanjidic2.css"
Delete "$INSTDIR\QtCore4.dll"
Delete "$INSTDIR\QtGui4.dll"
Delete "$INSTDIR\QtSql4.dll"
Delete "$INSTDIR\QtNetwork4.dll"
Delete "$INSTDIR\qt.conf"
Delete "$INSTDIR\libgcc_s_dw2-1.dll"
Delete "$INSTDIR\mingwm10.dll"
Delete "$INSTDIR\export_template.html"
Delete "$INSTDIR\kanjidic2-ru.db"
Delete "$INSTDIR\jmdict-ru.db"
Delete "$INSTDIR\kanjidic2-es.db"
Delete "$INSTDIR\jmdict-es.db"
Delete "$INSTDIR\kanjidic2-de.db"
Delete "$INSTDIR\jmdict-de.db"
Delete "$INSTDIR\kanjidic2-fr.db"
Delete "$INSTDIR\jmdict-fr.db"
Delete "$INSTDIR\kanjidic2-en.db"
Delete "$INSTDIR\jmdict-en.db"
Delete "$INSTDIR\kanjidic2.db"
Delete "$INSTDIR\jmdict.db"
Delete "$INSTDIR\tagainijisho.exe"
Delete "$INSTDIR\uninstall.exe"
RMDir "$INSTDIR"
DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Tagaini Jisho"
SectionEnd

