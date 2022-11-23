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
    btnKemiripan: TButton;
    imgSrc1_cut: TImage;
    imgSrc2_cut: TImage;
    imgSrc2: TImage;
    imgSrc1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenPictureDialog2: TOpenPictureDialog;
    procedure btnEktraksiClick(Sender: TObject);
    procedure btnLoad1Click(Sender: TObject);
    procedure btnLoad2Click(Sender: TObject);
    procedure btnScan1Click(Sender: TObject);
    procedure btnScan2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
uses
  Windows, math;

var
  bitmapR1, bitmapG1, bitmapB1, BitmapGray1, BitmapBiner1: array[0..1000, 0..1000] of
  integer;
  bitmapR2, bitmapG2, bitmapB2, BitmapGray2, BitmapBiner2: array[0..1000, 0..1000] of
  integer;

  BitmapBiner1_cut: array[0..1000, 0..1000] of integer;
  BitmapBiner2_cut: array[0..1000, 0..1000] of integer;

  feature1 : array[1..5, 1..5] of integer;
  feature2 : array[1..5, 1..5] of integer;
procedure TForm1.btnLoad1Click(Sender: TObject);
var
  i, j, R, G, B, gray: integer;
begin
  if (OpenPictureDialog1.Execute) then
  begin
    imgSrc1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
  for j := 0 to imgSrc1.Height - 1 do
  begin
    for i := 0 to imgSrc1.Width - 1 do
    begin
      //mengambil nilai RGB
      R := GetRValue(imgSrc1.Canvas.Pixels[i, j]);
      G := GetGValue(imgSrc1.Canvas.Pixels[i, j]);
      B := GetBValue(imgSrc1.Canvas.Pixels[i, j]);
      gray := (R + G + B) div 3;
      bitmapR1[i, j] := R;
      bitmapG1[i, j] := G;
      bitmapB1[i, j] := B;
      bitmapGray1[i, j] := gray;
      if gray > 127 then
        BitmapBiner1[i, j] := 1
      else
        BitmapBiner1[i, j] := 0;
    end;
  end;
end;

procedure TForm1.btnEktraksiClick(Sender: TObject);
var
  x, y : integer;
  i, j : integer;

  //variabel untuk proses ekstraksi gambar pertama
  feature_number1 : integer;
  cell_width1, cell_height1 : integer;
  left_most_cell_1, right_most_cell_1 : integer;
  top_most_cell_1, bottom_most_cell_1 : integer;
  total_cells_in_1_feature1 : integer;

  //variabel untuk proses ekstraksi gambar kedua (cuma beda angka 1 dan 2)
  feature_number2 : integer;
  cell_width2, cell_height2 : integer;
  left_most_cell_2, right_most_cell_2 : integer;
  top_most_cell_2, bottom_most_cell_2 : integer;
  total_cells_in_1_feature2 : integer;

