require 'prawn/labels'

class Leaver <
	Struct.new(
		:first,
		:last
		)
end

leavers = Array.new

# open the file
fn = ARGV[0]
f = File.open("#{fn}.txt", "r")

# loop through each record in the file, adding each record to our array.
f.each_line { |line|
	fields = line.split(" ")
	leaver = Leaver.new

	leaver.first = fields[0]
	leaver.last = fields[1]
	leavers.push(leaver)
}

label_type = 'YourPrice08'

Prawn::Labels.generate("#{fn}_#{__FILE__.split('.')[0]}.pdf", leavers, type: label_type) do |pdf, leaver|
	pdf.indent(16) do
		#pdf.move_down 5
		pdf.text "#{leaver.first},"
        pdf.move_down 4
        pdf.text "    Well done for all your computing work this year and good luck for Year 7."
		pdf.move_down 4
        pdf.text "    If you'd like to keep working on a Scratch platform game, find my how tos and recipies on the web at bit.ly/ncpH2C1."
        pdf.move_down 4
        pdf.text "Best wishes,"
        pdf.move_down 2
        pdf.text "Mr J."
        pdf.image "H:/dev/labels/monogram.png", at: [180,100], scale: 0.1
	end
end