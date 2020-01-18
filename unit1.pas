unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, SynHighlighterPas, SynPluginSyncroEdit,
   Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, EditBtn,
  ExtCtrls, LResources, Menus, ComCtrls, ActnList,
  DbCtrls, dos;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    PageControl1: TPageControl;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
     { if MessageDlg('Intro', 'Chào mừng đến với CI - Test Generator',
       mtConfirmation, [mbYes, mbCancel], 0) = mrCancel then
          begin
               Form1.Close;
          end;    }
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;


procedure TForm1.Button1Click(Sender: TObject);
var direct, taskname, codedir : string;
    inpfile, outfile : string;
    dir, inputdir, outputdir : string;
    checkfirst, checklast : string;
    firstindex, lastindex, id : integer;
    check : boolean;
begin
      direct := DirectoryEdit1.Text;
      codedir := FileNameEdit1.Text;
      taskname := Edit1.Text;
      checkfirst := Edit2.Text;
      checklast := Edit3.Text;
      inpfile := Edit4.Text;
      outfile := Edit5.Text;
      //********* End of Read Data *********//
      if (not DirectoryExists(direct)) and (direct <> '') then
         begin
              MessageDlg('Địa chỉ lưu Test không tồn tại nhoe!',
                              mtError, [mbok], 0);
              exit();
         end;
      if (not FileExists(codedir)) then
         begin
              MessageDlg('Không tồn tại file exe code mẫu!',
                                 mtError, [mbok], 0);
              exit();
         end;
      if (taskname = '') then
         begin
           MessageDlg('Bạn chưa nhập tên bài :(((',
                              mtError, [mbok], 0);
           exit();
         end;
      if (inpfile = '') then
         begin
           MessageDlg('Tên file input đâu òi :(',
                              mtError, [mbok], 0);
           exit();
         end;
      if (outfile = '') then
         begin
           MessageDlg('Tên file output đâu òi :(((',
                              mtError, [mbok], 0);
           exit();
         end;
      if (checkfirst = '') or (checklast = '') then
         begin
              MessageDlg('Ahuhu bạn quên nhập chỉ số test kìa',
                              mtError, [mbok], 0);
              exit();
         end;
      firstindex := StrToInt(Edit2.Text);
      lastindex := StrToInt(Edit3.Text);
      if (firstindex > lastindex) or (firstindex < 0) then
         begin
           ShowMessage('Mời bạn nhập lại chỉ số test - Buồn bạn quá:(');
           exit();
         end;
      //********* End of Check Data ********//

      check := true;
      direct := direct + '/' + taskname;
      CopyFile(codedir, taskname + '.exe');
      if (not DirectoryExists(direct)) then mkdir(direct);

      for id := firstindex to lastindex do
          begin
               dir := IntToStr(id);
               if (id < 10) then dir := '0' + dir;
               dir := direct + '/' + taskname + dir;
               inputdir := dir + '/' + inpfile;
               outputdir := dir + '/' + outfile;
               if (not DirectoryExists(dir)) then mkdir(dir);
               if (FileExists(inputdir)) then DeleteFile(inputdir);
               if (FileExists(outputdir)) then DeleteFile(outputdir);
               Exec('CodeSinhTest.exe', '');
               if (not FileExists(inpfile)) then
                  begin
                    MessageDlg('Tên file input bạn nhập không trùng với tên file input trong CodeSinhTest',
                              mtError, [mbok], 0);
                    check := false;
                    break;
                  end;
               Exec(taskname + '.exe', '');
               if (not FileExists(outfile)) then
                  begin
                    MessageDlg('Tên file output bạn nhập không trùng với tên file output trong code mẫu',
                              mtError, [mbok], 0);
                    check := false;
                    break;
                  end;
               CopyFile(inpfile, inputdir);
               CopyFile(outfile, outputdir);
          end;
      if (FileExists(inpfile)) then DeleteFile(inpfile);
      if (FileExists(outfile)) then DeleteFile(outfile);
      if (FileExists(taskname + '.exe')) then DeleteFile(taskname + '.exe');
      if (check = true) then MessageDlg('Hoàn thành', mtInformation, [mbok], 0);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
      DirectoryEdit1.Text := '';
      FileNameEdit1.Text := '';
      Edit1.Text := '';
      Edit2.Text := '';
      Edit3.Text := '';
      Edit4.Text := '';
      Edit5.Text := '';
end;



end.

