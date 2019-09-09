require 'prawn/labels'

class Login <
	Struct.new(:firstname, :lastname, :login, :password, :role, :shared_folders, :class_group, :upn)
end

logins = Array.new

# open the text file
fn = ARGV[0]
f = File.open("#{fn}.txt", "r")

# loop through each record in the pupils.mash file from Rooster adding each record to our array.
f.each_line { |line|
	fields = line.split("\t")
	login = Login.new
    login.firstname = fields[0]
	login.lastname = fields[1]
	login.login = fields[2]
	login.password = fields[3]
	login.role = fields[4]
	login.shared_folders = fields[5]
	login.class_group = fields[6]
	login.upn = fields[7]
    logins.push(login)
}
# Sort the logins by class_group
puts 'Pre-sort'
logins.each { |i| puts "#{i.class_group}, #{i.login}" }
logins.sort_by! { |i| [-i.class_group, i.login] } # not working fully
puts 'Post sort_by'
logins.each { |i| puts "#{i.class_group}, #{i.login}" }

Prawn::Labels.types = './types.yaml'
label_type = 'YourPrice21'
url3 ="www.activelearnprimary.co.uk"

Prawn::Labels.generate("#{fn}_#{__FILE__.split('.')[0]}.pdf", logins, type: label_type) do |pdf, login|
    if login.firstname.nil? || login.firstname == ''
        puts 'firstname was nil or blank'
        pdf.move_down 4 # is this enough to generate a blank label? Yes!
    else
        pdf.stroke_color "eeeeee"
        pdf.stroke_bounds

        pdf.image "./bug.png", at: [125, 85], width: 50

        pdf.move_down 5
        pdf.indent(8) do
            pdf.text_box "<color rgb='9200B5'><b>#{login.firstname} #{login.lastname}</b></color>",
							size: 16, height: 20,
							overflow: :shrink_to_fit,
							at: [0, pdf.cursor - 4],
							inline_format: true
			pdf.move_down 22 # nestle close under pupil name
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
