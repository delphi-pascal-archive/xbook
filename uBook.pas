unit uBook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, DB, ADODB, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls,
  DBCtrls, Menus, uRichEditWithLinks, Printers, DAO2000, ComObj, ImgList;

type
  TForm1Tree = class(TForm)
    ADOConnection1: TADOConnection;
    qTreeCompanies: TADOQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    TreeCompanies: TTreeView;
    Panel5: TPanel;
    DataSource1: TDataSource;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    MainMenu1: TMainMenu;
    Connect1: TMenuItem;
    Exit1: TMenuItem;
    ools1: TMenuItem;
    About1: TMenuItem;
    RichEditWithLinks1: TRichEditWithLinks;
    Panel6: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    PopupMenu2: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N4: TMenuItem;
    CompactBase1: TMenuItem;
    Edit1: TEdit;
    ImageList1: TImageList;
    Procedure ExpandLevel( Node : TTreeNode);
    procedure TreeCompaniesExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure TreeCompaniesChange(Sender: TObject; Node: TTreeNode);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure MyConnect(Sender: TObject);
    procedure TreeCompaniesClick(Sender: TObject);
    procedure POPupMenuAdd(Sender: TObject);
    procedure POPupMenuAddIN(Sender: TObject);
    procedure POPupMenuDelete(Sender: TObject);
    procedure TreeCompaniesEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CompactBase1Click(Sender: TObject);
    procedure Edit1Locate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1Tree: TForm1Tree;
  RedoDone:Boolean;
  DataBaseName:string;
implementation

uses about;

{$R *.dfm}
Procedure DeclarePar;
begin
   with Form1Tree.qTreeCompanies.Parameters.AddParameter do begin
        Name := 'ParentID';
        DataType := ftInteger;
        Direction := pdInput;
        Value := 0;
   end;
   with Form1Tree.qTreeCompanies.Parameters.AddParameter do begin
        Name := 'ID';
        DataType := ftInteger;
        Direction := pdInput;
        Value := 0;
   end;
end;

Procedure TForm1Tree.ExpandLevel( Node : TTreeNode);
Var ID , i   : Integer;
    TreeNode : TTreeNode;
Begin
// ��� ������ �������� ������ ������� ������ ���,
    // ��� �� ����� ���������.
    IF Node = nil Then ID:=0
    Else ID:=Integer(Node.Data);
    qTreeCompanies.Close;
    qTreeCompanies.SQL.Clear;
    declarepar;
    qTreeCompanies.Parameters.ParamByName('ParentID').Value :=ID;
    qTreeCompanies.SQL.Add('Select * From COMPANY Where ParentID=:ParentID');
    qTreeCompanies.Open;
    TreeCompanies.Items.BeginUpdate;
// ��� ������ ������ �� ����������� ������ ������
    // ��������� ����� � TreeView, ��� �������� ����� � ���,
    // ������� �� ������ ��� "��������"
    For i:=1 To qTreeCompanies.RecordCount Do
    Begin
// ������� � ���� Data ����� �� ����������������� �����(ID) � �������
 TreeNode:=
 TreeCompanies.Items.AddChildObject(Node,qTreeCompanies.FieldByName('Name').AsString
 ,Pointer(qTreeCompanies.FieldByName('ID').AsInteger));
 TreeNode.ImageIndex:=1;
 TreeNode.SelectedIndex:=2;
// ������� ��������� (������) �������� ����� ������ ��� ����,
       // ����� ��� ��������� [+] �� ����� � �� ����� ���� �� ��������
 TreeCompanies.Items.AddChildObject(TreeNode ,'' , nil);
 qTreeCompanies.Next;
    End;
    TreeCompanies.Items.EndUpdate;
End;

procedure TForm1Tree.TreeCompaniesExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  IF Node.getFirstChild.Data = nil Then
  Begin
          Node.DeleteChildren;
          ExpandLevel(Node);
  End;


end;

procedure TForm1Tree.TreeCompaniesChange(Sender: TObject; Node: TTreeNode);
var id:integer;
begin
   IF TreeCompanies.Selected <> nil Then
   Begin
//ID ������������ ����� , ��� ��� � ���� ��� ��������
    ID:=Integer(TreeCompanies.Selected.Data);
    qTreeCompanies.Close;
    qTreeCompanies.SQL.Clear;
    DeclarePar;
//    showmessage(inttostr(qTreeCompanies.Parameters.Count));
    qTreeCompanies.Parameters.ParamByName('ParentID').Value :=ID;
    qTreeCompanies.SQL.Add('Select * From COMPANY Where ParentID=:ParentID');
    qTreeCompanies.Open;
    End;
end;

