@echo on
setlocal EnableDelayedExpansion

:: Ustaw ścieżki źródłową i docelową
set "source=C:\source\"
set "destination=C:\destination\"

:: Format daty i godziny
set "datetime=%date:~-4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%"

:: Tworzenie struktury folderów i kopii zapasowych plików
for /R "%source%" %%F in (*) do (
    set "file=%%F"
    set "relPath=%%~pF"
    set "destPath=!destination!!relPath!"

    :: Utwórz strukturę folderów w miejscu docelowym, jeśli jeszcze nie istnieje
    if not exist "!destPath!" (
        mkdir "!destPath!"
    )

    set "destFile=!destPath!%%~nxF"

    if exist "!destFile!" (
        :: Pobierz daty ostatniej modyfikacji plików
        for %%I in ("!file!") do set "srcDate=%%~tI"
        for %%I in ("!destFile!") do set "destDate=%%~tI"

        :: Porównaj daty
        if not "!srcDate!"=="!destDate!" (
            :: Twórz kopię zapasową z nową datą w nazwie
            set "backupDestFile=!destPath!%%~nF_!datetime!%%~xF"
            copy "!file!" "!backupDestFile!"

            :: Nadpisz plik w miejscu docelowym
            copy "!file!" "!destFile!" /Y
        )
    ) else (
        copy "!file!" "!destFile!"
    )
)

:: Koniec skryptu
endlocal
echo Kopiowanie zakończone.
pause