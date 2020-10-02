require 'prawn/labels'
require 'CSV'
require 'pathname'

def roundy_text_box(pdf, text, left:, top:,
                    box_width:, box_height:, box_colour:, opacity:,
                    text_height:, text_colour:)
  pdf.transparent(opacity) do
    pdf.fill_color box_colour
    pdf.rounded_rectangle [left, top], box_width, box_height, 5
    pdf.fill
  end
  pdf.fill_color text_colour
  pdf.text_box text,
               at: [left + 5, top - 5], width: box_width - 10,
               height: text_height,
               size: 20, overflow: :shrink_to_fit, align: :center
end

rockers = CSV.parse(File.read('ttrockers.csv'), headers: true)
stats = CSV.parse(File.read('ttstatus.csv'), headers: true)
stats.each do |stat|
  rocker = rockers.find { |r| r['Our ID for this user'] == stat['Id'] }
  rocker['Baseline'] = stat['Baseline'] # Can I add a field? Yes.
end

Prawn::Labels.types = './types.yaml'
label_type = 'YourPrice08'
Prawn::Labels.generate("#{__FILE__.split('.')[0]}.pdf", rockers, type: label_type) do |pdf, rocker|

  # Background hexagon
  pdf.fill_color '732c0b'
  pdf.fill_polygon [0, 95], [45, 190], [235, 190], [280, 95], [235, 0], [45, 0]

  # Avatar image
  avatar_fn = "#{rocker['First name REQUIRED']}_#{rocker['Last name REQUIRED']}.png"
  avatar_pn = Pathname.new("./ttrockavatars/#{avatar_fn}")
  if avatar_pn.exist?
  pdf.image avatar_pn, at: [45,190], height: 190
  end

  # Name box
  name = "#{rocker['First name REQUIRED']} #{rocker['Last name REQUIRED']}"
  roundy_text_box pdf, name, left: 60, top: 65,
                  box_width: 160, box_height: 20, box_colour: 'a1c5ff',
                  text_height: 15, text_colour: 'ffffff',
                  opacity: 0.6

  # Is box
  pdf.rotate(20, origin: [210, 50]) do
    roundy_text_box pdf, 'IS', left: 210, top: 50,
                    box_width: 50, box_height: 25, box_colour: 'f4ffa3',
                    text_height: 20, text_colour: 'ff7e2e',
                    opacity: 1
  end

  # Rock name box
  roundy_text_box pdf, rocker['Rock Name'].to_s,
                  left: 50, top: 40,
                  box_width: 180, box_height: 30, box_colour: 'ff7e2e',
                  text_height: 25, text_colour: 'f4ffa3',
                  opacity: 0.9
  # Was box
  roundy_text_box pdf, 'Was',
                  left: 20, top: 110,
                  box_width: 50, box_height: 40, box_colour: 'ffffff',
                  text_height: 8, text_colour: '000000',
                  opacity: 0.8

  # Was number (in a box on top)
  roundy_text_box pdf, rocker['Baseline'],
                  left: 30, top: 95,
                  box_width: 30, box_height: 20, box_colour: 'ffffff',
                  text_height: 10, text_colour: '000000',
                  opacity: 1

  # Now box
  roundy_text_box pdf, 'Now',
                  left: 190, top: 120,
                  box_width: 70, box_height: 50, box_colour: 'ffffff',
                  text_height: 10, text_colour: '06cf1a',
                  opacity: 1

  # pdf.stroke_axis step_length: 20, negative_axes_length: 0
end
