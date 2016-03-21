require 'prawn/labels'

class Login <
	Struct.new(:name, :username, :password, :type, :y, :class, :upn)
end

logins = Array.new

# open the csv file
f = File.open("year1.txt", "r")

# loop through each record in the csv file, adding each record to our array.
f.each_line { |line|
	fields = line.split("\t")
	login = Login.new

	login.name = fields[0]
	login.username = fields[1]
	login.password = fields[2]
	login.type = fields[3]
	login.y = fields[4]
	login.class = fields[5]
	login.upn = fields[6]
	logins.push(login)
}

label_type = 'YourPrice21'
url = 'purplemash.co.uk/sch/norton-yo17'
last_class = logins[0].class

Prawn::Labels.generate("reminders.pdf", logins, type: label_type) do |pdf, login|
	if last_class != login.class
		pdf.start_new_page
		pdf.move_to 0, 0
	end
	last_class = login.class
	
	pdf.image Dir::pwd + "/pm-logo.png", width: 180
	pdf.image Dir::pwd + "/RoosterNew48.png", at: [120, 60]
	pdf.move_down 5
	pdf.indent(8) do
		pdf.text "<b>#{login.name}</b>", size: 12, leading: 5, inline_format: true
		pdf.text "<b>Username:</b> <font name='Courier'>#{login.username}</font>", size: 10, inline_format: true
		pdf.text "<b>Password :</b> <font name='Courier'>#{login.password}</font>", size: 10, inline_format: true
		pdf.text "<font name='Courier'>#{login.class}</font>", size: 10, leading: 3, inline_format: true
	end
end