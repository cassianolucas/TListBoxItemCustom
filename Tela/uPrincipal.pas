unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation,
  FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ListBox: TListBox;
    Image1: TImage;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    i: Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses uCustomListBoxItem;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not Assigned(customListBoxItem) then
    customListBoxItem := TCustomListBoxItem.Create(ListBox, Image1.Bitmap, Image2.Bitmap);

  Inc(I);

  customListBoxItem.AdicionarItem(i.ToString, 'descrição ' + i.ToString);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if not Assigned(customListBoxItem) then
    customListBoxItem := TCustomListBoxItem.Create(ListBox, Image1.Bitmap, Image2.Bitmap);

  customListBoxItem.removerTodos();
  i := 0;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if not Assigned(customListBoxItem) then
    customListBoxItem := TCustomListBoxItem.Create(ListBox, Image1.Bitmap, Image2.Bitmap);

  customListBoxItem.removerItem(i -1);

  if (i > 0) then
    Dec(i);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Image1.Visible := False;
  Image2.Visible := False;
  i := 0;
end;

end.
