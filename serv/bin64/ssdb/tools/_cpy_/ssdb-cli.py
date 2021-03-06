# encoding=utf-8
# Generated by cpy
# 2014-12-30 10:04:42.222385
import os, sys
from sys import stdin, stdout

import thread
import re
import time
import socket
import getopt
import shlex
import datetime
from ssdb_cli import importer
from ssdb_cli import util
from ssdb_cli import flushdb
from ssdb_cli import exporter
try:
	pass
	import readline
except Exception , e:
	pass
escape_data = False

def welcome():
	pass
	sys.stderr.write('ssdb (cli) - ssdb command line tool.\n')
	sys.stderr.write('Copyright (c) 2012-2014 ssdb.io\n')
	sys.stderr.write('\n')
	sys.stderr.write("'h' or 'help' for help, 'q' to quit.\n")
	sys.stderr.write('\n')

def show_command_help():
	pass
	print ''
	print '# display ssdb-server status'
	print '    info'
	print '# escape/do not escape response data'
	print '    : escape yes|no'
	print '# export/import'
	print '    export [-i] out_file'
	print '        -i    interactive mode'
	print '    import in_file'
	print ''
	print 'see http://ssdb.io/docs/php/ for commands details'
	print ''
	print 'press \'q\' and Enter to quit.'
	print ''

def usage():
	pass
	print ''
	print 'Usage:'
	print '	ssdb-cli [-h] [HOST] [-p] [PORT]'
	print ''
	print 'Options:'
	print '	-h 127.0.0.1'
	print '		ssdb server hostname/ip address'
	print '	-p 8888'
	print '		ssdb server port'
	print ''
	print 'Examples:'
	print '	ssdb-cli'
	print '	ssdb-cli 8888'
	print '	ssdb-cli 127.0.0.1 8888'
	print '	ssdb-cli -h 127.0.0.1 -p 8888'

def repr_data(s):
	pass
	gs = globals()

	if gs['escape_data']==False:
		pass
		return s
	ret = str(s).encode('string-escape')
	return ret

def timespan(stime):
	pass
	etime = datetime.datetime.now()
	ts = (etime - stime)
	time_consume = (ts.seconds + ts.microseconds / 1000000.)
	return time_consume

def show_version():
	pass
	try:
		pass
		resp = link.request('info', [])
		sys.stderr.write((('server version: ' + resp.data[2]) + '\n\n'))
	except Exception , e:
		pass
host = ''
port = ''
opt = ''
args = []

_cpy_r_0 = _cpy_l_1 = sys.argv[1 : ]
if type(_cpy_r_0).__name__ == 'dict': _cpy_b_3=True; _cpy_l_1=_cpy_r_0.iterkeys()
else: _cpy_b_3=False;
for _cpy_k_2 in _cpy_l_1:
	if _cpy_b_3: arg=_cpy_r_0[_cpy_k_2]
	else: arg=_cpy_k_2
	pass

	if opt=='' and arg.startswith('-'):
		pass
		opt = arg
	else:
		pass

		# {{{ switch: opt
		_continue_1 = False
		while True:
			if False or ((opt) == '-h'):
				pass
				host = arg
				opt = ''
				break
			if False or ((opt) == '-p'):
				pass
				port = arg
				opt = ''
				break
			### default
			args.append(arg)
			break
			break
			if _continue_1:
				continue
		# }}} switch


if host=='':
	pass
	host = '127.0.0.1'

	_cpy_r_4 = _cpy_l_5 = args
	if type(_cpy_r_4).__name__ == 'dict': _cpy_b_7=True; _cpy_l_5=_cpy_r_4.iterkeys()
	else: _cpy_b_7=False;
	for _cpy_k_6 in _cpy_l_5:
		if _cpy_b_7: arg=_cpy_r_4[_cpy_k_6]
		else: arg=_cpy_k_6
		pass

		if not (re.match('^[0-9]+$', args[0])):
			pass
			host = arg
			break

if port=='':
	pass
	port = '8888'

	_cpy_r_8 = _cpy_l_9 = args
	if type(_cpy_r_8).__name__ == 'dict': _cpy_b_11=True; _cpy_l_9=_cpy_r_8.iterkeys()
	else: _cpy_b_11=False;
	for _cpy_k_10 in _cpy_l_9:
		if _cpy_b_11: arg=_cpy_r_8[_cpy_k_10]
		else: arg=_cpy_k_10
		pass

		if re.match('^[0-9]+$', args[0]):
			pass
			port = arg
			break
try:
	pass
	port = int(port)
except Exception , e:
	pass
	sys.stderr.write('Invalid argument port: '%(port))
	usage()
	sys.exit(0)
