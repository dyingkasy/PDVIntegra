unit PDVIntegration;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Net.HTTPClient,
  System.Net.URLClient, System.NetConsts;

type
  TPDVIntegration = class
  private
    FBaseURL: string;
    FToken: string;
    FDeviceId: string;
    FHTTPClient: THTTPClient;
    FLastResponseText: string;
    FLastResponseHeaders: string;

    function GetFingerprint: string;
    function SendRequest(const Method, Endpoint: string;
      const Payload: TJSONObject): TJSONObject;
    procedure SaveCredentials;
    function TryGetStringValue(const Obj: TJSONObject; const Key: string;
      out Value: string): Boolean;
    function TryGetNestedString(const Obj: TJSONObject; const Key: string;
      out Value: string): Boolean;
  public
    constructor Create(const BaseURL: string);
    destructor Destroy; override;

    function ActivateDevice(const Code, LabelText: string): Boolean;

    property Token: string read FToken;
    property DeviceId: string read FDeviceId;
    property LastResponseText: string read FLastResponseText;
    property LastResponseHeaders: string read FLastResponseHeaders;
  end;

implementation

uses
  Winapi.Windows, System.Win.Registry, IdHashMessageDigest, IdGlobal,
  PDVStorage;

function GetComputerNameStr: string;
var
  Buffer: array [0 .. MAX_COMPUTERNAME_LENGTH] of Char;
  Size: DWORD;
begin
  Size := Length(Buffer);
  if GetComputerName(Buffer, Size) then
    Result := Buffer
  else
    Result := '';
end;

function GetSystemDriveRoot: string;
var
  Drive: string;