procedure TForm1Tree.DBGrid1DblClick(Sender: TObject);
var ID:integer;
begin
 ID:=qTreeCompanies.FieldByName('ID').AsInteger;
 If ID <> 0 then
 begin
    Redodone:=False;
    RichEditWithLinks1.Clear;
    RichEditWithLinks1.Lines.Add(qTreeCompanies.FieldByName('TEXT').AsString);
 end;
{
Allow:=True;
    ID:=qTreeCompanies.FieldByName('ID').AsInteger;
// �������������� "���������" ��������� ��� �����, �� ������� �����
 TreeCompanies.OnExpanding(TreeCompanies ,TreeCompanies.Selected, Allow);
// ���������� ��� ������������ �������� ����� � ���� ��, ID �������
// ��������� � ID ������ � ������ �������. �� ���� ���� ����� � ������,
// ������� ������������ ��� ������ � �������, �� ������� �� �����
// ��� ������ �����, ��������� ���������� ����� � ������ �� ����������,
// �� ���� ��������� "������" �� ��� � ������
   FOR i:=0 To TreeCompanies.Selected.Count-1 Do
   IF Integer(TreeCompanies.Selected.Item[i].Data) = ID Then
     Begin
          TreeCompanies.Selected.Item[i].Expand(False);
          TreeCompanies.Selected.Item[i].Selected:=True;
          TreeCompanies.Repaint;
          Exit;
     End;
}
end;

procedure TForm1Tree.MyConnect(Sender: TObject);
var mainPath, filebase, rconnect:string;
begin
 MainPath:=ExtractFilePath(Application.ExeName);
 filebase:= MainPath+'book.mdb';
 DatabaseName:=FileBase;
 Form1Tree.Caption:='����: '+ filebase;
 rconnect:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+
 filebase+  ';Persist Security Info=False';
// aconnect:='Microsoft.Jet.OLEDB.4.0;Data Source='+filebase+';Mode=ReadWrite;Persist Security Info=False';
 ADOConnection1.close;
 AdoConnection1.ConnectionString:=Rconnect;
 ADOConnection1.Open;
 TreeCompaniesClick(Sender);
end;

procedure TForm1Tree.TreeCompaniesClick(Sender: TObject);
var id:integer;
begin   
   IF TreeCompanies.Selected <> nil Then
   Begin
//ID ����� , ��� ��� � ���� ��� � ��� ID
   ID:=Integer(TreeCompanies.Selected.Data);
   qTreeCompanies.Close;
   qTreeCompanies.SQL.Clear;
   DeclarePar;
   qTreeCompanies.SQL.Add('Select * From COMPANY Where ID=:ID');
//   qTreeCompanies.SQL.Add('Select * From COMPANY Where ParentID=:ParentID');
//Select * From COMPANY Where ParentID=:ParentID
   qTreeCompanies.Parameters.ParamByName( 'ID').Value:=ID;
   qTreeCompanies.Open;
   if id = 0 then
   RichEditWithLinks1.Lines.Clear;
   DBGrid1DblClick(sender);
   End;
end;

procedure TForm1Tree.POPupMenuAdd(Sender: TObject);
var id,RParentID:integer;
Label Fin;
begin
   IF TreeCompanies.Selected <> nil Then
   Begin
   ID:=Integer(TreeCompanies.Selected.Data);
   qTreeCompanies.Close;
   qTreeCompanies.SQL.Clear;
   DeclarePar;
   qTreeCompanies.SQL.Add('Select * From COMPANY Where ID=:ID');
   qTreeCompanies.Parameters.ParamByName( 'ID').Value:=ID;
   qTreeCompanies.Open;
   RParentID:= qTreeCompanies.FieldByName('ParentID').AsInteger;
    if RParentID = 0 then
    begin
      showmessage('� �������� ������!');
      goto fin;
    end;
   qTreeCompanies.Append;
   qTreeCompanies.FieldByName('ParentID').Value:=RParentID;
   qTreeCompanies.FieldByName('NAME').AsString:='NEW_IN_'+INTTOSTR(RParentID);
   qTreeCompanies.Post;
   qTreeCompanies.Edit;
   qTreeCompanies.FieldByName('NAME').AsString:=qTreeCompanies.FieldByName('ID').AsString+'_NEW_IN_'+INTTOSTR(RParentID);
   qTreeCompanies.Post;
 TreeCompanies.Items.AddObject(TreeCompanies.Selected,   //AddChildObject
 qTreeCompanies.FieldByName('Name').AsString
 ,Pointer(qTreeCompanies.FieldByName('ID').AsInteger));
   TreeCompanies.Repaint;    ///FullExpand;
   End;
  fin:
end;

procedure TForm1Tree.POPupMenuAddIN(Sender: TObject);
var id,RID:integer;
Label Fin;
begin   
   IF TreeCompanies.Selected <> nil Then
   Begin
