require 'thor'
require 'prawn'
require 'prawn/labels'

class Login <
	Struct.new(:first_name, :last_name, :login, :password, :group)
  def initialize (fname, lname, login, pass, group)
    self.first_name = fname
    self.last_name = lname
    self.login = login
		self.password = pass
		self.group = group
  end
end

# load types (maybe move to options)
Prawn::Labels.types = './types.yaml'

class MyCLI < Thor
  class_option :label_type, :default => 'YourPrice21'

  desc "mash SOURCE DEST", "Make labels from SOURCE, to DEST"
  long_desc "Read a Rooster .mash file from SOURCE, labelify into DEST."
  def mash(src, dest)
    logins = Array.new
    fsrc = File.open("#{src}", "r:UTF-8", &:read) # Prawn may need this
    fsrc.each_line { |line|
    	fields = line.split("\t")
    	login = Login.new(fields[0], fields[1], fields[2], fields[3], fields[6])
      logins.push(login)
    }
		logins.sort_by! { |i| [-i.group, i.last_name, i.first_name] }

    Prawn::Labels.generate("#{dest}", logins, type: options[:label_type]) do |pdf, login|
			# Registering a DFONT package
			font_path = "./PanicSans.dfont"
			pdf.font_families.update(
				"Panic Sans" => {
				 :normal => { :file => font_path, :font => "PanicSans" },
				 :italic => { :file => font_path, :font => "PanicSans-Italic" },
				 :bold => { :file => font_path, :font => "PanicSans-Bold" },
				 :bold_italic => { :file => font_path, :font => "PanicSans-BoldItalic" }
				}
			)
			pdf.indent(8) do
				pdf.move_down 8
				pdf.font "Helvetica"
				pdf.text_box "#{login.first_name} #{login.last_name}", at: [0, pdf.cursor + 2], size: 18, height: 20, overflow: :shrink_to_fit

				pdf.move_down 15
				pdf.font_size 10
				pdf.text login.group
				pdf.font "Panic Sans"
				pdf.text "norton-pri.n-yorks.sch.uk", color: '0000FF'
				pdf.font "Helvetica"
				pdf.text 'Go to the school website to find'
				pdf.text 'Purple Mash and more.'

				pdf.move_down 5
				pdf.font "Panic Sans"
				pdf.text "U: #{login.login}"
				pdf.text "P: #{login.password}"

			end
			#pdf.stroke_bounds
    end
	end
end

MyCLI.start(ARGV)
