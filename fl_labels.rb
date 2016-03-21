require 'prawn/labels'

class Login <
	Struct.new(:fname, :lname, :email, :pass, :class_group, :year_group)
end

logins = Array.new

# open the text file
fn = 'y3schoolsfl'
f = File.open("#{fn}.txt", "r")

# loop through each record in the csv file, adding each record to our array.
f.each_line { |line|
	fields = line.split("\t")
	login = Login.new

	login.fname = fields[0]
	login.lname = fields[1]
	login.email = fields[2]
	login.pass = fields[3]
	login.class_group = fields[4]
	login.year_group = fields[5]
    logins.push(login)
}

label_type = 'YourPrice14'
url1 = "schoolsfl.com"

Prawn::Labels.generate("#{fn}.pdf", logins, type: label_type) do |pdf, login|
	if login.fname.nil? || login.lname == ''
		puts 'name was nil or blank'
		pdf.move_down 4 # is this enough to generate a blank label? Yes!
	else
		pdf.image "H:/dev/labels/schools-fl-logo.png", at: [160,70], width: 100
		pdf.indent(8) do
			pdf.text "<b><u>Football Manager ID Card</u></b>", size: 16, inline_format: true
			pdf.text "<b>#{login.fname} #{login.lname}</b>", size: 10, overflow: :shrink_to_fit, inline_format: true
			pdf.move_down 2
			pdf.text "<font name='Courier'>#{login.email}</font>", size: 10, inline_format: true
			pdf.text "<b>Password :</b> <font name='Courier'>#{login.pass}</font>", size: 10, inline_format: true
			pdf.move_down 3
			pdf.font "Helvetica"
			pdf.text "Find the Fantasy League in your<br/><b>Rooster</b> applications, or log in at<br/><b>schoolsfl.com</b>", size: 10,inline_format: true
		end
	end
end