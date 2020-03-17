require 'thor'
require 'prawn'
require 'prawn/labels'

class Login <
	Struct.new(:name, :login, :password, :parent_code, :group)
  def initialize (name, login, pass, parent_code, group)
    self.name = name
    self.login = login
		self.password = pass
		self.parent_code = parent_code
		self.group = group
  end
end

# load types (maybe move to options)
Prawn::Labels.types = './types.yaml'

class MyCLI < Thor
  class_option :label_type, :default => 'YourPrice21'

  desc "mash SOURCE DEST", "Make labels from SOURCE, to DEST"
  long_desc "Read a Purple Mash tab delimited Excel export from SOURCE, labelify into DEST."
  def mash(src, dest)
    logins = Array.new
    fsrc = File.open("#{src}", "r:UTF-8", &:read) # Prawn may need this
    fsrc.each_line { |line|
    	fields = line.split("\t")
    	login = Login.new(fields[0], fields[1], fields[2], fields[4], fields[5])
      logins.push(login)
    }
		logins.sort_by! { |i| [-i.group, i.name] }

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
				pdf.text_box "#{login.name}", at: [0, pdf.cursor + 2], size: 18, height: 20, overflow: :shrink_to_fit

				pdf.move_down 15
				pdf.font_size 10
				pdf.text login.group
				pdf.font "Panic Sans"
				pdf.text "norton-pri.n-yorks.sch.uk", color: '0000FF'
				pdf.font "Helvetica"
				pdf.text 'Purple Mash account:'

				pdf.move_down 5
				pdf.font "Panic Sans"
				pdf.text "User: #{login.login}"
				pdf.text "Pass: #{login.password}"
				pdf.text "Parent code: #{login.parent_code}"

			end
			#pdf.stroke_bounds
    end
	end
end

MyCLI.start(ARGV)