sys.path.append('./api/python')
sys.path.append('../api/python')
sys.path.append('/usr/local/ssdb/api/python')
from SSDB import SSDB
try:
	pass
	link = SSDB(host, port)
except socket.error , e:
	pass
	sys.stderr.write('Failed to connect to: %s:%d\n'%(host, port))
	sys.stderr.write('Connection error: %s\n'%(str(e)))
	sys.exit(0)
welcome()

if sys.stdin.isatty():
	pass
	show_version()
password = False

while True:
	pass
	line = ''
	c = 'ssdb %s:%s> '%(host, str(port))
	b = sys.stdout
	sys.stdout = sys.stderr
	try:
		pass
		line = raw_input(c)
	except Exception , e:
		pass
		break
	sys.stdout = b

	if line=='':
		pass
		continue
	line = line.strip()

	if (line=='q' or line=='quit'):
		pass
		sys.stderr.write('bye.\n')
		break

	if (line=='h' or line=='help'):
		pass
		show_command_help()
		continue
	try:
		pass
		ps = shlex.split(line)
	except Exception , e:
		pass
		sys.stderr.write('error: %s\n'%(str(e)))
		continue

	if len(ps)==0:
		pass
		continue
	cmd = ps[0].lower()

	if cmd.startswith(':'):
		pass
		ps[0] = cmd[1 : ]
		cmd = ':'
		args = ps
	else:
		pass
		args = ps[1 : ]

	if cmd==':':
		pass
		op = ''

		if len(args)>0:
			pass
			op = args[0]

		if op!='escape':
			pass
			sys.stderr.write("Bad setting!\n")
			continue
		yn = 'yes'

		if len(args)>1:
			pass
			yn = args[1]
		gs = globals()

		if yn=='yes':
			pass
			gs['escape_data'] = True
			sys.stderr.write("  Escape response\n")
		elif (yn=='no' or yn=='none'):
			pass
			gs['escape_data'] = False
			sys.stderr.write("  No escape response\n")
		else:
			pass
			sys.stderr.write("  Usage: escape yes|no\n")
		continue

	if cmd=='v':
		pass
		show_version()
		continue

	if cmd=='auth':
		pass

		if len(args)==0:
			pass
			sys.stderr.write('Usage: auth password\n')
			continue
		password = args[0]

	if cmd=='export':
		pass
		exporter.run(link, args)
		continue

	if cmd=='import':
		pass

		if len(args)<1:
			pass
			sys.stderr.write('Usage: import in_file\n')
			continue
		filename = args[0]
		importer.run(link, filename)
		continue
	try:
		pass

		if cmd=='flushdb':
			pass
			stime = datetime.datetime.now()

			if len(args)==0:
				pass
				flushdb.flushdb(link, '')
			else:
				pass
				flushdb.flushdb(link, args[0])
			sys.stderr.write('(%.3f sec)\n'%(timespan(stime)))
			continue
	except Exception , e:
		pass
		sys.stderr.write((("error! - " + str(e)) + "\n"))
		continue
	retry = 0
	max_retry = 5
	stime = datetime.datetime.now()

	while True:
		pass
		stime = datetime.datetime.now()
		resp = link.request(cmd, args)

		if resp.code=='disconnected':
			pass
			link.close()
			time.sleep(retry)
			retry += 1

			if retry>max_retry:
				pass
				sys.stderr.write('cannot connect to server, give up...\n')
				break
			sys.stderr.write('[%d/%d] reconnecting to server... '%(retry, max_retry))
			try:
				pass
				link = SSDB(host, port)
				sys.stderr.write('done.\n')
			except socket.error , e:
				pass
				sys.stderr.write('Connect error: %s\n'%(str(e)))
				continue
			sys.stderr.write('\n')

			if password:
				pass
				ret = link.request('auth', [password])
		else:
			pass
			break
	time_consume = timespan(stime)

	if not (resp.ok()):
		pass

		if resp.not_found():
			pass
			sys.stderr.write('not_found\n')
		else:
			pass
			s = resp.code

			if resp.message:
				pass
				s += (': ' + resp.message)
			sys.stderr.write((str(s) + '\n'))
		sys.stderr.write('(%.3f sec)\n'%(time_consume))
	else:
		pass

		# {{{ switch: cmd
		_continue_1 = False
		while True:
			if False or ((cmd) == 'exists') or ((cmd) == 'hexists') or ((cmd) == 'zexists'):
				pass

				if resp.data==True:
					pass
					sys.stdout.write('true\n')
				else:
					pass
					sys.stdout.write('false\n')
				sys.stderr.write('(%.3f sec)\n'%(time_consume))
				break
			if False or ((cmd) == 'multi_exists') or ((cmd) == 'multi_hexists') or ((cmd) == 'multi_zexists'):
				pass
				sys.stderr.write('%-15s %s\n'%('key', 'value'))
				sys.stderr.write(('-' * 25 + '\n'))

				_cpy_r_12 = _cpy_l_13 = resp.data
				if type(_cpy_r_12).__name__ == 'dict': _cpy_b_15=True; _cpy_l_13=_cpy_r_12.iterkeys()
				else: _cpy_b_15=False;k=-1
				for _cpy_k_14 in _cpy_l_13:
					if _cpy_b_15: k=_cpy_k_14; v=_cpy_r_12[_cpy_k_14]
					else: k += 1; v=_cpy_k_14
					pass

					if v==True:
						pass
						s = 'true'
					else:
						pass
						s = 'false'
					sys.stdout.write('  %-15s : %s\n' % (repr_data(k), s))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			if False or ((cmd) == 'dbsize') or ((cmd) == 'getbit') or ((cmd) == 'setbit') or ((cmd) == 'countbit') or ((cmd) == 'strlen') or ((cmd) == 'getset') or ((cmd) == 'setnx') or ((cmd) == 'get') or ((cmd) == 'substr') or ((cmd) == 'ttl') or ((cmd) == 'expire') or ((cmd) == 'zget') or ((cmd) == 'hget') or ((cmd) == 'qfront') or ((cmd) == 'qback') or ((cmd) == 'qget') or ((cmd) == 'incr') or ((cmd) == 'decr') or ((cmd) == 'zincr') or ((cmd) == 'zdecr') or ((cmd) == 'hincr') or ((cmd) == 'hdecr') or ((cmd) == 'hsize') or ((cmd) == 'zsize') or ((cmd) == 'qsize') or ((cmd) == 'zrank') or ((cmd) == 'zrrank') or ((cmd) == 'zsum') or ((cmd) == 'zcount') or ((cmd) == 'zavg') or ((cmd) == 'zremrangebyrank') or ((cmd) == 'zremrangebyscore') or ((cmd) == 'zavg') or ((cmd) == 'multi_del') or ((cmd) == 'multi_hdel') or ((cmd) == 'multi_zdel') or ((cmd) == 'hclear') or ((cmd) == 'zclear') or ((cmd) == 'qclear') or ((cmd) == 'qpush') or ((cmd) == 'qpush_front') or ((cmd) == 'qpush_back') or ((cmd) == 'qtrim_front') or ((cmd) == 'qtrim_back'):
				pass
				print repr_data(resp.data)
				sys.stderr.write('(%.3f sec)\n'%(time_consume))
				break
			if False or ((cmd) == 'ping') or ((cmd) == 'qset') or ((cmd) == 'compact') or ((cmd) == 'auth') or ((cmd) == 'set') or ((cmd) == 'setx') or ((cmd) == 'zset') or ((cmd) == 'hset') or ((cmd) == 'del') or ((cmd) == 'zdel') or ((cmd) == 'hdel'):
				pass
				print resp.code
				sys.stderr.write('(%.3f sec)\n'%(time_consume))
				break
			if False or ((cmd) == 'scan') or ((cmd) == 'rscan') or ((cmd) == 'hgetall') or ((cmd) == 'hscan') or ((cmd) == 'hrscan'):
				pass
				sys.stderr.write('%-15s %s\n'%('key', 'value'))
				sys.stderr.write(('-' * 25 + '\n'))

				_cpy_r_16 = _cpy_l_17 = resp.data['index']
				if type(_cpy_r_16).__name__ == 'dict': _cpy_b_19=True; _cpy_l_17=_cpy_r_16.iterkeys()
				else: _cpy_b_19=False;
				for _cpy_k_18 in _cpy_l_17:
					if _cpy_b_19: k=_cpy_r_16[_cpy_k_18]
					else: k=_cpy_k_18
					pass
					sys.stdout.write('  %-15s : %s\n' % (repr_data(k), repr_data(resp.data['items'][k])))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data['index']), time_consume))
				break
			if False or ((cmd) == 'zscan') or ((cmd) == 'zrscan') or ((cmd) == 'zrange') or ((cmd) == 'zrrange'):
				pass
				sys.stderr.write('%-15s %s\n'%('key', 'score'))
				sys.stderr.write(('-' * 25 + '\n'))

				_cpy_r_20 = _cpy_l_21 = resp.data['index']
				if type(_cpy_r_20).__name__ == 'dict': _cpy_b_23=True; _cpy_l_21=_cpy_r_20.iterkeys()
				else: _cpy_b_23=False;
				for _cpy_k_22 in _cpy_l_21:
					if _cpy_b_23: k=_cpy_r_20[_cpy_k_22]
					else: k=_cpy_k_22
					pass
					score = resp.data['items'][k]
					sys.stdout.write('  %-15s: %s\n' % (repr_data(repr_data(k)), score))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data['index']), time_consume))
				break
			if False or ((cmd) == 'keys') or ((cmd) == 'list') or ((cmd) == 'zkeys') or ((cmd) == 'hkeys'):
				pass
				sys.stderr.write('  %15s\n'%('key'))
				sys.stderr.write(('-' * 17 + '\n'))

				_cpy_r_24 = _cpy_l_25 = resp.data
				if type(_cpy_r_24).__name__ == 'dict': _cpy_b_27=True; _cpy_l_25=_cpy_r_24.iterkeys()
				else: _cpy_b_27=False;
				for _cpy_k_26 in _cpy_l_25:
					if _cpy_b_27: k=_cpy_r_24[_cpy_k_26]
					else: k=_cpy_k_26
					pass
					sys.stdout.write('  %15s\n' % (repr_data(k)))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			if False or ((cmd) == 'hvals'):
				pass
				sys.stderr.write('  %15s\n'%('value'))
				sys.stderr.write(('-' * 17 + '\n'))

				_cpy_r_28 = _cpy_l_29 = resp.data
				if type(_cpy_r_28).__name__ == 'dict': _cpy_b_31=True; _cpy_l_29=_cpy_r_28.iterkeys()
				else: _cpy_b_31=False;
				for _cpy_k_30 in _cpy_l_29:
					if _cpy_b_31: k=_cpy_r_28[_cpy_k_30]
					else: k=_cpy_k_30
					pass
					sys.stdout.write('  %15s\n' % (repr_data(k)))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			if False or ((cmd) == 'hlist') or ((cmd) == 'hrlist') or ((cmd) == 'zlist') or ((cmd) == 'zrlist') or ((cmd) == 'qlist') or ((cmd) == 'qrlist') or ((cmd) == 'qslice') or ((cmd) == 'qrange') or ((cmd) == 'qpop') or ((cmd) == 'qpop_front') or ((cmd) == 'qpop_back'):
				pass

				_cpy_r_32 = _cpy_l_33 = resp.data
				if type(_cpy_r_32).__name__ == 'dict': _cpy_b_35=True; _cpy_l_33=_cpy_r_32.iterkeys()
				else: _cpy_b_35=False;
				for _cpy_k_34 in _cpy_l_33:
					if _cpy_b_35: k=_cpy_r_32[_cpy_k_34]
					else: k=_cpy_k_34
					pass
					sys.stdout.write('  %s\n' % (repr_data(k)))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			if False or ((cmd) == 'multi_get') or ((cmd) == 'multi_hget') or ((cmd) == 'multi_zget'):
				pass
				sys.stderr.write('%-15s %s\n'%('key', 'value'))
				sys.stderr.write(('-' * 25 + '\n'))

				_cpy_r_36 = _cpy_l_37 = resp.data
				if type(_cpy_r_36).__name__ == 'dict': _cpy_b_39=True; _cpy_l_37=_cpy_r_36.iterkeys()
				else: _cpy_b_39=False;k=-1
				for _cpy_k_38 in _cpy_l_37:
					if _cpy_b_39: k=_cpy_k_38; v=_cpy_r_36[_cpy_k_38]
					else: k += 1; v=_cpy_k_38
					pass
					sys.stdout.write('  %-15s : %s\n' % (repr_data(k), repr_data(v)))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			if False or ((cmd) == 'info'):
				pass
				is_val = False
				i = 1

				while i<len(resp.data):
					pass
					s = resp.data[i]

					if is_val:
						pass
						s = ('    ' + s.replace('\n', '\n    '))
					print s
					is_val = not (is_val)
					pass
					i += 1
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			if False or ((cmd) == 'get_key_range'):
				pass
				i = 0

				while i<len(resp.data):
					pass
					resp.data[i] = repr_data(resp.data[i])

					if resp.data[i]=='':
						pass
						resp.data[i] = '""'
					pass
					i += 1
				klen = 0
				vlen = 0
				i = 0

				while i<len(resp.data):
					pass
					klen = max(len(resp.data[i]), klen)
					vlen = max(len(resp.data[(i + 1)]), vlen)
					pass
					i += 2
				sys.stdout.write('    kv :  %-*s  -  %-*s\n' % (klen, resp.data[0], vlen, resp.data[1]))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			### default

			if resp.data:
				pass
				print repr_data(resp.code), repr_data(resp.data)
			else:
				pass
				print repr_data(resp.code)
			sys.stderr.write('(%.3f sec)\n'%(time_consume))
			break
			break
			if _continue_1:
				continue
		# }}} switch

