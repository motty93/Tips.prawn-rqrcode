require 'rqrcode'
require 'prawn'
require 'prawn/table'
require 'stringio'

class QrCodeInPdf < Prawn::Document
  CHARACTERS_PER_LINE_SHORT = 15
  CHARACTERS_PER_LINE_LONG = 25

  def initialize()
    super(
      page_size: 'A4',
      top_margin: 50.0,
      bottom_margin: 50.0,
      left_margin: 0,
      right_margin: 0
    )
    font 'font/SourceHanSans-Normal.ttc'
    font_size 10

    styles = {
      inline_format: true,
      min_font_size: 8,
      overflow: :shrink_to_fit,
      padding: [5, 5, 5, 10],
      border_width: 0
    }

    table_options = {
      :cell_style => styles,
      :width => 250,
      :column_widths => [160, 90]
    }

    qr_code = RQRCode::QRCode.new('https://shop.motty93.com')
    data = [
      [12345],
      [make_cell(content: "<font size='12'>お店の名前</font>"), make_cell(content: "5/22", align: :right)],
      [make_cell(content: "<br>商品の名前")],
      [make_cell(content: "商品詳細 (長さ)")],
      [make_cell(content: "<font size='12'>10</font>個", valign: :bottom), make_cell(image: StringIO.new(qr_code.as_png(size: 90).to_s), rowspan: 3)],
      [make_cell(content: "<font size='14'>配送業者の名前</font>", valign: :bottom)],
      [make_cell(content: "<font size='12'>配送先の住所はこちらになります</font>", valign: :top)]
    ]

    table(data, table_options)
  end
end

pdf = QrCodeInPdf.new
pdf.render_file 'test.pdf'
