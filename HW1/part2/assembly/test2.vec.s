	.text
	.file	"test2.cpp"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3                               # -- Begin function _Z5test2PfS_S_i
.LCPI0_0:
	.quad	0x3e112e0be826d695              # double 1.0000000000000001E-9
	.text
	.globl	_Z5test2PfS_S_i
	.p2align	4, 0x90
	.type	_Z5test2PfS_S_i,@function
_Z5test2PfS_S_i:                        # @_Z5test2PfS_S_i
.Lfunc_begin0:
	.file	1 "/home/312551080/HW1/part2" "test2.cpp"
	.loc	1 6 0                           # test2.cpp:6:0
	.cfi_startproc
# %bb.0:
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r13
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	subq	$32, %rsp
	.cfi_def_cfa_offset 80
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r13, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdx, %rbx
	movq	%rsi, %r14
	movq	%rdi, %r15
	leaq	8(%rsp), %rsi
.Ltmp0:
	.file	2 "/home/312551080/HW1/part2" "./fasttime.h"
	.loc	2 74 11 prologue_end            # ./fasttime.h:74:11
	movl	$1, %edi
	callq	clock_gettime
	.loc	2 75 3                          # ./fasttime.h:75:3
	testl	%eax, %eax
	jne	.LBB0_11
# %bb.1:
	.loc	2 78 1                          # ./fasttime.h:78:1
	movq	8(%rsp), %r13
	movq	16(%rsp), %r12
	xorl	%eax, %eax
	jmp	.LBB0_2
.Ltmp1:
	.p2align	4, 0x90
.LBB0_8:                                #   in Loop: Header=BB0_2 Depth=1
	.loc	1 12 27                         # test2.cpp:12:27
	addl	$1, %eax
	.loc	1 12 21 is_stmt 0               # test2.cpp:12:21
	cmpl	$20000000, %eax                 # imm = 0x1312D00
	.loc	1 12 3                          # test2.cpp:12:3
	je	.LBB0_9
.LBB0_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	.loc	1 0 3                           # test2.cpp:0:3
	xorl	%ecx, %ecx
	jmp	.LBB0_3
	.p2align	4, 0x90
.LBB0_7:                                #   in Loop: Header=BB0_3 Depth=2
	.loc	1 14 29 is_stmt 1               # test2.cpp:14:29
	addq	$2, %rcx
	.loc	1 14 23 is_stmt 0               # test2.cpp:14:23
	cmpq	$1024, %rcx                     # imm = 0x400
	.loc	1 14 5                          # test2.cpp:14:5
	je	.LBB0_8
