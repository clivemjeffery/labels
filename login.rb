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
    logins.push(login)
}

# load and select label type
Prawn::Labels.types = './types.yaml'
label_type = 'YourPrice21'
url1 = "https://toothed-rooster.herokuapp.com"
url2 = "www.purplemash.co.uk/sch/norton-yo17"
url3 ="www.activelearnprimary.co.uk (code 'jhjx')"

Prawn::Labels.generate("#{fn}_#{__FILE__.split('.')[0]}.pdf", logins, type: label_type) do |pdf, login|
    if login.name.nil? || login.name == ''
        puts 'name was nil or blank'
        pdf.move_down 4 # is this enough to generate a blank label? Yes!
    else
        pdf.stroke_color "eeeeee"
        pdf.stroke_bounds
		
        pdf.image "./pm-logo.png", at: [100, 90], width: 70 # first so other images sit on top
        pdf.image "./RoosterNew48.png", at: [110, 67], width: 30
        pdf.image "./bug.png", at: [145, 75], width: 30
        
        pdf.indent(8) do
            pdf.text_box "<color rgb='9200B5'><b>#{login.name}</b></color>", 
				at: [0, pdf.cursor - 4],
				size: 16,
				height: 20,
				overflow: :shrink_to_fit,
				inline_format: true
			pdf.move_down 22 # nestle close under pupil name
			pdf.text "#{login.class_group}", size: 8
            pdf.move_down 3
            pdf.text "<b>Username:</b> <font name='Courier'>#{login.login}</font>", size: 10, inline_format: true
            pdf.text "<b>Password :</b> <font name='Courier'>#{login.password}</font>", size: 10, inline_format: true
            pdf.move_down 5
            pdf.font "Helvetica"
            pdf.text '<i>Join us at:</i>', size: 9, inline_format: true
            pdf.text url1, size: 9
            pdf.text url2, size: 9
            pdf.text url3, size: 9
        end
    end
end