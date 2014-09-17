unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, IniFiles, jpeg, ExtCtrls, ImgList;

type
  TfrmAuto = class(TForm)
    cmbUser: TComboBox;
    btnEnter: TButton;
    btnQuit: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    edtPass: TEdit;
    btnChange: TButton;
    grpNew: TGroupBox;
    lblNewPass: TLabel;
    edtNewPass: TEdit;
    lblNewPassRe: TLabel;
    edtNewPassRe: TEdit;
    btnNewOK: TButton;
    xpmnfst1: TXPManifest;
    chkShowS: TCheckBox;
    img1: TImage;
    btnNewCancel: TButton;
    btnAdd: TButton;
    btnDel: TButton;
    shp1: TShape;
    GroupBox1: TGroupBox;
    procedure btnQuitClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNewCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEnterClick(Sender: TObject);
    procedure btnNewOKClick(Sender: TObject);
    procedure chkShowSClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure edtPassChange(Sender: TObject);
  private
    function IsPassCorrect(isDelOrAddUser:Boolean = False): Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAuto: TfrmAuto;
  MyIni : TIniFile;
  Pass: string;               //�������� ���������� ��� ������
  AdminPass: string;
  const SecretPass: string = '25011984';  //��������� ������ ���
                                          //�������������� �������
                                          //� ����� ������� �������))
                                          //� ��� ����� ��.
implementation
uses Unit3;
{$R *.dfm}
//������ ������ ����� �... ������� ����� �����������,
//���� ������ �� �������, ����� ��������� ����������� �������
procedure TfrmAuto.btnQuitClick(Sender: TObject);
begin
Application.Terminate;
end;
procedure TfrmAuto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Application.Terminate;
end;
//�����-���� ������� ����� ����������, ���������
procedure TfrmAuto.btnChangeClick(Sender: TObject);
begin
btnChange.Visible:=False;
grpNew.Enabled:=True;
frmAuto.ClientHeight:=250;
end;
procedure TfrmAuto.btnNewCancelClick(Sender: TObject);
begin
grpNew.Enabled:=False;
frmAuto.ClientHeight:=115;
btnChange.Visible:=True;
end;
//�������������
procedure TfrmAuto.FormCreate(Sender: TObject);
begin
  //������������� ������ ��� INI

  MyIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Users.ini');
  //��������� ��������� ����� ������
  cmbUser.Clear;
  MyIni.ReadSections(cmbUser.Items);
  if cmbUser.Items.Count<>0 then cmbUser.ItemIndex:=0
  else cmbUser.AddItem('���� ������� �� ������ ��� ����������� ������', nil); //������� �� �������
  AdminPass:=MyIni.ReadString(cmbUser.Items.Strings[0], 'Pass', 'error');
end;

//�����������.
procedure TfrmAuto.btnEnterClick(Sender: TObject);
begin
if IsPassCorrect(False) = False then Exit;
  frmMain.Show;
  frmAuto.Hide;
  Beep;
end;
//��������� ����� ������
//�� ������ �� ��� ���� �������� �����
procedure TfrmAuto.btnNewOKClick(Sender: TObject);
begin
    if IsPassCorrect(False) = False then Exit
    else if edtNewPass.Text = '' then begin
        MessageBox(Handle, '����� ������ �� ����� ���� ������', '������', MB_ICONWARNING);
        Exit;
    end else if Pass = edtNewPass.Text then begin
        MessageBox(Handle, '�� ��������� �������� ������ ������', '������', MB_ICONWARNING);
        Exit;
    end else if edtNewPass.Text<>edtNewPassRe.Text then begin
        MessageBox(Handle, '������������� ������ �� ������', '������', MB_ICONERROR);
        Exit;
    end else begin
        MyIni.WriteString(cmbUser.Text, 'Pass', edtNewPass.Text);
        MessageBox(Handle, '������ �������', '�������', MB_ICONINFORMATION);
        edtPass.Text:= edtNewPass.Text;
        btnNewCancelClick(nil);
    end;
end;
//����� �������� � �������, ������� �����
procedure TfrmAuto.chkShowSClick(Sender: TObject);
begin
if chkShowS.Checked then begin
  edtPass.PasswordChar:=#0;
  edtNewPass.PasswordChar:=#0;
  edtNewPassRe.PasswordChar:=#0;
