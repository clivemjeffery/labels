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
    logins.push(login) # push twice for two labels
    logins.push(login)
}

label_type = 'YourPrice14'
url1 = "https://toothed-rooster.herokuapp.com"
url2 = "www.purplemash.co.uk/sch/norton-yo17"
url3 ="www.activelearnprimary.co.uk (school code 'jhjx')"

Prawn::Labels.generate("#{fn}_#{__FILE__.split('.')[0]}.pdf", logins, type: label_type) do |pdf, login|
    if login.name.nil? || login.name == ''
        puts 'name was nil or blank'
        pdf.move_down 4 # is this enough to generate a blank label? Yes!
    else
        pdf.stroke_color "eeeeee"
        pdf.stroke_bounds

        pdf.image "./pm-logo.png", at: [125, 65], width: 120 # first so other images sit on top
        pdf.image "./RoosterNew48.png", at: [220, 100], width: 40
        pdf.image "./bug.png", at: [220, 50], width: 40
        
        pdf.move_down 5
        pdf.indent(8) do
            pdf.text "<b>#{login.name}</b> (#{login.class_group})", size: 16, overflow: :shrink_to_fit, inline_format: true, color: "9200B5"
            pdf.move_down 2
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