if exists('b:current_syntax')
    finish
endif

syn match nftSetDelimiter contained /,/
hi def link nftSetDelimiter Delimiter
hi def link nftSetBraces Special

syn match nftSyntaxError /\S\+/ contained
hi def link nftSyntaxError Error
syn region nftStatement contained skip=/\\\(;\|\_$\)/ start=/./ matchgroup=nftStatementEnd end=/\(;\|\_$\)/

syn match nftIPv4Addr /\<\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}\>/
syn match nftIPv6Addr /[a-fA-F0-9:]*::[a-fA-F0-9:.]*/
syn match nftIPv6Addr /[a-fA-F0-9:]\+:[a-fA-F0-9:]\+:[a-fA-F0-9:.]\+/
syn match nftBadIPv6Addr /[a-fA-F0-9:]*:::[a-fA-F0-9:.]*/
syn match nftBadIPv6Addr /[a-fA-F0-9:]*::[a-fA-F0-9:]*::[a-fA-F0-9:.]*/
syn match nftCIDRMask /\/\d\+/
hi def link nftIPv4Addr Constant
hi def link nftIPv6Addr Constant
hi def link nftBadIPv6Addr Error
hi def link nftCIDRMask Operator

syn match nftNumber contained /\<\d\+\>/
syn match nftPortNumber contained /\<\d\+\>/
syn match nftPortRange contained /\<\d\+-\d\+\>/
syn match nftInetServiceName contained /[^[:space:]{},]\+/
syn match nftInetService contained /[^[:space:]{},]\+/ contains=nftInetServiceName,nftPortNumber,nftPortRange
syn region nftInetServiceSet contained contains=nftInetService,nftSetDelimiter,nftVarRef matchgroup=nftSetBraces start=/{/ end=/}/
hi def link nftInetServiceName Constant
hi def link nftNumber Number
hi def link nftPortNumber Number
hi def link nftPortRange Number

syn match nftInterfaceName contained /\<[[:alnum:]\.@_+-]\+\>/ contains=nftInterfaceWildcard,nftInterfaceLoopback
syn match nftInterfaceWildcard contained /+/
syn match nftInterfaceLoopback contained /\<lo\>/
hi def link nftInterfaceName Constant
hi def link nftInterfaceWildcard Bold
hi def link nftInterfaceLoopback Bold

syn match nftName /[A-Za-z][A-Za-z0-9_-]*/ contained
syn match nftVarName /[a-zA-Z][a-zA-Z0-9_]*/ contained
syn match nftMapName /[a-zA-Z][a-zA-Z0-9_-]*/ contained
syn match nftVarRefOp /\$/ contained transparent nextgroup=nftSyntaxError,nftVarName
syn match nftVarRef /\$\S*/ contains=nftVarRefOp
syn match nftMapRefOp /@/ contained nextgroup=nftSyntaxError,nftName
syn match nftMapRef /@\S*/ contains=nftMapRefOp
syn match nftVarAssign /\S\+\ze\s*=/ contained contains=nftVarName
syn keyword nftDefine undefine
syn match nftDefine /^\s*\zs\(re\|\)define\ze\s/ skipwhite nextgroup=nftSyntaxError,nftVarName,nftVarAssign
"syn region nftSetMap start=/{/ end=/}/ contained contains=nftSetItem,nftMapItem
"syn region nftSetItem start=/\s*\zs[^,]\+/ end=/,/ contained contains=ALL
"syn region nftMapItem start=/\s*\zs[^:]\+:/ end=/[,}]/ contained contains=ALL
"syn keyword nftType limit set map vmap
syn keyword Todo TODO FIXME TBD containedin=Comment contained
syn match nftNAT /[sd]nat\s\+to/
syn match nftNAT /[sd]nat\s\+\w\+\s\+to/
hi def link nftDefine Define
hi def link nftVarAssign Identifier
hi def link nftVarRef Identifier
hi def link nftName Identifier
hi def link nftVarName Identifier
hi def link nftMapName Identifier
hi def link nftMapRef Identifier
hi def link nftNAT Special

