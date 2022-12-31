unit fncExportUnit;

interface

uses CompressBLT, ComCtrls, clFileDataSetUnit, StdCtrls, TEDEmailUnit;

procedure CreateExportArchive(archiwum: TBLTArchive; ProgressBar: TProgressBar = nil;
      OnProgress: TOnProcentLog = nil; cbExportAlsoZones: Boolean = True);   overload;

procedure LoadExportArchive(archiwum: TBLTArchive; ProgressBar: TProgressBar = nil;
      OnProgress: TOnProcentLog = nil; Label2: TLabel = nil; cbImportAlsoZones: Boolean = True;
      Label10: TLabel = nil);   overload;

implementation

uses Classes, math, forms, windows, SysUtils, fncPasswordUnit,
    controls;

procedure CreateExportArchive(archiwum: TBLTArchive; ProgressBar: TProgressBar = nil;
      OnProgress: TOnProcentLog = nil; cbExportAlsoZones: Boolean = True); overload;
var cars, inputs_description, kierowcy, przesiadki, oddzialy, grupy,
      grupy_zawartosc_pojazdy, grupy_zawartosc_kierowcy, oddzialy_zawartosc,
      synch_events_status, mail_settings, ustawienia, ustawienia2,
      paliwo, paliwo_temp, paliwo_wyjatki, regiony, reguly_regionow: TStream;
    paliwo_char: TCharakterystykaArray;
    i, i2: Integer;
