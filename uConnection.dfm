object ConnectionModule: TConnectionModule
  OldCreateOrder = True
  Height = 239
  Width = 408
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=wk'
      'User_Name=root'
      'Password=mysql'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 152
    Top = 80
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'D:\Projetos\WK_Teste\libmysql.dll'
    Left = 280
    Top = 80
  end
end
