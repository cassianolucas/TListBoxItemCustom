program ExemploListBoxItem;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in '..\Tela\uPrincipal.pas' {Form1},
  uCustomListBoxItem in '..\Classe\uCustomListBoxItem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
