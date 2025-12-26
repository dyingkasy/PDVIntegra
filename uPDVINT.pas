unit uPDVINT;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.IOUtils, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, AdvEdit, AdvGlowButton, AdvMemo,
  AdvPanel,
  PDVIntegration, PDVStorage;

type
  TForm1 = class(TForm)
    pnlHeader: TAdvPanel;
    shHeaderCircle: TShape;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    shCard: TShape;
    shLogCard: TShape;
    shAccentTop: TShape;
    shAccentLog: TShape;
    lblBaseUrl: TLabel;
    lblBaseUrlHelp: TLabel;
    lblCode: TLabel;
    lblCodeHelp: TLabel;
    lblLabel: TLabel;
    lblLabelHelp: TLabel;
    lblLog: TLabel;
    lblStatus: TLabel;
    edtBaseUrl: TAdvEdit;
    edtCode: TAdvEdit;
    edtLabel: TAdvEdit;
    btnActivate: TAdvGlowButton;
    memLog: TAdvMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnActivateClick(Sender: TObject);
  private
    procedure Log(const Msg: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  edtBaseUrl.Text := 'https://meinobolso.com';
  memLog.Font.Name := 'Consolas';
  memLog.Font.Size := 9;
  lblStatus.Caption := 'Pronto para ativar.';
  lblStatus.Font.Color := clGray;
  Log('App iniciado.');
end;

procedure TForm1.Log(const Msg: string);
begin
  memLog.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' - ' + Msg);
  memLog.SelStart := Length(memLog.Lines.Text);
  memLog.SelLength := 0;
  memLog.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TForm1.btnActivateClick(Sender: TObject);
var
  Integrator: TPDVIntegration;
  BaseUrl: string;
  Code: string;
  LabelText: string;
  Storage: TPDVStorage;
begin
  BaseUrl := Trim(edtBaseUrl.Text);
  Code := Trim(edtCode.Text);
  LabelText := Trim(edtLabel.Text);

  if BaseUrl = '' then
  begin
    Log('Informe a base URL.');
    Exit;
  end;
  if Code = '' then
  begin
    Log('Informe o codigo de ativacao.');
    Exit;
  end;
  if LabelText = '' then
  begin
    Log('Informe o label do dispositivo.');
    Exit;
  end;

  Log('Ativando dispositivo...');
  btnActivate.Enabled := False;
  btnActivate.Caption := 'Conectando...';
  lblStatus.Caption := 'Conectando ao servidor...';
  lblStatus.Font.Color := clTeal;
  Integrator := TPDVIntegration.Create(BaseUrl);
  try
    try
      if Integrator.ActivateDevice(Code, LabelText) then
      begin
        Log('Ativado com sucesso.');
        lblStatus.Caption := 'Ativacao concluida com sucesso.';
        lblStatus.Font.Color := clGreen;
        Log('DeviceId: ' + Integrator.DeviceId);
        if Integrator.Token = '' then
          Log('Aviso: token nao retornado pela API.');
        if Integrator.LastResponseHeaders <> '' then
          Log('Headers: ' + Integrator.LastResponseHeaders);
        Storage := TPDVStorage.Create;
        try
          Log('INI salvo em: ' + Storage.IniPath);
          if not TFile.Exists(Storage.IniPath) then
            Log('Aviso: INI nao encontrado no caminho informado.');
        finally
          Storage.Free;
        end;
      end
      else
      begin
        Log('Ativacao nao concluida.');
        lblStatus.Caption := 'Ativacao nao concluida.';
        lblStatus.Font.Color := clMaroon;
      end;
    except
      on E: Exception do
      begin
        Log('Erro: ' + E.Message);
        lblStatus.Caption := 'Erro na ativacao.';
        lblStatus.Font.Color := clRed;
        if Integrator.LastResponseText <> '' then
          Log('Resposta: ' + Integrator.LastResponseText);
        if Integrator.LastResponseHeaders <> '' then
          Log('Headers: ' + Integrator.LastResponseHeaders);
      end;
    end;
  finally
    Integrator.Free;
    btnActivate.Enabled := True;
    btnActivate.Caption := 'Ativar dispositivo';
  end;
end;

end.
