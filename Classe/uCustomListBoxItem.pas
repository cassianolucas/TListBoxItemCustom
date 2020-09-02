{*******************************************************}
{                                                       }
{              Delphi FireMonkey Platform               }
{                                                       }
{       Copyright(c) 2020 Lucas Cassiano da Silva       }
{                                                       }
{                                                       }
{*******************************************************}

unit uCustomListBoxItem;

interface

uses FMX.StdCtrls, FMX.ListBox,
  FMX.Effects, FMX.Objects,
  FMX.Layouts, FMX.Types,
  FMX.Controls, FMX.Edit,
  FMX.Graphics;

type TOpcao = (TSoma, TSubtracao);

type TCustomListBoxItem = class
  private
    FListBox: TListBox;
    FListBoxItem: TListBoxItem;
    FEfeito: TShadowEffect;
    FLabel: TLabel;
    FEdit: TEdit;
    FLayout: TLayout;
    FObject: TFmxObject;
    FIconeSubtracao,
    FIconeSoma: TBitMap;

    const NOME_ITEM = 'lbiItem_%s';
          NOME_BORDA = 'recBorda_%s';
          NOME_EFEITO = 'swFundo_%s';
          NOME_DESC = 'lblDesc%s_%s';
          NOME_LAY = 'lyGeral_%s';
          NOME_BOTAO = 'btAcao%s_%s';
          NOME_CAIXA_TEXTO = 'edQuantidade_%s';

    function retornaAlturaTexto(const Width: single; const Text: string): Single;

    function somenteNumeros(const valor: String): String;

    procedure acao(Sender: TObject);

    procedure digitando(Sender: TObject);

    function buscarEditItem(item: TlistBoxItem): TEdit;

    function criarItem(const sIdentificador: String): TListBoxItem;

    function criarBorda(const proprietario: TFmxObject): TFmxObject;

    function criarEfeito(const proprietario: TFmxObject): TShadowEffect;

    function criarDescricao(const sDescricao: String; const proprietario: TFmxObject): TLabel;

    function criarLayout(const proprietario: TFmxObject): TLayout;

    function criarBotao(const proprietario: TFmxObject; const opcao: TOpcao): TFmxObject;

    function criarCaixaTexto(const proprietario: TFmxObject): TEdit;
  public
    /// <summary>Método cria classe com configurações necessárias</summary>
    /// <param name="listBox">ListBox onde serão gerados os itens</param>
    /// <param name="iconeSubtracao">Icone de subtração que será usado no botão</param>
    /// <param name="iconeSoma">Icone de soma que será usado no botão</param>
    constructor Create(const listBox: TListBox; const iconeSubtracao, iconeSoma: TBitMap);

    /// <summary>Método adiciona novo item em listBox</summary>
    /// <param name="sIdentificador">Identificador do item, deve ser único</param>
    /// <param name="sDescricao">Descrição de que será apresentada na parte superior do item</param>
    procedure adicionarItem(const sIdentificador, sDescricao: String);

    /// <summary>Método remove item indicado</summary>
    /// <param name="indice">Índice do item a ser removido do listBox</param>
    procedure removerItem(const indice: Integer);

    /// <summary>Método remove todos os itens do listBox</summary>
    procedure removerTodos();

    /// <summary>Método retorna quantidade que está indicada no item</summary>
    /// <param name="indice">Índice do item</param>
    /// <returns>Retorna valor que está no item</returns>
    function retornarQuantidadeItem(const indice: Integer): Double;
end;

var
  customListBoxItem: TCustomListBoxItem;

implementation

uses
  System.SysUtils, System.UITypes,
  FMX.TextLayout, System.Types,
  StrUtils, FMX.Ani;

{ TCustomListBoxItem }

constructor TCustomListBoxItem.Create(const listBox: TListBox; const iconeSubtracao, iconeSoma: TBitMap);
begin
  inherited Create;
  FListBox := listBox;
  FIconeSubtracao := iconeSubtracao;
  FIconeSoma := iconeSoma;
end;

function TCustomListBoxItem.retornaAlturaTexto(const Width: single; const Text: string): Single;
var
  Layout: TTextLayout;
begin
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      with Layout do
      begin
        VerticalAlign := TTextAlign.Leading;

        HorizontalAlign := TTextAlign.Leading;

        WordWrap := true;

        Trimming := TTextTrimming.Character;

        MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);

        Text := Text;
      end;
    finally
      Layout.EndUpdate;
    end;
    Result := Round(Layout.Height);

    Layout.Text := 'm';

    Result := Result + Round(Layout.Height);
  finally
    Layout.DisposeOf;
  end;
end;

function TCustomListBoxItem.somenteNumeros(const valor: String): String;
var
  vText : PChar;
