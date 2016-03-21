require 'prawn/labels'

class Login <
	Struct.new(:name, :login, :password, :role, :shared_folders, :class_group, :upn)
end

logins = Array.new

# open the text file
fn = ARGV[0]
f = File.open("#{fn}.txt", "r")

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
url1 = "https://toothed-rooster.herokuapp.com"
url2 = "www.purplemash.co.uk/sch/norton-yo17"

Prawn::Labels.generate("#{fn}.pdf", logins, type: label_type) do |pdf, login|
	if login.name.nil? || login.name == ''
		puts 'name was nil or blank'
		pdf.move_down 4 # is this enough to generate a blank label? Yes!
	else
		#pdf.image Dir::pwd + "/pm-logo.png", width: 180
		pdf.image "H:/dev/labels/RoosterNew48.png", at: [125,90]
		pdf.indent(8) do
			pdf.text "<b>#{login.name}</b>", size: 16, overflow: :shrink_to_fit, inline_format: true, color: "9200B5"
			pdf.move_down 2
			pdf.text "<b>Username:</b> <font name='Courier'>#{login.login}</font>", size: 10, inline_format: true
			pdf.text "<b>Password :</b> <font name='Courier'>#{login.password}</font>", size: 10, inline_format: true
			pdf.move_down 3
			pdf.text "#{login.class_group}", size: 10, leading: 5, inline_format: true
			pdf.move_down 3
			pdf.text "After your lesson, please give this card back to Mr Jeffery."
		end
	end
end