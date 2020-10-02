require 'prawn/labels'
require 'CSV'
require 'pathname'

rockers = CSV.parse(File.read("ttrockers.csv"), headers: true)
rockers.each do |rocker|
	puts "#{rocker['First name REQUIRED']} #{rocker['Last name REQUIRED']} = #{rocker['Rock Name']} #{rocker['Our ID for this user']}"
end

stats = CSV.parse(File.read("ttstatus.csv"), headers: true)
stats.each do |stat|
	puts stat['Id']
	rocker = rockers.find { |r| r['Our ID for this user'] == stat['Id'] }
	rocker['Baseline'] = stat['Baseline'] # Can I add a field? Yes.

	puts "#{rocker['First name REQUIRED']} #{rocker['Last name REQUIRED']} IS #{rocker['Rock Name']}"
	puts "Baseline: #{rocker['Baseline']}"
	puts '-------------------------------------------'
end

Prawn::Labels.types = './types.yaml'
label_type = 'YourPrice08'
Prawn::Labels.generate("#{__FILE__.split('.')[0]}.pdf", rockers, type: label_type) do |pdf, rocker|
	pdf.stroke_color "dddddd"
	pdf.fill_color "ffffff"
	pdf.stroke_bounds
	avatar_fn = "#{rocker['First name REQUIRED']}_#{rocker['Last name REQUIRED']}.png"
	avatar_pn = Pathname.new("./ttrockavatars/#{avatar_fn}")
	if avatar_pn.exist?
		pdf.image avatar_pn, at: [0,180], width: 180
	end

	pdf.rounded_rectangle [150, 150], 100, 100, 20
	pdf.fill

	pdf.indent(5) do
		pdf.move_down 2
    pdf.font "Helvetica"

    pdf.text "#{rocker['First name REQUIRED']} #{rocker['Last name REQUIRED']}", size: 14
		pdf.text "#{rocker['Maths Band REQUIRED']}", size: 12

		pdf.move_down 25
		pdf.text "Current Level:", size: 14

    pdf.text "Baseline: #{rocker['Baseline']}", size: 14, leading: 5
		pdf.text rocker['Rock Name'], size: 18
	end
end