syn keyword nftAddrFam ip ip6 inet arp bridge netdev
syn keyword nftPriority raw mangle dstnat filter security out srcnat contained
syn keyword nftVerdict accept drop queue continue return masquerade
syn keyword nftVerdict jump goto skipwhite nextgroup=nftSyntaxError,nftName,nftVarRef
syn keyword nftVerdict reject skipwhite nextgroup=nftRejectWith
syn keyword nftRejectWith contained with skipwhite nextgroup=nftRejectWithArg
syn keyword nftRejectWithArg contained tcp skipwhite nextgroup=nftSyntaxError,nftRejectWithTcp
syn keyword nftRejectWithTcp contained reset
syn keyword nftRejectWithArg contained icmpx skipwhite nextgroup=nftSyntaxError,nftNumber,nftRejectWithICMPx
syn match nftRejectWithICMPx contained /\<no-route\>/
syn match nftRejectWithICMPx contained /\<port-unreachable\>/
syn match nftRejectWithICMPx contained /\<host-unreachable\>/
syn match nftRejectWithICMPx contained /\<admin-prohibited\>/
hi def link nftAddrFam Identifier
hi def link nftVerdict Keyword
hi def link nftRejectWith Special
hi def link nftRejectWithArg Type
hi def link nftRejectWithTcp Special
hi def link nftRejectWithICMPx Special

syn keyword nftLog log skipwhite nextgroup=nftLogArg
syn keyword nftLogArg contained prefix skipwhite nextgroup=nftLogPrefix,nftVarRef
syn region nftLogPrefix contained start=/"/ skip=/\\"/ end=/"/ skipwhite nextgroup=nftLogArg
syn keyword nftLogArg contained level skipwhite nextgroup=nftSyntaxError,nftLogLevel
syn keyword nftLogLevel contained emerg alert crit err warn notice info debug skipwhite nextgroup=nftLogArg
syn keyword nftLogArg contained flags skipwhite nextgroup=nftLogFlags
syn match nftLogFlags contained /\S\+/ skipwhite nextgroup=nftLogArg
syn keyword nftLogLevel contained audit skipwhite nextgroup=nftLogNoMoreArgs
syn keyword nftLogNoMoreArgs contained prefix group level snaplen flags
hi def link nftLogNoMoreArgs Error
hi def link nftLog Keyword
hi def link nftLogArg Type
hi def link nftLogPrefix String

syn match nftICMPv4Type contained /\<echo-reply\>/
syn match nftICMPv4Type contained /\<destination-unreachable\>/
syn match nftICMPv4Type contained /\<source-quench\>/
syn match nftICMPv4Type contained /\<redirect\>/
syn match nftICMPv4Type contained /\<echo-request\>/
syn match nftICMPv4Type contained /\<router-advertisement\>/
syn match nftICMPv4Type contained /\<router-solicitation\>/
syn match nftICMPv4Type contained /\<time-exceeded\>/
syn match nftICMPv4Type contained /\<parameter-problem\>/
syn match nftICMPv4Type contained /\<timestamp-request\>/
syn match nftICMPv4Type contained /\<timestamp-reply\>/
syn match nftICMPv4Type contained /\<info-request\>/
syn match nftICMPv4Type contained /\<info-reply\>/
syn match nftICMPv4Type contained /\<address-mask-request\>/
syn match nftICMPv4Type contained /\<address-mask-reply\>/

