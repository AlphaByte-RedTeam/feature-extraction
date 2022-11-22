unit featureextractionform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnLoad1: TButton;
    btnLoad2: TButton;
    btnEktraksi: TButton;
    btnScan1: TButton;
    btnScan2: TButton;
    imgSrc12: TImage;
    imgSrc11: TImage;
    ListBox1: TListBox;
    ListBox2: TListBox;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenPictureDialog2: TOpenPictureDialog;
    procedure btnLoad1Click(Sender: TObject);
    procedure btnLoad2Click(Sender: TObject);
    procedure btnScan1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
uses
  windows;

var
   bitmapR1, bitmapG1, bitmapB1, BitmapGray1, BitmapBiner1 : array[0..1000, 0..1000] of integer;
   bitmapR2, bitmapG2, bitmapB2, BitmapGray2, BitmapBiner2 : array[0..1000, 0..1000] of integer;

procedure TForm1.btnLoad1Click(Sender: TObject);
var
  i, j, R, G, B, gray : integer;
begin
  if (OpenPictureDialog1.Execute) then
  begin
    imgSrc1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
  for j:=0 to imgSrc1.Height-1 do
  begin
    for i:=0 to imgSrc1.Width-1 do
    begin
      //mengambil nilai RGB
      R := GetRValue(imgSrc1.Canvas.Pixels[i,j]);
      G := GetGValue(imgSrc1.Canvas.Pixels[i,j]);
      B := GetBValue(imgSrc1.Canvas.Pixels[i,j]);
      gray := (R + G + B) div 3;
      bitmapR1[i,j] := R;
      bitmapG1[i,j] := G;
      bitmapB1[i,j] := B;
      bitmapGray1[i,j] := gray;
      if gray>127 then
        BitmapBiner1[i,j] := 1
      else
        BitmapBiner1[i,j] := 0;
    end;
  end;
end;

procedure TForm1.btnLoad2Click(Sender: TObject);
var
  i, j, R, G, B, gray : integer;
begin
  if (OpenPictureDialog2.Execute) then
  begin
    imgSrc2.Picture.LoadFromFile(OpenPictureDialog2.FileName);
  end;
  for j:=0 to imgSrc2.Height-1 do
  begin
    for i:=0 to imgSrc2.Width-1 do
    begin
      //mengambil nilai RGB
      R := GetRValue(imgSrc2.Canvas.Pixels[i,j]);
      G := GetGValue(imgSrc2.Canvas.Pixels[i,j]);
      B := GetBValue(imgSrc2.Canvas.Pixels[i,j]);
      gray := (R + G + B) div 3;
      bitmapR2[i,j] := R;
      bitmapG2[i,j] := G;
      bitmapB2[i,j] := B;
      bitmapGray2[i,j] := gray;
      if gray>127 then
        BitmapBiner2[i,j] := 1
      else
        BitmapBiner2[i,j] := 0;
    end;
  end;
end;

procedure TForm1.btnScan1Click(Sender: TObject);
var
  x, y : integer;
  tepi_atas_x, tepi_atas_y : integer;
  tepi_bawah_x, tepi_bawah_y : integer;
  tepi_kiri_x, tepi_kiri_y : integer;
  tepi_kanan_x, tepi_kanan_y : integer;

begin
// tepi atas
  for y := 0 to imgSrc1.Height-1 do
  begin
    for x := 0 to imgSrc1.Width-1 do
    begin
      if(BitmapBiner1[x,y] = 0) then
      begin
        tepi_atas_x  := x;
        tepi_atas_y := y;
        break;
      end;
    end;
     if(BitmapBiner1[x,y] = 0) then
     begin
       break;
     end;
  end;

// tepi bawah
    for y := imgSrc1.Height-1 to 0  do
    begin
      for x := 0 to imgSrc1.Width-1 do
      begin
        if(BitmapBiner1[x,y] = 0) then
        begin
          tepi_bawah_x := x;
          tepi_bawah_y := y;
          break;
        end;
      end;
      if(BitmapBiner1[x,y] = 0) then
      begin
        break;
      end;
    end;

// tepi kiri
    for x := 0 to imgSrc1.Width-1  do
        begin
          for y := 0 to imgSrc1.Height-1 do
          begin
            if(BitmapBiner1[x,y] = 0) then
            begin
              tepi_kiri_x := x;
              tepi_kiri_y := y;
              break;
            end;
          end;
          if(BitmapBiner1[x,y] = 0) then
          begin
            break;
          end;
        end;

// tepi kanan
       for x := imgSrc1.Width-1 to 0 do
        begin
          for y := 0 to imgSrc1.Height-1 do
          begin
            if(BitmapBiner1[x,y] = 0) then
            begin
              tepi_kanan_x := x;
              tepi_kanan_y := y;
              break;
            end;
          end;
          if(BitmapBiner1[x,y] = 0) then
          begin
            break;
          end;
        end;
end;

end.
