# haribote-ipl
	.code16
	.section .text
	jmp	entry
	.byte	0x90
	.ascii	"HARIBOTE"	# any name you like of this boot sector
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
	.ascii	"HARIBOTEOS "	# disk name in 11 byte
	.ascii	"FAT12   "	# format name in 8 byte
	.fill	18		# padding 18byte

# body of program

entry:
	mov	$0, %ax		# initialization of registers
	mov	%ax, %ss
	mov	$0x7c00, %sp
	mov	%ax, %ds

# read the disk

	mov	$0x0820, %ax
	mov	%ax, %es	# buffer segment
	mov	$0, %ch		# cylinder[7:0]
	mov	$0, %dh		# head[7:0]
	mov	$2, %cl		# {cylinder[9:8], sector[5:0]}

	mov	$2, %ah		# command (2 = read, 3 = write, 4 = verify...)
	mov	$1, %al 	# number of sectors
	mov	$0, %bx		# buffer offset
	mov	$0, %dl		# drive number (A drive)
	int	$0x13		# call disk BIOS
	jc	error

# sleep forever

fin:
	hlt			# halt CPU
	jmp	fin
error:
	movw	$0, %ax
	movw	%ax, %es
	movw	$msg, %si
putloop:
	mov	(%si), %al
	add	$1, %si
	cmp	$0, %al
	je	fin
	mov	$0x0e, %ah	# print a character
	mov	$15, %bx	# color code
	int	$0x10		# call Video BIOS
	jmp	putloop
msg:
	.asciz	"\n\nload error\n"

	.org	0x1fe
	.byte	0x55, 0xaa
