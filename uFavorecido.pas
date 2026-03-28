unit uFavorecido;

interface

uses
Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  uMainForm, UchequeEmitido;

type
  TFavorecido = class(TForm)
    BtnSalva: TButton;
    EdtNome: TEdit;
    procedure BtnSalvaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject); // 🔥 ADICIONA ISSO
    procedure EdtNomeKeyPress(Sender: TObject; var Key: Char);

  private
  FFavorecidoID: Integer;
    { Private declarations }
  public
  ModoEdicao: Boolean;
  procedure CarregarFavorecido(ID: Integer);
    { Public declarations }
  end;

var
  FrmFavorecido: TFavorecido;

implementation

{$R *.dfm}
procedure TFavorecido.FormActivate(Sender: TObject);
begin
  edtNome.SetFocus;
end;
procedure TFavorecido.CarregarFavorecido(ID: Integer);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := MainForm.FDConnection1;
    Q.SQL.Text := 'SELECT * FROM TB_PESSOA WHERE PESS_ID = :ID';
    Q.ParamByName('ID').AsInteger := ID;
    Q.Open;

    if not Q.IsEmpty then
    begin
      edtNome.Text := Q.FieldByName('PESS_NOME').AsString;

      FFavorecidoID := ID;
      ModoEdicao := True; // 🔥 ativa edição
    end;

  finally
    Q.Free;
  end;
end;
procedure TFavorecido.EdtNomeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // ENTER
  begin
    Key := #0; // evita beep
    BtnSalvaClick(Sender); // chama o salvar
  end;
end;

procedure TFavorecido.BtnSalvaClick(Sender: TObject);
var
  Q: TFDQuery;
begin
  if Trim(edtNome.Text) = '' then
  begin
    ShowMessage('Digite o nome do favorecido antes de salvar.');
    Exit;
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := MainForm.FDConnection1;

    if ModoEdicao then
    begin
      Q.SQL.Text :=
        'UPDATE TB_PESSOA SET PESS_NOME = :NOME WHERE PESS_ID = :ID';

      Q.ParamByName('ID').AsInteger := FFavorecidoID;
    end
    else
    begin
      Q.SQL.Text :=
        'INSERT INTO TB_PESSOA (PESS_NOME) VALUES (:NOME)';
    end;

    Q.ParamByName('NOME').AsString := edtNome.Text;

    Q.ExecSQL;

    ModalResult := mrOk; // 🔥 fecha direto

  except
    on E: Exception do
      ShowMessage('Erro ao salvar favorecido: ' + E.Message);
  end;

  Q.Free;

end;


end.
