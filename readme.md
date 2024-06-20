```
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
```

# BACKUP - kopia przyrostowa
[Backup_incremental.cmd](https://github.com/Tusonic/Backup/blob/main/backup_incremental.cmd)
## Opis 
### @echo on
* Włącza wyświetlanie wszystkich wykonywanych poleceń na konsoli, co ułatwia śledzenie procesu wykonania skryptu.
### setlocal EnableDelayedExpansion
* Aktywuje opóźnione rozwijanie zmiennych, umożliwiając dynamiczne ich zmienianie i odczyt w trakcie działania pętli.
### Ustawianie ścieżek źródłowej i docelowej
#### set "source=C:\source\" 
* Ustawia zmienną source na ścieżkę katalogu źródłowego, skąd będą kopiowane pliki.
#### set "destination=C:\destination\" 
* Ustawia zmienną destination na ścieżkę katalogu docelowego, gdzie pliki będą kopiowane.
### Format daty i godziny
* %date:~-4% – Pobiera cztery ostatnie znaki ze zmiennej date, które zwykle odpowiadają roku. 
* %date:~-7,2% – Pobiera dwa znaki zaczynając od siódmego znaku od końca, co zwykle odpowiada miesiącu. 
* %date:~-10,2% – Pobiera dwa znaki zaczynając od dziesiątego znaku od końca, co zwykle odpowiada dniu. 
* %time:~0,2% – Pobiera dwa pierwsze znaki ze zmiennej time, które zwykle odpowiadają godzinie. 
* %time:~3,2% – Pobiera dwa znaki zaczynając od czwartego znaku, co zwykle odpowiada minutom. 
* %time:~6,2% – Pobiera dwa znaki zaczynając od siódmego znaku, co zwykle odpowiada sekundom. 
 
* * RRRR reprezentuje rok,
* * MM reprezentuje miesiąc,
* * DD reprezentuje dzień,
* * GG reprezentuje godzinę,
* * MM reprezentuje minuty,
* * SS reprezentuje sekundy

### Tworzenie struktury folderów i kopii zapasowych plików
* Rozpoczęcie pętli, która iteruje przez wszystkie pliki w katalogu źródłowym i jego podkatalogach (for /R "%source%" %%F in (*) do {).
#### set "file=%%F" 
* Przypisuje do zmiennej file pełną ścieżkę aktualnie przetwarzanego pliku.
#### set "relPath=%%~pF" 
* Przechowuje względną ścieżkę pliku.
#### set "destPath=!destination!!relPath!" 
* Łączy ścieżkę docelową z względną ścieżką pliku, tworząc pełną ścieżkę docelową.

### Warunki kopiowania
#### Sprawdzenie, czy katalog docelowy istnieje (if not exist "!destPath!" {). Jeśli nie, tworzony jest nowy katalog (mkdir "!destPath!").
#### set "destFile=!destPath!%%~nxF"
* Określa ścieżkę i nazwę pliku docelowego.
### Warunkowe kopiowanie plików:
* Jeśli plik docelowy istnieje, porównywane są daty modyfikacji (if exist "!destFile!" {).
#### for %%I in ("!file!") do set "srcDate=%%~tI" 
* Pobiera datę modyfikacji pliku źródłowego.
#### for %%I in ("!destFile!") do set "destDate=%%~tI" 
* Pobiera datę modyfikacji pliku docelowego.
#### Jeśli daty są różne, plik jest kopiowany z nową datą w nazwie oraz nadpisuje istniejący plik docelowy.
