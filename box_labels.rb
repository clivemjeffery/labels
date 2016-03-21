require 'prawn/labels'

classes = Array.new
classes.push("3ML")
classes.push("3SH")
classes.push("34S")
classes.push("4JE")
classes.push("4NR")
classes.push("5AP")
classes.push("5FA")
classes.push("5FA")
classes.push("5LL")
classes.push("5LL")
classes.push("6CM")
classes.push("6MG")
classes.push("6HR")

label_type = 'YourPrice08'

Prawn::Labels.generate("H:/dev/labels/box.pdf", classes, type: label_type) do |pdf, c|
	pdf.indent(16) do
		pdf.move_down 2
		pdf.text "<b>Computing</b>", size: 40, leading: 5, inline_format: true
		pdf.move_down 2
		pdf.text "<b>#{c}</b>", size: 80, inline_format: true
	end
end