begin
    cars := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select t1.gr1, t1.id_car id, t1.name, t1.rej_numb, t2.max_capacity fuel_max, t3.max_capacity fuel_max2, ' +
      't2.max_probe max_probe1, t3.max_probe max_probe2, t2.id_chart_type id_chart_type1, t3.id_chart_type id_chart_type2, ' +
      't7.max_capacity fuel_max3, t7.max_probe max_probe3, t7.id_chart_type id_chart_type3, ' +
      't1.useles, t1.fast_imp, t4.imp_div mod_imp, ' +
      't6.driver_name driver, t1.i_tank, t1.i_up, t1.rpm_obro, t1.rpm_disp, t1.mileage count, ' +
      't1.enable_checking_oil_change, t1.ChangeOilKM, t1.ChangeOilMTH, t1.CountedOilKM, t1.CountedOilMTH, t1.StartCountOilKM, t1.StartCountOilMTH, ' +
      'max_speed mspeed, ' +
      '(select ''T'' where rpm_stat = 1 and rpm_stat is not null union ' +
      'select ''N'' where rpm_stat <> 1 or rpm_stat is null) rpm_stat, rpm_delay rpmdelay, cast(id_probe_type as varchar(1)) sonda, ' +
      '''5'' freq, rpm_id, ' +
      'cast(dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(installation_date)))) + ''/'' + ' +
      'dbo.spDoDwochZnakowf(LTRIM(STR(DAY(installation_date)))) + ''/'' + ' +
      'LTRIM(STR(YEAR(installation_date))) as datetime) c_date, ' +
      '(select 1 where fuel_algorithm = 1 ' +
      '				union ' +
      '			    select 0 where fuel_algorithm <> 1 or fuel_algorithm is null ' +
      '               ) stralis, ' +
      '(select 2 where use_motohours = 1 ' +
      '				union ' +
      '			    select 0 where use_motohours <> 1 or use_motohours is null ' +
      '               ) car_type, ' +
      'phone_nr telefon, ' +
      'null changed, 1 synchronized, null deleted, ' +
      'id_device_type isEmailGPS, ' +
      'factor_approx_1 aproksymacja, ' +
      '(select id_approx_type_1 where id_approx_type_1 <> 0 ' +
      '   union' +
      '   select 1 where id_approx_type_1 = 0) aproksym_kind, ' +
      'factor_approx_2 aproksymacja2, ' +
      '(select id_approx_type_2 where id_approx_type_2 <> 0 ' +
      '   union' +
      '   select 1 where id_approx_type_2 = 0) aproksym_kind2, ' +
      '(select 1 where cistern = 1 ' +
      '   union' +
      '   select 0 where cistern = 0) cistern, ' +
      '(select 1 where factor_approx_2 <> 0.0 ' +
      '   union ' +
      '   select 0 where factor_approx_2 = 0.0) second_aproksym, ' +
      'power_off_on_fuel_chart PowerOffOnFuelChart, ident, useles_city, useles_city_enabled, apn, ' +
      'id_starter_type starter, id_email_cycle email_cycle, ' +
      'mode_30_sec second30, sms_on_start, gps_always_on gps_mode, road_correction, dyn_data_enabled, ' +
      'dyn_data_max_bad_time, dyn_data_max_useles, filter_first filtr_kolejnosc, ' +
      'id_transmitter_mode transmitter_mode, alarm_tel, ' +
'(  select 1 where apn=''www.idea.pl'' ' +
'  union ' +
'  select 2 where apn=''www.plusgsm.pl'' ' +
'  union ' +
'  select 3 where apn=''erainternet'' ' +
'  union ' +
'  select 4 where apn=''erainternettt'' ' +
'  union ' +
'  select 5 where apn=''heyah.pl'' ' +
'  union ' +
'  select 6 where apn=''playmetric'' ' +
'  union ' +
'  select 7 where (apn <> ''www.idea.pl'') and (apn <> ''www.plusgsm.pl'') and (apn<>''erainternet'') ' +
'  and (apn<>''erainternettt'') and (apn<>''heyah.pl'') and (apn<>''playmetric'')) operator_karty ' +
      'from car t1 ' +
      'left join fuel_tank t2 on (t1.id_car = t2.id_car and t2.tank_nr = 1) ' +
      'left join fuel_tank t3 on (t1.id_car = t3.id_car and t3.tank_nr = 2) ' +
      'left join fuel_tank t7 on (t1.id_car = t7.id_car and t7.tank_nr = 3) ' +
      'left join road_imp_div t4 on (t1.id_road_imp_div = t4.id_road_imp_div) ' +
      'left join car_change t5 on (t1.id_car = t5.id_car and t5.end_date is null) ' +
      'left join driver t6 on (t5.id_driver = t6.id_driver) ' +
      ''
      , cars, nil);
    cars.Position := 0;
    archiwum.AddPlik('cars', cars);
    cars.Free();

    inputs_description := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select 1 id, t1.description enabled_desc, t2.description disabled_desc from ' +
        'event t1, event t2 where t1.id_event = 1 and t2.id_event = 31 union ' +
        'select 2 id, t1.description enabled_desc, t2.description disabled_desc from ' +
        'event t1, event t2 where t1.id_event = 2 and t2.id_event = 32 union ' +
        'select 3 id, t1.description enabled_desc, t2.description disabled_desc from ' +
        'event t1, event t2 where t1.id_event = 3 and t2.id_event = 33 union ' +
        'select 4 id, t1.description enabled_desc, t2.description disabled_desc from ' +
        'event t1, event t2 where t1.id_event = 4 and t2.id_event = 34 union ' +
        'select 5 id, t1.description enabled_desc, t2.description disabled_desc from ' +
        'event t1, event t2 where t1.id_event = 5 and t2.id_event = 35 '
        , inputs_description, nil);
    inputs_description.Position := 0;
    archiwum.AddPlik('inputs_description', inputs_description);
    inputs_description.Free();

    kierowcy := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select id_driver id, driver_name nazwa, fired was_deleted from driver', kierowcy, nil);
    kierowcy.Position := 0;
    archiwum.AddPlik('kierowcy', kierowcy);
    kierowcy.Free();

    przesiadki := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select id_car car_no, id_driver driver_no, start_date poczatek, end_date koniec from car_change', przesiadki, nil);
    przesiadki.Position := 0;
    archiwum.AddPlik('przesiadki', przesiadki);
    przesiadki.Free();

    oddzialy := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select top 0 1 fdsggs from car', oddzialy, nil);
    oddzialy.Position := 0;
    archiwum.AddPlik('oddzialy', oddzialy);
    oddzialy.Free();

    grupy := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select top 0 1 fdsggs from car', grupy, nil);
    grupy.Position := 0;
    archiwum.AddPlik('grupy', grupy);
    grupy.Free();

    grupy_zawartosc_pojazdy := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select top 0 1 fdsggs from car', grupy_zawartosc_pojazdy, nil);
    grupy_zawartosc_pojazdy.Position := 0;
    archiwum.AddPlik('grupy_zawartosc_pojazdy', grupy_zawartosc_pojazdy);
    grupy_zawartosc_pojazdy.Free();

    grupy_zawartosc_kierowcy := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select top 0 1 fdsggs from car', grupy_zawartosc_kierowcy, nil);
    grupy_zawartosc_kierowcy.Position := 0;
    archiwum.AddPlik('grupy_zawartosc_kierowcy', grupy_zawartosc_kierowcy);
    grupy_zawartosc_kierowcy.Free();

    oddzialy_zawartosc := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select top 0 1 fdsggs from car', oddzialy_zawartosc, nil);
    oddzialy_zawartosc.Position := 0;
    archiwum.AddPlik('oddzialy_zawartosc', oddzialy_zawartosc);
    oddzialy_zawartosc.Free();

    synch_events_status := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select top 0 1 fdsggs from car', synch_events_status, nil);
    synch_events_status.Position := 0;
    archiwum.AddPlik('synch_events_status', synch_events_status);
    synch_events_status.Free();

    mail_settings := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select * from mail_settings', mail_settings, nil);
    mail_settings.Position := 0;
    archiwum.AddPlik('mail_settings', mail_settings);
    mail_settings.Free();

    ustawienia := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select * from carnet_settings', ustawienia, nil);
    ustawienia.Position := 0;
    archiwum.AddPlik('ustawienia', ustawienia);
    ustawienia.Free();

    ustawienia2 := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select * from extra_settings', ustawienia2, nil);
    ustawienia2.Position := 0;
    archiwum.AddPlik('ustawienia2', ustawienia2);
    ustawienia2.Free();

    TEDEmailSrv.tmp.Close();
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('select t1.*, t2.id_car, t2.tank_nr, t2.max_probe, t2.id_chart_type from probe_liters t1 inner join fuel_tank t2 on (t1.id_fuel_tank = t2.id_fuel_tank) ');
    TEDEmailSrv.tmp.Open();
    SetLength(paliwo_char, 0);
    while not TEDEmailSrv.tmp.Eof do
    begin
        i := 0;
        while i < Length(paliwo_char) do
        begin
            if (paliwo_char[i].car_no = TEDEmailSrv.tmp.FieldByName('id_car').AsInteger) and
                  (paliwo_char[i].zb_nr = TEDEmailSrv.tmp.FieldByName('tank_nr').AsInteger) and
                  (paliwo_char[i].id_chart_type = TEDEmailSrv.tmp.FieldByName('id_chart_type').AsInteger) then
                break;
            Inc(i);
        end;
        if not (i < Length(paliwo_char)) then
        begin
            SetLength(paliwo_char, Length(paliwo_char) + 1);
            paliwo_char[Length(paliwo_char) - 1].car_no := TEDEmailSrv.tmp.FieldByName('id_car').AsInteger;
            paliwo_char[Length(paliwo_char) - 1].zb_nr := TEDEmailSrv.tmp.FieldByName('tank_nr').AsInteger;
            paliwo_char[Length(paliwo_char) - 1].max_probe := TEDEmailSrv.tmp.FieldByName('max_probe').AsInteger;
            paliwo_char[Length(paliwo_char) - 1].id_chart_type := TEDEmailSrv.tmp.FieldByName('id_chart_type').AsInteger;
            SetLength(paliwo_char[Length(paliwo_char) - 1].liters2, TEDEmailSrv.tmp.FieldByName('max_probe').AsInteger + 1);
            for i2 := 0 to TEDEmailSrv.tmp.FieldByName('max_probe').AsInteger do
                paliwo_char[Length(paliwo_char) - 1].liters2[i2] := 0.0;
        end;
        paliwo_char[i].liters2[TEDEmailSrv.tmp.FieldByName('id_probe').AsInteger] :=
            TEDEmailSrv.tmp.FieldByName('liters').AsFloat;
        TEDEmailSrv.tmp.Next();
    end;
    TEDEmailSrv.tmp.Close();


    if ProgressBar <> nil then
        ProgressBar.Visible := True;
    paliwo := TMemoryStream.Create();
    TEDEmailSrv.SavePaliwoToStream(paliwo_char, paliwo, OnProgress);
    paliwo.Position := 0;
    archiwum.AddPlik('paliwo', paliwo);
    paliwo.Free();

    paliwo_temp := TMemoryStream.Create();
    TEDEmailSrv.SavePaliwoTmpToStream(paliwo_char, paliwo_temp, OnProgress);
    paliwo_temp.Position := 0;
    archiwum.AddPlik('paliwo_temp', paliwo_temp);
    paliwo_temp.Free();
    if ProgressBar <> nil then
        ProgressBar.Visible := False;

    SetLength(paliwo_char, 0);

    paliwo_wyjatki := TMemoryStream.Create();
    TEDEmailSrv.SaveSelectToStream('select * from paliwo_wyjatki', paliwo_wyjatki, OnProgress);
    paliwo_wyjatki.Position := 0;
    archiwum.AddPlik('paliwo_wyjatki', paliwo_wyjatki);
    paliwo_wyjatki.Free();

    if cbExportAlsoZones then
    begin
        regiony := TMemoryStream.Create();
        TEDEmailSrv.SaveSelectToStream('select * from regiony', regiony, OnProgress);
        regiony.Position := 0;
        archiwum.AddPlik('regiony', regiony);
        regiony.Free();

        reguly_regionow := TMemoryStream.Create();
        TEDEmailSrv.SaveSelectToStream('select * from reguly', reguly_regionow, OnProgress);
        reguly_regionow.Position := 0;
        archiwum.AddPlik('reguly_regionow', reguly_regionow);
        reguly_regionow.Free();
    end;
end;

procedure LoadExportArchive(archiwum: TBLTArchive; ProgressBar: TProgressBar = nil;
      OnProgress: TOnProcentLog = nil; Label2: TLabel = nil; cbImportAlsoZones: Boolean = True;
      Label10: TLabel = nil);  overload;
var cars, inputs_description, kierowcy, przesiadki, oddzialy, grupy,
      grupy_zawartosc_pojazdy, grupy_zawartosc_kierowcy, oddzialy_zawartosc,
      synch_events_status, mail_settings, ustawienia, ustawienia2,
      paliwo, paliwo_temp, paliwo_wyjatki, regiony, reguly_regionow: TStream;
    dataset: TStreamDataSet;
    ids: TIDs;
    i, j: Integer;
    id_fuel_tank: Integer;
    max_fuels: array [0..255, 1..3] of double;
begin
    TEDEmailSrv.tmp.Close();
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('delete from car_change');
    TEDEmailSrv.tmp.ExecSQL();

    cars := TMemoryStream.Create();
    archiwum.PlikByName('cars').DekompresujDo(cars);
    cars.Position := 0;

    TEDEmailSrv.tmp.Close();
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('insert into car (gr1, name, rej_numb, useles, fast_imp, id_road_imp_div, i_tank, i_up, rpm_obro, ' +
        'rpm_disp, mileage, installation_date, max_speed, rpm_stat, rpm_delay, id_probe_type, rpm_id, ' +
        'use_motohours, phone_nr, id_device_type, factor_approx_1, power_off_on_fuel_chart, id_approx_type_1, ' +
        'id_approx_type_2, factor_approx_2, ident, useles_city, useles_city_enabled, apn, alarm_tel, ' +
        'id_starter_type, id_email_cycle, mode_30_sec, sms_on_start, gps_always_on, road_correction, ' +
        'id_transmitter_mode, dyn_data_enabled, dyn_data_max_bad_time, dyn_data_max_useles, filter_first, id_car, cistern) ' +
        'values(:gr1, :name, :rej_numb, :useles, :fast_imp, :mod_imp, :i_tank, :i_up, :rpm_obro, :rpm_disp, :count, :c_date, :mspeed, ' +
        ':rpm_stat, :rpmdelay, cast(:sonda as integer), :rpm_id, :car_type, :telefon, ' +
        ':isEmailGPS, :aproksymacja, :PowerOffOnFuelChart, :aproksym_kind, :aproksym_kind2, :aproksymacja2, ' +
        ':ident, :useles_city, :useles_city_enabled, :apn, :alarm_tel, :starter, :email_cycle, :second30, ' +
        ':sms_on_start, :gps_mode, :road_correction, :transmitter_mode, :dyn_data_enabled, ' +
        ':dyn_data_max_bad_time, :dyn_data_max_useles, :filtr_kolejnosc, :id, :cistern) ');

    TEDEmailSrv.tmp2.Close();
    TEDEmailSrv.tmp2.SQL.Clear();
    TEDEmailSrv.tmp2.SQL.Add('update car set gr1 = :gr1, name = :name, rej_numb = :rej_numb, useles = :useles, fast_imp = :fast_imp, ');
    TEDEmailSrv.tmp2.SQL.Add('id_road_imp_div = :mod_imp, ' +
        'i_tank = :i_tank, i_up = :i_up, rpm_obro = :rpm_obro, rpm_disp = :rpm_disp, mileage = :count, ' +
        'installation_date = :c_date, max_speed = :mspeed, ');
    TEDEmailSrv.tmp2.SQL.Add('rpm_stat = :rpm_stat, rpm_delay = :rpmdelay, id_probe_type = cast(:sonda as integer), ' +
        'rpm_id = :rpm_id, ');
    TEDEmailSrv.tmp2.SQL.Add('use_motohours = :car_type, phone_nr = :telefon, id_device_type = :isEmailGPS, factor_approx_1 = :aproksymacja, ');
    TEDEmailSrv.tmp2.SQL.Add('power_off_on_fuel_chart = :PowerOffOnFuelChart, id_approx_type_1 = :aproksym_kind, id_approx_type_2 = :aproksym_kind2, ');
    TEDEmailSrv.tmp2.SQL.Add('factor_approx_2 = :aproksymacja2, ident = :ident, useles_city = :useles_city, ' +
          'useles_city_enabled = :useles_city_enabled, apn = :apn, alarm_tel = :alarm_tel, ');
    TEDEmailSrv.tmp2.SQL.Add('id_starter_type = :starter, id_email_cycle = :email_cycle, mode_30_sec = :second30, ' +
          'sms_on_start = :sms_on_start, gps_always_on = :gps_mode, road_correction = :road_correction, ');
    TEDEmailSrv.tmp2.SQL.Add('id_transmitter_mode =:transmitter_mode, ');
    TEDEmailSrv.tmp2.SQL.Add('dyn_data_enabled = :dyn_data_enabled, dyn_data_max_bad_time = :dyn_data_max_bad_time, ' +
          'dyn_data_max_useles = :dyn_data_max_useles, filter_first = :filtr_kolejnosc, cistern = :cistern, ' +
          'enable_checking_oil_change = :enable_checking_oil_change, ChangeOilKM = :ChangeOilKM, ChangeOilMTH = :ChangeOilMTH, CountedOilKM = :CountedOilKM, CountedOilMTH = :CountedOilMTH, StartCountOilKM = :StartCountOilKM, StartCountOilMTH = :StartCountOilMTH ' +
          'where id_car = :id ');
    dataset := TEDEmailSrv.LoadSelectFromStream(cars);
    dataset.Open();
    TEDEmailSrv.tmp3.Close();
    TEDEmailSrv.tmp3.SQL.Clear();
    TEDEmailSrv.tmp3.SQL.Add('select id_car from car');
    TEDEmailSrv.tmp3.Open();
    SetLength(ids, 0);
    while not TEDEmailSrv.tmp3.Eof do
    begin
        SetLength(ids, Length(ids) + 1);
        ids[Length(ids) - 1].dest_key_value := TEDEmailSrv.tmp3.FieldByName('id_car').AsInteger;
        TEDEmailSrv.tmp3.Next();
    end;
    TEDEmailSrv.tmp3.Close();
    TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil,
          TEDEmailSrv.tmp2, ids, 'id_car', 'id', 'deleted', True, 'car', False);
    SetLength(ids, 0);
    dataset.Close();
    dataset.Free();
    cars.Free();

    for i := 0 to 255 do
        for j := 1 to 3 do
            max_fuels[i, j] := 0.0;
    if archiwum.ExistsPlik('paliwo_temp') then
    begin
        paliwo_temp := TMemoryStream.Create();
        archiwum.PlikByName('paliwo_temp').DekompresujDo(paliwo_temp);
        paliwo_temp.Position := 0;
        dataset := TEDEmailSrv.LoadSelectFromStream(paliwo_temp);
        dataset.Open();

        dataset.First();
        while not dataset.Eof do
        begin
            max_fuels[dataset.FieldByName('car_no').AsInteger, dataset.FieldByName('nr_zb').AsInteger] :=
              Max(max_fuels[dataset.FieldByName('car_no').AsInteger, dataset.FieldByName('nr_zb').AsInteger],
                  dataset.FieldByName('value').AsFloat);
            dataset.Next();
        end;
        dataset.Close();
        dataset.Free();
        paliwo_temp.Free();
    end;

    cars := TMemoryStream.Create();
    archiwum.PlikByName('cars').DekompresujDo(cars);
    cars.Position := 0;
    dataset := TEDEmailSrv.LoadSelectFromStream(cars);
    dataset.First();
    while not dataset.Eof do
    begin
        if (dataset.FieldByName('sonda').AsString = '1') or
           (dataset.FieldByName('sonda').AsString = '2') then
        begin
            TEDEmailSrv.tmp3.Close();
            TEDEmailSrv.tmp3.SQL.Clear();
            TEDEmailSrv.tmp3.SQL.Add('select id_fuel_tank from fuel_tank where id_car = :id_car and tank_nr = 1 ');
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.Open();
            id_fuel_tank := TEDEmailSrv.tmp3.FieldByName('id_fuel_tank').AsInteger;
            TEDEmailSrv.tmp3.Close();
            if id_fuel_tank = 0 then
            begin
                TEDEmailSrv.tmp3.SQL.Clear();
                TEDEmailSrv.tmp3.SQL.Add('insert into fuel_tank (id_car, tank_nr, max_capacity, max_probe, id_chart_type) values(:id_car, 1, :max_capacity, :max_probe, 1) ');
            end
            else
            begin
                TEDEmailSrv.tmp3.SQL.Clear();
                TEDEmailSrv.tmp3.SQL.Add('update fuel_tank set id_car = :id_car, max_capacity = :max_capacity, max_probe = :max_probe where id_fuel_tank = :id_fuel_tank ' );
                TEDEmailSrv.tmp3.Parameters.ParamByName('id_fuel_tank').Value := id_fuel_tank;
            end;
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.Parameters.ParamByName('max_capacity').Value :=
                Max(dataset.FieldByName('fuel_max').AsFloat, max_fuels[dataset.FieldByName('id').AsInteger, 1]);
            if dataset.ExistField('max_probe1') then
                TEDEmailSrv.tmp3.Parameters.ParamByName('max_probe').Value := dataset.FieldByName('max_probe1').AsInteger
            else
                TEDEmailSrv.tmp3.Parameters.ParamByName('max_probe').Value := 255;
            TEDEmailSrv.tmp3.ExecSQL();

            TEDEmailSrv.tmp3.SQL.Clear();
            TEDEmailSrv.tmp3.SQL.Add('delete from fuel_tank where id_car = :id_car and tank_nr = 2 ');
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.ExecSQL();
        end
        else
        if dataset.FieldByName('sonda').AsString = '3' then
        begin
            TEDEmailSrv.tmp3.Close();
            TEDEmailSrv.tmp3.SQL.Clear();
            TEDEmailSrv.tmp3.SQL.Add('select id_fuel_tank from fuel_tank where id_car = :id_car and tank_nr = 1 ');
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.Open();
            id_fuel_tank := TEDEmailSrv.tmp3.FieldByName('id_fuel_tank').AsInteger;
            TEDEmailSrv.tmp3.Close();
            if id_fuel_tank = 0 then
            begin
                TEDEmailSrv.tmp3.SQL.Clear();
                TEDEmailSrv.tmp3.SQL.Add('insert into fuel_tank (id_car, tank_nr, max_capacity, max_probe, id_chart_type) values(:id_car, 1, :max_capacity, :max_probe, 1) ');
            end
            else
            begin
                TEDEmailSrv.tmp3.SQL.Clear();
                TEDEmailSrv.tmp3.SQL.Add('update fuel_tank set id_car = :id_car, max_capacity = :max_capacity, max_probe = :max_probe where id_fuel_tank = :id_fuel_tank ' );
                TEDEmailSrv.tmp3.Parameters.ParamByName('id_fuel_tank').Value := id_fuel_tank;
            end;
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.Parameters.ParamByName('max_capacity').Value :=
                Max(dataset.FieldByName('fuel_max').AsFloat, max_fuels[dataset.FieldByName('id').AsInteger, 1]);
            if dataset.ExistField('max_probe1') then
                TEDEmailSrv.tmp3.Parameters.ParamByName('max_probe').Value := dataset.FieldByName('max_probe1').AsInteger
            else
                TEDEmailSrv.tmp3.Parameters.ParamByName('max_probe').Value := 255;
            TEDEmailSrv.tmp3.ExecSQL();

            TEDEmailSrv.tmp3.Close();
            TEDEmailSrv.tmp3.SQL.Clear();
            TEDEmailSrv.tmp3.SQL.Add('select id_fuel_tank from fuel_tank where id_car = :id_car and tank_nr = 2 ');
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.Open();
            id_fuel_tank := TEDEmailSrv.tmp3.FieldByName('id_fuel_tank').AsInteger;
            TEDEmailSrv.tmp3.Close();
            if id_fuel_tank = 0 then
            begin
                TEDEmailSrv.tmp3.SQL.Clear();
                TEDEmailSrv.tmp3.SQL.Add('insert into fuel_tank (id_car, tank_nr, max_capacity, max_probe, id_chart_type) values(:id_car, 2, :max_capacity, :max_probe, 1) ');
            end
            else
            begin
                TEDEmailSrv.tmp3.SQL.Clear();
                TEDEmailSrv.tmp3.SQL.Add('update fuel_tank set id_car = :id_car, max_capacity = :max_capacity, max_probe = :max_probe where id_fuel_tank = :id_fuel_tank ' );
                TEDEmailSrv.tmp3.Parameters.ParamByName('id_fuel_tank').Value := id_fuel_tank;
            end;
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.Parameters.ParamByName('max_capacity').Value :=
                Max(dataset.FieldByName('fuel_max2').AsFloat, max_fuels[dataset.FieldByName('id').AsInteger, 2]);
            if dataset.ExistField('max_probe2') then
                TEDEmailSrv.tmp3.Parameters.ParamByName('max_probe').Value := dataset.FieldByName('max_probe2').AsInteger
            else
                TEDEmailSrv.tmp3.Parameters.ParamByName('max_probe').Value := 255;
            TEDEmailSrv.tmp3.ExecSQL();
        end
        else
        begin
            TEDEmailSrv.tmp3.SQL.Clear();
            TEDEmailSrv.tmp3.SQL.Add('delete from fuel_tank where id_car = :id_car and tank_nr = 1 ');
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.ExecSQL();

            TEDEmailSrv.tmp3.SQL.Clear();
            TEDEmailSrv.tmp3.SQL.Add('delete from fuel_tank where id_car = :id_car and tank_nr = 2 ');
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.ExecSQL();
        end;

        if (not dataset.ExistField('max_probe3')) or (dataset.FieldByName('max_probe3').AsInteger = 0) then
        begin
            TEDEmailSrv.tmp3.SQL.Clear();
            TEDEmailSrv.tmp3.SQL.Add('delete from fuel_tank where id_car = :id_car and tank_nr = 3 ');
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.ExecSQL();
        end;

        if (dataset.ExistField('max_probe3')) and (dataset.FieldByName('max_probe3').AsInteger <> 0) then
        begin
            TEDEmailSrv.tmp3.Close();
            TEDEmailSrv.tmp3.SQL.Clear();
            TEDEmailSrv.tmp3.SQL.Add('select id_fuel_tank from fuel_tank where id_car = :id_car and tank_nr = 3 ');
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.Open();
            id_fuel_tank := TEDEmailSrv.tmp3.FieldByName('id_fuel_tank').AsInteger;
            TEDEmailSrv.tmp3.Close();
            if id_fuel_tank = 0 then
            begin
                TEDEmailSrv.tmp3.SQL.Clear();
                TEDEmailSrv.tmp3.SQL.Add('insert into fuel_tank (id_car, tank_nr, max_capacity, max_probe, id_chart_type) values(:id_car, 3, :max_capacity, :max_probe, 2) ');
            end
            else
            begin
                TEDEmailSrv.tmp3.SQL.Clear();
                TEDEmailSrv.tmp3.SQL.Add('update fuel_tank set id_car = :id_car, max_capacity = :max_capacity, max_probe = :max_probe where id_fuel_tank = :id_fuel_tank ' );
                TEDEmailSrv.tmp3.Parameters.ParamByName('id_fuel_tank').Value := id_fuel_tank;
            end;
            TEDEmailSrv.tmp3.Parameters.ParamByName('id_car').Value := dataset.FieldByName('id').AsInteger;
            TEDEmailSrv.tmp3.Parameters.ParamByName('max_capacity').Value :=
                Max(dataset.FieldByName('fuel_max').AsFloat, max_fuels[dataset.FieldByName('id').AsInteger, 3]);
            if dataset.ExistField('max_probe3') then
                TEDEmailSrv.tmp3.Parameters.ParamByName('max_probe').Value := dataset.FieldByName('max_probe3').AsInteger
            else
                TEDEmailSrv.tmp3.Parameters.ParamByName('max_probe').Value := 1023;
            TEDEmailSrv.tmp3.ExecSQL();
        end;

        dataset.Next();
    end;
    dataset.Close();
    dataset.Free();
    cars.Free();

    inputs_description := TMemoryStream.Create();
    archiwum.PlikByName('inputs_description').DekompresujDo(inputs_description);

    inputs_description.Position := 0;
    TEDEmailSrv.tmp.Close();
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('update event set description = :enabled_desc where id_event = :id');
    dataset := TEDEmailSrv.LoadSelectFromStream(inputs_description);
    dataset.Open();
    TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil);
    dataset.Close();
    dataset.Free();

    inputs_description.Position := 0;
    TEDEmailSrv.tmp.Close();
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('update event set description = :disabled_desc where id_event = :id + 30');
    dataset := TEDEmailSrv.LoadSelectFromStream(inputs_description);
    dataset.Open();
    TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil);
    dataset.Close();
    dataset.Free();

    inputs_description.Free();

    kierowcy := TMemoryStream.Create();
    archiwum.PlikByName('kierowcy').DekompresujDo(kierowcy);
    kierowcy.Position := 0;
    TEDEmailSrv.tmp.Close();
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('delete from driver');
    TEDEmailSrv.tmp.ExecSQL();
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('set identity_insert driver on;');
    TEDEmailSrv.tmp.ExecSQL();
    try
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('insert into driver ');
        TEDEmailSrv.tmp.SQL.Add('  (id_driver, driver_name, fired) ');
        TEDEmailSrv.tmp.SQL.Add('values ');
        TEDEmailSrv.tmp.SQL.Add('  (:id, :nazwa, :was_deleted) ');
        dataset := TEDEmailSrv.LoadSelectFromStream(kierowcy);
        dataset.Open();
        TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil);
        dataset.Close();
        dataset.Free();
        kierowcy.Free();
    finally
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('set identity_insert driver off;');
        TEDEmailSrv.tmp.ExecSQL();
    end;

    przesiadki := TMemoryStream.Create();
    archiwum.PlikByName('przesiadki').DekompresujDo(przesiadki);
    przesiadki.Position := 0;
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('insert into car_change ');
    TEDEmailSrv.tmp.SQL.Add('  (id_car, id_driver, start_date, end_date) ');
    TEDEmailSrv.tmp.SQL.Add('values ');
    TEDEmailSrv.tmp.SQL.Add('  (:car_no, :driver_no, :poczatek, :koniec) ');
    dataset := TEDEmailSrv.LoadSelectFromStream(przesiadki);
    dataset.Open();
    TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil);
    dataset.Close();
    dataset.Free();
    przesiadki.Free();

    mail_settings := TMemoryStream.Create();
    archiwum.PlikByName('mail_settings').DekompresujDo(mail_settings);
    mail_settings.Position := 0;

    TEDEmailSrv.tmp.Close();
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('insert into mail_settings (id, serwerpop3, konto, haslo, temat, nadawca, serwersmtp, mail_hour, extra_mail, virtual_mail, delete_after_load) ');
    TEDEmailSrv.tmp.SQL.Add(' values(:id, :serwerpop3, :konto, :haslo, :temat, :nadawca, :serwersmtp, :mail_hour, :extra_mail, :virtual_mail, :delete_after_load) ');

    TEDEmailSrv.tmp2.Close();
    TEDEmailSrv.tmp2.SQL.Clear();
    TEDEmailSrv.tmp2.SQL.Add('update mail_settings set ');
    TEDEmailSrv.tmp2.SQL.Add('  id = :id, serwerpop3 = :serwerpop3, konto = :konto, haslo = :haslo, temat = :temat, nadawca = :nadawca, serwersmtp = :serwersmtp, mail_hour = :mail_hour, ');
    TEDEmailSrv.tmp2.SQL.Add('   extra_mail = :extra_mail, virtual_mail = :virtual_mail, delete_after_load = :delete_after_load ');

    TEDEmailSrv.tmp3.Close();
    TEDEmailSrv.tmp3.SQL.Clear();
    TEDEmailSrv.tmp3.SQL.Add('select id from mail_settings');
    TEDEmailSrv.tmp3.Open();
    SetLength(ids, 0);
    while not TEDEmailSrv.tmp3.Eof do
    begin
        SetLength(ids, Length(ids) + 1);
        ids[Length(ids) - 1].dest_key_value :=
                  TEDEmailSrv.tmp3.FieldByName('id').AsInteger;
        TEDEmailSrv.tmp3.Next();
    end;
    TEDEmailSrv.tmp3.Close();

    dataset := TEDEmailSrv.LoadSelectFromStream(mail_settings);
    dataset.Open();
    TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil, TEDEmailSrv.tmp2, ids,
        'id', 'id', '', False, 'mail_settings');
    SetLength(ids, 0);
    dataset.Close();
    dataset.Free();
    mail_settings.Free();
    SetLength(ids, 0);

    ustawienia := TMemoryStream.Create();
    archiwum.PlikByName('ustawienia').DekompresujDo(ustawienia);
    ustawienia.Position := 0;

    TEDEmailSrv.tmp.Close();
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('insert into carnet_settings  ');
    TEDEmailSrv.tmp.SQL.Add('(smtp, pop3, account, password, address, place, ' +
        'disablmail, lastselcar, cfgcode, dataod, datado, addresscen, ' +
        'nazwa, smtpauth, smtpsame, smtppass, smtpuser, mappoint, ' +
        'lastseldriver, kontekst, sms_host, sms_port, sms_timeout, ' +
        'ident, mapcenter_host, mapcenter_port, mapcenter_login, ' +
        'mapcenter_pass, version) ');
    TEDEmailSrv.tmp.SQL.Add(' values(:smtp, :pop3, :account, :password, ' +
        ':address, :place, :disablmail, :lastselcar, :cfgcode, ' +
        ':dataod, :datado, :addresscen, :nazwa, :smtpauth, ' +
        ':smtpsame, :smtppass, :smtpuser, :mappoint, :lastseldriver, ' +
        ':kontekst, :sms_host, :sms_port, :sms_timeout, :ident, ' +
        ':mapcenter_host, :mapcenter_port, :mapcenter_login, ' +
        ':mapcenter_pass, 200) ');

    TEDEmailSrv.tmp2.Close();
    TEDEmailSrv.tmp2.SQL.Clear();
    TEDEmailSrv.tmp2.SQL.Add('update carnet_settings set ');
    TEDEmailSrv.tmp2.SQL.Add('   smtp = :smtp, pop3 = :pop3, account = :account, password = :password, address = :address, place = :place, disablmail = :disablmail, lastselcar = :lastselcar, ');
    TEDEmailSrv.tmp2.SQL.Add('   cfgcode = :cfgcode, dataod = :dataod, datado = :datado, addresscen = :addresscen, nazwa = :nazwa, smtpauth = :smtpauth, smtpsame = :smtpsame, ');
    TEDEmailSrv.tmp2.SQL.Add('   smtppass = :smtppass, smtpuser = :smtpuser, mappoint = :mappoint, lastseldriver = :lastseldriver, kontekst = :kontekst, ');
    TEDEmailSrv.tmp2.SQL.Add('   sms_host = :sms_host, sms_port = :sms_port, ');
    TEDEmailSrv.tmp2.SQL.Add('   sms_timeout = :sms_timeout, ident = :ident, ');
    TEDEmailSrv.tmp2.SQL.Add('   mapcenter_host = :mapcenter_host, mapcenter_port = :mapcenter_port, mapcenter_login = :mapcenter_login, mapcenter_pass = :mapcenter_pass, version = 200 ');

    TEDEmailSrv.tmp3.Close();
    TEDEmailSrv.tmp3.SQL.Clear();
    TEDEmailSrv.tmp3.SQL.Add('select portnr from carnet_settings');
    TEDEmailSrv.tmp3.Open();
    SetLength(ids, 0);
    while not TEDEmailSrv.tmp3.Eof do
    begin
        SetLength(ids, Length(ids) + 1);
        ids[Length(ids) - 1].dest_key_value :=
                  TEDEmailSrv.tmp3.FieldByName('portnr').AsInteger;
        TEDEmailSrv.tmp3.Next();
    end;
    TEDEmailSrv.tmp3.Close();

    dataset := TEDEmailSrv.LoadSelectFromStream(ustawienia);
    dataset.Open();
    TEDEmailSrv.CopyStreamSelectToInsertQuery( dataset, TEDEmailSrv.tmp, nil, TEDEmailSrv.tmp2,
        ids, 'portnr', 'portnr', '', False, 'carnet_settings');
    dataset.Close();
    dataset.Free();
    ustawienia.Free();

    if (TEDEmailSrv.tmp2.Parameters.FindParam('ident') <> nil) and
          (Length(TEDEmailSrv.tmp2.Parameters.ParamByName('ident').Value) = 5) then
    begin
        if TEDEmailSrv.ident <> TEDEmailSrv.tmp2.Parameters.FindParam('ident').Value then
        begin
//            if Screen.ActiveForm <> frmCreatorImportExport then
//                TEDEmailSrv.ident := TEDEmailSrv.tmp2.Parameters.FindParam('ident').Value
//            else
//            if Application.MessageBox('Zmieni³ siê identyfikator firmy. Kontynuowaæ ?', 'Wybierz', MB_OKCANCEL + MB_ICONQUESTION + MB_DEFBUTTON2) = ID_OK then
                TEDEmailSrv.ident := TEDEmailSrv.tmp2.Parameters.FindParam('ident').Value
//            else
//            begin
//                archiwum.Free();
//                raise Exception.Create('Przerwanie operacji');
//            end;
        end;
    end
    else
    if (TEDEmailSrv.tmp3.Parameters.FindParam('ident') <> nil) and
          (Length(TEDEmailSrv.tmp3.Parameters.ParamByName('ident').Value) = 5) then
    begin
        if TEDEmailSrv.ident <> TEDEmailSrv.tmp3.Parameters.FindParam('ident').Value then
        begin
//            if Screen.ActiveForm <> frmCreatorImportExport then
//                TEDEmailSrv.ident := TEDEmailSrv.tmp3.Parameters.FindParam('ident').Value
//            else
//            if Application.MessageBox('Zmieni³ siê identyfikator firmy. Kontynuowaæ ?', 'Wybierz', MB_OKCANCEL + MB_ICONQUESTION + MB_DEFBUTTON2) = ID_OK then
                TEDEmailSrv.ident := TEDEmailSrv.tmp3.Parameters.FindParam('ident').Value
//            else
//            begin
//                archiwum.Free();
//                raise Exception.Create('Przerwanie operacji');
//            end;
        end;
    end;

    if archiwum.ExistsPlik('paliwo_temp') then
    begin
        if Label2 <> nil then
          Label2.Visible := False;
        if ProgressBar <> nil then
          ProgressBar.Visible := True;
        paliwo_temp := TMemoryStream.Create();
        archiwum.PlikByName('paliwo_temp').DekompresujDo(paliwo_temp);
        paliwo_temp.Position := 0;
        TEDEmailSrv.tmp.Close();
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('delete from probe_liters');
        TEDEmailSrv.tmp.ExecSQL();
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('INSERT INTO probe_liters ');
        TEDEmailSrv.tmp.SQL.Add('  (id_fuel_tank, id_probe, liters) ');
        TEDEmailSrv.tmp.SQL.Add('  VALUES ');
        TEDEmailSrv.tmp.SQL.Add('  (:id_fuel_tank, :pal, :value) ');
        dataset := TEDEmailSrv.LoadSelectFromStream(paliwo_temp);
        dataset.Open();
        TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, OnProgress);
        dataset.Close();
        dataset.Free();
        paliwo_temp.Free();
        if ProgressBar <> nil then
          ProgressBar.Visible := False;
    end
    else
        if Label2 <> nil then
          Label2.Visible := True;

    if archiwum.ExistsPlik('paliwo_wyjatki') then
    begin
        paliwo_wyjatki := TMemoryStream.Create();
        archiwum.PlikByName('paliwo_wyjatki').DekompresujDo(paliwo_wyjatki);
        paliwo_wyjatki.Position := 0;
        TEDEmailSrv.tmp.Close();
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('delete from paliwo_wyjatki');
        TEDEmailSrv.tmp.ExecSQL();
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('insert into paliwo_wyjatki ');
        TEDEmailSrv.tmp.SQL.Add('  (car_no, dataczas, ilosc) ');
        TEDEmailSrv.tmp.SQL.Add('values ');
        TEDEmailSrv.tmp.SQL.Add('  (:car_no, :dataczas, :ilosc) ');
        dataset := TEDEmailSrv.LoadSelectFromStream(paliwo_wyjatki);
        dataset.Open();
        TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil);
        dataset.Close();
        dataset.Free();
        paliwo_wyjatki.Free();
    end;

    if archiwum.ExistsPlik('regiony') and cbImportAlsoZones then
    begin
        if Label10 <> nil then
          Label10.Visible := False;
        regiony := TMemoryStream.Create();
        archiwum.PlikByName('regiony').DekompresujDo(regiony);
        regiony.Position := 0;
        TEDEmailSrv.tmp.Close();
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('delete from regiony');
        TEDEmailSrv.tmp.ExecSQL();
//                    TEDEmailSrv.tmp.SQL.Clear();
//                    TEDEmailSrv.tmp.SQL.Add('set identity_insert regiony on;');
//                    TEDEmailSrv.tmp.ExecSQL();
        try
            TEDEmailSrv.tmp.SQL.Clear();
            TEDEmailSrv.tmp.SQL.Add('INSERT INTO regiony ');
            TEDEmailSrv.tmp.SQL.Add('           (id ');
            TEDEmailSrv.tmp.SQL.Add('           ,nazwa ');
            TEDEmailSrv.tmp.SQL.Add('           ,kolor ');
            TEDEmailSrv.tmp.SQL.Add('           ,p1lat ');
            TEDEmailSrv.tmp.SQL.Add('           ,p1lng ');
            TEDEmailSrv.tmp.SQL.Add('           ,p2lat ');
            TEDEmailSrv.tmp.SQL.Add('           ,p2lng ');
            TEDEmailSrv.tmp.SQL.Add('           ,p3lat ');
            TEDEmailSrv.tmp.SQL.Add('           ,p3lng) ');
            TEDEmailSrv.tmp.SQL.Add('     VALUES ');
            TEDEmailSrv.tmp.SQL.Add('           (:id ');
            TEDEmailSrv.tmp.SQL.Add('           ,:nazwa ');
            TEDEmailSrv.tmp.SQL.Add('           ,:kolor ');
            TEDEmailSrv.tmp.SQL.Add('           ,:p1lat ');
            TEDEmailSrv.tmp.SQL.Add('           ,:p1lng ');
            TEDEmailSrv.tmp.SQL.Add('           ,:p2lat ');
            TEDEmailSrv.tmp.SQL.Add('           ,:p2lng ');
            TEDEmailSrv.tmp.SQL.Add('           ,:p3lat ');
            TEDEmailSrv.tmp.SQL.Add('           ,:p3lng) ');
            dataset := TEDEmailSrv.LoadSelectFromStream(regiony);
            dataset.Open();
            TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil);
            dataset.Close();
            dataset.Free();
            regiony.Free();
        finally
//                        TEDEmailSrv.tmp.SQL.Clear();
//                        TEDEmailSrv.tmp.SQL.Add('set identity_insert regiony off;');
//                        TEDEmailSrv.tmp.ExecSQL();
        end;

        reguly_regionow := TMemoryStream.Create();
        archiwum.PlikByName('reguly_regionow').DekompresujDo(reguly_regionow);
        reguly_regionow.Position := 0;
        TEDEmailSrv.tmp.Close();
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('delete from reguly');
        TEDEmailSrv.tmp.ExecSQL();
//                    TEDEmailSrv.tmp.SQL.Clear();
//                    TEDEmailSrv.tmp.SQL.Add('set identity_insert reguly on;');
//                    TEDEmailSrv.tmp.ExecSQL();
        try
            TEDEmailSrv.tmp.SQL.Clear();
            TEDEmailSrv.tmp.SQL.Add('INSERT INTO reguly ');
            TEDEmailSrv.tmp.SQL.Add('(region_id ');
            TEDEmailSrv.tmp.SQL.Add(',car_id ');
            TEDEmailSrv.tmp.SQL.Add(',zakres ');
            TEDEmailSrv.tmp.SQL.Add(',typ_dni ');
            TEDEmailSrv.tmp.SQL.Add(',dzien_tygodnia_od ');
            TEDEmailSrv.tmp.SQL.Add(',dzien_tygodnia_do ');
            TEDEmailSrv.tmp.SQL.Add(',dzien_miesiaca_od ');
            TEDEmailSrv.tmp.SQL.Add(',dzien_miesiaca_do ');
            TEDEmailSrv.tmp.SQL.Add(',miesiac_od ');
            TEDEmailSrv.tmp.SQL.Add(',miesiac_do ');
            TEDEmailSrv.tmp.SQL.Add(',data_od ');
            TEDEmailSrv.tmp.SQL.Add(',data_do ');
            TEDEmailSrv.tmp.SQL.Add(',godziny_od ');
            TEDEmailSrv.tmp.SQL.Add(',minuty_od ');
            TEDEmailSrv.tmp.SQL.Add(',godziny_do ');
            TEDEmailSrv.tmp.SQL.Add(',minuty_do ');
            TEDEmailSrv.tmp.SQL.Add(',wymog ');
            TEDEmailSrv.tmp.SQL.Add(',extra_enabled ');
            TEDEmailSrv.tmp.SQL.Add(',godziny_extra ');
            TEDEmailSrv.tmp.SQL.Add(',minuty_extra ');
            TEDEmailSrv.tmp.SQL.Add(',enabled ');
            TEDEmailSrv.tmp.SQL.Add(',dotyczy ');
            TEDEmailSrv.tmp.SQL.Add(',region_number_in_device ');
            TEDEmailSrv.tmp.SQL.Add(',region_sms_mode_in_device ');
            TEDEmailSrv.tmp.SQL.Add(',region_sms_enabled) ');
            TEDEmailSrv.tmp.SQL.Add('VALUES ');
            TEDEmailSrv.tmp.SQL.Add('(:region_id ');
            TEDEmailSrv.tmp.SQL.Add(',:car_id ');
            TEDEmailSrv.tmp.SQL.Add(',:zakres ');
            TEDEmailSrv.tmp.SQL.Add(',:typ_dni ');
            TEDEmailSrv.tmp.SQL.Add(',:dzien_tygodnia_od ');
            TEDEmailSrv.tmp.SQL.Add(',:dzien_tygodnia_do ');
            TEDEmailSrv.tmp.SQL.Add(',:dzien_miesiaca_od ');
            TEDEmailSrv.tmp.SQL.Add(',:dzien_miesiaca_do ');
            TEDEmailSrv.tmp.SQL.Add(',:miesiac_od ');
            TEDEmailSrv.tmp.SQL.Add(',:miesiac_do ');
            TEDEmailSrv.tmp.SQL.Add(',:data_od ');
            TEDEmailSrv.tmp.SQL.Add(',:data_do ');
            TEDEmailSrv.tmp.SQL.Add(',:godziny_od ');
            TEDEmailSrv.tmp.SQL.Add(',:minuty_od ');
            TEDEmailSrv.tmp.SQL.Add(',:godziny_do ');
            TEDEmailSrv.tmp.SQL.Add(',:minuty_do ');
            TEDEmailSrv.tmp.SQL.Add(',:wymog ');
            TEDEmailSrv.tmp.SQL.Add(',:extra_enabled ');
            TEDEmailSrv.tmp.SQL.Add(',:godziny_extra ');
            TEDEmailSrv.tmp.SQL.Add(',:minuty_extra ');
            TEDEmailSrv.tmp.SQL.Add(',:enabled ');
            TEDEmailSrv.tmp.SQL.Add(',:dotyczy ');
            TEDEmailSrv.tmp.SQL.Add(',:region_number_in_device ');
            TEDEmailSrv.tmp.SQL.Add(',:region_sms_mode_in_device ');
            TEDEmailSrv.tmp.SQL.Add(',:region_sms_enabled) ');
            dataset := TEDEmailSrv.LoadSelectFromStream(reguly_regionow);
            dataset.Open();
            TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil);
            dataset.Close();
            dataset.Free();
            reguly_regionow.Free();
        finally
//                        TEDEmailSrv.tmp.SQL.Clear();
//                        TEDEmailSrv.tmp.SQL.Add('set identity_insert reguly off;');
//                        TEDEmailSrv.tmp.ExecSQL();
        end;
    end
    else
    if not archiwum.ExistsPlik('regiony') then
      if Label10 <> nil then
        Label10.Visible := True;

{
    if archiwum.ExistsPlik('ustawienia2') then
    begin
        ustawienia2 := TMemoryStream.Create();
        archiwum.PlikByName('ustawienia2').DekompresujDo(ustawienia2);
        ustawienia2.Position := 0;
        TEDEmailSrv.tmp.Close();
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('delete from extra_settings');
        TEDEmailSrv.tmp.ExecSQL();

        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('INSERT INTO extra_settings ');
        TEDEmailSrv.tmp.SQL.Add('(id, simple_look_host ');
        TEDEmailSrv.tmp.SQL.Add(',simple_look_port) ');
        TEDEmailSrv.tmp.SQL.Add('VALUES ');
        TEDEmailSrv.tmp.SQL.Add('(1, :simple_look_host ');
        TEDEmailSrv.tmp.SQL.Add(',:simple_look_port) ');
        dataset := TEDEmailSrv.LoadSelectFromStream(ustawienia2);
        dataset.Open();
        TEDEmailSrv.CopyStreamSelectToInsertQuery(dataset, TEDEmailSrv.tmp, nil);
        dataset.Close();
        dataset.Free();
        ustawienia2.Free();

        TEDEmailSrv.tmp.Close();
        TEDEmailSrv.tmp.SQL.Clear();
        TEDEmailSrv.tmp.SQL.Add('select * from extra_settings ');
        TEDEmailSrv.tmp.Open();
        if TEDEmailSrv.tmp.FieldByName('simple_look_host').AsString <> '' then
            TEDEmailSrv.SimpleLookServer := TEDEmailSrv.tmp.FieldByName('simple_look_host').AsString;
        if TEDEmailSrv.tmp.FieldByName('simple_look_port').AsString <> '' then
            TEDEmailSrv.SimpleLookListeningPort := TEDEmailSrv.tmp.FieldByName('simple_look_port').AsInteger;
        TEDEmailSrv.tmp.Close();
    end;
}



    if TEDEmailSrv.qPaliwo.Active then
        TEDEmailSrv.qPaliwo.Close();
    TEDEmailSrv.qPaliwo.Parameters.ParamByName('car_no').Value := -1;

//    TEDEmailSrv.tmp.Close();
//    TEDEmailSrv.tmp.SQL.Clear();
//    TEDEmailSrv.tmp.SQL.Add('select * from carnet_settings ');
//    TEDEmailSrv.tmp.Open();
//    if TEDEmailSrv.tmp.FieldByName('mapcenter_host').AsString <> '' then
//        TEDEmailSrv.MapcenterServer:= TEDEmailSrv.tmp.FieldByName('mapcenter_host').AsString;
//    if TEDEmailSrv.tmp.FieldByName('mapcenter_port').AsString <> '' then
//        TEDEmailSrv.MapcenterListeningPort := TEDEmailSrv.tmp.FieldByName('mapcenter_port').AsInteger;
//    if TEDEmailSrv.tmp.FieldByName('mapcenter_login').AsString <> '' then
//        TEDEmailSrv.MapcenterServerUser := TEDEmailSrv.tmp.FieldByName('mapcenter_login').AsString;
//    if TEDEmailSrv.tmp.FieldByName('mapcenter_pass').AsString <> '' then
//        TEDEmailSrv.MapcenterServerPassword := DecodePass(TEDEmailSrv.tmp.FieldByName('mapcenter_pass').AsString);
//    TEDEmailSrv.tmp.Close();


    Screen.Cursor := crDefault;

//                TEDEmailSrv.UstawNajnowszePozycje(0);
    TEDEmailSrv.ADOConnection.CommitTrans();

end;

end.