end else begin
  edtPass.PasswordChar:='#';
  edtNewPass.PasswordChar:='#';
  edtNewPassRe.PasswordChar:='#';
end;
end;
//���������� � �������� �������������
procedure TfrmAuto.btnAddClick(Sender: TObject);
var NewS: string;
begin
    if IsPassCorrect(True) = False then Exit;
    NewS:= InputBox('���������� ������������', '������� ��� ������ ������������','');
    if NewS<>'' then begin
        if Pos(NewS, cmbUser.Items.Text)<>0 then begin
            MessageBox(Handle, '����� ������������ ��� ����������', '������', MB_ICONERROR);
            Exit;
        end else begin
            MyIni.WriteString(NewS, 'Pass', '12345');
            MessageBox(Handle, '������ ����� ������������, ������ �� ��������� 12345', '�������', MB_ICONINFORMATION);
            //edtPass.Clear;
            cmbUser.Clear;
            MyIni.ReadSections(cmbUser.Items);
            cmbUser.ItemIndex:=cmbUser.Items.Count - 1;
        end;
    end else Beep;
end;
procedure TfrmAuto.btnDelClick(Sender: TObject);
begin
    if cmbUser.ItemIndex = 0 then begin
        MessageBox(Handle, '���������� ������� ������ ��������������', '������', MB_ICONERROR);
        Exit;
    end;
    if IsPassCorrect(True) = False then Exit
    else if MessageBox(Handle, PWideChar('�� �������, ��� ������ ������� ������������'+ chr(13)
                         + '"' + cmbUser.Text + '" ?'), '�������� ������������',
              MB_ICONQUESTION + MB_YESNO) = IDNO then begin
                Beep;
                Exit;
    end;
    MyIni.EraseSection(cmbUser.Text);
    Beep;
    edtPass.Clear;
    cmbUser.Clear;
    MyIni.ReadSections(cmbUser.Items);
    if cmbUser.Items.Count<>0 then cmbUser.ItemIndex:=0 //������� �� �������
end;
//������������� ��������� �������� ������
//�� � �������
function TfrmAuto.IsPassCorrect(isDelOrAddUser:Boolean = False): Boolean;
begin
    Pass:='';
    result:= False;
    if (edtPass.Text = SecretPass) then begin
        result:=true;
        exit;
    end else if (cmbUser.Text = '') then begin
        MessageBox(Handle, '�� ������� ��� ������������', '������', MB_ICONERROR);
        Exit;
    end else if (edtPass.Text = '') then begin
        MessageBox(Handle, '�� ������ ������. ������ ������ �����������', '������', MB_ICONERROR);
        Exit;
    end;
    Pass:=MyIni.ReadString(cmbUser.Text, 'Pass', 'error');
    AdminPass:=MyIni.ReadString(cmbUser.Items.Strings[0], 'Pass', 'error');
    if (Pass = 'error') or (AdminPass = '') or (Pass='') then begin
        MessageBox(Handle, '������ ������ ������ �� �����, ���������� � ��������������', '������', MB_ICONERROR);
        Exit;
    end else if (isDelOrAddUser and (edtPass.Text = AdminPass)) or
                (not isDelOrAddUser and (edtPass.Text = Pass))  then begin
        result:=True;
        Exit;
    end else if isDelOrAddUser then MessageBox(0, '�������� ������! ��� �������� ��� ����������' + chr(13) +
                                                    '������������� ���������� ����������� ������' + chr(13) +
                                                    '�������������� ���� ������������� ������!' + chr(13) +
                                                    '������������ �� ����� ��������� ��� �����������' + chr(13) +
                                                    '��������������.', '������', MB_ICONWARNING)
    else MessageBox(Handle, '�������� ������ ��� ����� ������������', '������', MB_ICONERROR);
end;
//GODMODE!!! ��� ��� ���!!!
procedure TfrmAuto.edtPassChange(Sender: TObject);
begin
shp1.Visible:= (edtPass.Text=SecretPass);
shp1.Pen.Color:=clLime;
end;
end.
