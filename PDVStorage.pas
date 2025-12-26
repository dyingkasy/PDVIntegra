unit PDVStorage;

interface

uses
  System.SysUtils, System.IniFiles, System.IOUtils;

type
  TPDVStorage = class
  private
    FIniPath: string;
    function GetIniPath: string;
  public
    constructor Create;
    property IniPath: string read FIniPath;
    procedure SaveToken(const Token: string);
    procedure SaveDeviceId(const DeviceId: string);
    function LoadToken: string;
    function LoadDeviceId: string;
  end;

implementation

constructor TPDVStorage.Create;
begin
  inherited Create;
  FIniPath := GetIniPath;
end;

function TPDVStorage.GetIniPath: string;
var
  ExeDir: string;
begin
  ExeDir := ExtractFilePath(ParamStr(0));
  Result := IncludeTrailingPathDelimiter(ExeDir) + 'PDVIntegra.ini';
end;

procedure TPDVStorage.SaveToken(const Token: string);
var
  Ini: TIniFile;
begin
  if not TFile.Exists(FIniPath) then
    TFile.WriteAllText(FIniPath, '');

  Ini := TIniFile.Create(FIniPath);
  try
    Ini.WriteString('pdv', 'token', Token);
  finally
    Ini.Free;
  end;
end;

procedure TPDVStorage.SaveDeviceId(const DeviceId: string);
var
  Ini: TIniFile;
begin
  if not TFile.Exists(FIniPath) then
    TFile.WriteAllText(FIniPath, '');

  Ini := TIniFile.Create(FIniPath);
  try
    Ini.WriteString('pdv', 'device_id', DeviceId);
  finally
    Ini.Free;
  end;
end;

function TPDVStorage.LoadToken: string;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FIniPath);
  try
    Result := Ini.ReadString('pdv', 'token', '');
  finally
    Ini.Free;
  end;
end;

function TPDVStorage.LoadDeviceId: string;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FIniPath);
  try
    Result := Ini.ReadString('pdv', 'device_id', '');
  finally
    Ini.Free;
  end;
end;

end.
