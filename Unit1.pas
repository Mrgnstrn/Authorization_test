unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmSplash = class(TForm)
    btn1: TButton;
    lbl1: TLabel;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

uses Unit2;

{$R *.dfm}

procedure TfrmSplash.btn1Click(Sender: TObject);
begin
  frmAuto.Show;
  frmSplash.Release;
end;

end.
