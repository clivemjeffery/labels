require 'prawn/labels'

names = []
names << "Mike" << "Kelly" << "Bob"
names << "Simeon" << "Greg" << "Sharon"
names << "Jim" << "Tim" << "Tom"
names << "Callum" << "Kevin" << "Brian"
names << "Lambert" << "Catherine" << "Oscar"
names << "Bunny" << "Christian" << "Jonathan"
names << "Pauline" << "Belinda" << "Kyle"

label_type = 'YourPrice21'

Prawn::Labels.generate("names.pdf", names, type: label_type) do |pdf, name|

	pdf.stroke_axis
	
	pdf.font "Helvetica", size: 9
	pdf.text "Using #{label_type}"
	pdf.font "Times-Roman", size: 12
	pdf.text "The person's name is:"
	pdf.font "Courier", size: 24
	pdf.text name
	
	y_pos = pdf.cursor
	pdf.image Dir::pwd + "/cockerel.jpg", at: [40, y_pos], height: 40

end