begin
  Drive := GetEnvironmentVariable('SystemDrive');
  if Drive = '' then
    Drive := 'C:';
  Result := IncludeTrailingPathDelimiter(Drive + '\');
end;

function GetHDSerial: string;
var
  VolSerial: DWORD;
  MaxCompLen, Flags: DWORD;
  RootPath: string;
begin
  RootPath := GetSystemDriveRoot;
  if GetVolumeInformation(PChar(RootPath), nil, 0, @VolSerial, MaxCompLen, Flags,
    nil, 0) then
    Result := IntToHex(VolSerial, 8)
  else
    Result := '';
end;

function GetCPUIdentifier: string;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('HARDWARE\DESCRIPTION\System\CentralProcessor\0') then
    begin
      if Reg.ValueExists('ProcessorNameString') then
        Result := Reg.ReadString('ProcessorNameString')
      else if Reg.ValueExists('Identifier') then
        Result := Reg.ReadString('Identifier');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

constructor TPDVIntegration.Create(const BaseURL: string);
var
  Normalized: string;
begin
  inherited Create;
  Normalized := Trim(BaseURL);
  while (Normalized <> '') and (Normalized[Length(Normalized)] = '/') do
    Normalized := Copy(Normalized, 1, Length(Normalized) - 1);
  if SameText(Copy(Normalized, Length(Normalized) - 3, 4), '/api') then
    Normalized := Copy(Normalized, 1, Length(Normalized) - 4);

  FBaseURL := Normalized;
  FHTTPClient := THTTPClient.Create;
  FHTTPClient.ConnectionTimeout := 30000;
  FHTTPClient.ResponseTimeout := 60000;
end;

destructor TPDVIntegration.Destroy;
begin
  FHTTPClient.Free;
  inherited;
end;

procedure TPDVIntegration.SaveCredentials;
var
  Storage: TPDVStorage;
begin
  Storage := TPDVStorage.Create;
  try
    Storage.SaveToken(FToken);
    Storage.SaveDeviceId(FDeviceId);
  finally
    Storage.Free;
  end;
end;

function TPDVIntegration.GetFingerprint: string;
var
  MD5: TIdHashMessageDigest5;
  HardwareInfo: string;
begin
  MD5 := TIdHashMessageDigest5.Create;
  try
    HardwareInfo := GetComputerNameStr + GetHDSerial + GetCPUIdentifier;
    Result := MD5.HashStringAsHex(HardwareInfo);
  finally
    MD5.Free;
  end;
end;

function TPDVIntegration.SendRequest(const Method, Endpoint: string;
  const Payload: TJSONObject): TJSONObject;
var
  Response: IHTTPResponse;
  Stream: TStringStream;
  URL: string;
  Header: TNameValuePair;
begin
  Result := nil;
  FLastResponseText := '';
  FLastResponseHeaders := '';
  URL := FBaseURL + Endpoint;

  FHTTPClient.CustomHeaders['Authorization'] := '';
  if FToken <> '' then
    FHTTPClient.CustomHeaders['Authorization'] := 'Bearer ' + FToken;

  if Method = 'POST' then
  begin
    if Payload = nil then
      raise Exception.Create('POST requires payload');

    Stream := TStringStream.Create(Payload.ToJSON, TEncoding.UTF8);
    try
      FHTTPClient.ContentType := 'application/json';
      Response := FHTTPClient.Post(URL, Stream);
    finally
      Stream.Free;
    end;
  end
  else if Method = 'GET' then
    Response := FHTTPClient.Get(URL)
  else
    raise Exception.CreateFmt('Unsupported method: %s', [Method]);

  for Header in Response.Headers do
    FLastResponseHeaders := FLastResponseHeaders + Header.Name + ': ' +
      Header.Value + sLineBreak;

  if Response.StatusCode in [200, 201] then
  begin
    FLastResponseText := Response.ContentAsString;
    Result := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject
  end
  else
  begin
    FLastResponseText := Response.ContentAsString;
    raise Exception.CreateFmt('HTTP %d: %s',
      [Response.StatusCode, Response.ContentAsString]);
  end;
end;

function TPDVIntegration.TryGetStringValue(const Obj: TJSONObject;
  const Key: string; out Value: string): Boolean;
begin
  Value := '';
  Result := Obj <> nil;
  if Result then
    Result := Obj.TryGetValue<string>(Key, Value);
end;

function TPDVIntegration.TryGetNestedString(const Obj: TJSONObject;
  const Key: string; out Value: string): Boolean;
var
  DataObj: TJSONObject;
begin
  Result := TryGetStringValue(Obj, Key, Value);
  if Result then
    Exit;

  if (Obj <> nil) and Obj.TryGetValue<TJSONObject>('data', DataObj) then
    Result := TryGetStringValue(DataObj, Key, Value);
end;

function TPDVIntegration.ActivateDevice(const Code, LabelText: string): Boolean;
var
  Payload, Response: TJSONObject;
  TokenValue, DeviceIdValue: string;
  HasToken: Boolean;
begin
  Result := False;

  Payload := TJSONObject.Create;
  try
    Payload.AddPair('code', Code);
    Payload.AddPair('label', LabelText);
    Payload.AddPair('fingerprint', GetFingerprint);
    Payload.AddPair('hostname', GetComputerNameStr);
    Payload.AddPair('os', TOSVersion.ToString);
    Payload.AddPair('appVersion', '1.0.0');

    Response := SendRequest('POST', '/api/pdv/activate', Payload);
    try
      if Response <> nil then
      begin
        HasToken := TryGetNestedString(Response, 'token', TokenValue) or
          TryGetNestedString(Response, 'accessToken', TokenValue) or
          TryGetNestedString(Response, 'jwt', TokenValue);
        if not (TryGetNestedString(Response, 'deviceId', DeviceIdValue) or
          TryGetNestedString(Response, 'device_id', DeviceIdValue) or
          TryGetNestedString(Response, 'id', DeviceIdValue)) then
          raise Exception.Create('Missing deviceId in response');

        if HasToken then
          FToken := TokenValue;
        FDeviceId := DeviceIdValue;
        SaveCredentials;
        Result := True;
      end;
    finally
      Response.Free;
    end;
  finally
    Payload.Free;
  end;
end;

end.