begin
  vText := PChar(valor);
  Result := '';
 
  while (vText^ <> #0) do
  begin
    {$IFDEF UNICODE}
    if CharInSet(vText^, ['0'..'9']) then
    {$ELSE}
    if vText^ in ['0'..'9'] then
    {$ENDIF}
      Result := Result + vText^;
 
    Inc(vText);
  end;
end;

procedure TCustomListBoxItem.acao(Sender: TObject);
var
  editTemp: TEdit;
  nValor: Double;
begin
  editTemp := buscarEditItem(TListBoxItem((Sender as TCircle).Parent.Parent.Parent));

  if (editTemp <> nil) then
  begin  
    if (somenteNumeros(editTemp.Text) <> '') then
    begin
      nValor := StrToFloat(somenteNumeros(editTemp.Text));    
      // quando vier do botão soma
      if Pos('Soma', (Sender as TCircle).Name) <> 0 then
        nValor := nValor + 1
      else
      begin
        if nValor > 0 then
          nValor := nValor -1;
        
        if nValor < 0 then
          nValor := 0;
      end;      
    end
    else
      nValor := 0;
    editTemp.Text := FloatToStr(nValor);
    editTemp.SelStart := Length(editTemp.Text);
  end;
end;

procedure TCustomListBoxItem.digitando(Sender: TObject);
begin
  (Sender as TEdit).Text := somenteNumeros((Sender as TEdit).Text);
  (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
end;

function TCustomListBoxItem.buscarEditItem(item: TlistBoxItem): TEdit;
var
  I, J: Integer;
  K: Integer;
begin
  Result := nil;
  for I := 0 to item.ComponentCount -1 do
  begin
    if (item.Components[i] is TRectangle) then
    begin
      for j := 0 to TRectangle(item.Components[i]).ComponentCount -1 do
      begin
        if (TRectangle(item.Components[i]).Components[j] is TLayout) then
        begin
          for k := 0 to TLayout(TRectangle(item.Components[i]).Components[j]).ComponentCount -1 do
          begin
            if (TLayout(TRectangle(item.Components[i]).Components[j]).Components[k] is TEdit) then
            begin
              Result := TEdit(TLayout(TRectangle(item.Components[i]).Components[j]).Components[k]);
              Exit;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TCustomListBoxItem.criarItem(const sIdentificador: String): TListBoxItem;
begin
  Result := TListBoxItem.Create(FListBox);

  with Result do
  begin
    Selectable := False;
    Name := Format(NOME_ITEM, [sIdentificador]);
    with Margins do
    begin
      Bottom := 10;
      Left := 10;
      Right := 10;
      Top := 10;
    end;
    Height := 100;
    Width := FListBox.Width;
    Text := '';
    TagString := sIdentificador;
  end;
end;

function TCustomListBoxItem.criarBorda(const proprietario: TFmxObject): TFmxObject;
begin
  Result := TRectangle.Create(proprietario);

  with (Result as TRectangle) do
  begin
    Align := TAlignLayout.Client;
    Name := Format(NOME_BORDA, [proprietario.TagString]);
    XRadius := 10;
    YRadius := 10;
    Fill.Color := TAlphaColorRec.White;
    Stroke.Kind := TBrushKind.None;
    TagString := proprietario.TagString;
  end;
end;

function TCustomListBoxItem.criarEfeito(const proprietario: TFmxObject): TShadowEffect;
begin
  Result := TShadowEffect.Create(proprietario);

  with Result do
  begin
    Direction := 45;
    Distance := 3;
    Enabled := True;
    Opacity := 0.2;
    ShadowColor := TAlphaColorRec.Black;
    Softness := 0.3;
    Name := Format(NOME_EFEITO, [proprietario.TagString]);
  end;
end;

function TCustomListBoxItem.criarDescricao(const sDescricao: String; const proprietario: TFmxObject): TLabel;
begin
  Result := TLabel.Create(proprietario);

  with Result do
  begin
    Parent := proprietario;

    if (proprietario is TRectangle) then
    begin
      Align := TAlignLayout.Top;
      TextSettings.Font.Size := 16;
      TextSettings.Font.Style := [TFontStyle.fsBold];
      Name := Format(NOME_DESC, ['Descricao', proprietario.TagString]);
    end
    else
    begin
      Align := TAlignLayout.Left;
      Name := Format(NOME_DESC, ['Quantidade', proprietario.TagString]);
    end;

    with Margins do
    begin
      Bottom := 5;
      Left := 5;
      Right := 5;
      Top := 5;
    end;

    if (proprietario is TRectangle) then
      Width := (proprietario as TRectangle).Width
    else
      Width := ((proprietario as TLayout).Width / 2) / 2 - 20;

    Height := RetornaAlturaTexto(Width, Text);
    Text := sDescricao;
    TagString := proprietario.TagString;
  end;
end;

function TCustomListBoxItem.criarLayout(const proprietario: TFmxObject): TLayout;
begin
  Result := TLayout.Create(proprietario);

  with Result do
  begin
    Parent := proprietario;
    Position.Y := FLabel.Height;
    Align := TAlignLayout.Client;
    Name := Format(NOME_LAY, [proprietario.TagString]);
    TagString := proprietario.TagString;
  end;
end;

function TCustomListBoxItem.criarBotao(const proprietario: TFmxObject; const opcao: TOpcao): TFmxObject;
begin
  Result := TCircle.Create(proprietario);

  with (Result as TCircle) do
  begin
    Parent := proprietario;
    Width := 40;
    Height := 40;

    if (opcao = TSoma) then
      Position.X := FLabel.Width + FLabel.Margins.Left + FLabel.Margins.Right +
        (FObject as TCircle).Width + (FObject as TCircle).Margins.Left +
        (FObject as TCircle).Margins.Right + FEdit.Width + FEdit.Margins.Left + FEdit.Margins.Right
    else
      Position.X := FLabel.Width;

    if (opcao = TSoma) then
      Fill.Bitmap.Bitmap := FIconeSoma
    else
      Fill.Bitmap.Bitmap := FIconeSubtracao;

    Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    Fill.Kind := TBrushKind.Bitmap;

    with Margins do
    begin
      Bottom := 8;
      Left := 0;
      Right := 5;
      Top := 8;
    end;
    Align := TAlignLayout.Left;
    BringToFront;
    OnClick := acao;
    Stroke.Kind := TBrushKind.None;
    TagString := proprietario.TagString;
    Name := Format(NOME_BOTAO, [IfThen(opcao = TSoma, 'Soma', 'Subtracao'), proprietario.TagString]);
  end;
end;

function TCustomListBoxItem.criarCaixaTexto(const proprietario: TFmxObject): TEdit;
begin
  Result := TEdit.Create(proprietario);

  with Result do
  begin
    Width := Trunc(FLayout.Width - FLabel.Width - FLabel.Margins.Left - FLabel.Margins.Right -
      ((FObject as TCircle).Width * 2) -  ((FObject as TCircle).Margins.Left * 2) -
      ((FObject as TCircle).Margins.Right * 2) - 10);
    Parent := proprietario;
    Position.X := (FObject as TCircle).Position.X + (FObject as TCircle).Margins.Right;
    Align := TAlignLayout.Left;

    with Margins do
    begin
      Bottom := 5;
      Left := 5;
      Right := 5;
      Top := 5;
    end;

    with TextSettings do
    begin
      HorzAlign := TTextAlign.Center;
      VertAlign := TTextAlign.Center;
    end;

    OnTyping := digitando;
    KeyboardType := TVirtualKeyboardType.NumberPad;
    TagString := proprietario.TagString;
    Name := Format(NOME_CAIXA_TEXTO, [proprietario.TagString]);
    Text := '0';
  end;
end;

procedure TCustomListBoxItem.adicionarItem(const sIdentificador, sDescricao: String);
var
  iAltura: Single;
begin
  // cria item em listBox
  FListBoxItem := criarItem(sIdentificador);

  // cria borda
  FObject := criarBorda(FListBoxItem);

  // cria efeito de sombra
  FEfeito := criarEfeito(FObject);

  // adiciona efeito em listBox
  FObject.AddObject(FEfeito);

  // adiciona borda em item
  FListBoxItem.AddObject(FObject);

  // cria descrição principal
  FLabel := criarDescricao(sDescricao, FObject);

  iAltura := FLabel.Height;

  // adiciona label em item
  FObject.AddObject(FLabel);

  // cria layout
  FLayout := criarLayout(FObject);

  // adiciona layout em fundo
  FObject.AddObject(FLayout);

  // cria texto
  FLabel := criarDescricao('Quantidade', FLayout);

  // adiciona descricao em layout
  FLayout.AddObject(FLabel);

  // cria botão de subtração
  FObject := criarBotao(FLayout, TSubtracao);

  // adiciona botão em layout
  FLayout.AddObject(FObject);

  // cria caixa de texto
  FEdit := criarCaixaTexto(FLayout);

  // adiciona caixa de texto em layout
  FLayout.AddObject(FEdit);

  // cria botão de soma
  FObject := criarBotao(FLayout, TSoma);

  // adiciona botão em layout
  FLayout.AddObject(FObject);

  // adiciona ancora em caixa de texto para ficar responsiva
  FEdit.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop,
    TAnchorKind.akRight, TAnchorKind.akBottom];

  // adiciona altura real
  FListBoxItem.Height := iAltura + FLayout.Height;

  // adiciona item em listBox
  FListBox.AddObject(FListBoxItem);
end;

procedure TCustomListBoxItem.removerItem(const indice: Integer);
begin
  if (indice >= 0) then
    FListBox.Items.Delete(indice);
end;

procedure TCustomListBoxItem.removerTodos;
begin
  if (FListBox.Items.Count > 0) then
    FListBox.Items.Clear;
end;

function TCustomListBoxItem.retornarQuantidadeItem(const indice: Integer): Double;
var
  iTem: TListBoxItem;
  editTemp: TEdit;
begin
  Result := 0;

  iTem := FListBox.ItemByIndex(indice);

  if (iTem <> nil) then
  begin
    editTemp := buscarEditItem(iTem);
    if (editTemp <> nil) then
      if (editTemp.Text <> '') then
        Result := StrToFloat(editTemp.Text);
  end;
end;

end.
