require 'prawn/labels'

class Login <
	Struct.new(:name, :login, :password, :role, :shared_folders, :class_group, :upn)
end

logins = Array.new

# open the text file
fn = ARGV[0]
f = File.open("#{fn}.txt", "r")

# loop through each record in the pupils.mash file from Rooster adding each record to our array.
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
	# push twice for two labels
    #logins.push(login)
}

label_type = 'YourPrice21'
url3 ="www.activelearnprimary.co.uk"

Prawn::Labels.generate("#{fn}_#{__FILE__.split('.')[0]}.pdf", logins, type: label_type) do |pdf, login|
    if login.name.nil? || login.name == ''
        puts 'name was nil or blank'
        pdf.move_down 4 # is this enough to generate a blank label? Yes!
    else
        pdf.stroke_color "eeeeee"
        pdf.stroke_bounds
		
        pdf.image "./bug.png", at: [125, 85], width: 50
        
        pdf.move_down 5
        pdf.indent(8) do
            pdf.text "<b>#{login.name}</b>", size: 16, overflow: :shrink_to_fit, inline_format: true, color: "9200B5"
			pdf.move_up 3 # nestle close under pupil name
			pdf.text "#{login.class_group}", size: 8
            pdf.move_down 3
            pdf.text "<b>Username:</b> <font name='Courier'>#{login.login}</font>", size: 10, inline_format: true
            pdf.text "<b>Password :</b> <font name='Courier'>#{login.password}</font>", size: 10, inline_format: true
            pdf.move_down 5
            pdf.font "Helvetica"
            pdf.text '<i>Log in to Phonics Bug at:</i>', size: 9, inline_format: true            
            pdf.text url3, size: 9
            pdf.text 'The school code is: <b>jhjx</b>', size: 9, inline_format: true
        end
    end
end