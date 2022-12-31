unit fncDataCzasBCB;

interface

function BCBToString(b2, b3, b5, b6, b7, b8: byte): string;
function BCBToStringWithError(b2: byte; b3:byte; b5, b6, b7, b8: byte): string;
procedure DateTimeToBCB(datetime: TDateTime; var b5, b6, b7, b8: byte);

implementation

uses SysUtils;

var last_good: String;
    ostatni_dzien_marca_2017: array[0..255] of Integer; // [nrpojazdu] = MMddHH - 1 marca 2017 polnoc to 100. 2 marca 3 w nocy to 203 itd.

function BCBToStringWithError(b2: byte; b3:byte; b5, b6, b7, b8: byte): string;
var d_min: Integer;
    j_min: Integer;
    d_godz: Integer;
    j_godz: Integer;
    rok: Integer;
    d_dni: Integer;
    j_dni: Integer;
    d_mies: Integer;
    j_mies: Integer;

{    d_min2: Integer;
    j_min2: Integer;
    d_godz2: Integer;
    j_godz2: Integer;
    rok2: Integer;
    d_dni2: Integer;
    j_dni2: Integer;
    d_mies2: Integer;
    j_mies2: Integer;
    tmp: Integer; }

    wynik: string;
    min, godz, dni, mies: String;
    Year, Year2, Month, Day: Word;
begin
    FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
    FormatSettings.ShortTimeFormat := 'gg:mm:ss';
    FormatSettings.DateSeparator := '-';

    d_min := Trunc(Integer(b5) / 16);
    j_min := Integer(b5) mod 16;
    d_godz := Trunc(Integer(b6) / 16);
    j_godz := Integer(b6) mod 16;
    rok := Trunc(Integer(b7) / 64);
    d_dni := Trunc((Integer(b7) mod 64) / 16);
    j_dni := Integer(b7) mod 16;
    d_mies := Trunc((Integer(b8) mod 32) / 16);
    j_mies := Integer(b8) mod 16;

    min := IntToStr(d_min * 10 + j_min);
    while Length(min) < 2 do
        min := '0' + min;
    godz := IntToStr(d_godz * 10 + j_godz);
    while Length(godz) < 2 do
        godz := '0' + godz;
    dni := IntToStr(d_dni * 10 + j_dni);
    while Length(dni) < 2 do
        dni := '0' + dni;
    mies := IntToStr(d_mies * 10 + j_mies);
    while Length(mies) < 2 do
        mies := '0' + mies;

    DecodeDate(Now(), Year, Month, Day);
    Year2 := Year;
    while (Year2 mod 4) <> 0 do
        Year2 := Year2 - 1;

    if ((Year mod 4) <> rok) and ((d_mies * 10 + j_mies) = 1) then
    begin
        Year2 := Year;

        while (Year2 mod 4) <> 0 do
            Year2 := Year2 - 1;

        rok := (Year mod 4); 
    end;





//    if (Year2 + rok) > Year then
//        Year2 := Year2 - 4;

//    if (Year2 + rok) = 2008 then // ?????? (stara, dziwna poprawka z 2010 roku)
//        Year2 := Year2 + 2;

//	if ((Year = 2016) and (Month in [1..6]) and (rok = 3)) then 
//	begin               // WKU 2016-01-04, blad w firmware: offset w 2016 roku nie moze wynosic 3 
//	    Year2 := 2016;  // by³ on wlasciwy w roku 2015-tym, ale nie w 2016-tym
//		                // problem nie jest jednorodny: czasami jest offset 3 przez jakis czas, na potem poprawny 0 w tym samym urzadzeniu (przejscie z zdarzeniu 66 - próba wysy³ki - byc moze problem wystepuje do czasu pierwszego uaktualnienia zegara przy zmianie roku)
//		rok := 0;       // poprawka dziala przez pierwsze polrocze 2016 (czas na poprawke firmware)
//	end;                // najlepiej dodac bajt 11-ty i 12-ty na pelny rok w zdarzeniu, zeby problem sie nie powtórzy³

