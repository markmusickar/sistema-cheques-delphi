unit UchequeEmitido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  FireDAC.Comp.Client, FireDAC.Stan.Param;
type

    TchequeEmitido = class(TForm)
    edtNumeroCheque: TEdit;
    Label1: TLabel;

    edtValor: TEdit;
    Label2: TLabel;
    EdtVencimento: TMaskEdit;
    Vencimento: TLabel;
    cbConta: TComboBox;
    btnAddconta: TButton;
    btnEditConta: TButton;
    cbStatus: TComboBox;
    cbFavorecido: TComboBox;
    BtnaddFavorecido: TButton;
    bntEditeFavorecido: TButton;
    EditNominal: TEdit;
    Nomial: TLabel;
    BtnSalva: TButton;
    Nome: TLabel;
    Nomef: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnAddcontaClick(Sender: TObject);
    procedure btnEditContaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnaddFavorecidoClick(Sender: TObject);
    procedure BtnSalvaClick(Sender: TObject);

    //procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    procedure CarregarContas;
    procedure CarregarFavorecidos;
  end;

var
  chequeEmitido: TchequeEmitido;


implementation

uses
  uConta, uMainForm, uFavorecido;

{$R *.dfm}

procedure TchequeEmitido.CarregarContas;
var
  Q: TFDQuery;
begin
  cbConta.Items.Clear;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := MainForm.FDConnection1;
    Q.SQL.Text := 'SELECT ID_CONTA, NOME_CONTA FROM TB_CONTA ORDER BY NOME_CONTA';
    Q.Open;

    while not Q.Eof do
    begin
      cbConta.Items.AddObject(
        Q.FieldByName('NOME_CONTA').AsString,
        TObject(Q.FieldByName('ID_CONTA').AsInteger) // 🔥 GUARDA O ID
      );
      Q.Next;
    end;

  finally
    Q.Free;
  end;
end;



procedure TchequeEmitido.FormShow(Sender: TObject);
begin
if Assigned(MainForm) and Assigned(MainForm.FDQueryConta) then
    CarregarContas
      else
    ShowMessage('MainForm ou FDQueryConta não está disponível.');
    CarregarFavorecidos;
end;


procedure TchequeEmitido.btnAddContaClick(Sender: TObject);
begin
  FrmConta := TConta.Create(Self);
  try
    FrmConta.ModoEdicao := False; // 🔥 nova conta

    if FrmConta.ShowModal = mrOk then
    begin
      CarregarContas; // 🔄 atualiza lista
    end;

  finally
    FrmConta.Free;
  end;
end;

procedure TchequeEmitido.BtnAddFavorecidoClick(Sender: TObject);
begin
  try
    if not Assigned(FrmFavorecido) then
      FrmFavorecido := TFavorecido.Create(Self);

    // 🔥 AQUI É A CORREÇÃO
    if FrmFavorecido.ShowModal = mrOk then
      CarregarFavorecidos;

  finally
    FreeAndNil(FrmFavorecido);
  end;
end;
procedure TchequeEmitido.btnEditContaClick(Sender: TObject);
var
  ContaID: Integer;
begin
  if cbConta.ItemIndex = -1 then
  begin
    ShowMessage('Selecione uma conta.');
    Exit;
  end;

  // 🔥 aqui você precisa pegar o ID correto
  ContaID := Integer(cbConta.Items.Objects[cbConta.ItemIndex]);

  FrmConta := TConta.Create(Self);
  try
    FrmConta.CarregarConta(ContaID); // 🔥 ativa edição automaticamente

    if FrmConta.ShowModal = mrOk then
      CarregarContas;

  finally
    FrmConta.Free;
  end;
end;
procedure TchequeEmitido.BtnSalvaClick(Sender: TObject);
var
  Q, QBusca: TFDQuery;
  ContaID, FavID: Integer;
