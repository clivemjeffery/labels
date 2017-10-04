require 'prawn/labels'

class Login <
	Struct.new(:fname, :lname, :login, :password, :class, :teacher, :notused)
end
class CardData <
	Struct.new(:type, :ilogin)
end
$logins = Array.new
$cards = Array.new
blank_card = CardData.new
blank_card.type = :blank

def push_back_and_front(nlogin)
	login = $logins[nlogin]
	puts "#{login.fname} #{login.lname} in #{login.class} (#{login.teacher})"
	cd = CardData.new
	cd.type = :class
	cd.ilogin = nlogin
	$cards.push(cd)
	cd = CardData.new
	cd.type = :title
	cd.ilogin = nlogin
	$cards.push(cd)
end

def push_middle(nlogin)
	login = $logins[nlogin]
	puts "#{login.fname} #{login.lname}"
	cd = CardData.new
	cd.type = :username
	cd.ilogin = nlogin
	$cards.push(cd)
	cd = CardData.new
	cd.type = :password
	cd.ilogin = nlogin
	$cards.push(cd)
end

# open the text file
fn = ARGV[0]
f = File.open("#{fn}.txt", "r")
outfile = "#{fn}_#{__FILE__.split('.')[0]}.pdf"

# loop through each record in the pupils.mash file from Rooster adding each record to our array.
f.each_line { |line|
	fields = line.split(",")
	login = Login.new
	login.fname = fields[0]
	login.lname = fields[1]
	login.login = fields[2]
	login.password = fields[3]
	login.class = fields[4]
	login.teacher = fields[5]
	login.notused = fields[6]
    $logins.push(login)
}
# Now make up the card data, in batches of 16
nbatch = 0
for nbatch in (0..$logins.length).step(16)
	puts "Processing batch begining at #{nbatch}" 
	nitem = 0
	# Make the page of usernames and passwords
	puts "Making data pages"
	for nitem in (0..15)
		# Make 2 $cards for each login
		nlogin = nbatch + nitem
		puts "Processing bach item #{nitem} which is login #{nlogin}."
		if nlogin < $logins.length # still some left
			push_middle(nlogin)
		else
			puts 'blank'
			$cards.push(blank_card)
			$cards.push(blank_card)
		end
	end
	# Go again to make the back pages for folding with full names and class, flipping the order
	puts "Making title pages to fold over"
	nitem = 0
	for nitem in (0..15).step(2)
		nlogin = nbatch + nitem
		puts "Reprocessing batch item #{nitem} which is login #{nlogin}."
		if nlogin < $logins.length # still some left but maybe just one
			if nlogin + 1 < $logins.length # more than one so flip and do the next one first
				push_back_and_front(nlogin + 1)
			end
			push_back_and_front(nlogin)
		else
			puts 'blank'
			$cards.push(blank_card)
			$cards.push(blank_card)
		end
	end
end

Prawn::Labels.types = {
	'FourByEight' => {
		'paper_size' => 'A4',
		'top_margin' => 42.52,
		'bottom_margin' => 42.52,
		'left_margin' => 21.26,
		'right_margin' => 21.26,
		'columns' => 4,
		'rows' => 8,
		'column_gutter' => 8.504,
		'row_gutter:' => 0
	}
}

Prawn::Labels.generate(outfile, $cards, type: 'FourByEight') do |pdf, card|
    
	pdf.stroke_color "dddddd"
	pdf.stroke_bounds
	
	case card.type
	when :title
		pdf.font 'Helvetica'
		pdf.text_box "#{$logins[card.ilogin].fname}", at: [5, pdf.cursor - 10], size: 48, height: 50, overflow: :shrink_to_fit
		pdf.text_box "#{$logins[card.ilogin].lname}", at: [5, pdf.cursor - 50], size: 48, height: 50, overflow: :shrink_to_fit
	when :class
		pdf.font 'Helvetica'
		pdf.text_box "#{$logins[card.ilogin].teacher}", at: [5, pdf.cursor - 10], size: 48, height: 25, overflow: :shrink_to_fit
		pdf.text_box "#{$logins[card.ilogin].class}", at: [5, pdf.cursor - 50], size: 48, height: 25, overflow: :shrink_to_fit
	when :username
		pdf.font 'Helvetica'
		pdf.text_box 'Username:', at: [5, pdf.cursor - 10], size: 24, height: 50
		pdf.font 'Courier'
		pdf.text_box "#{$logins[card.ilogin].login}", at: [5, pdf.cursor - 50], size: 48, height: 25, overflow: :shrink_to_fit
	when :password
		pdf.font 'Helvetica'
		pdf.text_box 'Password:', at: [5, pdf.cursor - 10], size: 24, height: 50
		pdf.font 'Courier'
		pdf.text_box "#{$logins[card.ilogin].password}", at: [5, pdf.cursor - 50], size: 48, height: 25, overflow: :shrink_to_fit
	when :blank
		pdf.text ''
	end	
end

puts "Wrote file #{outfile}"