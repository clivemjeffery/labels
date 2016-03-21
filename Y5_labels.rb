require 'prawn/labels'

class Login <
	Struct.new(
		:name, :login, :password, :role,
		:shared_folders, :class_group, :upn,
		:year_group, :teacher_title, :label_design)
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
url = 'purplemash.co.uk/sch/norton-yo17'

Prawn::Labels.generate("y5newbook.pdf", logins, type: label_type) do |pdf, login|
	pdf.font "Helvetica"
	pdf.image "internet-3.png", at: [136,100]
	pdf.indent(8) do
		pdf.move_down 2
		pdf.text "<b>#{login.name}</b>", size: 14, inline_format: true
		pdf.move_down 5
		pdf.text "<u>Computing</u>", size: 14, leading: 5, inline_format: true
		pdf.text "<font name='Courier'>Y5: #{login.teacher_title} #{login.class_group}</font>", size: 10, leading: 3, inline_format: true
		pdf.text "<font name='Courier'>Y6:</font>", size: 10, inline_format: true
		pdf.horizontal_rule
	end
end