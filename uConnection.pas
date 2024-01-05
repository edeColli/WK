unit uConnection;

interface

uses
  System.Classes, IniFiles, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet,FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.ODBC, FireDAC.Phys.ODBCDef,
  FireDAC.Comp.UI, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TConnectionModule = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
  private
    FConnection: TFDConnection;
    { Private declarations }
    procedure LoadDatabaseConfig;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    property Connection: TFDConnection read FConnection;
  end;

var
  ConnectionModule: TConnectionModule;

implementation

uses
  System.SysUtils, Vcl.Forms, Vcl.Dialogs;

{$R *.dfm}

destructor TConnectionModule.Destroy;
begin
  FConnection.Free;
  inherited;
end;

procedure TConnectionModule.LoadDatabaseConfig;
  var
  IniFile: TIniFile;
  sDataBase: string;
begin
  FConnection.Params.Clear;
  FConnection.Params.Add('DriverID=MySQL');

  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Conexao.ini');
  try
    sDataBase := IniFile.ReadString('MySQL', 'Database', '');
    FConnection.Params.Add('Database=' + IniFile.ReadString('MySQL', 'Database', ''));
    FConnection.Params.Add('User_Name=' + IniFile.ReadString('MySQL', 'Username', 'root'));
    FConnection.Params.Add('Password=' + IniFile.ReadString('MySQL', 'Password', 'mysql'));
    FConnection.Params.Add('Server=' + IniFile.ReadString('MySQL', 'Server', 'localhost'));
    FConnection.Params.Add('Port=' + IniFile.ReadString('MySQL', 'Port', '3306'));

    FDPhysMySQLDriverLink1.VendorLib := ExtractFilePath(Application.ExeName) + 'libmysql.dll';
  finally
    IniFile.Free;
  end;
end;

constructor TConnectionModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnection := TFDConnection.Create(nil);
  LoadDatabaseConfig;
  FConnection.Connected := True;
end;

end.

