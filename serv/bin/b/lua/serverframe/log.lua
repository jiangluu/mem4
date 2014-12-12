
-- artme����־ϵͳ������ʵ����C�
-- �÷��� alog.verbose(xx)  alog.debug(xx) �ȡ�xx�����Ǹ��ַ���������ת�����ַ�����

local o = {}

alog = o


local lcf = ffi.C
function o.verbose(s)
	return lcf.log_write(0,tostring(s),#s)
end

function o.debug(s)
	return lcf.log_write(1,tostring(s),#s)
end

function o.info(s)
	return lcf.log_write(2,tostring(s),#s)
end

function o.warning(s)
	return lcf.log_write(3,tostring(s),#s)
end

function o.error(s)
	return lcf.log_write(4,tostring(s),#s)
end

function o.final(s)
	return lcf.log_write(5,tostring(s),#s)
end

function o.force_flush()
	lcf.log_force_flush()
end