syn match nftICMPv6Type contained /\<destination-unreachable\>/
syn match nftICMPv6Type contained /\<packet-too-big\>/
syn match nftICMPv6Type contained /\<time-exceeded\>/
syn match nftICMPv6Type contained /\<parameter-problem\>/
syn match nftICMPv6Type contained /\<echo-request\>/
syn match nftICMPv6Type contained /\<echo-reply\>/
syn match nftICMPv6Type contained /\<mld-listener-query\>/
syn match nftICMPv6Type contained /\<mld-listener-report\>/
syn match nftICMPv6Type contained /\<mld-listener-done\>/
syn match nftICMPv6Type contained /\<mld-listener-reduction\>/
syn match nftICMPv6Type contained /\<nd-router-solicit\>/
syn match nftICMPv6Type contained /\<nd-router-advert\>/
syn match nftICMPv6Type contained /\<nd-neighbor-solicit\>/
syn match nftICMPv6Type contained /\<nd-neighbor-advert\>/
syn match nftICMPv6Type contained /\<nd-redirect\>/
syn match nftICMPv6Type contained /\<router-renumbering\>/
syn match nftICMPv6Type contained /\<ind-neighbor-solicit\>/
syn match nftICMPv6Type contained /\<ind-neighbor-advert\>/
syn match nftICMPv6Type contained /\<mld2-listener-report\>/

syn cluster nftICMPxTypes contains=nftICMPv4Type,nftICMPv6Type
hi def link nftICMPv4Type Constant
hi def link nftICMPv6Type Constant

syn keyword nftCt ct skipwhite nextgroup=nftSyntaxError,nftCtType
syn keyword nftCtType contained state direction status mark expiration helper label count id
syn keyword nftCtType contained original reply l3proto protocol bytes packets avgpkt zone ip ip6 saddr daddr
syn match nftCtType contained /\<proto-src\>/
syn match nftCtType contained /\<proto-dst\>/
syn keyword nftCtType contained state skipwhite nextgroup=nftSyntaxError,nftNumber,nftCtState,nftCtStateSet,nftMapRef,nftVarRef
syn keyword nftCtType contained status skipwhite nextgroup=nftSyntaxError,nftNumber,nftCtStatus,nftCtStatusSet,nftMapRef,nftVarRef
syn keyword nftCtState contained invalid established related new untracked
syn region nftCtStateSet contained contains=nftCtState,nftVarRef matchgroup=nftSetBraces start=/{/ end=/}/
syn keyword nftCtDir contained original reply
syn keyword nftCtStatus contained expected assured confirmed snat dnat dying helper offload
syn match nftCtStatus contained /\<seen-reply\>/
syn match nftCtStatus contained /\<seq-adjust\>/
syn match nftCtStatus contained /\<[sd]nat-done\>/
syn match nftCtStatus contained /\<hw-offload\>/
syn match nftCtStatus contained /\<fixed-timeout\>/
syn region nftCtStatusSet contained contains=nftCtStatus,nftVarRef matchgroup=nftSetBraces start=/{/ end=/}/
hi def link nftCt Keyword
hi def link nftCtType Type
hi def link nftCtDir Constant
hi def link nftCtState Constant
hi def link nftCtStatus Constant

syn keyword nftSetSpec type typeof flags timeout elements size policy
syn match nftSetSpec /\<gc-interval\>/
syn match nftSetSpec /\<auto-merge\>/

syn region Comment start=/#/ end=/$/
syn region String start=/"/ skip=/\\"/ end=/"/
syn region nftCommentStmt start=/\<comment\s/ end=/;/ contains=nftCommentString
syn region nftCommentString contained start=/"/ skip=/\\"/ end=/"/
hi def link nftCommentString Comment
syn keyword nftFlush flush skipwhite nextgroup=nftFlushType
syn keyword nftFlushType ruleset table chain map set contained
hi def link nftFlush Macro
hi def link nftFlushType Macro
syn keyword Type ether vlan arp ip icmp igmp ip6 icmpv6 tcp udp udplite sctp dccp ah esp comp icmpx
syn keyword Constant prerouting input forward output postrouting

syn keyword Special masquerade redirect
"syn keyword Keyword continue return jump goto
"syn keyword Keyword counter log limit
"syn keyword Define define
syn keyword Include include

