unit fncFCSUnit;

interface

uses Classes;

procedure InitFCSTable();
Function FCS_calc(fcs_start: Word; fcs_stop: Word; buff: array of Word): Word;
Function FCS_calc2(fcs_start: Word; fcs_stop: Word; buff: String): String;
Function FCS_calc3(buff: TStream): String;

// fcs_start in [0..Length(bufor)]
// max(fcs_stop) = Length(bufor)

implementation

uses SysUtils, clipbrd;

var
    fcstab: array [0..255] of Word;

procedure InitFCSTable();
const p: Word = $8408;
var b: Word;
    v: Word;
    i: Word;
begin
    b := 0;
    repeat
        v := b;
        for i := 8 downto 1 do
            if (v and 1) <> 0 then
                v := ((v shr 1) xor p)
            else
                v := (v shr 1);
        fcstab[b] := v and $FFFF;
        Inc(b);
    until b = 256;
end;

Function FCS_calc2(fcs_start: Word; fcs_stop: Word; buff: String): String; 
const fcsinit: Word = $FFFF;
var fcs: Word;
    i: Word;
    old_: CHar;
begin
    fcs := fcsinit;
    for i := fcs_start + 1 to fcs_stop do
    begin
        old_ := buff[i];
//        if buff[i] = char($7D) then
//        begin
//            buff[i + 1] := char(Word(buff[i + 1]) xor $20);
//            continue;
//        end;
        fcs := (fcs shr 8) xor fcstab[(fcs xor Word(buff[i])) and $FF];
        buff[i] := old_;
    end;

    fcs := fcs xor $FFFF;
//    fcs := Trunc((fcs and $FF00) / $100) + (fcs and $FF) * $100;
    result := char(fcs and $FF) + Char(Trunc((fcs and $FF00) / $100));
end;

Function FCS_calc(fcs_start: Word; fcs_stop: Word; buff: array of Word): Word;
const fcsinit: Word = $FFFF;
var fcs: Word;
    i: Word;
begin
    fcs := fcsinit;
    for i := fcs_start to fcs_stop - 1 do
    begin
//        if buff[i] = $7D then
//        begin
//            buff[i + 1] := buff[i + 1] xor $20;
//            continue;
//        end;
        fcs := (fcs shr 8) xor fcstab[(fcs xor buff[i]) and $FF];
    end;
    fcs := fcs xor $FFFF;
    fcs := Trunc((fcs and $FF00) / $100) + (fcs and $FF) * $100;
    result := fcs;
end;

Function FCS_calc3(buff: TStream): String;
const fcsinit: Word = $FFFF;
var fcs: Word;
    znak: CHar;
begin
    fcs := fcsinit;
    while buff.Position < buff.Size do
    begin
        buff.Read(znak, 1);
        fcs := (fcs shr 8) xor fcstab[(fcs xor Word(znak)) and $FF];
    end;

    fcs := fcs xor $FFFF;
//    fcs := Trunc((fcs and $FF00) / $100) + (fcs and $FF) * $100;
    result := char(fcs and $FF) + Char(Trunc((fcs and $FF00) / $100));
end;

{var
    i: Integer;
    tmp: String; }

initialization

InitFCSTable();

{for i := 0 to 255 do
begin
    tmp := tmp + IntToHex(fcstab[i], 4) + ' ';
    if ((i + 1) mod 8) = 0 then
        tmp := tmp + #13 + #10;
end;

Clipboard().AsText := tmp; }

end.