//ID ����� , ��� ��� � ���� ��� � ��� ID
   ID:=Integer(TreeCompanies.Selected.Data);
   qTreeCompanies.Close;
   qTreeCompanies.SQL.Clear;
   DeclarePar;
   qTreeCompanies.SQL.Add('Select * From COMPANY Where ID=:ID');
   qTreeCompanies.Parameters.ParamByName( 'ID').Value:=ID;
   qTreeCompanies.Open;
   RID:= qTreeCompanies.FieldByName('ID').AsInteger;
   qTreeCompanies.Append;
   qTreeCompanies.FieldByName('ParentID').Value:=RID;
   qTreeCompanies.FieldByName('NAME').AsString:='NEW_INTO '+IntToStr(RID);
   qTreeCompanies.Post;
   qTreeCompanies.Edit;
   qTreeCompanies.FieldByName('NAME').AsString:=qTreeCompanies.FieldByName('ID').AsString+'NEW_INTO '+IntToStr(RID);
   qTreeCompanies.Post;
 TreeCompanies.Items.AddChildObject(TreeCompanies.Selected,   //AddChildObject
 qTreeCompanies.FieldByName('Name').AsString
 ,Pointer(qTreeCompanies.FieldByName('ID').AsInteger));
   TreeCompanies.Repaint;    
   End;
  fin:
end;

procedure TForm1Tree.POPupMenuDelete(Sender: TObject);
// �������
var ii,id:integer;
Label Fin;
begin
   IF TreeCompanies.Selected <> nil Then
   Begin
   if TreeCompanies.Selected.HasChildren then
   begin
     showmessage('������ �������! ���� ���������');
     goto fin;
   end;
   ID:=Integer(TreeCompanies.Selected.Data);
   qTreeCompanies.Close;
   qTreeCompanies.SQL.Clear;
   DeclarePar;
   qTreeCompanies.SQL.Add('Select * From COMPANY Where ID=:ID');
   qTreeCompanies.Parameters.ParamByName( 'ID').Value:=ID;
   qTreeCompanies.Open;
//   RParentID:= qTreeCompanies.FieldByName('ParentID').AsInteger;
    if ID = 0 then
    begin
      showmessage('������� ������!');
      goto fin;
    end;
   for ii := 0  to qTreeCompanies.RecordCount-1  do
   begin
        qTreeCompanies.Delete;
   end;
    TreeCompanies.Items.Delete(TreeCompanies.Selected);
   End;
  fin:
end;

procedure TForm1Tree.TreeCompaniesEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
var id:integer;
Label Fin;
begin
   IF TreeCompanies.Selected <> nil Then
   Begin
   ID:=Integer(TreeCompanies.Selected.Data);
   if ID = 0 then
   begin
     showmessage('������� �� ������� !');
     goto fin;
   end;
   qTreeCompanies.Close;
   qTreeCompanies.SQL.Clear;
   DeclarePar;
   qTreeCompanies.SQL.Add('Select * From COMPANY Where ID=:ID');
   qTreeCompanies.Parameters.ParamByName( 'ID').Value:=ID;
   qTreeCompanies.Open;
   qTreeCompanies.Edit;
   qTreeCompanies.FieldByName('NAME').AsString:=s;
   qTreeCompanies.Post;
   End;
  fin:
end;

procedure TForm1Tree.About1Click(Sender: TObject);
begin
 AboutBox.showmodal;
end;

procedure TForm1Tree.Exit1Click(Sender: TObject);
begin
  ADOConnection1.Close;
  Close;
end;

procedure TForm1Tree.MenuItem1Click(Sender: TObject);
begin
// ���������� � �����
    RichEditWithLinks1.CopyToClipboard;
end;

procedure TForm1Tree.MenuItem2Click(Sender: TObject);
begin
// �������� �� ������
   RichEditWithLinks1.PasteFromClipboard;
end;

procedure TForm1Tree.MenuItem3Click(Sender: TObject);
begin
// ��������
   RichEditWithLinks1.CutToClipboard;
end;

procedure TForm1Tree.Button1Click(Sender: TObject);
begin
// � ��
   RedoDone:=True;
   if ( qTreeCompanies.RecordCount >= 0 ) and ( qTreeCompanies.FieldByName('ID').value <> 0 ) then
   begin
     qTreeCompanies.edit;
     qTreeCompanies.FieldByName('TEXT').asstring:=TrimRight(RichEditWithLinks1.Lines.Text);
     qTreeCompanies.post;
   end;   
//   FRedak.Close;
end;

procedure TForm1Tree.Button2Click(Sender: TObject);
begin
 // �� ����
  if Savedialog1.Execute then
  begin
   richeditwithlinks1.Lines.SaveToFile(Savedialog1.FileName);
  end;
end;