"syn keyword nftLimit limit skipwhite nextgroup=nftLimitMod
"syn keyword nftLimitMod contained name over
"hi def link nftLimit Type
"hi def link nftLimitMod nftLimit

syn keyword nftMeta meta skipwhite nextgroup=nftMetaType
" These meta expressions require the keyword 'meta' in front
syn keyword nftMetaType contained length nfproto l4proto protocol priority
" These meta expressions do not require the keyword 'meta' in front
syn keyword nftMetaType mark iif iifname iiftype oif oiftype skuid skgid nftrace rtclassid ibrname obrname pkttype cpu iifgroup oifgroup cgroup random ipsec iifkind oifkind time hour day
hi def link nftMeta Keyword
hi def link nftMetaType Type
syn keyword nftL4ProtoName contained ip icmp igmp ggp ipv4 st tcp cbt egp igp nvp pup argus emcon xnet chaos udp mux dcn hmp prm rdp irtp netblt dccp idpr xtp ddp il idrp rsvp gre dsr bna esp ah ipv6 sdrp swipe narp mobile tlsp skip cftp kryptolan rvd ippc visa ipcv cpnx cphb wsn pvp vmtp vines ttp dgp tcf eigrp ospf larp mtp ipip micp etherip encap gmtp ifmp pnni pim aris scps qnx ipcomp snp vrrp pgm l2tp ddx iatp stp srp uti smp sm ptp isis fire crtp crudp sscopmce iplt sps pipe sctp fc udplite manet hip shim6 wesp rohc ethernet aggfrag nsh homa
syn match nftL4ProtoName contained /\<secure-vmtp>/
syn match nftL4ProtoName contained /\<sat-mon>/
syn match nftL4ProtoName contained /\<sat-expak>/
syn match nftL4ProtoName contained /\<ipv6-route>/
syn match nftL4ProtoName contained /\<ipv6-frag>/
syn match nftL4ProtoName contained /\<bbn-rcc>/
syn match nftL4ProtoName contained /\<xns-idp>/
syn match nftL4ProtoName contained /\<trunk-1>/
syn match nftL4ProtoName contained /\<trunk-2>/
syn match nftL4ProtoName contained /\<leaf-1>/
syn match nftL4ProtoName contained /\<leaf-2>/
syn match nftL4ProtoName contained /\<iso-tp4>/
syn match nftL4ProtoName contained /\<mfe-nsp>/
syn match nftL4ProtoName contained /\<merit-inp>/
syn match nftL4ProtoName contained /\<idpr-cmtp>/
syn match nftL4ProtoName contained /\<3pc>/
syn match nftL4ProtoName contained /\<tp++>/
syn match nftL4ProtoName contained /\<i-nlsp>/
syn match nftL4ProtoName contained /\<ipv6-icmp>/
syn match nftL4ProtoName contained /\<ipv6-nonxt>/
syn match nftL4ProtoName contained /\<ipv6-opts>/
syn match nftL4ProtoName contained /\<br-sat-mon>/
syn match nftL4ProtoName contained /\<sun-nd>/
syn match nftL4ProtoName contained /\<wb-mon>/
syn match nftL4ProtoName contained /\<wb-expak>/
syn match nftL4ProtoName contained /\<iso-ip>/
syn match nftL4ProtoName contained /\<nsfnet-igp>/
syn match nftL4ProtoName contained /\<sprite-rpc>/
syn match nftL4ProtoName contained /\<ax.25>/
syn match nftL4ProtoName contained /\<scc-sp>/
syn match nftL4ProtoName contained /\<a\/n>/
syn match nftL4ProtoName contained /\<compaq-peer>/
syn match nftL4ProtoName contained /\<ipx-in-ip>/
syn match nftL4ProtoName contained /\<rsvp-e2e-ignore>/
syn match nftL4ProtoName contained /\<mobility-header>/
syn match nftL4ProtoName contained /\<mpls-in-ip>/
syn match nftL4ProtoName contained /\<bit-emu>/