begin
// ***************************GAMBAR PERTAMA************************************

  // menentukan lebar dan tinggi setiap cell setelah TImage dibagi menjadi matriks 5x5
  cell_width1  := ceil(imgSrc1_cut.width / 5) - 1;
  cell_height1 := ceil(imgSrc1_cut.Height / 5) - 1;

  // menentukan posisi paling kiri dan posisi paling kanan pixel dalam suatu daerah fitur
  left_most_cell_1  := 0;
  right_most_cell_1 := 0;

  // menentukan posisi paling atas dan posisi paling bawah dalam suatu daerahfitur
  top_most_cell_1   := 0;
  bottom_most_cell_1 := 0;

  for j := 1 to 5 do
  begin
    left_most_cell_1  := 0;
    right_most_cell_1 := 0;
    for i := 1 to 5 do
    begin
      for y := (top_most_cell_1) to (cell_height1 + bottom_most_cell_1) do
      begin
        for x := (left_most_cell_1) to (cell_width1 + right_most_cell_1) do
        begin
          if(BitmapBiner1_cut[x,y] = 0) then
            feature1[i,j] += 1
        end;
      end;
      left_most_cell_1  += cell_width1;
      right_most_cell_1 += cell_width1;
    end;
    top_most_cell_1    += cell_height1;
    bottom_most_cell_1 += cell_height1;
  end;

  feature_number1 += 1;
  total_cells_in_1_feature1 := (cell_width1 + 1) * (cell_height1 + 1);
  for y := 1 to 5 do
  begin
    for x := 1 to 5 do
    begin
      ListBox1.Items.Add('Fitur ' + IntToStr(feature_number1) + ' : ' + IntToStr(round((feature1[x,y] /total_cells_in_1_feature1)*100)) + '%');
      feature_number1 += 1;
    end;
  end;

  //-----------------------------------------------------------------------------------------------------------------------------------------------//

  // ********************GAMBAR KEDUA*******************************************

    // menentukan lebar dan tinggi setiap cell setelah TImage dibagi menjadi matriks 5x5
    cell_width2  := ceil(imgSrc2_cut.width / 5) - 1;
    cell_height2 := ceil(imgSrc2_cut.Height / 5) - 1;

    // menentukan posisi paling kiri dan posisi paling kanan pixel dalam suatu daerah fitur
    left_most_cell_2  := 0;
    right_most_cell_2 := 0;

    // menentukan posisi paling atas dan posisi paling bawah dalam suatu daerahfitur
    top_most_cell_2   := 0;
    bottom_most_cell_2 := 0;

    for j := 1 to 5 do
    begin
      left_most_cell_2  := 0;
      right_most_cell_2 := 0;
      for i := 1 to 5 do
      begin
        for y := (top_most_cell_2) to (cell_height2 + bottom_most_cell_2) do
        begin
          for x := (left_most_cell_2) to (cell_width2 + right_most_cell_2) do
          begin
            if(BitmapBiner2_cut[x,y] = 0) then
              feature2[i,j] += 1
          end;
        end;
        left_most_cell_2  += cell_width2;
        right_most_cell_2 += cell_width2;
      end;
      top_most_cell_2    += cell_height2;
      bottom_most_cell_2 += cell_height2;
    end;

    feature_number2 += 1;
    total_cells_in_1_feature2 := (cell_width2 + 1) * (cell_height2 + 1);
    for y := 1 to 5 do
    begin
      for x := 1 to 5 do
      begin
        ListBox2.Items.Add('Fitur ' + IntToStr(feature_number2) + ' : ' + IntToStr(round((feature2[x,y] /total_cells_in_1_feature2)*100)) + '%');
        feature_number2 += 1;
      end;
    end;
end;

procedure TForm1.btnLoad2Click(Sender: TObject);
var
  i, j, R, G, B, gray: integer;
begin
  if (OpenPictureDialog2.Execute) then
  begin
    imgSrc2.Picture.LoadFromFile(OpenPictureDialog2.FileName);
  end;
  for j := 0 to imgSrc2.Height - 1 do
  begin
    for i := 0 to imgSrc2.Width - 1 do
    begin
      //mengambil nilai RGB
      R := GetRValue(imgSrc2.Canvas.Pixels[i, j]);
      G := GetGValue(imgSrc2.Canvas.Pixels[i, j]);
      B := GetBValue(imgSrc2.Canvas.Pixels[i, j]);
      gray := (R + G + B) div 3;
      bitmapR2[i, j] := R;
      bitmapG2[i, j] := G;
      bitmapB2[i, j] := B;
      bitmapGray2[i, j] := gray;
      if gray > 127 then
        BitmapBiner2[i, j] := 1
      else
        BitmapBiner2[i, j] := 0;
    end;
  end;
end;

procedure TForm1.btnScan1Click(Sender: TObject);
var
  x, y: integer;
  i, j: integer;
  tepi_atas_y: integer;
  tepi_bawah_y: integer;
  tepi_kiri_x: integer;
  tepi_kanan_x: integer;

