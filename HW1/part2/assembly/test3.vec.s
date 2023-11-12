	.text
	.file	"test3.cpp"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3                               # -- Begin function _Z5test3Pdi
.LCPI0_0:
	.quad	0x3e112e0be826d695              # double 1.0000000000000001E-9
	.text
	.globl	_Z5test3Pdi
	.p2align	4, 0x90
	.type	_Z5test3Pdi,@function
_Z5test3Pdi:                            # @_Z5test3Pdi
.Lfunc_begin0:
	.file	1 "/home/312551080/HW1/part2" "test3.cpp"
	.loc	1 5 0                           # test3.cpp:5:0
	.cfi_startproc
# %bb.0:
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$32, %rsp
	.cfi_def_cfa_offset 64
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %rbx
	movq	%rsp, %rsi
.Ltmp0:
	.file	2 "/home/312551080/HW1/part2" "./fasttime.h"
	.loc	2 74 11 prologue_end            # ./fasttime.h:74:11
	movl	$1, %edi
	callq	clock_gettime
	.loc	2 75 3                          # ./fasttime.h:75:3
	testl	%eax, %eax
	jne	.LBB0_7
# %bb.1:
	.loc	2 78 1                          # ./fasttime.h:78:1
	movq	(%rsp), %r15
	movq	8(%rsp), %r14
	xorl	%eax, %eax
	xorpd	%xmm0, %xmm0
.Ltmp1:
	.p2align	4, 0x90
.LBB0_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	.loc	2 0 1 is_stmt 0                 # ./fasttime.h:0:1
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB0_3:                                #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	.loc	1 14 9 is_stmt 1                # test3.cpp:14:9
	addsd	(%rbx,%rcx,8), %xmm0
	addsd	8(%rbx,%rcx,8), %xmm0
	addsd	16(%rbx,%rcx,8), %xmm0
	addsd	24(%rbx,%rcx,8), %xmm0
	addsd	32(%rbx,%rcx,8), %xmm0
	addsd	40(%rbx,%rcx,8), %xmm0
	addsd	48(%rbx,%rcx,8), %xmm0
	addsd	56(%rbx,%rcx,8), %xmm0
	.loc	1 13 25                         # test3.cpp:13:25
	addq	$8, %rcx
	.loc	1 13 20 is_stmt 0               # test3.cpp:13:20
	cmpq	$1024, %rcx                     # imm = 0x400
	.loc	1 13 5                          # test3.cpp:13:5
	jne	.LBB0_3
# %bb.4:                                #   in Loop: Header=BB0_2 Depth=1
	.loc	1 12 23 is_stmt 1               # test3.cpp:12:23
	addl	$1, %eax
	.loc	1 12 18 is_stmt 0               # test3.cpp:12:18
	cmpl	$20000000, %eax                 # imm = 0x1312D00
	.loc	1 12 3                          # test3.cpp:12:3
	jne	.LBB0_2
# %bb.5:
	.loc	1 0 3                           # test3.cpp:0:3
	movsd	%xmm0, 24(%rsp)                 # 8-byte Spill
	movq	%rsp, %rsi
.Ltmp2:
	.loc	2 74 11 is_stmt 1               # ./fasttime.h:74:11
	movl	$1, %edi
	callq	clock_gettime
	.loc	2 75 3                          # ./fasttime.h:75:3
	testl	%eax, %eax
	jne	.LBB0_7
# %bb.6:
	.loc	2 78 1                          # ./fasttime.h:78:1
	movq	(%rsp), %rax
.Ltmp3:
	.loc	2 83 21                         # ./fasttime.h:83:21
	subq	%r15, %rax
.Ltmp4:
	.loc	2 78 1                          # ./fasttime.h:78:1
	movq	8(%rsp), %rcx
.Ltmp5:
	.loc	2 83 56                         # ./fasttime.h:83:56
	subq	%r14, %rcx
	.loc	2 83 10 is_stmt 0               # ./fasttime.h:83:10
	xorps	%xmm0, %xmm0
	cvtsi2sd	%rax, %xmm0
	.loc	2 83 43                         # ./fasttime.h:83:43
	cvtsi2sd	%rcx, %xmm1
	.loc	2 83 42                         # ./fasttime.h:83:42
	mulsd	.LCPI0_0(%rip), %xmm1
	.loc	2 83 36                         # ./fasttime.h:83:36
	addsd	%xmm0, %xmm1
	movsd	%xmm1, 16(%rsp)                 # 8-byte Spill
