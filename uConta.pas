unit uConta;

interface

uses
Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  uMainForm, UchequeEmitido;         // ← para acessar MainForm e chequeEmitido

type
TConta = class(TForm)
    EditNome: TEdit;
    EditAgencia: TEdit;
    EditConta: TEdit;
    BtnSalva: TButton;
    Nome: TLabel;
    Agencia: TLabel;
    Conta: TLabel;
    procedure CarregarConta(ID: Integer);
    procedure BtnSalvaClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
  private
    FContaID: Integer;
  public
    ModoEdicao: Boolean;
    procedure CarregarDados(const Agencia, Conta, Nome: string; ID: Integer);
  end;

var
  FrmConta: TConta;

 implementation

{$R *.dfm}
procedure TConta.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;

    // 🔥 se estiver no último campo → salva
    if Sender = EditConta then
      BtnSalvaClick(Sender)
    else
      SelectNext(Sender as TWinControl, True, True);
  end;
end;
procedure TConta.BtnSalvaClick(Sender: TObject);
var
  Q: TFDQuery;
begin
  if (EditNome.Text = '') or (EditConta.Text = '') or (EditAgencia.Text = '') then
  begin
    ShowMessage('Preencha Agência, Conta e Nome antes de salvar.');
    Exit;
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := MainForm.FDConnection1;

    // 🔥 SE ESTIVER EDITANDO → UPDATE
    if ModoEdicao then
    begin
      Q.SQL.Text :=
        'UPDATE TB_CONTA SET ' +
        'NOME_CONTA = :NOME, ' +
        'NUMERO_CONTA = :CONTA, ' +
        'AGENCIA = :AGENCIA ' +
        'WHERE ID_CONTA = :ID';

      Q.ParamByName('ID').AsInteger := FContaID;
    end
    else
    begin
      // 🔥 SENÃO → INSERT
      Q.SQL.Text :=
        'INSERT INTO TB_CONTA (NOME_CONTA, NUMERO_CONTA, AGENCIA) ' +
        'VALUES (:NOME, :CONTA, :AGENCIA)';
    end;

    Q.ParamByName('NOME').AsString    := EditNome.Text;
    Q.ParamByName('CONTA').AsString   := EditConta.Text;
    Q.ParamByName('AGENCIA').AsString := EditAgencia.Text;

    Q.ExecSQL;

    ModalResult := mrOk;



  except
    on E: Exception do
      ShowMessage('Erro ao salvar conta: ' + E.Message);
  end;

  Q.Free;
end;
  procedure TConta.CarregarDados(const Agencia, Conta, Nome: string; ID: Integer);
begin
  EditAgencia.Text := Agencia;
  EditConta.Text   := Conta;
  EditNome.Text    := Nome;

  ModoEdicao := True;
  FContaID := ID;
  end;
  procedure TConta.CarregarConta(ID: Integer);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := MainForm.FDConnection1;
    Q.SQL.Text := 'SELECT * FROM TB_CONTA WHERE ID_CONTA = :ID';
    Q.ParamByName('ID').AsInteger := ID;
    Q.Open;

    if not Q.IsEmpty then
    begin
      EditNome.Text    := Q.FieldByName('NOME_CONTA').AsString;
      EditConta.Text   := Q.FieldByName('NUMERO_CONTA').AsString;
      EditAgencia.Text := Q.FieldByName('AGENCIA').AsString;

      FContaID := ID;
      ModoEdicao := True;
    end;

  finally
    Q.Free;
  end;
end;
end.