begin
  // mengambil nilai tepi atas
  for y := 0 to imgSrc1.Height - 1 do
  begin
    for x := 0 to imgSrc1.Width - 1 do
    begin
      if (BitmapBiner1[x, y] = 0) then
      begin
        tepi_atas_y := y;
        break;
      end;
    end;
    if (BitmapBiner1[x, y] = 0) then
    begin
      break;
    end;
  end;

  // mengambil nilai tepi bawah
  for y := imgSrc1.Height - 1 downto 0 do
  begin
    for x := 0 to imgSrc1.Width - 1 do
    begin
      if (BitmapBiner1[x, y] = 0) then
      begin
        tepi_bawah_y := y;
        break;
      end;
    end;
    if (BitmapBiner1[x, y] = 0) then
    begin
      break;
    end;
  end;

  // mengambil nilai tepi kiri
  for x := 0 to imgSrc1.Width - 1 do
  begin
    for y := 0 to imgSrc1.Height - 1 do
    begin
      if (BitmapBiner1[x, y] = 0) then
      begin
        tepi_kiri_x := x;
        break;
      end;
    end;
    if (BitmapBiner1[x, y] = 0) then
    begin
      break;
    end;
  end;

  // mengambil nilai tepi kanan
  for x := imgSrc1.Width - 1 downto 0 do
  begin
    for y := 0 to imgSrc1.Height - 1 do
    begin
      if (BitmapBiner1[x, y] = 0) then
      begin
        tepi_kanan_x := x;
        break;
      end;
    end;
    if (BitmapBiner1[x, y] = 0) then
    begin
      break;
    end;
  end;

  // mengambil nilai bitmap daerah yang dipotong
  for j := tepi_atas_y to tepi_bawah_y do
  begin
    for i := tepi_kiri_x to tepi_kanan_x do
    begin
      BitmapBiner1_cut[i - tepi_kiri_x, j - tepi_atas_y] := BitmapBiner1[i, j];
    end;
  end;

  // mengatur tinggi dan lebar gambar setelah dipotong
  imgSrc1_cut.Width := tepi_kanan_x - tepi_kiri_x;
  imgSrc1_cut.Height := tepi_bawah_y - tepi_atas_y;

  //menampilkan pixel ke gambar setelah dipotong
  for y := 0 to imgSrc1_cut.Height do
  begin
    for x := 0 to imgSrc1_cut.Width do
    begin
      if (BitmapBiner1_cut[x, y] = 0) then
        imgSrc1_cut.Canvas.Pixels[x, y] := RGB(0, 0, 0)
      else
        imgSrc1_cut.Canvas.Pixels[x, y] := RGB(255, 255, 255);
    end;
  end;
end;

procedure TForm1.btnScan2Click(Sender: TObject);
var
  x, y: integer;
  i, j: integer;
  tepi_atas_y: integer;
  tepi_bawah_y: integer;
  tepi_kiri_x: integer;
  tepi_kanan_x: integer;

begin

  // mengambil nilai tepi atas
  for y := 0 to imgSrc2.Height - 1 do
  begin
    for x := 0 to imgSrc2.Width - 1 do
    begin
      if (BitmapBiner2[x, y] = 0) then
      begin
        tepi_atas_y := y;
        break;
      end;
    end;
    if (BitmapBiner2[x, y] = 0) then
    begin
      break;
    end;
  end;

  // mengambil nilai tepi bawah
  for y := imgSrc2.Height - 1 downto 0 do
  begin
    for x := 0 to imgSrc2.Width - 1 do
    begin
      if (BitmapBiner2[x, y] = 0) then
      begin
        tepi_bawah_y := y;
        break;
      end;
    end;
    if (BitmapBiner2[x, y] = 0) then
    begin
      break;
    end;
  end;

  // mengambil nilai tepi kiri
  for x := 0 to imgSrc2.Width - 1 do
  begin
    for y := 0 to imgSrc2.Height - 1 do
    begin
      if (BitmapBiner2[x, y] = 0) then
      begin
        tepi_kiri_x := x;
        break;
      end;
    end;
    if (BitmapBiner2[x, y] = 0) then
    begin
      break;
    end;
  end;

  // mengambil nilai tepi kanan
  for x := imgSrc2.Width - 1 downto 0 do
  begin
    for y := 0 to imgSrc2.Height - 1 do
    begin
      if (BitmapBiner2[x, y] = 0) then
      begin
        tepi_kanan_x := x;
        break;
      end;
    end;
    if (BitmapBiner2[x, y] = 0) then
    begin
      break;
    end;
  end;

  // mengambil nilai bitmap daerah yang dipotong
  for j := tepi_atas_y to tepi_bawah_y do
  begin
    for i := tepi_kiri_x to tepi_kanan_x do
    begin
      BitmapBiner2_cut[i - tepi_kiri_x, j - tepi_atas_y] := BitmapBiner2[i, j];
    end;
  end;

  // mengatur tinggi dan lebar gambar setelah dipotong
  imgSrc2_cut.Width := tepi_kanan_x - tepi_kiri_x;
  imgSrc2_cut.Height := tepi_bawah_y - tepi_atas_y;

  //menampilkan pixel ke gambar setelah dipotong
  for y := 0 to imgSrc2_cut.Height do
  begin
    for x := 0 to imgSrc2_cut.Width do
    begin
      if (BitmapBiner2_cut[x, y] = 0) then
        imgSrc2_cut.Canvas.Pixels[x, y] := RGB(0, 0, 0)
      else
        imgSrc2_cut.Canvas.Pixels[x, y] := RGB(255, 255, 255);
    end;
  end;
end;

end.
