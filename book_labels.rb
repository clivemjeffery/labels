require 'prawn/labels'

class Login <
	Struct.new(
		:name, :login, :password, :role,
		:shared_folders, :class_group, :upn,
		:year_group, :teacher_title)
end

logins = Array.new

# open the csv file
f = File.open("y5newlabels.txt", "r")

# loop through each record in the csv file, adding each record to our array.
f.each_line { |line|
	fields = line.split("\t")
	login = Login.new

	login.name = fields[0]
	login.login = fields[1]
	login.password = fields[2]
	login.role = fields[3]
	login.shared_folders = fields[4]
	login.class_group = fields[5]
	login.upn = fields[6]
	logins.push(login)
}

label_type = 'YourPrice21'

Prawn::Labels.generate("H:/dev/labels/book.pdf", logins, type: label_type) do |pdf, login|
	pdf.image "H:/dev/labels/internet-3.png", at: [125,100]
	pdf.indent(8) do
		pdf.move_down 2
		pdf.font "Helvetica"
		pdf.text "<b>#{login.name}</b><br\><b><i>Computing</i></b><br/>#{login.class_group} - Y6",
			size: 14,
			inline_format: true,
			valign: :center
	end
end