syn keyword nftMetaType iif iifname iifgroup oif oifname oifgroup skipwhite nextgroup=nftInterfaceName

syn keyword nftMetaType contained l4proto skipwhite nextgroup=nftL4ProtoName,nftL4ProtoSet,nftVarRef,nftMapRef
syn match nftL4ProtoArg contained /\<\S\+\s/ contains=nftSyntaxError,nftL4ProtoName skipwhite nextgroup=nftL4ProtoTransportHeader
syn region nftL4ProtoSet contained contains=nftSetDelimiter,nftL4ProtoName,nftVarRef matchgroup=nftSetBraces start=/{/ end=/}/ skipwhite nextgroup=nftL4ProtoTransportHeader
hi def link nftL4ProtoName Constant
syn keyword nftL4ProtoTransportHeader contained th skipwhite nextgroup=nftTransportHeaderArg
hi def link nftL4ProtoTransportHeader Type
syn keyword nftTransportHeaderArg contained dport sport skipwhite nextgroup=nftSyntaxError,nftInetService,nftInetServiceSet,nftVarRef,nftMapRef
hi def link nftTransportHeaderArg Type

syn keyword nftNFProtoName contained ipv4 ipv6
syn keyword nftMetaType contained nfproto skipwhite nextgroup=nftNFProtoName,nftNFProtoSet,nftVarRef,nftMapRef
syn region nftNFProtoSet contained contains=nftSetDelimiter,nftNFProtoName,nftVarRef matchgroup=nftSetBraces start=/{/ end=/}/
hi def link nftNFProtoName Constant

syn keyword nftPktTypeName contained host broadcast multicast other
syn region nftPktTypeSet contained contains=nftSetDelimiter,nftPktTypeName,nftVarRef matchgroup=nftSetBraces start=/{/ end=/}/
syn keyword nftMetaType pkttype skipwhite nextgroup=nftPktTypeName,nftPktTypeSet,nftMapRef,nftVarRef
hi def link nftPktTypeName Constant

syn keyword nftEther ether skipwhite nextgroup=nftSyntaxError,nftEtherArg
syn keyword nftEtherArg contained daddr saddr type
hi def link nftEther Keyword
hi def link nftEtherArg Type

syn keyword nftVLAN vlan skipwhite nextgroup=nftSyntaxError,nftVLANArg
syn keyword nftVLANArg contained id dei pcp type
hi def link nftVLAN Keyword
hi def link nftVLANArg Type

syn keyword nftARP arp skipwhite nextgroup=nftSyntaxError,nftARPArg
syn keyword nftARPArg contained htype ptype hlen plen operation
syn keyword nftARPArg contained saddr daddr skipwhite nextgroup=nftSyntaxError,nftARPAddrFam
syn keyword nftARPAddrFam contained ip ether
hi def link nftARP Keyword
hi def link nftARPArg Type
hi def link nftARPAddrFam nftARPArg

syn cluster nftL4Expressions contains=nftUDP,nftTCP,nftUDPLite,nftSCTP

syn keyword nftIPv4 ip skipwhite nextgroup=nftSyntaxError,@nftL4Expressions,nftIPv4Arg
syn keyword nftIPv4Arg contained version hdrlength dscp ecn length id ttl protocol checksum saddr daddr
syn match nftIPv4Arg contained /\<frag-off\>/
hi def link nftIPv4 Keyword
hi def link nftIPv4Arg Type

syn keyword nftICMPv4 icmp skipwhite nextgroup=nftSyntaxError,nftICMPv4Arg
syn keyword nftICMPv4Arg contained type code checksum id sequence gateway mtu
syn keyword nftICMPv4Arg contained type skipwhite nextgroup=nftSyntaxError,nftICMPv4Type,nftICMPv4TypeSet,nftVarRef,nftMapRef
syn region nftICMPv4TypeSet contained contains=nftSetDelimiter,nftICMPv4Type,nftVarRef matchgroup=nftSetBraces start=/{/ end=/}/
hi def link nftICMPv4 Keyword
hi def link nftICMPv4Arg Type