.Ltmp6:
	.file	3 "/usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10" "ostream"
	.loc	3 611 2 is_stmt 1               # /usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10/ostream:611:2
	movl	$_ZSt4cout, %edi
	movl	$.L.str, %esi
	movl	$47, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp7:
	.loc	3 221 16                        # /usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10/ostream:221:16
	movl	$_ZSt4cout, %edi
	movsd	16(%rsp), %xmm0                 # 8-byte Reload
                                        # xmm0 = mem[0],zero
	callq	_ZNSo9_M_insertIdEERSoT_
	movq	%rax, %rbx
.Ltmp8:
	.loc	3 611 2                         # /usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10/ostream:611:2
	movl	$.L.str.1, %esi
	movl	$8, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp9:
	.loc	1 21 31                         # test3.cpp:21:31
	movq	%rbx, %rdi
	movl	$1024, %esi                     # imm = 0x400
	callq	_ZNSolsEi
	movq	%rax, %rbx
.Ltmp10:
	.loc	3 611 2                         # /usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10/ostream:611:2
	movl	$.L.str.2, %esi
	movl	$5, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp11:
	.loc	1 21 47                         # test3.cpp:21:47
	movq	%rbx, %rdi
	movl	$20000000, %esi                 # imm = 0x1312D00
	callq	_ZNSolsEi
.Ltmp12:
	.loc	3 611 2                         # /usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10/ostream:611:2
	movl	$.L.str.3, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	movsd	24(%rsp), %xmm0                 # 8-byte Reload
                                        # xmm0 = mem[0],zero
.Ltmp13:
	.loc	1 23 3                          # test3.cpp:23:3
	addq	$32, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.LBB0_7:
	.cfi_def_cfa_offset 64
	.loc	1 0 0 is_stmt 0                 # test3.cpp:0:0
	movl	$.L.str.4, %edi
	movl	$.L.str.5, %esi
	movl	$.L__PRETTY_FUNCTION__._ZL7gettimev, %ecx
	movl	$75, %edx
	callq	__assert_fail
.Ltmp14:
.Lfunc_end0:
	.size	_Z5test3Pdi, .Lfunc_end0-_Z5test3Pdi
	.cfi_endproc
                                        # -- End function
	.section	.text.startup,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _GLOBAL__sub_I_test3.cpp
	.type	_GLOBAL__sub_I_test3.cpp,@function
_GLOBAL__sub_I_test3.cpp:               # @_GLOBAL__sub_I_test3.cpp
.Lfunc_begin1:
	.loc	1 0 0 is_stmt 1                 # test3.cpp:0:0
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
.Ltmp15:
	.file	4 "/usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10" "iostream"
	.loc	4 74 25 prologue_end            # /usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10/iostream:74:25
	movl	$_ZStL8__ioinit, %edi
	callq	_ZNSt8ios_base4InitC1Ev
	movl	$_ZNSt8ios_base4InitD1Ev, %edi
	movl	$_ZStL8__ioinit, %esi
	movl	$__dso_handle, %edx
	popq	%rax
	.cfi_def_cfa_offset 8
	jmp	__cxa_atexit                    # TAILCALL
.Ltmp16:
.Lfunc_end1:
	.size	_GLOBAL__sub_I_test3.cpp, .Lfunc_end1-_GLOBAL__sub_I_test3.cpp
	.cfi_endproc
                                        # -- End function
	.type	_ZStL8__ioinit,@object          # @_ZStL8__ioinit
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.hidden	__dso_handle
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Elapsed execution time of the loop in test3():\n"
	.size	.L.str, 48

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"sec (N: "
	.size	.L.str.1, 9

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	", I: "
	.size	.L.str.2, 6

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	")\n"
	.size	.L.str.3, 3

	.type	.L.str.4,@object                # @.str.4
.L.str.4:
	.asciz	"r == 0"
	.size	.L.str.4, 7

	.type	.L.str.5,@object                # @.str.5
