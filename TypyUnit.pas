unit TypyUnit;

interface

type
    TTablica2Znakow = array [0..1] of Char;
    TTablica3Znakow = array [0..2] of Char;
    TTablica4Znakow = array [0..3] of Char;
    TTablica5Znakow = array [0..4] of Char;
    TTablica6Znakow = array [0..5] of Char;
    TTablica7Znakow = array [0..6] of Char;
    TTablica10Znakow = array [0..9] of Char;
    TTablica13Znakow = array [0..13] of Char;
    TTablica16Znakow = array [0..15] of Char;
    TTablica19Znakow = array [0..19] of Char;
    TTablica255Znakow = array [0..254] of Char;
    TTablica500Znakow = array [0..499] of Char;

    TOnRaportCreateProgress = procedure(position, max: Integer) of object;
    TOnRaportCreateFunction = procedure(onProgress: TOnRaportCreateProgress) of object;

implementation

end.
 