syn keyword nftIGMP igmp skipwhite nextgroup=nftSyntaxError,nftIGMPArg
syn keyword nftIGMPArg contained type mrt checksum group
hi def link nftIGMP Keyword
hi def link nftIGMPArg Type

syn keyword nftIPv6 ip6 skipwhite nextgroup=nftSyntaxError,@nftL4Expressions,nftIPv6Arg
syn keyword nftIPv6Arg contained version dscp ecn flowlabel length nexthdr hoplimit saddr daddr
hi def link nftIPv6 Keyword
hi def link nftIPv6Arg Type

syn keyword nftICMPv6 icmpv6 skipwhite nextgroup=nftSyntaxError,nftICMPv6Arg
syn keyword nftICMPv6Arg contained code checksum id sequence taddr daddr
syn match nftICMPv6Arg contained /\<parameter-problem\>/
syn match nftICMPv6Arg contained /\<packet-too-big\>/
syn match nftICMPv6Arg contained /\<max-delay\>/
syn keyword nftICMPv6Arg contained type skipwhite nextgroup=nftSyntaxError,nftICMPv6Type,nftICMPv6TypeSet,nftVarRef,nftMapRef
syn region nftICMPv6TypeSet contained contains=nftSetDelimiter,nftICMPv6Type,nftVarRef matchgroup=nftSetBraces start=/{/ end=/}/
hi def link nftICMPv6 Keyword
hi def link nftICMPv6Arg Type
"hi def link nftICMPv6TypeSet Error

syn keyword nftTCP tcp skipwhite nextgroup=nftSyntaxError,nftTCPArg
syn keyword nftTCPArg contained sport dport sequence ackseq doff reserved flags window checksum urgptr
syn keyword nftTCPArg contained dport sport skipwhite nextgroup=nftSyntaxError,nftInetService,nftInetServiceSet,nftVarRef,nftMapRef
hi def link nftTCP Keyword
hi def link nftTCPArg Type


syn keyword nftUDP udp skipwhite nextgroup=nftSyntaxError,nftUDPArg
syn keyword nftUDPArg contained sport dport length checksum
syn keyword nftUDPArg contained dport sport skipwhite nextgroup=nftSyntaxError,nftInetService,nftInetServiceSet,nftVarRef,nftMapRef
hi def link nftUDP Keyword
hi def link nftUDPArg Type

syn keyword nftUDPLite udplite skipwhite nextgroup=nftSyntaxError,nftUDPLiteArg
syn keyword nftUDPLiteArg contained sport dport checksum
syn keyword nftUDPLiteArg contained dport sport skipwhite nextgroup=nftSyntaxError,nftInetService,nftInetServiceSet,nftVarRef,nftMapRef
hi def link nftUDPLite Keyword
hi def link nftUDPLiteArg Type

syn keyword nftSCTP sctp skipwhite nextgroup=nftSyntaxError,nftSCTPArg
syn keyword nftSCTPArg contained sport dport vtag checksum
syn keyword nftSCTPArg contained chunk skipwhite nextgroup=nftSCTPChunk
syn keyword nftSCTPArg contained dport sport skipwhite nextgroup=nftSyntaxError,nftInetService,nftInetServiceSet,nftVarRef,nftMapRef
syn keyword nftSCTPChunk contained data init sack heartbeat abort shutdown error ecne cwr asconf
syn match nftSCTPChunk contained /\<init-ack\>/
syn match nftSCTPChunk contained /\<heartbeat-ack\>/
syn match nftSCTPChunk contained /\<cookie-echo\>/
syn match nftSCTPChunk contained /\<cookie-ack\>/
syn match nftSCTPChunk contained /\<shutdown-complete\>/
syn match nftSCTPChunk contained /\<asconf-ack\>/
syn match nftSCTPChunk contained /\<forward-tsn\>/
hi def link nftSCTP Keyword
hi def link nftSCTPArg Type
" TODO sctp fields

