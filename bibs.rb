require 'prawn/labels'

class Bib <
	Struct.new(
		:name, # :other columns to ignore,
		:bibno
		)
end

bibs = Array.new

# open the file
fn = ARGV[0]
f = File.open("#{fn}.txt", "r")

# loop through each record in the file, adding each record to our array.
f.each_line { |line|
	fields = line.split("\t")
	bib = Bib.new

	bib.name = fields[0]
	bib.bibno = fields[1]
	bibs.push(bib)
}

label_type = 'YourPrice08'

Prawn::Labels.generate("#{fn}_#{__FILE__.split('.')[0]}.pdf", bibs, type: label_type) do |pdf, bib|
	pdf.indent(16) do
		pdf.move_down 5
		pdf.text "<b>#{bib.bibno}</b>", size: 80, inline_format: true, align: :center
		pdf.move_down 2
		pdf.text "#{bib.name}", size: 14, inline_format: true, align: :center
		
	end
end