begin
  try
    // 🔹 Validação
    if Trim(edtNumeroCheque.Text) = '' then
    begin
      ShowMessage('Informe o número do cheque.');
      Exit;
    end;

    if Trim(edtValor.Text) = '' then
    begin
      ShowMessage('Informe o valor do cheque.');
      Exit;
    end;

    if cbConta.ItemIndex = -1 then
    begin
      ShowMessage('Selecione uma conta.');
      Exit;
    end;

    if cbFavorecido.ItemIndex = -1 then
    begin
      ShowMessage('Selecione um favorecido.');
      Exit;
    end;

    ContaID := 0;
    FavID := 0;

    // 🔍 Busca o ID da conta
    QBusca := TFDQuery.Create(nil);
    try
      QBusca.Connection := MainForm.FDConnection1;
      QBusca.SQL.Text := 'SELECT ID_CONTA FROM TB_CONTA WHERE NOME_CONTA = :NOME';
      QBusca.ParamByName('NOME').AsString := cbConta.Text;
      QBusca.Open;

      if not QBusca.IsEmpty then
        ContaID := QBusca.FieldByName('ID_CONTA').AsInteger
      else
        raise Exception.Create('Conta não encontrada no banco.');
    finally
      QBusca.Free;
    end;

    // 🔍 Busca o ID do favorecido
    QBusca := TFDQuery.Create(nil);
    try
      QBusca.Connection := MainForm.FDConnection1;
      QBusca.SQL.Text := 'SELECT PESS_ID FROM TB_PESSOA WHERE PESS_NOME = :NOME';
      QBusca.ParamByName('NOME').AsString := cbFavorecido.Text;
      QBusca.Open;

      if not QBusca.IsEmpty then
        FavID := QBusca.FieldByName('PESS_ID').AsInteger
      else
        raise Exception.Create('Favorecido não encontrado no banco.');
    finally
      QBusca.Free;
    end;

    // 💾 Gravação do cheque
    Q := TFDQuery.Create(nil);
    try
      Q.Connection := MainForm.FDConnection1;
      Q.SQL.Text :=
        'INSERT INTO TB_CHEQUE ' +
        '(CONTA_CHEQUE, NUMERO_CHEQUE, FORNECEDOR_CHEQUE, VALOR_CHEQUE, ' +
        'DATA_VENCIMENTO_CHEQUE, ESTADO_CHEQUE, NOMINAL_CHEQUE, DATA_CADASTRO) ' +
        'VALUES (:CONTA, :NUMERO, :FORNECEDOR, :VALOR, :VENCIMENTO, ''ABERTO'', :NOMINAL, :DATA_CAD)';

      Q.ParamByName('CONTA').AsInteger := ContaID;
      Q.ParamByName('NUMERO').AsString := edtNumeroCheque.Text;
      Q.ParamByName('FORNECEDOR').AsInteger := FavID;
      Q.ParamByName('VALOR').AsFloat := StrToFloatDef(edtValor.Text, 0);
      Q.ParamByName('VENCIMENTO').AsDate := StrToDateDef(EdtVencimento.Text, Date);
      Q.ParamByName('NOMINAL').AsString := EditNominal.Text;
      Q.ParamByName('DATA_CAD').AsDate := Date;

      Q.ExecSQL;
      // 🔹 Atualiza a grid principal automaticamente
      if Assigned(Application.MainForm) then
      begin
      if Application.MainForm.FindComponent('FDQueryCheque') <> nil then
      (Application.MainForm.FindComponent('FDQueryCheque') as TFDQuery).Refresh;
      end;

      ShowMessage('✅ Cheque gravado com sucesso!');

      // 🔹 Limpa todos os campos após salvar
      edtNumeroCheque.Clear;
      edtValor.Clear;
      EdtVencimento.Clear;
      //EditNominal.Clear;
      //cbConta.ItemIndex := -1;
      //cbFavorecido.ItemIndex := -1;
      //cbStatus.ItemIndex := -1;
      edtNumeroCheque.SetFocus; // volta o foco para o primeiro campo

    finally
      Q.Free;  // fecha o try interno
    end;

  except
    on E: Exception do
      ShowMessage('Erro ao salvar cheque: ' + E.Message);
  end; // fecha o try externo
end;



procedure TchequeEmitido.CarregarFavorecidos;
var
  Q: TFDQuery;
begin
  cbFavorecido.Clear; // limpa antes de recarregar

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := MainForm.FDConnection1;
    Q.SQL.Text := 'SELECT PESS_NOME FROM TB_PESSOA ORDER BY PESS_NOME';
    Q.Open;

    while not Q.Eof do
    begin
      cbFavorecido.Items.Add(Q.FieldByName('PESS_NOME').AsString);
      Q.Next;
    end;

  finally
    Q.Free;
  end;
end;
procedure TchequeEmitido.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
const
  CamposPermitidos: array[0..4] of string = (
    'edtNumeroCheque',   // 1️⃣ Número do cheque
    'edtValor',          // 2️⃣ Valor
    'EdtVencimento',     // 3️⃣ Data de vencimento
    'EditNominal',       // 4️⃣ Nominal
    'btnSalva'          // 5️⃣ Botão Salvar
  );
var
  i, idxAtual, proximo: Integer;
  NomeAtual: string;
  Controle: TWinControl;
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    NomeAtual := (ActiveControl as TWinControl).Name;
    idxAtual := -1;

    // 🔍 Localiza o campo atual
    for i := Low(CamposPermitidos) to High(CamposPermitidos) do
      if SameText(CamposPermitidos[i], NomeAtual) then
      begin
        idxAtual := i;
        Break;
      end;

    // 👉 Vai para o próximo campo
    if idxAtual <> -1 then
    begin
      proximo := idxAtual + 1;
      if proximo > High(CamposPermitidos) then
        proximo := Low(CamposPermitidos);

      Controle := FindComponent(CamposPermitidos[proximo]) as TWinControl;
      if Assigned(Controle) then
      begin
        if Controle is TButton then
        begin
          // 🔹 Executa automaticamente o clique no botão
          (Controle as TButton).Click;

          // 🔁 Após salvar, volta para o primeiro campo
          Controle := FindComponent('edtNumeroCheque') as TWinControl;
          if Assigned(Controle) then
            Controle.SetFocus;
        end
        else
          Controle.SetFocus;
      end;
    end;
  end;
end;

end.


