unit fncPasswordUnit;

interface

uses classes;

function CodePass(const pass: String) : String;
function DecodePass(const code: String) : String;


implementation

uses Sysutils;

const key_length = 3; // tego nie wolno zmieniaæ !

type
    TKlucz = array[0..key_length-1] of Byte;

//var stream, stream2, stream3: TFileStream;

function CodePass(const pass: String) : String;
var klucz: array[0..key_length-1] of Byte;
    i, length_: Integer;
    code: array of Byte;
    code2: String;
begin
    for i := 0 to key_length - 1 do
        klucz[i] := Byte(random(128));
    length_ := Length(pass);
    SetLength(code, length_ + key_length);
    for i := 0 to length_ - 1 do
        code[i] := Byte(pass[i + 1]) xor klucz[i mod key_length];
    for i := 0 to key_length - 1 do
        code[length_ + i] := klucz[i];
    code2 := '';
    for i :=0 to length_+key_length-1 do
        code2 := code2 + IntToHex(Integer(code[i]), 2);
    SetLength(code, 0);
    result := UpperCase(code2);
end;

function DecodePass(const code: String) : String;
var klucz: array[0..key_length-1] of Byte;
    length_: Integer;
    code2: array of Byte;
    i: Integer;
    pass: String;
    tmp: Integer;
    code_: String;
begin
    code_ := UpperCase(code);
    length_ := Trunc(Length(code_) / 2);
    SetLength(code2, length_);
    for i := 0 to length_ - 1 do
    begin
        if code[i*2 + 1] in ['0' .. '9'] then
            tmp := Byte(code_[i*2 + 1]) - Byte('0')
        else
            tmp := Byte(code_[i*2 + 1]) - Byte('A') + 10;
        tmp := tmp * 16;
        if code[i*2 + 2] in ['0' .. '9'] then
            tmp := tmp + Byte(code_[i*2 + 2]) - Byte('0')
        else
            tmp := tmp + Byte(code_[i*2 + 2]) - Byte('A') + 10;

        code2[i] := Byte(tmp);
    end;

    for i := 1 to length_ - key_length do
        pass := pass + ' ';
    if length_ > key_length then
    begin
        for i := 0 to key_length - 1 do
            klucz[i] := code2[length_ - key_length + i];
        for i := 0 to length_-key_length-1 do
            pass[i + 1] := Char(code2[i] xor klucz[i mod key_length]);
    end;
    SetLength(code2, 0);
    result := pass;
end;

end.

