require 'prawn/labels'

class Login <
	Struct.new(
		:name, :login, :password, :role,
		:shared_folders, :class_group, :upn,
		:year_group, :teacher_title, :label_design)
end

logins = Array.new

# open the file
fn = ARGV[0]
f = File.open("#{fn}.txt", "r")

# loop through each record in the file, adding each record to our array.
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

Prawn::Labels.generate("#{fn}_#{__FILE__.split('.')[0]}.pdf", logins, type: label_type) do |pdf, login|
	pdf.image "cpu.png", at: [125,120]
	pdf.indent(8) do
		pdf.move_down 4
		pdf.text "<b>#{login.name}</b>", size: 14, inline_format: true
		pdf.text "<b><i>Computing</i></b>", size: 14, inline_format: true
		pdf.text "#{login.class_group}</font> - Y4", size: 14, inline_format: true
	end
end