.L.str.5:
	.asciz	"./fasttime.h"
	.size	.L.str.5, 13

	.type	.L__PRETTY_FUNCTION__._ZL7gettimev,@object # @__PRETTY_FUNCTION__._ZL7gettimev
.L__PRETTY_FUNCTION__._ZL7gettimev:
	.asciz	"fasttime_t gettime()"
	.size	.L__PRETTY_FUNCTION__._ZL7gettimev, 21

	.section	.init_array,"aw",@init_array
	.p2align	3
	.quad	_GLOBAL__sub_I_test3.cpp
	.section	.debug_abbrev,"",@progbits
	.byte	1                               # Abbreviation Code
	.byte	17                              # DW_TAG_compile_unit
	.byte	1                               # DW_CHILDREN_yes
	.byte	37                              # DW_AT_producer
	.byte	14                              # DW_FORM_strp
	.byte	19                              # DW_AT_language
	.byte	5                               # DW_FORM_data2
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	16                              # DW_AT_stmt_list
	.byte	23                              # DW_FORM_sec_offset
	.byte	27                              # DW_AT_comp_dir
	.byte	14                              # DW_FORM_strp
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	85                              # DW_AT_ranges
	.byte	23                              # DW_FORM_sec_offset
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	2                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	3                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	4                               # Abbreviation Code
	.byte	29                              # DW_TAG_inlined_subroutine
	.byte	0                               # DW_CHILDREN_no
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	88                              # DW_AT_call_file
	.byte	11                              # DW_FORM_data1
	.byte	89                              # DW_AT_call_line
	.byte	11                              # DW_FORM_data1
	.byte	87                              # DW_AT_call_column
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	5                               # Abbreviation Code
	.byte	29                              # DW_TAG_inlined_subroutine
	.byte	0                               # DW_CHILDREN_no
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	85                              # DW_AT_ranges
	.byte	23                              # DW_FORM_sec_offset
	.byte	88                              # DW_AT_call_file
	.byte	11                              # DW_FORM_data1
	.byte	89                              # DW_AT_call_line
	.byte	11                              # DW_FORM_data1
	.byte	87                              # DW_AT_call_column
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
	.byte	29                              # DW_TAG_inlined_subroutine
	.byte	0                               # DW_CHILDREN_no
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	88                              # DW_AT_call_file
	.byte	11                              # DW_FORM_data1
	.byte	89                              # DW_AT_call_line
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.short	4                               # DWARF version number
	.long	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	8                               # Address Size (in bytes)
	.byte	1                               # Abbrev [1] 0xb:0xfc DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	33                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	0                               # DW_AT_low_pc
	.long	.Ldebug_ranges2                 # DW_AT_ranges
	.byte	2                               # Abbrev [2] 0x2a:0x5 DW_TAG_subprogram
	.long	.Linfo_string3                  # DW_AT_name
	.byte	2                               # Abbrev [2] 0x2f:0x5 DW_TAG_subprogram
	.long	.Linfo_string4                  # DW_AT_name
	.byte	2                               # Abbrev [2] 0x34:0x5 DW_TAG_subprogram
	.long	.Linfo_string5                  # DW_AT_name
	.byte	2                               # Abbrev [2] 0x39:0x5 DW_TAG_subprogram
	.long	.Linfo_string6                  # DW_AT_name
	.byte	3                               # Abbrev [3] 0x3e:0xa2 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.long	.Linfo_string8                  # DW_AT_name
	.byte	4                               # Abbrev [4] 0x4f:0x14 DW_TAG_inlined_subroutine
	.long	42                              # DW_AT_abstract_origin
	.quad	.Ltmp0                          # DW_AT_low_pc
	.long	.Ltmp1-.Ltmp0                   # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	11                              # DW_AT_call_line
	.byte	22                              # DW_AT_call_column
	.byte	5                               # Abbrev [5] 0x63:0xc DW_TAG_inlined_subroutine
	.long	42                              # DW_AT_abstract_origin
	.long	.Ldebug_ranges0                 # DW_AT_ranges
	.byte	1                               # DW_AT_call_file
	.byte	17                              # DW_AT_call_line
	.byte	22                              # DW_AT_call_column
	.byte	5                               # Abbrev [5] 0x6f:0xc DW_TAG_inlined_subroutine
	.long	47                              # DW_AT_abstract_origin
	.long	.Ldebug_ranges1                 # DW_AT_ranges
	.byte	1                               # DW_AT_call_file
	.byte	19                              # DW_AT_call_line
	.byte	21                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0x7b:0x14 DW_TAG_inlined_subroutine
	.long	52                              # DW_AT_abstract_origin
	.quad	.Ltmp6                          # DW_AT_low_pc
	.long	.Ltmp7-.Ltmp6                   # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	20                              # DW_AT_call_line
	.byte	13                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0x8f:0x14 DW_TAG_inlined_subroutine
	.long	57                              # DW_AT_abstract_origin
	.quad	.Ltmp7                          # DW_AT_low_pc
	.long	.Ltmp8-.Ltmp7                   # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	21                              # DW_AT_call_line
	.byte	5                               # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0xa3:0x14 DW_TAG_inlined_subroutine
	.long	52                              # DW_AT_abstract_origin
	.quad	.Ltmp8                          # DW_AT_low_pc
	.long	.Ltmp9-.Ltmp8                   # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	21                              # DW_AT_call_line
	.byte	17                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0xb7:0x14 DW_TAG_inlined_subroutine
	.long	52                              # DW_AT_abstract_origin
	.quad	.Ltmp10                         # DW_AT_low_pc
	.long	.Ltmp11-.Ltmp10                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	21                              # DW_AT_call_line
	.byte	36                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0xcb:0x14 DW_TAG_inlined_subroutine
	.long	52                              # DW_AT_abstract_origin
	.quad	.Ltmp12                         # DW_AT_low_pc
	.long	.Ltmp13-.Ltmp12                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	21                              # DW_AT_call_line
	.byte	52                              # DW_AT_call_column
	.byte	0                               # End Of Children Mark
	.byte	2                               # Abbrev [2] 0xe0:0x5 DW_TAG_subprogram
	.long	.Linfo_string7                  # DW_AT_name
	.byte	6                               # Abbrev [6] 0xe5:0x21 DW_TAG_subprogram
	.quad	.Lfunc_begin1                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	7                               # Abbrev [7] 0xf2:0x13 DW_TAG_inlined_subroutine
	.long	224                             # DW_AT_abstract_origin
	.quad	.Ltmp15                         # DW_AT_low_pc
	.long	.Ltmp16-.Ltmp15                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	0                               # DW_AT_call_line
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.quad	.Ltmp2
	.quad	.Ltmp3
	.quad	.Ltmp4
	.quad	.Ltmp5
	.quad	0
	.quad	0
