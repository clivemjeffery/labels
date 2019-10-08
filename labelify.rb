require 'thor'
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
    fsrc = File.open("#{src}", "r")
    fsrc.each_line { |line|
    	fields = line.split("\t")
    	text = Text.new(fields[0], fields[1])
      texts.push(text)
    }

    Prawn::Labels.generate("#{dest}", texts, type: options[:label_type]) do |pdf, text|
      pdf.stroke_color "dddddd"
      pdf.stroke_bounds
      pdf.text_box "<color rgb='9200B5'><b>#{text.title}</b></color>",
        at: [0, pdf.cursor - 4],
        size: 16,
        height: 20,
        overflow: :shrink_to_fit,
        inline_format: true
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
