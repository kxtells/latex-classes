all: dnd4eicons.600pk dnd4eicons.480pk dnd4eicons.540pk
	mv *pk ../

dnd4eicons.480pk: dnd4eicons.ttf
	ttf2afm -e T1-WGL4.enc -o dnd4eicons.afm dnd4eicons.ttf
	afm2tfm dnd4eicons.afm -T T1-WGL4.enc
	echo "dnd4eicons dnd4eicons.ttf Encoding=T1-WGL4.enc" >> ttfonts.map
	mktexpk --mfmode ljfour --bdpi 600 --mag 1+0/480 --dpi 480 dnd4eicons

dnd4eicons.600pk: dnd4eicons.ttf
	ttf2afm -e T1-WGL4.enc -o dnd4eicons.afm dnd4eicons.ttf
	afm2tfm dnd4eicons.afm -T T1-WGL4.enc
	echo "dnd4eicons dnd4eicons.ttf Encoding=T1-WGL4.enc" >> ttfonts.map
	mktexpk --mfmode ljfour --bdpi 600 --mag 1+0/600 --dpi 600 dnd4eicons

dnd4eicons.540pk: dnd4eicons.ttf
	ttf2afm -e T1-WGL4.enc -o dnd4eicons.afm dnd4eicons.ttf
	afm2tfm dnd4eicons.afm -T T1-WGL4.enc
	echo "dnd4eicons dnd4eicons.ttf Encoding=T1-WGL4.enc" >> ttfonts.map
	mktexpk --mfmode ljfour --bdpi 600 --mag 1+0/540 --dpi 540 dnd4eicons

clean:
	rm dnd4eicons.afm ttfonts.map
	rm *pk
