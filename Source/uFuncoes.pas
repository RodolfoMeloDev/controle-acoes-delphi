unit uFuncoes;

interface

uses
  System.SysUtils;

type
  TFuncoes = class
  public
    class function RetornaLetrasAcao(psAcao: String): String;
    class function RetornaCodigoAcao(psAcao: String): String;
  end;

implementation

class function TFuncoes.RetornaCodigoAcao(psAcao: String): String;
var
  var_I: Integer;
  nCodigoAcao: Integer;
begin
  for var_I := 1 to Length(psAcao) do
  begin
    if TryStrToInt(psAcao[var_I], nCodigoAcao) then
      Result := Copy(psAcao, var_I, Length(psAcao));
  end;
end;

class function TFuncoes.RetornaLetrasAcao(psAcao: String): String;
var
  var_I: Integer;
  nCodigoAcao: Integer;
begin
  Result := '';
  for var_I := 1 to Length(psAcao) do
  begin
    if not TryStrToInt(psAcao[var_I], nCodigoAcao) then
      Result := Result + psAcao[var_I]
    else
      break;
  end;
end;

end.
