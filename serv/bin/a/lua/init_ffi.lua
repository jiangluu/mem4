
-- open ffi
ffi = require("ffi")
ffi.cdef[[
int printf(const char*, ...);
int MessageBoxA(void *w, const char *txt, const char *cap, int type);



int32_t cur_stream_get_int32();

int16_t cur_stream_peek_int16();

const char* cur_stream_get_string();


bool cur_stream_push_int32(int32_t v);

bool cur_stream_push_string(const char* v,int len);


void cur_write_stream_cleanup();

// 同步原路返回。messageid 是req的+1，内容是push到 stream里的内容。 
void cur_stream_write_back();

// 定点发送 。内容是push到 stream里的内容。
void cur_stream_write_2_link(int link_index,int message_id);

void copy_read_buf_to_write();

int get_cur_link_index();
]]


-- define C function global var.
cf = ffi.C