syn keyword nftDCCP dccp skipwhite nextgroup=nftSyntaxError,nftDCCPArg
syn keyword nftDCCPArg contained sport dport type
hi def link nftDCCP Keyword
hi def link nftDCCPArg Type

syn keyword nftAH ah skipwhite nextgroup=nftSyntaxError,nftAHArg
syn keyword nftAHArg contained nexthdr hdrlength reserved spi sequence
hi def link nftAH Keyword
hi def link nftAHArg Type

syn keyword nftESP esp skipwhite nextgroup=nftSyntaxError,nftESPArg
syn keyword nftESPArg contained spi sequence
hi def link nftESP Keyword
hi def link nftESPArg Type

syn keyword nftIPComp ipcomp skipwhite nextgroup=nftSyntaxError,nftIPCompArg
syn keyword nftIPCompArg contained nexthdr flags cpi
hi def link nftIPComp Keyword
hi def link nftIPCompArg Type

syn keyword nftGRE gre skipwhite nextgroup=nftSyntaxError,nftIPv4,nftIPv6,nftGREArg
syn keyword nftGREArg contained flags version protocol
hi def link nftGRE Keyword
hi def link nftGREArg Type

syn keyword nftTunnel geneve gretap vxlan skipwhite nextgroup=nftSyntaxError,nftEther,nftVLAN,nftIPv4,nftIPv6,nftTCP,nftUDP,nftTunnelArg
syn keyword nftTunnelArg contained vni flags
hi def link nftTunnel Keyword
hi def link nftTunnelArg Type

