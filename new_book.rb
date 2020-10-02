require 'prawn/labels'
require 'CSV'

names = CSV.parse(File.read("y6dales.txt"), col_sep: '\t', headers: true)
names.each {|name| puts "#{name['Firstname']}" }

Prawn::Labels.types = './types.yaml'
label_type = 'YourPrice21'

Prawn::Labels.generate("#{__FILE__.split('.')[0]}.pdf", names, type: label_type) do |pdf, name|
	pdf.image "H:/dev/labels/internet-3.png", at: [125,100]
	pdf.indent(8) do
		pdf.move_down 2
    pdf.font "Helvetica"
    pdf.text "#{name['Firstname']} #{name['Lastname']}", size: 18, position: :center
    pdf.move_down 5
    pdf.text "Computing", size: 14, leading: 5, inline_format: true
    pdf.text "#{name['Class']}", size: 12
    pdf.horizontal_rule
	end
end
