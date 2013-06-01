unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, IntervalArithmetic, ComCtrls, Math, ExtCtrls,
  Choleski;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    RichEdit1: TRichEdit;
    StringGrid1: TStringGrid;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
  
  public

  end;
  
  procedure setStringGrid(edit: TEdit; StringGrid1: TStringGrid);
  
var
  Form1: TForm1;
  n: Integer;
  intervalA, intervalB: interval;
  res: interval;
  strA, strB: String;
  MA: matrix;
  MB, MX: vector;
  MA_ia: matrix_ia;
  MB_ia, MX_ia: vector_ia;
  st: Integer;
  mode: Integer;

implementation

{$R *.dfm}

// mode 1 - Real
// mode 2 - IntAr 1
// mode 3 - IntAr 2
procedure TForm1.Button1Click(Sender: TObject);
var
  i,j: Integer;
  st: Integer;
  str,tmpl,tmpr: String;
  errno: Integer;
begin
  RichEdit1.Clear;
  RichEdit1.Lines.Add('Tutaj bêdzie wynik.');
  try
    begin
    for i:=1 to n do begin
      for j:=1 to n do begin
        if mode=1 then
          val(StringGrid1.Cells[i,j],MA[i,j],errno)
        else if mode=2 then
          MA_ia[i,j]:=int_read(StringGrid1.Cells[i,j])
        else begin
          MA_ia[i,j].a:=left_read(StringGrid1.Cells[2*i-1,j]);
          MA_ia[i,j].b:=right_read(StringGrid1.Cells[2*i,j]);
        end;
      end;
    end;

    for i:=1 to n do begin
      if mode=1 then
        val(StringGrid1.Cells[n+1,i],MB[i],errno)
      else if mode=2 then
        MB_ia[i]:=int_read(StringGrid1.Cells[n+1,i])
      else begin
        MB_ia[i].a:=left_read(StringGrid1.Cells[2*n+1,i]);
        MB_ia[i].b:=right_read(StringGrid1.Cells[2*n+2,i]);
      end;
    end;

    if errno<>0 then
      raise Exception.Create('4');

    RichEdit1.Clear;
    RichEdit1.Lines.Add('Wprowadzono nastêpuj¹ce równania:');
    RichEdit1.Lines.Add('');

    for i:=1 to n do begin
      for j:=1 to n do begin
        if j>1 then begin
          if mode=1 then
            if MA[i,j]>=0 then
              str:=str+' + '+FloatToStrF(MA[i,j],ffExponent,17,4)+'x'+IntToStr(j)
            else
              str:=str+' - '+FloatToStrF(abs(MA[i,j]),ffExponent,17,4)+'x'+IntToStr(j)
          else begin
              iends_to_strings(MA_ia[i,j],tmpl,tmpr);
              str:=str+' + ['+tmpl+','+tmpr+']x'+IntToStr(j);
          end;
        end
        else begin
          if mode=1 then
            str:=FloatToStrF(MA[i,j],ffExponent,17,4)+'x1'
          else begin
            iends_to_strings(MA_ia[i,j],tmpl,tmpr);
            str:='['+tmpl+','+tmpr+']x'+IntToStr(j);
          end;
        end;
      end;

      if mode=1 then
        str:=str+' = '+FloatToStrF(MB[i],ffExponent,17,4)
      else begin
        iends_to_strings(MB_ia[i],tmpl,tmpr);
        str:=str+' = ['+tmpl+','+tmpr+']';
      end;
      RichEdit1.Lines.Add(str);
    end;

    if mode=1 then
      Choleski.symposmatrix(n, MA, MB, MX, st)
    else
      Choleski.symposmatrix_ia(n, MA_ia, MB_ia, MX_ia, st);

    if st=0 then begin
      RichEdit1.Lines.Add('');
      RichEdit1.Lines.Add('Otrzymano rozwi¹zanie:');
      RichEdit1.Lines.Add('');

      for i:=1 to n do begin
        if mode=1 then
          RichEdit1.Lines.Add('x'+IntToStr(i)+' = '+FloatToStrF(MX[i],ffExponent,17,4))
        else begin
          iends_to_strings(MX_ia[i],tmpl,tmpr);
          RichEdit1.Lines.Add('x'+IntToStr(i)+' = ['+tmpl+','+tmpr+']')
        end;
      end;
    end
    else if st=1 then
      raise Exception.Create('1')
    else if st=2 then
      raise Exception.Create('2')
    else if st=3 then
      raise Exception.Create('3')
  end
  except
    on EConvertError do begin
      RichEdit1.Clear;
      RichEdit1.Lines.Add('B³¹d: macierz nie jest wypelniona liczbami.');
    end;
    on E: Exception do begin
      RichEdit1.Clear;
      if E.message='1' then
        RichEdit1.Lines.Add('B³¹d: n<1.')
      else if E.Message='2' then
        RichEdit1.Lines.Add('B³¹d: macierz nie jest symetryczna.')
      else if E.Message='3' then
        RichEdit1.Lines.Add('B³¹d: macierz nie jest dodatnio okreœlona.')
      else if E.Message='4' then
        RichEdit1.Lines.Add('B³¹d: macierz nie jest wypelniona liczbami.');
    end
    else begin
      RichEdit1.Clear;
      RichEdit1.Lines.Add('B³¹d: podczas obliczeñ wyst¹pi³ nieznany b³¹d.');
    end
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  mode := 1;
  setStringGrid(Edit1, StringGrid1);
  RichEdit1.Clear;
  RichEdit1.Lines.Add('Tutaj bêdzie wynik.');
end;

procedure setStringGrid(edit: TEdit; StringGrid1: TStringGrid);
var
  i: Integer;