.Ldebug_ranges1:
	.quad	.Ltmp3
	.quad	.Ltmp4
	.quad	.Ltmp5
	.quad	.Ltmp6
	.quad	0
	.quad	0
.Ldebug_ranges2:
	.quad	.Lfunc_begin0
	.quad	.Lfunc_end0
	.quad	.Lfunc_begin1
	.quad	.Lfunc_end1
	.quad	0
	.quad	0
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 11.0.0-2~ubuntu20.04.1" # string offset=0
.Linfo_string1:
	.asciz	"test3.cpp"                     # string offset=44
.Linfo_string2:
	.asciz	"/home/312551080/HW1/part2"     # string offset=54
.Linfo_string3:
	.asciz	"gettime"                       # string offset=80
.Linfo_string4:
	.asciz	"tdiff"                         # string offset=88
.Linfo_string5:
	.asciz	"operator<<<std::char_traits<char> >" # string offset=94
.Linfo_string6:
	.asciz	"operator<<"                    # string offset=130
.Linfo_string7:
	.asciz	"__cxx_global_var_init"         # string offset=141
.Linfo_string8:
	.asciz	"test3"                         # string offset=163
	.ident	"Ubuntu clang version 11.0.0-2~ubuntu20.04.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym _GLOBAL__sub_I_test3.cpp
	.addrsig_sym _ZStL8__ioinit
	.addrsig_sym __dso_handle
	.addrsig_sym _ZSt4cout
	.section	.debug_line,"",@progbits
.Lline_table_start0:
