# hello-os
	.code16
	.section .text
	jmp	entry
	.byte	0x90
	.ascii	"HELLOIPL"	# any name you like of this boot sector
	.word	512		# size of a sector (must be 512byte)
	.byte	1		# size of a cluster (must be 1sector)
	.word	1		# start of FAT (typically 1 sector)
	.byte	2		# number of FATs (must be 2)
	.word	224		# size of root directory area (typically 224)
	.word	2880		# size of this disk (must be 2880 sector)
	.byte	0xf0		# media type (must be 0xf0)
	.word	9		# length of FAT area (must be 9sector)
	.word	18		# sectors per track (must be 18sector)
	.word	2		# number of heads (must be 2)
	.long	0		# must be 0 because the partition is not in use
	.long	2880		# set again the size of this disk
	.byte	0,0,0x29	# this values are nice, but I don't know why.
	.long	0xffffffff	# probablly volume serial number
	.ascii	"HELLO-OS   "	# disk name in 11 byte
	.ascii	"FAT12   "	# format name in 8 byte
	.fill	18		# padding 18byte

# body of program

entry:
	mov	$0, %ax		# initialization of registers
	mov	%ax, %ss
	mov	$0x7c00, %sp
	mov	%ax, %ds
	mov	%ax, %es

	mov	$msg, %si
putloop:
	mov	(%si), %al
	add	$1, %si
	cmp	$0, %al
	je	fin
	mov	$0x0e, %ah	# print a character
	mov	$15, %bx	# color code
	int	$0x10		# call Video BIOS
	jmp	putloop
fin:
	hlt			# halt CPU
	jmp	fin
msg:
	.asciz	"\n\nhello, world\n"

	.org	0x1fe
	.byte	0x55, 0xaa