begin
  TryStrToInt(edit.Text, n);
  if mode=1 then begin
    finalize(MA);
    finalize(MB);
    finalize(MX);
    SetLength(MA, n+1, n+1);
    SetLength(MB, n+1);
    SetLength(MX, n+1);
    StringGrid1.ColCount:=n+2;
    StringGrid1.RowCount:=n+1;
    for i:=1 to n do begin
      StringGrid1.Cells[i,0]:='x'+IntToStr(i);
      StringGrid1.Cells[0,i]:='rownanie '+IntToStr(i);
      StringGrid1.ColWidths[i]:=64;
    end;
    StringGrid1.Cells[n+1,0]:='b';
    StringGrid1.ColWidths[n+1]:=64;
    {
    // hard codowane wartosci poczatkowe
    StringGrid1.Cells[1,1]:='3';
    StringGrid1.Cells[1,2]:='1';
    StringGrid1.Cells[1,3]:='0';
    StringGrid1.Cells[2,1]:='1';
    StringGrid1.Cells[2,2]:='2';
    StringGrid1.Cells[2,3]:='-1';
    StringGrid1.Cells[3,1]:='0';
    StringGrid1.Cells[3,2]:='-1';
    StringGrid1.Cells[3,3]:='3';
    StringGrid1.Cells[4,1]:='0';
    StringGrid1.Cells[4,2]:='1';
    StringGrid1.Cells[4,3]:='0';
    }
  end
  else if mode=2 then begin
    finalize(MA_ia);
    finalize(MB_ia);
    finalize(MX_ia);
    SetLength(MA_ia, n+1, n+1);
    SetLength(MB_ia, n+1);
    SetLength(MX_ia, n+1);
    StringGrid1.ColCount:=n+2;
    StringGrid1.RowCount:=n+1;
    for i:=1 to n do begin
      StringGrid1.Cells[i,0]:='[x'+IntToStr(i)+',x'+IntToStr(i)+']';
      StringGrid1.Cells[0,i]:='rownanie '+IntToStr(i);
      StringGrid1.ColWidths[i]:=64;
    end;
    StringGrid1.Cells[n+1,0]:='[b,b]';
    StringGrid1.ColWidths[n+1]:=64;
    {
    // hard codowane wartosci poczatkowe
    StringGrid1.Cells[1,1]:='3';
    StringGrid1.Cells[1,2]:='1';
    StringGrid1.Cells[1,3]:='0';
    StringGrid1.Cells[2,1]:='1';
    StringGrid1.Cells[2,2]:='2';
    StringGrid1.Cells[2,3]:='-1';
    StringGrid1.Cells[3,1]:='0';
    StringGrid1.Cells[3,2]:='-1';
    StringGrid1.Cells[3,3]:='3';
    StringGrid1.Cells[4,1]:='0';
    StringGrid1.Cells[4,2]:='1';
    StringGrid1.Cells[4,3]:='0';
    }
  end
  else begin
    finalize(MA_ia);
    finalize(MB_ia);
    finalize(MX_ia);
    SetLength(MA_ia, n+1, n+1);
    SetLength(MB_ia, n+1);
    SetLength(MX_ia, n+1);
    StringGrid1.ColCount:=2*n+3;
    StringGrid1.RowCount:=n+1;
    for i:=1 to n do begin
      StringGrid1.Cells[2*i-1,0]:='[x'+IntToStr(i);
      StringGrid1.ColWidths[2*i-1]:=31;
      StringGrid1.Cells[2*i,0]:='x'+IntToStr(i)+']';
      StringGrid1.ColWidths[2*i]:=31;
      StringGrid1.Cells[0,i]:='rownanie '+IntToStr(i);
    end;
    StringGrid1.Cells[2*n+1,0]:='[b';
    StringGrid1.Cells[2*n+2,0]:='b]';
    StringGrid1.ColWidths[2*n+1]:=31;
    StringGrid1.ColWidths[2*n+2]:=31;
    {
    StringGrid1.ColWidths[2*n+1]:=31;
    StringGrid1.ColWidths[2*n+2]:=31;
    StringGrid1.Cells[1,1]:='3';
    StringGrid1.Cells[2,1]:='3';
    StringGrid1.Cells[3,1]:='1';
    StringGrid1.Cells[4,1]:='1';
    StringGrid1.Cells[5,1]:='0';
    StringGrid1.Cells[6,1]:='0';
    StringGrid1.Cells[1,2]:='1';
    StringGrid1.Cells[2,2]:='1';
    StringGrid1.Cells[3,2]:='2';
    StringGrid1.Cells[4,2]:='2';
    StringGrid1.Cells[5,2]:='-1';
    StringGrid1.Cells[6,2]:='-1';
    StringGrid1.Cells[1,3]:='0';
    StringGrid1.Cells[2,3]:='0';
    StringGrid1.Cells[3,3]:='-1';
    StringGrid1.Cells[4,3]:='-1';
    StringGrid1.Cells[5,3]:='3';
    StringGrid1.Cells[6,3]:='3';
    StringGrid1.Cells[7,1]:='0';
    StringGrid1.Cells[8,1]:='0';
    StringGrid1.Cells[7,2]:='1';
    StringGrid1.Cells[8,2]:='1';
    StringGrid1.Cells[7,3]:='0';
    StringGrid1.Cells[8,3]:='0';
    }
  end;
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
begin
  mode := 3;
  setStringGrid(Edit1, StringGrid1);
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  mode := 1;
  setStringGrid(Edit1, StringGrid1);
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  mode := 2;
  setStringGrid(Edit1, StringGrid1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  setStringGrid(Edit1, StringGrid1);
end;

end.
