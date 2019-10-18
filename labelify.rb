require 'thor'
require 'prawn'
require 'prawn/labels'


class Text <
	Struct.new(:title, :text)
  def initialize (title, text)
    self.title = title
    self.text = text
  end
end

# load types (maybe move to options)
Prawn::Labels.types = './types.yaml'

class MyCLI < Thor
  class_option :label_type, :default => 'YourPrice21'

  desc "tabbed SOURCE DEST", "titled text from SOURCE, to DEST"
  long_desc "Read TAB delimited titles and text from SOURCE, labelify into DEST."
  def tabbed(src, dest)
    texts = Array.new
    fsrc = File.open("#{src}", "r:UTF-8", &:read) # Prawn may need this
    fsrc.each_line { |line|
    	fields = line.split("\t")
    	text = Text.new(fields[0], fields[1])
      texts.push(text)
    }

    Prawn::Labels.generate("#{dest}", texts, type: options[:label_type]) do |pdf, text|
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

      pdf.stroke_color "dddddd"
      pdf.stroke_bounds
			pdf.font "Helvetica"
      pdf.text_box "<color rgb='9200B5'><b>#{text.title}</b></color>",
				at: [0, pdf.cursor - 4],
        size: 16,
        height: 20,
        overflow: :shrink_to_fit,
        inline_format: true
			pdf.font "Panic Sans"
			pdf.text_box text.text,
        at: [0, pdf.cursor - 24],
        size: 30,
        height: 80,
        overflow: :shrink_to_fit,
        disable_wrap_by_char: true
    end
  end
end

MyCLI.start(ARGV)