//    if ((Year >= 2016) and (Month = 1) and ((Year mod 4) <> rok)) and ((d_mies * 10 + j_mies) <> 1) then
//    begin                    // WKU 2016-01-04, blad w firmware: offset w 2016 roku nie moze wynosic 3
//        Year2 := Year;       // by³ on wlasciwy w roku 2015-tym, ale nie w 2016-tym
//                             // problem nie jest jednorodny: czasami jest offset 3 przez jakis czas
//        rok := (Year mod 4); // a potem poprawny 0 w tym samym urzadzeniu (przejscie z zdarzeniu 66 - próba wysy³ki
//    end;                     //  - problem wystepuje do czasu pierwszego uaktualnienia zegara przy zmianie roku)



    if ((Year2 + rok) mod 4) <> 0 then
    begin
        if (mies = '02') and (dni = '29') then
        begin
            mies := '03';
            dni := '01';
        end;
    end;

       {
    if ((Year2 + rok) = 2017)
        and (StrToInt(mies) = 3)
        and (StrToInt(dni) in [1..1])
        and (integer(b3) <> 85)
    then
    begin
        if ((StrToInt(mies) * 10000) + (StrToInt(dni) * 100) + StrToInt(godz)) >
            ostatni_dzien_marca_2017[integer(b2)] then
        begin
            ostatni_dzien_marca_2017[integer(b2)] :=
                ((StrToInt(mies) * 10000) + (StrToInt(dni) * 100) + StrToInt(godz));
        end;

        if ((StrToInt(mies) * 10000) + (StrToInt(dni) * 100) + StrToInt(godz)) <
            ostatni_dzien_marca_2017[integer(b2)] then
        begin
            dni := IntToStr(StrToInt(dni) + 1);
            while Length(dni) < 2 do
                dni := '0' + dni;
            ostatni_dzien_marca_2017[integer(b2)] :=
                ((StrToInt(mies) * 10000) + (StrToInt(dni) * 100) + StrToInt(godz));
        end;
    end;  }


	
    wynik := IntToStr(Year2 + rok) + '-' + mies + '-' + dni + ' ' + godz + ':' + min;
    result := wynik;
end;

function BCBToString(b2, b3, b5, b6, b7, b8: byte): string;
var wynik: String;
begin
    wynik := BCBToStringWithError(b2, b3, b5, b6, b7, b8);
    try
        StrToDateTime(wynik);
        if (b3 <> byte(85)) and (b3 <> byte(117)) and (b3 <> byte(217)) then
            last_good := wynik;
        result := wynik;
    except
        if last_good = '' then
        begin
            last_good := DateTimeToStr(Now());
            last_good := Copy(last_good, 1, Length(last_good) - 3);
        end;
        result := last_good;
    end;
end;

procedure DateTimeToBCB(datetime: TDateTime; var b5, b6, b7, b8: byte);
var Year, Month, Day: Word;
    Hour, Min, Sec, MSec: Word;
    j_min, d_min: Integer;
    j_godz, d_godz: Integer;
    j_dni, d_dni: Integer;
    j_mies, d_mies: Integer;
    rok: integer;
begin
    FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
    FormatSettings.ShortTimeFormat := 'gg:mm:ss';
    FormatSettings.DateSeparator := '-';

    DecodeDate(datetime, Year, Month, Day);
    DecodeTime(datetime, Hour, Min, Sec, MSec);

    d_min := Trunc(Min / 10);
    j_min := Min mod 10;

    d_godz := Trunc(Hour / 10);
    j_godz := Hour mod 10;

    d_dni := Trunc(Day / 10);
    j_dni := Day mod 10;

    d_mies := Trunc(Month / 10);
    j_mies := Month mod 10;

    rok := Year mod 4;

    b5 := byte(d_min * 16 + j_min);
    b6 := byte(d_godz * 16 + j_godz);
    b7 := byte(rok * 64 + d_dni * 16 + j_dni);
    b8 := byte(d_mies * 16 + j_mies);
end;

initialization

//BCBToStringWithError(byte(51), char(22), char(132), char(1));

end.