procedure TForm1Tree.Button3Click(Sender: TObject);
begin
 // � �����
 if Opendialog1.Execute then
  begin
   richeditwithlinks1.Lines.clear;
   richeditwithlinks1.Lines.LoadFromFile(Opendialog1.FileName);
  end;
end;

procedure TForm1Tree.Button4Click(Sender: TObject);
var P:TextFile;
 ii: integer;
begin
// ��������
   if RichEditWithLinks1.Lines.Count > -1 then
   begin
     AssignPrn(P);
     Rewrite(P);
       for ii :=0  to RichEditWithLinks1.Lines.Count-1 do
       begin
           Writeln(P,RichEditWithLinks1.Lines[ii]);
       end;
     System.CloseFile(P);
   end;
end;

procedure TForm1Tree.BitBtn1Click(Sender: TObject);
begin
 // bold
RichEditWithLinks1.SetFocus;
if fsBold in RichEditWithLinks1.SelAttributes.Style then
RichEditWithLinks1.SelAttributes.Style :=RichEditWithLinks1.SelAttributes.Style - [fsBold] else
RichEditWithLinks1.SelAttributes.Style :=RichEditWithLinks1.SelAttributes.Style + [fsBold];
RichEditWithLinks1.SetFocus;
redodone:=True; 
end;

procedure TForm1Tree.BitBtn2Click(Sender: TObject);
begin
// ������
        RichEditWithLinks1.SetFocus;
        if fsItalic in RichEditWithLinks1.SelAttributes.Style then
        RichEditWithLinks1.SelAttributes.Style :=RichEditWithLinks1.SelAttributes.Style - [fsItalic] else
        RichEditWithLinks1.SelAttributes.Style :=RichEditWithLinks1.SelAttributes.Style + [fsItalic];
        RichEditWithLinks1.SetFocus;
end;

procedure TForm1Tree.BitBtn3Click(Sender: TObject);
begin
// ������������
      RichEditWithLinks1.SetFocus;
      if fsUnderline in RichEditWithLinks1.SelAttributes.Style then
      RichEditWithLinks1.SelAttributes.Style :=RichEditWithLinks1.SelAttributes.Style-[fsUnderline] else
      RichEditWithLinks1.SelAttributes.Style :=RichEditWithLinks1.SelAttributes.Style+[fsUnderline];
      RichEditWithLinks1.SetFocus;
end;

procedure TForm1Tree.CompactBase1Click(Sender: TObject);
//������ ����
Var  password:string;
  TempName : Array[0..MAX_PATH] of Char; // ��� ���������� �����
  TempPath : String; // ����
  Name : String;
  tmpDAO : _DBEngine;
  ClassID : TGUID;
  //V35,
  V36 : String; // ������ DAO
Begin
  Password:='';
  TreeCompanies.Enabled :=False;
  qTreeCompanies.Close;
  ADOConnection1.Close;
//  V35:='DAO.DBEngine.35';
  V36:='DAO.DBEngine.36';
  try // ������� ClassID
    try
      ClassID := ProgIDToClassID(v36);
    except
      try
//        ClassID := ProgIDToClassID(v36);
      except
        raise; // ��� �� ��� �����������
      end;
    end;
    // �������� ���� ��� ���������� �����
    TempPath:=ExtractFilePath(DatabaseName);
    if TempPath='' Then TempPath:=GetCurrentDir;
    //�������� ��� ���������� �����
    GetTempFileName(PChar(TempPath),'mdb',0,TempName);
    Name:=StrPas(TempName);
    DeleteFile(PChar(Name));// ����� ����� �� ������ ������������ :))
    if Password <> '' Then Password:=';pwd='+Password;
    tmpDAO := CreateComObject(ClassID) as _DBEngine;
//    tmpDAO.FreeLocks;
    tmpDAO.CompactDatabase(DatabaseName,Name,0,0,Password);
    DeleteFile(PChar(DatabaseName)); // ������� �� ����������� ����
    RenameFile(Name,DatabaseName); // ��������������� ����������� ����
    ShowMessage('�������� ���� ���������');
  except
    // ������ ��������� �� �������������� ��������
    on E: Exception do ShowMessage(e.message);
  end;
  MyConnect(Sender);
  qTreeCompanies.Open;
  TreeCompanies.Enabled :=True;
end;

procedure TForm1Tree.Edit1Locate(Sender: TObject);
begin
  //  ����� �� ������� !!!!!!!!!!!!!!!!!!!!!
  if length(Edit1.Text) > 0 then
  begin
  qTreeCompanies.Filtered:=true;
  qTreeCompanies.Filter:='( Name '+' LIKE ''%'+Edit1.Text+'%'' ) OR ( Text '+' LIKE ''%'+Edit1.Text+'%'' )';
  end
  else
  begin
  qTreeCompanies.Filtered:=False;
  qTreeCompanies.Filter:='';
  end;
end;

end.