syn keyword nftTableBegin table skipwhite nextgroup=nftSyntaxError,nftTableName,nftTableAddrFam
syn keyword nftTableAddrFam ip ip6 inet arp bridge netdev contained skipwhite nextgroup=nftSyntaxError,nftTableName
syn match nftTableName /[A-Za-z][A-Za-z0-9_-]*/ contained skipwhite nextgroup=nftSyntaxError,nftTableBlock
syn match nftTableBlock /{/ contained
hi def link nftTableAddrFam Type
hi def link nftTableName Identifier
hi def link nftTableBegin Operator

syn keyword nftChainBegin chain skipwhite nextgroup=nftSyntaxError,nftChainName
syn match nftChainName /[A-Za-z][A-Za-z0-9_-]*/ contained skipwhite nextgroup=nftSyntaxError,nftChainBlock
syn match nftChainBlock /{/ contained skipwhite skipempty nextgroup=nftChainStmt
syn keyword nftChainStmt contained type skipwhite nextgroup=nftSyntaxError,nftChainType
syn keyword nftChainType contained filter nat route skipwhite nextgroup=nftSyntaxError,nftChainStmt
syn keyword nftChainStmt contained hook skipwhite nextgroup=nftSyntaxError,nftHook
syn keyword nftHook contained prerouting input forward output postrouting ingress egress skipwhite nextgroup=nftSyntaxError,nftChainStmt
syn keyword nftChainStmt contained priority skipwhite nextgroup=nftPriorityValue
syn match nftPriorityValue contained /-\?\d\+/ skipwhite nextgroup=nftSyntaxError,nftChainStmt
syn keyword nftPriorityValue contained raw mangle dstnat filter security out srcnat skipwhite nextgroup=nftChainStmt,nftPriorityOffset
syn match nftPriorityOffset contained /\s*[+-]\s*\d\+/ skipwhite nextgroup=nftSyntaxError,nftChainStmt
syn match nftChainStmt contained /;/he=s skipwhite nextgroup=nftPolicyStmt
syn keyword nftPolicyStmt contained policy skipwhite nextgroup=nftSyntaxError,nftPolicyValue
syn keyword nftPolicyValue contained accept drop
hi def link nftChainStmt Keyword
hi def link nftChainType Constant
hi def link nftHook Constant
hi def link nftPriorityValue Constant
hi def link nftPriorityOffset nftPriorityValue
hi def link nftPolicyStmt Keyword
hi def link nftPolicyValue Constant
hi def link nftChainName Identifier
hi def link nftChainBegin Operator

syn region nftLimitRateStmt contained start=/\<rate\>/ end=/\ze;/ keepend contains=nftSyntaxError,nftLimitRateOp,nftVarRef
syn keyword nftLimitRateOp contained rate skipwhite nextgroup=nftSyntaxError,nftRateExpr,nftLimitRateMod
syn keyword nftLimitRateMod contained over skipwhite nextgroup=nftSyntaxError,nftRateExpr
syn match nftRateExpr contained /\d\+/ skipwhite nextgroup=nftSyntaxError,nftRateUnit,nftRatePerUnit
syn keyword nftByteUnit contained bytes kbytes mbytes
syn match nftRateUnit contained /\w\+/ contains=nftSyntaxError,nftByteUnit skipwhite nextgroup=nftTimeUnit
syn match nftRatePerUnit contained /\// skipwhite nextgroup=nftTimeUnit
syn keyword nftTimeUnit contained second minute hour day
hi def link nftLimitRateOp Operator
hi def link nftLimitRateMod nftRateOp
hi def link nftRateExpr Constant
hi def link nftRatePerUnit Operator
hi def link nftTimeUnit Type
hi def link nftByteUnit Type

syn keyword nftCounter counter skipwhite nextgroup=nftCounterNameOp
syn keyword nftCounterNameOp contained name skipwhite nextgroup=nftCounterName
syn match nftCounterName /\S\+/ contained contains=nftSyntaxError,nftName,nftVarRef
hi def link nftCounter Keyword
hi def link nftCounterNameOp Type
hi def link nftCounterName Identifier

syn keyword nftNamedSetBegin set skipwhite nextgroup=nftSyntaxError,nftNamedSetName
syn match nftNamedSetName /[A-Za-z][A-Za-z0-9_-]*/ contained skipwhite nextgroup=nftSyntaxError,nftNamedSetBlock
syn match nftNamedSetBlock /{/ contained
hi def link nftNamedSetAddrFam Type
hi def link nftNamedSetName Identifier
hi def link nftNamedSetBegin Operator

syn region nftNamedLimitBlock contained matchgroup=nftNamedLimitBlockOpen start=/{/ matchgroup=nftNamedLimitBlockClose end=/}/ fold transparent contains=nftLimitRateStmt,nftCommentStmt
syn match nftNamedLimitDef /\<limit\ze\s.*{/ skipwhite nextgroup=nftSyntaxError,nftNamedLimitName
"syn keyword nftNamedLimitBegin contained limit skipwhite nextgroup=nftSyntaxError,nftNamedLimitName
syn match nftNamedLimitName /[A-Za-z][A-Za-z0-9_-]*/ contained skipwhite nextgroup=nftSyntaxError,nftNamedLimitBlock
"syn match nftNamedLimitBlock /{/ contained
hi def link nftNamedLimitName Identifier
hi def link nftNamedLimitDef Operator

syn match nftColorRed /\<red\>/
hi def nftColorRed ctermfg=Red cterm=underline
syn match nftColorYellow /\<yellow\>/
hi def nftColorYellow ctermfg=Yellow cterm=underline
syn match nftColorGreen /\<green\>/
hi def nftColorGreen ctermfg=Green cterm=underline
syn match nftColorBlue /\<blue\>/
hi def nftColorBlue ctermfg=Blue cterm=underline

let b:current_syntax = 'nftables'