.LBB0_3:                                #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	.loc	1 17 14 is_stmt 1               # test2.cpp:17:14
	movl	(%r15,%rcx,4), %edx
	.loc	1 17 12 is_stmt 0               # test2.cpp:17:12
	movl	%edx, (%rbx,%rcx,4)
	.loc	1 18 11 is_stmt 1               # test2.cpp:18:11
	movss	(%r14,%rcx,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	.loc	1 18 18 is_stmt 0               # test2.cpp:18:18
	movd	%edx, %xmm1
	.loc	1 18 16                         # test2.cpp:18:16
	ucomiss	%xmm1, %xmm0
	.loc	1 18 11                         # test2.cpp:18:11
	jbe	.LBB0_5
# %bb.4:                                #   in Loop: Header=BB0_3 Depth=2
	.loc	1 19 14 is_stmt 1               # test2.cpp:19:14
	movss	%xmm0, (%rbx,%rcx,4)
.LBB0_5:                                #   in Loop: Header=BB0_3 Depth=2
	.loc	1 17 14                         # test2.cpp:17:14
	movl	4(%r15,%rcx,4), %edx
	.loc	1 17 12 is_stmt 0               # test2.cpp:17:12
	movl	%edx, 4(%rbx,%rcx,4)
	.loc	1 18 11 is_stmt 1               # test2.cpp:18:11
	movss	4(%r14,%rcx,4), %xmm0           # xmm0 = mem[0],zero,zero,zero
	.loc	1 18 18 is_stmt 0               # test2.cpp:18:18
	movd	%edx, %xmm1
	.loc	1 18 16                         # test2.cpp:18:16
	ucomiss	%xmm1, %xmm0
	.loc	1 18 11                         # test2.cpp:18:11
	jbe	.LBB0_7
# %bb.6:                                #   in Loop: Header=BB0_3 Depth=2
	.loc	1 19 14 is_stmt 1               # test2.cpp:19:14
	movss	%xmm0, 4(%rbx,%rcx,4)
	jmp	.LBB0_7
.LBB0_9:
	.loc	1 0 14 is_stmt 0                # test2.cpp:0:14
	leaq	8(%rsp), %rsi
.Ltmp2:
	.loc	2 74 11 is_stmt 1               # ./fasttime.h:74:11
	movl	$1, %edi
	callq	clock_gettime
	.loc	2 75 3                          # ./fasttime.h:75:3
	testl	%eax, %eax
	jne	.LBB0_11
# %bb.10:
	.loc	2 78 1                          # ./fasttime.h:78:1
	movq	8(%rsp), %rax
.Ltmp3:
	.loc	2 83 21                         # ./fasttime.h:83:21
	subq	%r13, %rax
.Ltmp4:
	.loc	2 78 1                          # ./fasttime.h:78:1
	movq	16(%rsp), %rcx
.Ltmp5:
	.loc	2 83 56                         # ./fasttime.h:83:56
	subq	%r12, %rcx
	.loc	2 83 10 is_stmt 0               # ./fasttime.h:83:10
	xorps	%xmm0, %xmm0
	cvtsi2sd	%rax, %xmm0
	.loc	2 83 43                         # ./fasttime.h:83:43
	xorps	%xmm1, %xmm1
	cvtsi2sd	%rcx, %xmm1
	.loc	2 83 42                         # ./fasttime.h:83:42
	mulsd	.LCPI0_0(%rip), %xmm1
	.loc	2 83 36                         # ./fasttime.h:83:36
	addsd	%xmm0, %xmm1
	movsd	%xmm1, 24(%rsp)                 # 8-byte Spill
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
	movsd	24(%rsp), %xmm0                 # 8-byte Reload
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
	.loc	1 30 39                         # test2.cpp:30:39
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
	.loc	1 30 55                         # test2.cpp:30:55
	movq	%rbx, %rdi
	movl	$20000000, %esi                 # imm = 0x1312D00
	callq	_ZNSolsEi
.Ltmp12:
	.loc	3 611 2                         # /usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10/ostream:611:2
	movl	$.L.str.3, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp13:
	.loc	1 31 1                          # test2.cpp:31:1
	addq	$32, %rsp
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.LBB0_11:
	.cfi_def_cfa_offset 80
	.loc	1 0 0 is_stmt 0                 # test2.cpp:0:0
	movl	$.L.str.4, %edi
	movl	$.L.str.5, %esi
	movl	$.L__PRETTY_FUNCTION__._ZL7gettimev, %ecx
	movl	$75, %edx
	callq	__assert_fail
.Ltmp14:
.Lfunc_end0:
	.size	_Z5test2PfS_S_i, .Lfunc_end0-_Z5test2PfS_S_i
	.cfi_endproc
                                        # -- End function
	.section	.text.startup,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _GLOBAL__sub_I_test2.cpp
	.type	_GLOBAL__sub_I_test2.cpp,@function
_GLOBAL__sub_I_test2.cpp:               # @_GLOBAL__sub_I_test2.cpp
.Lfunc_begin1:
	.loc	1 0 0 is_stmt 1                 # test2.cpp:0:0
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
	.size	_GLOBAL__sub_I_test2.cpp, .Lfunc_end1-_GLOBAL__sub_I_test2.cpp
	.cfi_endproc
                                        # -- End function
	.type	_ZStL8__ioinit,@object          # @_ZStL8__ioinit
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.hidden	__dso_handle
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Elapsed execution time of the loop in test2():\n"
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
	.quad	_GLOBAL__sub_I_test2.cpp
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
	.byte	26                              # DW_AT_call_line
	.byte	22                              # DW_AT_call_column
	.byte	5                               # Abbrev [5] 0x6f:0xc DW_TAG_inlined_subroutine
	.long	47                              # DW_AT_abstract_origin
	.long	.Ldebug_ranges1                 # DW_AT_ranges
	.byte	1                               # DW_AT_call_file
	.byte	28                              # DW_AT_call_line
	.byte	21                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0x7b:0x14 DW_TAG_inlined_subroutine
	.long	52                              # DW_AT_abstract_origin
	.quad	.Ltmp6                          # DW_AT_low_pc
	.long	.Ltmp7-.Ltmp6                   # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	29                              # DW_AT_call_line
	.byte	13                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0x8f:0x14 DW_TAG_inlined_subroutine
	.long	57                              # DW_AT_abstract_origin
	.quad	.Ltmp7                          # DW_AT_low_pc
	.long	.Ltmp8-.Ltmp7                   # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	30                              # DW_AT_call_line
	.byte	13                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0xa3:0x14 DW_TAG_inlined_subroutine
	.long	52                              # DW_AT_abstract_origin
	.quad	.Ltmp8                          # DW_AT_low_pc
	.long	.Ltmp9-.Ltmp8                   # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	30                              # DW_AT_call_line
	.byte	25                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0xb7:0x14 DW_TAG_inlined_subroutine
	.long	52                              # DW_AT_abstract_origin
	.quad	.Ltmp10                         # DW_AT_low_pc
	.long	.Ltmp11-.Ltmp10                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	30                              # DW_AT_call_line
	.byte	44                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0xcb:0x14 DW_TAG_inlined_subroutine
	.long	52                              # DW_AT_abstract_origin
	.quad	.Ltmp12                         # DW_AT_low_pc
	.long	.Ltmp13-.Ltmp12                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	30                              # DW_AT_call_line
	.byte	60                              # DW_AT_call_column
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
	.asciz	"test2.cpp"                     # string offset=44
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
	.asciz	"test2"                         # string offset=163
	.ident	"Ubuntu clang version 11.0.0-2~ubuntu20.04.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym _GLOBAL__sub_I_test2.cpp
	.addrsig_sym _ZStL8__ioinit
	.addrsig_sym __dso_handle
	.addrsig_sym _ZSt4cout
	.section	.debug_line,"",@progbits
.Lline_table_start0:
