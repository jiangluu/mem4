# encoding=utf-8
# Generated by cpy
# 2014-09-01 02:56:19.827905
import os, sys
from sys import stdin, stdout

import thread
import re
import time
import socket
import getopt
import shlex
import datetime
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
	print '# Display ssdb-server status'
	print '	info'
	print '# Escape/Do not escape response data'
	print '	: escape yes|no'
	print '# KEY-VALUE COMMANDS'
	print '	set key value'
	print '	setx key value ttl'
	print '	get key'
	print '	del key'
	print '	list key_start key_end limit'
	print '	keys key_start key_end limit'
	print '	scan key_start key_end limit'
	print '# MAP(HASHMAP) COMMANDS'
	print '	hset name key value'
	print '	hget name key'
	print '	hdel name key'
	print '	hclear name'
	print '	hlist name_start name_end limit'
	print '	hkeys name key_start key_end limit'
	print '	hscan name key_start key_end limit'
	print '# ZSET(SORTED SET) COMMANDS'
	print '	zset name key score'
	print '	zget name key'
	print '	zdel name key'
	print '	zclear name'
	print '	zlist name_start name_end limit'
	print '	zkeys name key_start score_start score_end limit'
	print '	zscan name key_start score_start score_end limit'
	print '# FLUSH DATABASE'
	print '	flushdb'
	print '	flushdb kv'
	print '	flushdb hash'
	print '	flushdb zset'
	print ''
	print '# EXAMPLES'
	print '	scan "" "" 10'
	print '	scan aa "" 10'
	print '	hlist "" "" 10'
	print '	hscan h "" "" 10'
	print '	hscan h aa "" 10'
	print '	zlist "" "" 10'
	print '	zscan z "" "" "" 10'
	print '	zscan z "" 1 100 10'
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

def repr_data(str):
	pass
	gs = globals()

	if gs['escape_data']==False:
		pass
		return str
	ret = repr(str)

	if len(ret)>0:
		pass

		if ret[0]=='\'':
			pass
			ret = ret.replace("\\'", "'")
			ret = ret[1 : - (1)]
		elif ret[0]=='"':
			pass
			ret = ret.replace('\\"', '"')
			ret = ret[1 : - (1)]
		else:
			pass
	ret = ret.replace("\\\\", "\\")
	return ret

def hclear(link, hname, verbose=True):
	pass
	ret = 0
	num = 0
	batch = 1000
	last_count = 0
	r = link.request('hclear', [hname])
	try:
		pass
		ret = r.data
	except Exception , e:
		pass
	return ret

def zclear(link, zname, verbose=True):
	pass
	ret = 0
	num = 0
	batch = 1000
	last_count = 0
	r = link.request('zclear', [zname])
	try:
		pass
		ret = r.data
	except Exception , e:
		pass
	return ret

def qclear(link, zname, verbose=True):
	pass
	ret = 0
	num = 0
	batch = 1000
	last_count = 0
	r = link.request('qclear', [zname])
	try:
		pass
		ret = r.data
	except Exception , e:
		pass
	return ret

def flushdb(link, data_type):
	pass
	sys.stdout.write('\n')
	sys.stdout.write('============================ DANGER! ============================\n')
	sys.stdout.write('This operation is DANGEROUS and is not recoverable, if you\n')
	sys.stdout.write('really want to flush the whole db(delete ALL data in ssdb server),\n')
	sys.stdout.write('input \'yes\' and press Enter, or just press Enter to cancel\n')
	sys.stdout.write('=================================================================\n')
	sys.stdout.write('\n')
	sys.stdout.write('> flushdb? ')
	line = sys.stdin.readline().strip()

	if line!='yes':
		pass
		sys.stdout.write('Operation cancelled.\n\n')
		return 
	print 'Begin to flushdb...\n'
	batch = 1000
	d_kv = 0

	if (data_type=='' or data_type=='kv'):
		pass

		while True:
			pass
			resp = link.request('keys', ['', '', batch])

			if len(resp.data)==0:
				pass
				break
			d_kv += len(resp.data)
			link.request('multi_del', resp.data)
			sys.stdout.write('delete[kv  ] %d key(s).\n' % (d_kv))
	d_hash = 0
	d_hkeys = 0

	if (data_type=='' or data_type=='hash'):
		pass

		while True:
			pass
			resp = link.request('hlist', ['', '', batch])

			if len(resp.data)==0:
				pass
				break
			last_num = 0

			_cpy_r_0 = _cpy_l_1 = resp.data
			if type(_cpy_r_0).__name__ == 'dict': _cpy_b_3=True; _cpy_l_1=_cpy_r_0.iterkeys()
			else: _cpy_b_3=False;
			for _cpy_k_2 in _cpy_l_1:
				if _cpy_b_3: hname=_cpy_r_0[_cpy_k_2]
				else: hname=_cpy_k_2
				pass
				d_hash += 1
				deleted_num = hclear(link, hname, False)
				d_hkeys += deleted_num

				if (d_hkeys - last_num)>=batch:
					pass
					last_num = d_hkeys
					sys.stdout.write('delete[hash] %d hash(s), %d key(s).\n' % (d_hash, d_hkeys))

			if (d_hkeys - last_num)>=batch:
				pass
				sys.stdout.write('delete[hash] %d hash(s), %d key(s).\n' % (d_hash, d_hkeys))
		sys.stdout.write('delete[hash] %d hash(s), %d key(s).\n' % (d_hash, d_hkeys))
	d_zset = 0
	d_zkeys = 0

	if (data_type=='' or data_type=='zset'):
		pass

		while True:
			pass
			resp = link.request('zlist', ['', '', batch])

			if len(resp.data)==0:
				pass
				break
			last_num = 0

			_cpy_r_4 = _cpy_l_5 = resp.data
			if type(_cpy_r_4).__name__ == 'dict': _cpy_b_7=True; _cpy_l_5=_cpy_r_4.iterkeys()
			else: _cpy_b_7=False;
			for _cpy_k_6 in _cpy_l_5:
				if _cpy_b_7: zname=_cpy_r_4[_cpy_k_6]
				else: zname=_cpy_k_6
				pass
				d_zset += 1
				deleted_num = zclear(link, zname, False)
				d_zkeys += deleted_num

				if (d_zkeys - last_num)>=batch:
					pass
					last_num = d_zkeys
					sys.stdout.write('delete[zset] %d zset(s), %d key(s).\n' % (d_zset, d_zkeys))

			if (d_zkeys - last_num)>=batch:
				pass
				sys.stdout.write('delete[zset] %d zset(s), %d key(s).\n' % (d_zset, d_zkeys))
		sys.stdout.write('delete[zset] %d zset(s), %d key(s).\n' % (d_zset, d_zkeys))
	d_list = 0
	d_lkeys = 0

	if (data_type=='' or data_type=='list'):
		pass

		while True:
			pass
			resp = link.request('qlist', ['', '', batch])

			if len(resp.data)==0:
				pass
				break
			last_num = 0

			_cpy_r_8 = _cpy_l_9 = resp.data
			if type(_cpy_r_8).__name__ == 'dict': _cpy_b_11=True; _cpy_l_9=_cpy_r_8.iterkeys()
			else: _cpy_b_11=False;
			for _cpy_k_10 in _cpy_l_9:
				if _cpy_b_11: zname=_cpy_r_8[_cpy_k_10]
				else: zname=_cpy_k_10
				pass
				d_list += 1
				deleted_num = qclear(link, zname, False)
				d_lkeys += deleted_num

				if (d_zkeys - last_num)>=batch:
					pass
					last_num = d_lkeys
					sys.stdout.write('delete[list] %d list(s), %d key(s).\n' % (d_list, d_lkeys))

			if (d_lkeys - last_num)>=batch:
				pass
				sys.stdout.write('delete[list] %d list(s), %d key(s).\n' % (d_list, d_lkeys))
		sys.stdout.write('delete[list] %d list(s), %d key(s).\n' % (d_list, d_lkeys))
	sys.stdout.write('\n')
	sys.stdout.write('===== flushdb stats =====\n')

	if (data_type=='' or data_type=='kv'):
		pass
		sys.stdout.write('[kv]   %8d key(s).\n' % (d_kv))

	if (data_type=='' or data_type=='hash'):
		pass
		sys.stdout.write('[hash] %8d hash(s), %8d key(s).\n' % (d_hash, d_hkeys))

	if (data_type=='' or data_type=='zset'):
		pass
		sys.stdout.write('[zset] %8d zset(s), %8d key(s).\n' % (d_zset, d_zkeys))

	if (data_type=='' or data_type=='list'):
		pass
		sys.stdout.write('[list] %8d list(s), %8d key(s).\n' % (d_list, d_lkeys))
	sys.stdout.write('\n')
	sys.stdout.write('clear binlog\n')
	link.request('clear_binlog')
	sys.stdout.write('\n')
	sys.stdout.write('compacting...\n')
	link.request('compact')
	sys.stdout.write('done.\n')
	sys.stdout.write('\n')

def timespan(stime):
	pass
	etime = datetime.datetime.now()
	ts = (etime - stime)
	time_consume = (ts.seconds + ts.microseconds / 1000000.)
	return time_consume
host = ''
port = ''
opt = ''
args = []

_cpy_r_12 = _cpy_l_13 = sys.argv[1 : ]
if type(_cpy_r_12).__name__ == 'dict': _cpy_b_15=True; _cpy_l_13=_cpy_r_12.iterkeys()
else: _cpy_b_15=False;
for _cpy_k_14 in _cpy_l_13:
	if _cpy_b_15: arg=_cpy_r_12[_cpy_k_14]
	else: arg=_cpy_k_14
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

	_cpy_r_16 = _cpy_l_17 = args
	if type(_cpy_r_16).__name__ == 'dict': _cpy_b_19=True; _cpy_l_17=_cpy_r_16.iterkeys()
	else: _cpy_b_19=False;
	for _cpy_k_18 in _cpy_l_17:
		if _cpy_b_19: arg=_cpy_r_16[_cpy_k_18]
		else: arg=_cpy_k_18
		pass

		if not (re.match('^[0-9]+$', args[0])):
			pass
			host = arg
			break

if port=='':
	pass
	port = '8888'

	_cpy_r_20 = _cpy_l_21 = args
	if type(_cpy_r_20).__name__ == 'dict': _cpy_b_23=True; _cpy_l_21=_cpy_r_20.iterkeys()
	else: _cpy_b_23=False;
	for _cpy_k_22 in _cpy_l_21:
		if _cpy_b_23: arg=_cpy_r_20[_cpy_k_22]
		else: arg=_cpy_k_22
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
	print 'Invalid argument port: ', port
	usage()
	sys.exit(0)
sys.path.append('./api/python')
sys.path.append('../api/python')
from SSDB import SSDB
try:
	pass
	link = SSDB(host, port)
except socket.error , e:
	pass
	sys.stdout.write('Failed to connect to: %s:%d\n' % (host, port))
	print 'Connection error: ', str(e)
	sys.exit(0)
welcome()
try:
	pass
	resp = link.request('info', [])
	print (('ssdb-server version: ' + resp.data[2]) + '\n')
except Exception , e:
	pass

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
		print 'bye.'
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
		print 'error: ', e
		continue

	if len(ps)==0:
		pass
		continue
	cmd = ps[0].lower()
	args = ps[1 : ]

	if cmd==':':
		pass
		op = ''

		if len(args)>0:
			pass
			op = args[0]

		if op!='escape':
			pass
			print "Bad setting!"
			continue
		yn = 'yes'

		if len(args)>1:
			pass
			yn = args[1]
		gs = globals()

		if yn=='yes':
			pass
			gs['escape_data'] = True
			print "  Escape response"
		elif (yn=='no' or yn=='none'):
			pass
			gs['escape_data'] = False
			print "  No escape response"
		else:
			pass
			print "  Usage: escape yes|no"
		continue
	try:
		pass

		if cmd=='flushdb':
			pass
			stime = datetime.datetime.now()

			if len(args)==0:
				pass
				flushdb(link, '')
			else:
				pass
				flushdb(link, args[0])
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
				print 'cannot connect to server, give up...'
				break
			sys.stdout.write('[%d/%d] reconnecting to server... ' % (retry, max_retry))
			try:
				pass
				link = SSDB(host, port)
				print 'done.'
			except socket.error , e:
				pass
				print 'Connect error: ', str(e)
				continue
			print ''
		else:
			pass
			break
	time_consume = timespan(stime)

	if not (resp.ok()):
		pass

		if resp.not_found():
			pass
			print 'not_found'
		else:
			pass
			print ('error: ' + resp.code)
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
				sys.stdout.write('%-15s %s\n' % ('key', 'value'))
				print '-' * 25

				_cpy_r_24 = _cpy_l_25 = resp.data
				if type(_cpy_r_24).__name__ == 'dict': _cpy_b_27=True; _cpy_l_25=_cpy_r_24.iterkeys()
				else: _cpy_b_27=False;k=-1
				for _cpy_k_26 in _cpy_l_25:
					if _cpy_b_27: k=_cpy_k_26; v=_cpy_r_24[_cpy_k_26]
					else: k += 1; v=_cpy_k_26
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
			if False or ((cmd) == 'getbit') or ((cmd) == 'setbit') or ((cmd) == 'countbit') or ((cmd) == 'strlen') or ((cmd) == 'getset') or ((cmd) == 'setnx') or ((cmd) == 'get') or ((cmd) == 'substr') or ((cmd) == 'ttl') or ((cmd) == 'expire') or ((cmd) == 'zget') or ((cmd) == 'hget') or ((cmd) == 'qfront') or ((cmd) == 'qback') or ((cmd) == 'qget') or ((cmd) == 'qpop') or ((cmd) == 'qpop_front') or ((cmd) == 'qpop_back') or ((cmd) == 'incr') or ((cmd) == 'decr') or ((cmd) == 'zincr') or ((cmd) == 'zdecr') or ((cmd) == 'hincr') or ((cmd) == 'hdecr') or ((cmd) == 'hsize') or ((cmd) == 'zsize') or ((cmd) == 'qsize') or ((cmd) == 'zrank') or ((cmd) == 'zrrank') or ((cmd) == 'zsum') or ((cmd) == 'zcount') or ((cmd) == 'zavg') or ((cmd) == 'zremrangebyrank') or ((cmd) == 'zremrangebyscore') or ((cmd) == 'zavg') or ((cmd) == 'multi_del') or ((cmd) == 'multi_hdel') or ((cmd) == 'multi_zdel') or ((cmd) == 'hclear') or ((cmd) == 'zclear') or ((cmd) == 'qclear') or ((cmd) == 'qpush') or ((cmd) == 'qpush_front') or ((cmd) == 'qpush_back'):
				pass
				print repr_data(resp.data)
				sys.stderr.write('(%.3f sec)\n'%(time_consume))
				break
			if False or ((cmd) == 'set') or ((cmd) == 'setx') or ((cmd) == 'zset') or ((cmd) == 'hset') or ((cmd) == 'del') or ((cmd) == 'zdel') or ((cmd) == 'hdel'):
				pass
				print resp.code
				sys.stderr.write('(%.3f sec)\n'%(time_consume))
				break
			if False or ((cmd) == 'scan') or ((cmd) == 'rscan') or ((cmd) == 'hgetall') or ((cmd) == 'hscan') or ((cmd) == 'hrscan'):
				pass
				sys.stdout.write('%-15s %s\n' % ('key', 'value'))
				print '-' * 25

				_cpy_r_28 = _cpy_l_29 = resp.data['index']
				if type(_cpy_r_28).__name__ == 'dict': _cpy_b_31=True; _cpy_l_29=_cpy_r_28.iterkeys()
				else: _cpy_b_31=False;
				for _cpy_k_30 in _cpy_l_29:
					if _cpy_b_31: k=_cpy_r_28[_cpy_k_30]
					else: k=_cpy_k_30
					pass
					sys.stdout.write('  %-15s : %s\n' % (repr_data(k), repr_data(resp.data['items'][k])))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data['index']), time_consume))
				break
			if False or ((cmd) == 'zscan') or ((cmd) == 'zrscan') or ((cmd) == 'zrange') or ((cmd) == 'zrrange'):
				pass
				sys.stdout.write('%-15s %s\n' % ('key', 'score'))
				print '-' * 25

				_cpy_r_32 = _cpy_l_33 = resp.data['index']
				if type(_cpy_r_32).__name__ == 'dict': _cpy_b_35=True; _cpy_l_33=_cpy_r_32.iterkeys()
				else: _cpy_b_35=False;
				for _cpy_k_34 in _cpy_l_33:
					if _cpy_b_35: k=_cpy_r_32[_cpy_k_34]
					else: k=_cpy_k_34
					pass
					score = resp.data['items'][k]
					sys.stdout.write('  %-15s: %s\n' % (repr_data(repr_data(k)), score))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data['index']), time_consume))
				break
			if False or ((cmd) == 'keys') or ((cmd) == 'list') or ((cmd) == 'zkeys') or ((cmd) == 'hkeys'):
				pass
				sys.stdout.write('  %15s\n' % ('key'))
				print '-' * 17

				_cpy_r_36 = _cpy_l_37 = resp.data
				if type(_cpy_r_36).__name__ == 'dict': _cpy_b_39=True; _cpy_l_37=_cpy_r_36.iterkeys()
				else: _cpy_b_39=False;
				for _cpy_k_38 in _cpy_l_37:
					if _cpy_b_39: k=_cpy_r_36[_cpy_k_38]
					else: k=_cpy_k_38
					pass
					sys.stdout.write('  %15s\n' % (repr_data(k)))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			if False or ((cmd) == 'hvals'):
				pass
				sys.stdout.write('  %15s\n' % ('value'))
				print '-' * 17

				_cpy_r_40 = _cpy_l_41 = resp.data
				if type(_cpy_r_40).__name__ == 'dict': _cpy_b_43=True; _cpy_l_41=_cpy_r_40.iterkeys()
				else: _cpy_b_43=False;
				for _cpy_k_42 in _cpy_l_41:
					if _cpy_b_43: k=_cpy_r_40[_cpy_k_42]
					else: k=_cpy_k_42
					pass
					sys.stdout.write('  %15s\n' % (repr_data(k)))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			if False or ((cmd) == 'hlist') or ((cmd) == 'hrlist') or ((cmd) == 'zlist') or ((cmd) == 'zrlist') or ((cmd) == 'qlist') or ((cmd) == 'qrlist') or ((cmd) == 'qslice') or ((cmd) == 'qrange'):
				pass

				_cpy_r_44 = _cpy_l_45 = resp.data
				if type(_cpy_r_44).__name__ == 'dict': _cpy_b_47=True; _cpy_l_45=_cpy_r_44.iterkeys()
				else: _cpy_b_47=False;
				for _cpy_k_46 in _cpy_l_45:
					if _cpy_b_47: k=_cpy_r_44[_cpy_k_46]
					else: k=_cpy_k_46
					pass
					sys.stdout.write('  %s\n' % (repr_data(k)))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			if False or ((cmd) == 'multi_get') or ((cmd) == 'multi_hget') or ((cmd) == 'multi_zget'):
				pass
				sys.stdout.write('%-15s %s\n' % ('key', 'value'))
				print '-' * 25

				_cpy_r_48 = _cpy_l_49 = resp.data
				if type(_cpy_r_48).__name__ == 'dict': _cpy_b_51=True; _cpy_l_49=_cpy_r_48.iterkeys()
				else: _cpy_b_51=False;k=-1
				for _cpy_k_50 in _cpy_l_49:
					if _cpy_b_51: k=_cpy_k_50; v=_cpy_r_48[_cpy_k_50]
					else: k += 1; v=_cpy_k_50
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
			if False or ((cmd) == 'key_range'):
				pass

				if len(resp.data)!=6:
					pass
					print 'error!'
				else:
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
					sys.stdout.write('	kv   :  %-*s  -  %-*s\n' % (klen, resp.data[0], vlen, resp.data[1]))
					sys.stdout.write('	hash :  %-*s  -  %-*s\n' % (klen, resp.data[2], vlen, resp.data[3]))
					sys.stdout.write('	zset :  %-*s  -  %-*s\n' % (klen, resp.data[4], vlen, resp.data[5]))
				sys.stderr.write('%d result(s) (%.3f sec)\n'%(len(resp.data), time_consume))
				break
			### default
			print repr_data(resp.code), repr_data(resp.data)
			sys.stderr.write('(%.3f sec)\n'%(time_consume))
			break
			break
			if _continue_1:
				continue
		# }}} switch

